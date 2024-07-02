---
title: "#11 - Nixery, nixfmt and Cachix releases, NixCon 2019 tickets, a job and first impressions post"
date: 2019-07-31
description: The things that we love tell us what we are - Thomas Aquinas
---

# News

- [nix is now easier to bootstrap](https://github.com/NixOS/nix/pull/2979) on Linux distributions without previous nix installation.

  Non-NixOS users are encouraged to try and report whether the improved autoconf checks make it easier to build it from source.

- [`static-haskell-nix` started a crowd-funding](https://github.com/NixOS/nixpkgs/issues/43795#issuecomment-503048915) on [OpenCollective](https://opencollective.com/static-haskell-nix) during [ZuriHac](https://zfoh.ch/zurihac2019/) to get its own dedicated Hetzner build server. Amazingly, the funding goal was reached [within only 4 days](https://github.com/NixOS/nixpkgs/issues/43795#issuecomment-504266116)!

- A big rework of the `gstreamer` package landed in nixpkgs with the [upgrade to 1.16](https://github.com/NixOS/nixpkgs/pull/54398).

  It also demonstrates how `meson`-build-system-based projects can be configured to complain loudly about any missing dependencies, as opposed to silently disabling features (like many `autoconf` based build systems do).

- [Cachix 0.2.1 released](https://github.com/cachix/cachix/blob/master/cachix/CHANGELOG.md#021---2019-07-05)

  Upgrade via the usual: `$ nix-env -iA cachix -f https://cachix.org/api/v1/install`

  Notable improvement is the default compression level which has been lowered to increase
  bandwidth throughput and it's overridable via `--compression-level`.

- [Hercules CI #5 update requiredSystemFeatures, Cachix and Darwin
  support](https://blog.hercules-ci.com/sprints,/hercules-ci/2019/07/09/development-update-5-cachix-da
  rwin/)

  Preview access for the CI has been given to all subscribers as we've reached feature parity for the
  public launch.

- [The NixCon 2019 ticket sale has started](https://discourse.nixos.org/t/nixcon-2019-ticket-presale/3434)

- [Functional DevOps in a Dysfunctional World](https://vaibhavsagar.com/blog/2019/07/04/functional-devops/index.html)

- [Leveraging NixOS tests in your project](https://nixos.mayflower.consulting/blog/2019/07/11/leveraging-nixos-tests-in-your-project/)

- [Obsidian Systems is hiring a Nix engineer](https://www.reddit.com/r/NixOS/comments/cf8ni3/job_offer_obsidian_systems_is_hiring_a_nix/)

- [nixfmt 0.2 release](https://discourse.nixos.org/t/nixfmt-beta-release/3545)

  Please try it out on your code and give us feedback!

- [Nixery is a tiny service that implements Docker’s registry protocol for serving images](https://discourse.nixos.org/t/nixery-serve-container-images-straight-from-nix/3579)

- [Nix and NixOS: first impressions](https://ian.pw/posts/2019-07-19-nix-nixos-first-impressions.html)

# Contribute to NixOS Weekly Newsletter

This work would not be possible without the many contributions of the community.

You can help too! Create or comment on the [pull request](https://github.com/NixOS/nixos-weekly/pulls)
for the next edition or look at the
[issue tracker](https://github.com/NixOS/nixos-weekly/issues) to add other improvements.
