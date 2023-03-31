import json
from itertools import groupby
from typing import NamedTuple
import click
from github import Github
from semver import VersionInfo


class NixInfo(NamedTuple):
    version: str
    sha: str


def get_tags() -> list[NixInfo]:
    # Fetch release date from GitHub
    g = Github()
    repo = g.get_repo("NixOS/nix")
    tags = [NixInfo(t.name, t.commit.sha)
            for t in repo.get_tags()[:20]]
    return tags


def version_info(x: NixInfo):
    return VersionInfo.parse(x.version)


def major_minor(info: NixInfo):
    v = version_info(info)
    return f"{v.major}.{v.minor}"


def parse_version_file(file: str) -> list[NixInfo]:
    with open(file, 'r') as input_file:
        versions = [NixInfo(**v) for v in json.load(input_file)]
    return sorted(versions, key=version_info)


def filter_old_versions(versions: list[NixInfo], limit = VersionInfo.parse("0.0.0")):
    # Give a NixInfo list, remove all old patch versions
    # (e.g.: for [2.1.0, 2.1.1, 2.2.0] returns [2.1.1, 2.2.0])
    # Also filters all versions older than limit
    versions_info = sorted((v for v in versions if version_info(v) >= limit),
                           key=version_info,
                           reverse=True)
    return [next(g) for _, g in groupby(versions_info, major_minor)]


def new_version_list(current_versions):
    tags = get_tags()
    return filter_old_versions([*tags, *current_versions], version_info(current_versions[0]))

@click.command()
@click.option("--file", required=True, type=str)
def main(file):
    new_versions = [x._asdict() for x in new_version_list(parse_version_file(file))]
    with open(file, 'w') as f:
        json.dump(new_versions, f, indent=2)

if __name__ == "__main__":
    main()
