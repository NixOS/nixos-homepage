---
id: nixos-progress-report-2007-september
title: NixOS progress report
date: 2007-09-22T00:00:00.000Z
category: announcements
---
 [![NixOS screenshot](/images/screenshots/nixos-games.png)](/images/screenshots/nixos-games.png) [Wine](https://www.winehq.org/) now runs on NixOS! Finally we can run all those [legacy applications](/images/screenshots/nixos-games.png)... Thanks to Michael Raskin for adding Wine and a NPTL-enabled Glibc (which Wine seems to need). This is a nice application of purely functional package composition, by the way: Wine didn’t work with the standard Glibc in Nixpkgs, so we just [pass it another Glibc at build time](https://svn.nixos.org/viewvc/nix/nixpkgs/trunk/pkgs/top-level/all-packages.nix?r1=9165&r2=9164&pathrev=9165).

In other news, Nix 0.11 and Nixpkgs 0.11 will be released soon.
