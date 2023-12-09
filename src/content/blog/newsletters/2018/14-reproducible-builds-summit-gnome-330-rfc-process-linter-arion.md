---
title: "#14 - Reproducible builds summit, Gnome 3.30, RFC process, linter, Arion"
date: 2018-12-19
description: Start by doing what's necessary; then do what's possible; and suddenly you are doing the impossible.
---

# News

- Gnome 3.30 with [wayland support](https://github.com/NixOS/nixpkgs/pull/44497) has hit master

  To launch a wayland session simply use [GDM](https://nixos.org/nixos/options.html#gdm) or [SDDM](https://nixos.org/nixos/options.html#sddm) and select the `gnome` session.  Select `gnome-xorg` to run an X11 session. If you encounter a bug please cc @hedning on github.

- Fast Docker Compose 'deployments' for development with [Arion](https://github.com/hercules-ci/arion#readme)

  A little tool we use at [Hercules CI](https://www.hercules-ci.com) for process supervision of local developer environments. No need to export, load or garbage collect Docker images!

- [RFC0036 (Improving the RFC process) entered its Final Comments Period with a disposition of merge](https://github.com/NixOS/rfcs/pull/36)

  FCP will end on Dec. 20, so go and check no important point has been left undiscussed!

- [Hercules CI development update](https://blog.hercules-ci.com/hercules-ci/2018/12/18/hercules-ci-development-update/)

  A short demo of CI development progress in the last couple of weeks including what have we worked on.

- [Nix-linter v0.2.0.0 released](https://github.com/Synthetica9/nix-linter/releases)

  Nix-linter is a program to check for several common mistakes or stylistic errors in Nix expressions, such as unused arguments, empty let blocks, etcetera.

- [Nix community attended Reproducible builds summit](https://discourse.nixos.org/t/reproducible-builds-summit-report/1683/2)

- [Job: DevOps Team Lead](https://iohk.io/careers/#op-296340-devops-team-lead)

# Contribute to NixOS Weekly Newsletter

This work would not be possible without the many contributions of the community.

You can help too! Create or comment on the [pull request](https://github.com/NixOS/nixos-weekly/pulls)
for the next edition or look at the
[issue tracker](https://github.com/NixOS/nixos-weekly/issues) to add other improvements.
