import aiohttp
import asyncio
import click
import collections
import feedparser
import html
import os
import time


Feed = collections.namedtuple("Feed", ["title", "url", "rss_url", "number_of_entries", "sanitize"])
Categories = collections.namedtuple("Categories", ["title", "feeds"])

def sanitize_weekly_news(summary):
    summary = summary.replace(
        "<h1>News</h1>",
        "",
    )
    summary = summary.replace(
        "<h1>Contribute to NixOS Weekly Newsletter</h1>",
        "<h2>Contribute to NixOS Weekly Newsletter</h2>",
    )
    summary = summary.replace(
        "https//twitter.com/garbas",
        "https://twitter.com/garbas",
    )
    summary = summary.replace(
        'src="images/',
        'src="https://weekly.nixos.org/images/',
    )
    return summary


FEEDS = {
    "index": Feed(
        title="Weekly news",
        url="https://weekly.nixos.org",
        rss_url="https://weekly.nixos.org/feeds/all.rss.xml",
        number_of_entries=1000,
        sanitize=sanitize_weekly_news,
    ),
    "categories": Categories(
        title="Categories",
        feeds={
            "events": Feed(
                title="Events",
                url="https://discourse.nixos.org/c/events/13",
                rss_url="https://discourse.nixos.org/c/events/13.rss",
                number_of_entries=8,
                sanitize=None,
            ),
            "jobs": Feed(
                title="Jobs",
                url="https://discourse.nixos.org/c/jobs/23",
                rss_url="https://discourse.nixos.org/c/jobs/23.rss",
                number_of_entries=8,
                sanitize=None,
            ),
            "planet": Feed(
                title="Planet",
                url="https://planet.nixos.org",
                rss_url="https://planet.nixos.org/rss20.xml",
                number_of_entries=8,
                sanitize=None,
            ),
            "community-announcements": Feed(
                title="Community announcements",
                url="https://discourse.nixos.org/c/announcements/8",
                rss_url="https://discourse.nixos.org/c/announcements/8.rss",
                number_of_entries=8,
                sanitize=None,
            ),
        },
    ),
}


FILE_TEMPLATE = '''
[% WRAPPER blog/layout.tt title="Nix {title}" %]
{content}
[% END %]'''

FEED_ENTRY_TEMPLATE = '''
<section class="blog-header">
  <div>
    <h2>{title}</h2>
    <span>
      &#8212; Published on
      <time datetime="{date}">{date_nice}</time>
    </span>
  </div>
</section>
<section class="blog-article">
{content}
</section>'''


CATEGORIES_TEMPLATE = '''
<section class="blog-{id}">
  <ul>{items}
  </ul>
</section>'''

CATEGORY_TEMPLATE = '''
    <li id="blog-category-{feed_id}-{category_id}">
      <h2>{category.title}</h2>
      <ul>{entries}
      </ul>
      <a href="{category.url}">More {category_title_lower} ...</a>
    </li>'''

CATEGORY_FEED_TEMPLATE = '''
        <li>
          <time datetime="{date}">({date_nice})</time>
          <a target="_blank" href="{url}">
            {title}
          </a>
        </li>'''


async def fetch_feed(session, feed_id, feed):
    if isinstance(feed, Feed):
        click.echo(f"     Fetching {feed.title} via `{feed.url}`")
        async with session.get(feed.rss_url) as response:
            content = await response.read()
            click.echo(f"      Fetched {feed.title}")
            return (feed_id, feedparser.parse(content))
    elif isinstance(feed, Categories):
        click.echo(f"     Fetching {feed.title}")
        items = await asyncio.gather(*[
            asyncio.ensure_future(fetch_feed(session, item_id, item))
            for item_id, item in feed.feeds.items()
        ])
        return (feed_id, {item_id: item for item_id, item in items})
    else:
        raise NotImplemented


async def fetch_feeds(limit, loop, feeds):

    connector = aiohttp.TCPConnector(limit=limit)
    async with aiohttp.ClientSession(loop=loop, connector=connector) as session:
        responses = await asyncio.gather(*[
            asyncio.ensure_future(fetch_feed(session, feed_id, feed))
            for feed_id, feed in feeds.items()
        ])

    return {
        feed_id: content
        for feed_id, content in responses
    }


@click.command()
@click.option('--limit', default=4, type=int)
@click.option('--output-dir', required=True, type=str)
def main(limit, output_dir):
    loop = asyncio.get_event_loop()
    result = loop.run_until_complete(fetch_feeds(limit, loop, FEEDS))

    click.echo(f"      Writing to `{output_dir}`")

    for feed_id, feed in FEEDS.items():

        if isinstance(feed, Feed):
            content = "".join([
                FEED_ENTRY_TEMPLATE.format(
                    title=html.escape(entry.title),
                    date=time.strftime("%Y-%m-%d", entry.published_parsed),
                    date_nice=time.strftime("%d %b %Y", entry.published_parsed),
                    content=feed.sanitize and feed.sanitize(entry.summary) or entry.summary,
                )
                for entry in result[feed_id]["entries"][:feed.number_of_entries]
            ])

        elif isinstance(feed, Categories):
            content = CATEGORIES_TEMPLATE.format(
                id=feed_id,
                items="".join([
                    CATEGORY_TEMPLATE.format(
                        feed_id=feed_id,
                        category_id=category_id,
                        category=category,
                        category_title_lower=category.title.lower(),
                        entries="".join([
                            CATEGORY_FEED_TEMPLATE.format(
                                title=html.escape(entry.title),
                                date=time.strftime("%Y-%m-%d", entry.published_parsed),
                                date_nice=time.strftime("%d %b %Y", entry.published_parsed),
                                url=entry.link,
                            )
                            for entry in result[feed_id][category_id]["entries"][:category.number_of_entries]
                        ]),
                    )
                    for category_id, category in FEEDS[feed_id].feeds.items()
                ])
            )

        else:
            raise NotImplemented

        feed_content = FILE_TEMPLATE.format(
            title=feed.title,
            content=content,
        )

        feed_file = os.path.join(output_dir, f"{feed_id}.tt")
        click.echo(f"      Writing `{feed_file}`")

        with open(feed_file, "w+") as f:
            f.write(feed_content)

    click.echo(f" Successfully updated blog.")


if __name__ == "__main__":
    main()
