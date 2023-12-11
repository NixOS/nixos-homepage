---
title: "#06 - NixOS Weekly"
date: 2020-06-29
description: The great aim of education is not knowledge but action - Herbert Spencer
---

# News

## Announcements

- [Nix error messages proposal: phase 2, PR 1 merged!](https://opencollective.com/nix-errors-enhancement/updates/nix-error-enhancement-phase-2-pr-1-merged)

  Nearly every C++ file in the repo was touched! This will be the biggest PR, by far, for this
  project. Getting this in is a major feat!

  Next up, I'm looking forward to finishing out this phase with showing the lines of code for errors,
  and supporting show-trace in the new format. I expect that PR to be much easier, both to make the
  changes and to review them.

- [Long-term reproducibility with Nix and Software Heritage](https://www.tweag.io/blog/2020-06-18-software-heritage/)

- [RFC 70](https://github.com/NixOS/rfcs/pull/70): Merge nixos-hardware into nixpkgs

- [NixOS 20.09 Release Manager has been selected](https://discourse.nixos.org/t/nixos-20-09-release-manager/7800/6)

## Tutorials & Resources

- [So, tell me about Nix](https://ghedam.at/15490/so-tell-me-about-nix)

  An introduction to the Nix ecosystem and a collection of resources to get started.

- [NixOS: How it works and how to install it!](https://www.youtube.com/watch?v=oPymb2-IXbg)

  Thorough overview of NixOS.

- [Github actions powered by Nix Shell & Cachix](https://gvolpe.github.io/blog/github-actions-nix-cachix-dhall/)

- [Tutorial: Ad hoc developer environments](https://nix.dev/tutorials/ad-hoc-developer-environments.html)

  Introduction how to get started with Nix for development in teams.

- [Tutorial: Towards reproducibility: Pinning nixpkgs](https://nix.dev/tutorials/towards-reproducibility-pinning-nixpkgs.html)

  Introduction for achieving reproducibility with Nix.

- [Tutorial: building and running Docker images](https://nix.dev/tutorials/building-and-running-docker-images.html)

- [Anti-patterns in Nix language](https://nix.dev/anti-patterns/language.html)

  A few short notes what to avoid when writing Nix.

- [ZuriHac: Overhaul of haskell.nix getting started](https://input-output-hk.github.io/haskell.nix/tutorials/getting-started/)

- [netboot.nix: 15 second netboot iterations](https://github.com/grahamc/netboot.nix/)

- [Windows-on-NixOS, part 2: Make it go fast!](https://nixos.mayflower.consulting/blog/2020/06/17/windows-vm-performance/)

- [Reproducible Builds with Nix](https://our.status.im/reproducable-builds-with-nix/)

  How Status.im, a messaging app, uses Nix to achieve the 'holy grail' of reproducible builds.

- [Mach-nix: Create python environments quick and easy](https://github.com/DavHau/mach-nix)

- [homelab using Nix and NixOS](https://thewagner.net/blog/2020/05/31/homelab/)

- [PureScript on Nix without dependency codegen](https://qiita.com/kimagure/items/9e75483c1263d85169e5)

- [Nix & libSystem](https://daiderd.com/2020/06/25/nix-and-libsystem.html)

  How nixpkgs links against macOS's system libraries.

- [home-manager template: get started in a reproducible way.](https://github.com/ryantm/home-manager-template)

- [Encypted Btrfs Root with Opt-in State on NixOS](https://mt-caret.github.io/blog/posts/2020-06-29-optin-state.html)

- [NixOS ❄: tmpfs as root](https://elis.nu/blog/2020/05/nixos-tmpfs-as-root/) & [NixOS ❄: tmpfs as home](https://elis.nu/blog/2020/06/nixos-tmpfs-as-home/)

  Tutorial with step by step instructions for installing NixOS on tmpfs. Also an introduction to how
  to have a usable `/home` on tmpfs.

## Jobs

- [Help Shopify rebuild our world in Nix](https://discourse.nixos.org/t/remote-help-shopify-rebuild-our-world-in-nix/7571)

  Shopify is looking to grow a Nix team to continue its roll-out of Nix-based environments to
  development, CI, and production, across macOS and Linux.

# Contribute to NixOS Weekly Newsletter

This work would not be possible without the many contributions of the community.

You can help too! Create or comment on the [pull request](https://github.com/NixOS/nixos-weekly/pulls)
for the next edition or look at the
[issue tracker](https://github.com/NixOS/nixos-weekly/issues) to add other improvements.

