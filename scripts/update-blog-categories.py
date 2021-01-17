import aiohttp
import asyncio
import click
import collections
import feedparser
import html
import time


Category = collections.namedtuple("Feed", ["id", "title", "url", "rss_url"])

CATEGORIES = [
    Category(
        id="events",
        title="Events",
        url="https://discourse.nixos.org/c/events/13",
        rss_url="https://discourse.nixos.org/c/events/13.rss",
    ),
    Category(
        id="jobs",
        title="Jobs",
        url="https://discourse.nixos.org/c/jobs/23",
        rss_url="https://discourse.nixos.org/c/jobs/23.rss",
    ),
    Category(
        id="planet",
        title="Planet",
        url="https://planet.nixos.org",
        rss_url="https://planet.nixos.org/rss20.xml",
    ),
    Category(
        id="announcements",
        title="Announcements",
        url="https://discourse.nixos.org/c/announcements/8",
        rss_url="https://discourse.nixos.org/c/announcements/8.rss",
    ),
]

TEMPLATE = '''
[% WRAPPER blog/layout.tt title="Categories" %]
<section class="blog-categories">
  <ul>{categories}
  </ul>
</section>
[% END %]'''

CATEGORY_TEMPLATE = '''
    <li id="blog-category-{category.id}">
      <h2>{category.title}</h2>
      <ul>{feeds}
      </ul>
      <a href="{category.url}">More {category.title} ...</a>
    </li>'''

FEED_TEMPLATE = '''
        <li>
          <time datetime="{date}">({date})</time>
          <a target="_blank" href="{url}">
            {title}
          </a>
        </li>'''


async def fetch_category(session, category):
    click.echo(f"     Fetching {category.title} via `{category.url}`")
    async with session.get(category.rss_url) as response:
        content = await response.text()
        click.echo(f"      Fetched {category.title}")
        return (category.id, feedparser.parse(content))


async def fetch_categories(limit, loop, categories):

    connector = aiohttp.TCPConnector(limit=limit)
    async with aiohttp.ClientSession(loop=loop, connector=connector) as session:
        responses = await asyncio.gather(*[
            asyncio.ensure_future(fetch_category(session, category))
            for category in categories
        ])

    return {
        category_id: content
        for category_id, content in responses
    }


@click.command()
@click.option('--limit', default=4, type=int)
@click.option('--number-of-feeds', default=8, type=int)
@click.option('--output', required=True, type=str)
def main(limit, number_of_feeds, output):
    loop = asyncio.get_event_loop()
    result = loop.run_until_complete(fetch_categories(limit, loop, CATEGORIES))

    click.echo(f"      Writing to `{output}`")

    categories = TEMPLATE.format(
        categories="".join([
            CATEGORY_TEMPLATE.format(
                category=category,
                feeds="".join([
                    FEED_TEMPLATE.format(
                        title=html.escape(feed.title),
                        date=time.strftime("%Y-%m-%d", feed.published_parsed),
                        url=feed.link,
                    )
                    for feed in result[category.id]["entries"][:number_of_feeds]
                ]),
            )
            for category in CATEGORIES
        ])
    )

    with open(output, "w+") as f:
        f.write(categories)

    click.echo(f" Successfully updated `{output}`.")


if __name__ == "__main__":
    main()
