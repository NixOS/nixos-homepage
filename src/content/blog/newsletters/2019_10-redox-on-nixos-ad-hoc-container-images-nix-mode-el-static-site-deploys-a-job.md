---
title: '#10 - Redox on NixOS, ad-hoc container images, nix-mode.el, static site deploys, a job'
date: 2019-06-27
description: Someone is sitting in the shade today because someone planted a tree a long time ago - Warren Buffett
---

# News

- [A set of patches to build Redox on NixOS](https://gitlab.redox-os.org/redox-os/redox-nix)

  An attempt to embrace Nix instead of constantly working around the
  limitations to build Redox OS. The ultra optimistic long-term goal
  is to be a competing alternative to the GNU make build system the
  project currently uses, to make Redox builds reproducible and
  reliable.

- [An experiment: ad-hoc container images](https://nixery.appspot.com/)

  made by [@tazjin](https://twitter.com/tazjin)

- [Using NixOS as an stateless workstation](https://euandre.org/2019/06/02/stateless-os.html)

  EuAndreh goes through the journey of installing NixOS on their laptop.

- [nix-mode.el 1.4.1 release](https://github.com/NixOS/nix-mode)

  Added support for the indentation function `smie-indent-line` in
  [NixOS/nix-mode#79](https://github.com/NixOS/nix-mode/pull/79) &
  [NixOS/nix-mode#80](https://github.com/NixOS/nix-mode/pull/80).
  Thanks to @j-piecuch and @matthewbauer for the work and testing.

- [PDT Partners is looking for an experienced engineer](https://jobs.pdtpartners.com/?gh_jid=1473543)

  For our Software Infrastructure team, which is responsible for our build, packaging, CI and
  deployment tooling. We’re using Nix to package our complex C++ and Python stack, and as part of our wider
  development environment for our fast-moving trading and research applications.

- [Complete overkill or exactly right? Deploying a static site using nix
  ](http://mpickering.github.io/posts/2019-06-24-overkill-or-not.html)

- [Introducing nixpkgs-tungsten: The most convenient way to working with Tungsten Fabric
  ](https://dev.cloudwatt.com/en/blog/introducing-nixpkgs-tungsten.html)

  [Tungsten Fabric](https://tungsten.io) is the open-source offering of
  [Contrail](https://www.juniper.net/us/en/products-services/sdn/contrail/) by
  Juniper Networks - a powerful SDN solution used by many big names in the IT industry.
  The [nixpkgs-tungsten](https://github.com/cloudwatt/nixpkgs-tungsten) project provides
  tools and workflows that make it much easier to work with, and on Tungsten Fabric itself.

# Contribute to NixOS Weekly Newsletter

This work would not be possible without the many contributions of the community.

You can help too! Create or comment on the [pull request](https://github.com/NixOS/nixos-weekly/pulls)
for the next edition or look at the
[issue tracker](https://github.com/NixOS/nixos-weekly/issues) to add other improvements.
