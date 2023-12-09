---
date: 2018-10-03
description: |
  Start by doing what\'s necessary; then do what\'s possible; and
  suddenly you are doing the impossible.
title: "#10 - AArch64 builders, NixOps alternative, optimised docker
  layers, Hercules CI"
---

# News

-   [Exploring Nix & Haskell Part 1: Project
    Setup](https://functional.works-hub.com/learn/exploring-nix-and-haskell-part-1-project-setup-0edb2)

    This is the first of a series of posts, with the overarching goal of
    building up a deterministic Haskell development environment using
    Nix, including a modern IDE experience and any tooling built-in.

-   [New Aarch64 (and armv7l-linux omg!)
    builders](https://discourse.nixos.org/t/new-aarch64-and-armv7l-linux-omg-builders/1010)

-   [New shirt and logo for 18.09
    release](https://www.redbubble.com/people/mogorman/works/34062374-nixos-18-09-jellyfish?asc=u)

-   [krops as an alternative to
    NixOps](https://tech.ingolf-wagner.de/nixos/krops/)

    NixOps, the official DevOps tool of NixOS, is nice but it has some
    flaws. krops is an alternative to NixOps trying to solve some of
    these flaws.

-   [Developer friendly backdoor to VM tests
    infrastructure](https://github.com/NixOS/nixpkgs/pull/47418)

-   [Optimising Docker Layers for Better Caching with
    Nix](https://grahamc.com/blog/nix-and-layered-docker-images)

    Check out how Graham created Nix tooling to automatically build
    Docker images with great cache characteristics by using Nix\'s
    reference graph to separate out important layers.

-   [Announcing Hercules CI - Continuous Integration service for Nix
    users launching beta in November](https://hercules-ci.com)

    Some distinguishing features:

    :   -   Great integration with Nix
        -   Host build agents wherever you want
        -   Free plan for open source!

-   [Cachix (binary cache as a service) client 0.1.2
    released](http://hackage.haskell.org/package/cachix-0.1.2/changelog)

-   [nix repl \'\<nixpkgs/nixos\>\' will let you check out your
    configuration
    results](https://twitter.com/IotaSamurai/status/1045220406792048640)

-   [Snowflake (language-agnostic, toolchain-agnostic build system built
    on top of Nix) v0.0.2
    released](https://groups.google.com/forum/#!topic/snowflake-announcements/4t4JXbYZP3k)

-   [Japanese on
    NixOS](https://functor.tokyo/blog/2018-10-01-japanese-on-nixos)

    An explanation of how to setup an environment for reading and
    writing Japanese on NixOS

# Contribute to NixOS Weekly Newsletter

This work would not be possible without the many contributions of the
community.

You can help too! Create or comment on the [pull
request](https://github.com/NixOS/nixos-weekly/pulls) for the next
edition or look at the [issue
tracker](https://github.com/NixOS/nixos-weekly/issues) to add other
improvements.
