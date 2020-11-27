# Source for nixos.org

[![GitHub Workflow Status of master branch](https://img.shields.io/github/workflow/status/nixos/nixos-homepage/Build%20&%20Deploy%20to%20Netlify?style=flat)](https://github.com/NixOS/nixos-homepage/actions?query=workflow%3A%22Build+%26+Deploy+to+Netlify%22) [![Number of open GitHub issues](https://img.shields.io/github/issues/nixos/nixos-homepage?style=flat&color=red)](https://github.com/nixos/nixos-homepage/issues) [![Number of open GitHub pull requests](https://img.shields.io/github/issues-pr/nixos/nixos-homepage?style=flat&color=blue)](https://github.com/nixos/nixos-homepage/pulls) [![Month of last commit](https://img.shields.io/github/last-commit/NixOS/nixos-homepage?style=flat)](https://github.com/NixOS/nixos-homepage/commits/master) [![Number of all contributors](https://img.shields.io/badge/all_contributors-10-orange.svg?style=flat)](https://github.com/nixos/nixos-homepage#how-to-help)

Code and content for [nixos.org](https://nixos.org) website.


# Help us!

There are many ways how you can help:

- if you are familiar with CSS look at the [issues tagged with `design` tag](https://github.com/NixOS/nixos-homepage/issues?q=is%3Aissue+is%3Aopen+label%3Adesign).
- if you are an native English speaker or just a person that is very good with words, please look at the [issues tagged with `content` tag](https://github.com/NixOS/nixos-homepage/issues?q=is%3Aissue+is%3Aopen+label%3Acontent)
- if you are developer and just eager to fix stuff please look at the [issues tagged with `bug` tag](https://github.com/NixOS/nixos-homepage/issues?q=is%3Aissue+is%3Aopen+label%3Abug)

If you feel lost where and how to contribute, ask [marketing team](https://nixos.org/teams/marketing.html) on [`#nixos-marketing` channel on IRC](irc://irc.freenode.net/#nixos-marketing).


# How to help?

To run local development instance follow this steps:

    $ git clone git@github.com:NixOS/nixos-homepage.git
    $ cd nixos-homepage
    $ nix-shell

      To start developing run:
          python run.py

      and open browser on:
          https://127.0.0.1:8000

      It will rebuild the website on each change.

    [nix-shell]$ python run.py

Open your browser at: http://127.0.0.1:8000/index.html

In order for browser to automatically refresh install [Livereload extension](http://livereload.com/extensions/) for you browser.

Before creating a pull request make sure that `nix-build` runs successfully.


## License

The content of the website is licensed under the [Creative Commons Attribution Share Alike 4.0 International](LICENSES/CC-BY-SA-4.0.txt) license.

The software (including sample code) is licensed under the [MIT](LICENSES/MIT.txt) license.

Some files might have a different license. See the files content for details.
