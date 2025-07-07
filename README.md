# Source for nixos.org

[![CI](https://github.com/NixOS/nixos-homepage/actions/workflows/deploy-prod.yml/badge.svg)](https://github.com/NixOS/nixos-homepage/actions/workflows/ci.yml)
[![Number of open GitHub issues](https://img.shields.io/github/issues/nixos/nixos-homepage?style=flat&color=red)](https://github.com/nixos/nixos-homepage/issues)
[![Number of open GitHub pull requests](https://img.shields.io/github/issues-pr/nixos/nixos-homepage?style=flat&color=blue)](https://github.com/nixos/nixos-homepage/pulls)
[![Month of last commit](https://img.shields.io/github/last-commit/NixOS/nixos-homepage?style=flat)](https://github.com/NixOS/nixos-homepage/commits/main)
[![Number of all contributors](https://img.shields.io/badge/all_contributors-10-orange.svg?style=flat)](https://github.com/nixos/nixos-homepage#how-to-help)

Code and content for the [nixos.org](https://nixos.org) website.

# Contributing

Thank you for your interest in contributing to the NixOS homepage!
We value your time and effort in helping us improve this vital resource for the community.

We want to make contributing as simple and welcoming as possible while ensuring the sustainability of the project.
Our small team of volunteers prioritizes the [health and maintainability of the site over rushing features or catering to individual interests](https://github.com/NixOS/org/blob/main/doc/values.md).

Here’s how you can help us achieve that:

- Don’t hesitate to reach out! We’re here to guide you and get you started.
- If you feel lost on where or how to contribute, ask the [Marketing Team](https://nixos.org/community/teams/marketing.html) on the [`#marketing` room on Matrix](https://matrix.to/#/#marketing:nixos.org).
- Focus on contributions that align with the project's long-term goals and maintainable growth.
- Be mindful of the maintainers’ capacity. We, like you, are here because we are passionate about the project.

## Small Changes and Fixes

If you find a bug or need to make a small content change, feel free to submit a pull request.
There is no need to create an issue if the change is sufficiently small.
Here are a few examples:

- [An image was in the wrong location](https://github.com/NixOS/nixos-homepage/pull/1630)
- [Updating team members](https://github.com/NixOS/nixos-homepage/pull/1636)
- [Fixing the logic for asciinema-player](https://github.com/NixOS/nixos-homepage/pull/1597)

## All Work is Tracked in Issues

All work, whether proposed or in progress, should be documented in Issues.
This ensures transparency and makes it easier for anyone to pick up tasks or for maintainers to manage the workload.
There are many ways how you can help:

- If you are familiar with CSS, look at the [issues tagged with `design` tag](https://github.com/NixOS/nixos-homepage/issues?q=is%3Aissue+is%3Aopen+label%3Adesign).
- If you are a native English speaker or just a person who is very good with words, please look at the [issues tagged with `content` tag](https://github.com/NixOS/nixos-homepage/issues?q=is%3Aissue+is%3Aopen+label%3Acontent)
- If you are a developer and just eager to fix stuff, please look at the [issues tagged with `bug` tag](https://github.com/NixOS/nixos-homepage/issues?q=is%3Aissue+is%3Aopen+label%3Abug)

## Propose Changes in the Right Place

It takes a lot of time and effort to keep the website running smoothly.
If you want to submit a change that is not tracked by an issue, propose it first so the details and scope can be refined before you start working.

- For well-scoped ideas that you can implement, check if there is an existing issue. If not, create one.
- For loosely defined ideas or if you lack the technical means to implement them, start a discussion in the Discussions section to refine the idea collaboratively.

## Separate Pull Requests by Type

When submitting pull requests, ensure they are categorized as one of the following:

- Design changes
- Content changes
- Technical changes

Avoid combining these types in a single pull request to make the review process smoother and more efficient.

Make sure to add a description in your pull request.
A few words can help reviewers understand your intent.
For example, if you are making design changes, you might want to answer why your changes are an improvement.
Similarly, if you are making technical changes, you might want to answer how your changes work.
Add enough detail so we know what you know.

## Adding your company to the commercial support page
When adding your company to the commercial support page, your company must...

- ... offer commercial support for Nix
- ... provide a clear description of their Nix services on their website (the descriptions have to explicitly mention Nix)
- ... keep their info and logo up to date

Please note that we will regularly check the commercial support page and will remove companies not adhering to this policy. The commercial support page is suited to finde companies that offer commercial Nix support and does not serve as advertising space.

# Development

To run local development instance, follow these steps to start a local server

    $ git clone git@github.com:NixOS/nixos-homepage.git
    $ cd nixos-homepage
    $ nix-shell
    [nix-shell]$ npm install --workspaces --include-workspace-root
    [nix-shell]$ npm run dev

If you have [Docker] and [Docker Compose] installed, you can alternatively run

    $ docker-compose up

Once everything's ready, you'll be able to access

Open your browser at: http://localhost:4321/

Before creating a pull request, make sure that `nix-build` runs successfully.

[Docker]: https://docs.docker.com/get-docker/
[Docker Compose]: https://docs.docker.com/compose/install/

## Binary cache (Optional)

It can take some time to enter the development environment. To speed up and avoid building from source, you can use a binary cache. The same cache is used to speed up our GitHub Actions.

### On NixOS

Add the following to your `configuration.nix`:

```
nix.settings.substituters = [ "https://nixos-homepage.cachix.org" ];
nix.settings.trusted-public-keys = [ "nixos-homepage.cachix.org-1:NHKBt7NjLcWfgkX4OR72q7LVldKJe/JOsfIWFDAn/tE=" ];
```

### On non-NixOS

Add the following to the `/etc/nix/nix.conf` or `~/.config/nix/nix.conf`:

```
substituters = ... https://nixos-homepage.cachix.org
trusted-public-keys = ... nixos-homepage.cachix.org-1:NHKBt7NjLcWfgkX4OR72q7LVldKJe/JOsfIWFDAn/tE=
```

## License

The content of the website is licensed under the [Creative Commons Attribution Share Alike 4.0 International](LICENSES/CC-BY-SA-4.0.txt) license.

The software (including sample code) is licensed under the [MIT](LICENSES/MIT.txt) license.

Some files might have a different license. See the file's content for details.
