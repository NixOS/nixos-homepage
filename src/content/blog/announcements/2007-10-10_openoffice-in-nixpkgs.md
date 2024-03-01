---
id: openoffice-in-nixpkgs
title: OpenOffice in Nixpkgs
date: 2007-10-10T00:00:00.000Z
category: announcements
---
 [![OpenOffice screenshot](/images/screenshots/nixos-openoffice.png)](/images/screenshots/nixos-openoffice.png) [OpenOffice](https://www.openoffice.org/) is now in Nixpkgs ([screenshot of OpenOffice 2.2.1 running under NixOS](/images/screenshots/nixos-openoffice.png), and [another screenshot](https://web.archive.org/web/20160528175628if_/https://www.denbreejen.net/public/nixos/nixos-oo-scrs.png)). Despite being a rather gigantic package (it takes two hours to compile on an Intel Core 2 6700), OpenOffice had only two “impurities” (references to paths outside of the Nix store) in its [build process](https://svn.nixos.org/viewvc/nix/nixpkgs/trunk/pkgs/applications/office/openoffice/) that had to be resolved — a reference to /bin/bash and one to /usr/lib/libjpeg.so.

Armijn Hemel, Wouter den Breejen and Eelco Dolstra contributed to the Nix expression for OpenOffice.
