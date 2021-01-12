import aiohttp
import asyncio
import click
import collections
import feedparser
import operator


Feed = collections.namedtuple("Feed", ["id", "title", "url"])

FEEDS = [
    Feed(
        id="community-announcements",
        title="Community announcements",
        url="https://discourse.nixos.org/c/announcements/8.rss",
    )
]

FEED_TEMPLATE = '''
  <li id="{category}-{id}">
    <h2>{title}</h2>
    <div>
      {summary}
    </div>
    <a href="{link}">Read more</a>
  </li>
'''

async def fetch_feed(session, feed):
    async with session.get(feed.url) as response:
        text = await response.text()
        return feedparser.parse(text)


async def fetch(limit, loop, feeds):
    files = dict()
    connector = aiohttp.TCPConnector(limit=limit)
    for feed in feeds:

        async with aiohttp.ClientSession(loop=loop, connector=connector) as session:
            click.echo(f" Fetching `{feed.title}` via `{feed.url}`")
            feed_rss = await fetch_feed(session, feed)
            click.echo(f"  Fetched `{feed.title}`")

            files.setdefault("blog/index.html.in", [])
            files.setdefault(f"blog/{feed.id}.html.in", [])
            for entry in feed_rss['entries']:
                entry['category'] = feed.id
                __import__('pdb').set_trace()
                files["blog/index.html.in"].append(entry)
                files[f"blog/{feed.id}.html.in"].append(entry)

    return files


@click.command()
@click.option('--limit', default=4, type=int)
def main(limit):
    loop = asyncio.get_event_loop()
    files = loop.run_until_complete(fetch(limit, loop, FEEDS))

    for file_, feeds in files.items():
        click.echo(f"  Writing `{file_}`")
        with open(file_, "w+") as f:
            f.write("<ul>\n")
            for feed in sorted(feeds,
                               key=operator.attrgetter('published_parsed'),
                               reverse=True)[:25]:
                f.write(FEED_TEMPLATE.format(**feed))
            f.write("</ul>")


if __name__ == "__main__":
    main()
