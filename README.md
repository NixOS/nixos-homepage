# Source for nixos.org

[![GitHub Workflow Status of master branch](https://img.shields.io/github/actions/workflow/status/nixos/nixos-homepage/cron.yml?branch=master&style=flat)](https://github.com/NixOS/nixos-homepage/actions/workflows/cron.yml?query=branch%3Amaster)
[![Number of open GitHub issues](https://img.shields.io/github/issues/nixos/nixos-homepage?style=flat&color=red)](https://github.com/nixos/nixos-homepage/issues)
[![Number of open GitHub pull requests](https://img.shields.io/github/issues-pr/nixos/nixos-homepage?style=flat&color=blue)](https://github.com/nixos/nixos-homepage/pulls)
[![Month of last commit](https://img.shields.io/github/last-commit/NixOS/nixos-homepage?style=flat)](https://github.com/NixOS/nixos-homepage/commits/main)
[![Number of all contributors](https://img.shields.io/badge/all_contributors-10-orange.svg?style=flat)](https://github.com/nixos/nixos-homepage#how-to-help)

Code and content for the [nixos.org](https://nixos.org) website.


# Help us!

There are many ways how you can help:

- if you are familiar with CSS look at the [issues tagged with `design` tag](https://github.com/NixOS/nixos-homepage/issues?q=is%3Aissue+is%3Aopen+label%3Adesign).
- if you are an native English speaker or just a person that is very good with words, please look at the [issues tagged with `content` tag](https://github.com/NixOS/nixos-homepage/issues?q=is%3Aissue+is%3Aopen+label%3Acontent)
- if you are developer and just eager to fix stuff please look at the [issues tagged with `bug` tag](https://github.com/NixOS/nixos-homepage/issues?q=is%3Aissue+is%3Aopen+label%3Abug)

If you feel lost where and how to contribute, ask the [marketing team](https://nixos.org/community/teams/marketing.html) on the [`#marketing` room on Matrix](https://matrix.to/#/#marketing:nixos.org).


# How to help?

To run local development instance follow this steps to start a local server

    $ git clone git@github.com:NixOS/nixos-homepage.git
    $ cd nixos-homepage
    $ nix-shell
    [nix-shell]$ npm install
    [nix-shell]$ npm run dev

If you have [Docker] and [Docker Compose] installed, you can alternatively run

    $ docker-compose up

Once everything's ready, you'll be able to access

Open your browser at: http://localhost:4321/

Before creating a pull request make sure that `nix-build` runs successfully.

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

Some files might have a different license. See the files content for details.
