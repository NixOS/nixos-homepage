---
title: '#02 - 19.03 feature freeze, EU grants, reproducibility, Nix in Debian'
date: 2019-02-07
description: Today is the only day. Yesterday is gone.
---

# News

- [Nix](https://ftp-master.debian.org/new/nix_2.2.1-2.html) is now available in Debian

- [NixOS 19.03 feature freeze](https://discourse.nixos.org/t/nixos-19-03-feature-freeze/1950)

- [nixos-generators](https://github.com/nix-community/nixos-generators)

  The nixos-generators project allows to take the same NixOS configuration, and generate outputs for different target formats i.e. ISO, kexec tarballs, qemu's qcow2 format, google cloud images...

- Code archeology: 15 years ago Nix files had `.fix` extension.

  Compare original [MPlayer expression](https://github.com/NixOS/nixpkgs/blob/0.4/pkgs/MPlayer/MPlayer.fix), it's [first rewrite](https://github.com/NixOS/nixpkgs/blob/0.4/pkgs-ng/applications/video/MPlayer/default.fix) and [modern view](https://github.com/NixOS/nixpkgs/blob/master/pkgs/applications/video/mplayer/default.nix)

- [hydra-in-a-bag](https://github.com/samueldr/hydra-in-a-bag)

  by @samueldr aims to provide a **one-click** command solution to running a hydra instance **for development purposes**.

- [Contributing to NixOS/Nixpkgs](https://discourse.nixos.org/t/call-for-proofreaders-and-beta-testers-for-19-03/1980)

  Matthew Bauer makes great recommendations on non-programming ways you can help make 19.03 the best NixOS release yet.

- [NixOS Foundation participating in EU's Next Generation Internet initiative](https://discourse.nixos.org/t/nixos-foundation-participating-in-eus-next-generation-internet-initiative/2011)

  Grants are available to make your privacy-enhancing or search-and-discovery project.

- [Is NixOS image binary reproducible?](https://r13y.com)

  Initial testing shows NixOS's minimal ISO image is already over 98% reproducible, thanks to the great effort of many contributors.

- [Mapping a universe of open source software](https://www.tweag.io/posts/2019-02-06-mapping-open-source.html)

  The repositories of distributions such as Debian and Nixpkgs are among the largest collections of open source (and some unfree) software. They are complex systems that connect and organize many interdependent packages. In this blog post we try to shed some light on them from the perspective of Nixpkgs, mostly with visualizations of its complete dependency.

- [How we use Nix at IOHK](https://iohk.io/blog/how-we-use-nix-at-iohk/)

- [Dhall - Year in review](http://www.haskellforall.com/2019/01/dhall-year-in-review-2018-2019.html)

# Contribute to NixOS Weekly Newsletter

This work would not be possible without the many contributions of the community.

You can help too! Create or comment on the [pull request](https://github.com/NixOS/nixos-weekly/pulls)
for the next edition or look at the
[issue tracker](https://github.com/NixOS/nixos-weekly/issues) to add other improvements.
