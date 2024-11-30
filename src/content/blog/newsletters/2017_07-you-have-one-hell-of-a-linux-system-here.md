---
date: 2017-05-02
description: |
  You have one hell of a Linux system here - someone on #nixos IRC
  channel
title: '#07 - You have one hell of a Linux system here'
---

A few months ago a proposal to define improvements process
([nixos/rfcs](https://github.com/nixos/rfcs)) was announced.

While many contributions to Nix and NixOS related projects fits into
GitHub pull requests model, doing a substantial change requires more
involvement from the community.

Two months later we can see that NixOS community is picking up on the
process and RFCs are starting to show up each week.

# News

- First RFC to go through the process. What a milestone!

  RFC 0004: [Replace Unicode
  Quotes](https://github.com/NixOS/rfcs/pull/4) was voted to be
  implemented.

  And there is a good list of interesting RFCs which are being
  discussed:

  - (draft) RFC 0003: [SOS: Simple Override
    Strategy](https://github.com/NixOS/rfcs/pull/3)
  - (draft) RFC 0005: [Nix
    encryption](https://github.com/NixOS/rfcs/pull/5)
  - (draft) RFC 0008: [Readonly recursive
    Nix](https://github.com/NixOS/rfcs/pull/8)
  - (draft) RFC 0009: [Nix rapid
    release](https://github.com/NixOS/rfcs/pull/9)
  - (draft) RFC 0010: [Nixpkgs development
    support](https://github.com/NixOS/rfcs/pull/10)
  - (draft) RFC 0011: [Per project
    config](https://github.com/NixOS/rfcs/pull/11)
  - (draft) RFC 0012: [Declarative virtual
    machines](https://github.com/NixOS/rfcs/pull/12)

- [nix-index](https://github.com/bennofs/nix-index) by [Benno
  Fünfstück](https://github.com/bennofs)

  A tool to make the process of finding the packages and their files
  in nixpkgs easier.

- [styx](https://styx-static.github.io/styx-site/), a static site
  generator in Nix expression language.

  To give it a quick try:

  ```console
  $ nix-shell -p styx
  $ styx new site mysite && cd mysite
  ```

- NixOS at Linux Infotag Augsburg

  Last week Linux Infotag Augsburg ("Linux Info Day") happened at
  Hochschule Augsburg. Like last year and the year before, a NixOS
  booth was organized. [A Short
  Retrospective](http://profpatsch.de/blog/posts/nixos-on-lit-2017.html)
  by [Profpatsch](https://github.com/Profpatsch).

- And in case you didn\'t know \...

  [Nix package manager works flawlessly in Windows 10 Creators Update
  with Windows Subsystem for
  Linux](https://www.reddit.com/r/NixOS/comments/64xyd7/nix_package_manager_works_flawlessly_in_windows)

# Reading

- [My journey into
  Nix](https://adelbertc.github.io/posts/2017-04-03-nix-journey.html)
- [My first Nix
  derivation](https://adelbertc.github.io/posts/2017-04-08-first-nix-derivation.html)
- [Reimplement \"npm install -g\" with nix and
  bash](http://nicknovitski.com/nix-npm-install)
- [Create a blog with
  styx](https://styx-static.github.io/styx-theme-hyde/posts/2016-09-19-blog-tutorial.html)

# Events / Meetups

- **Thu, May 4, 2017**, [regular Meetup
  \@c-base](https://www.meetup.com/Berlin-NixOS-Meetup/events/239572944/),
  Berlin, Germany

  Generally, the event is not structured, we have no talks or
  presentations planned. It\'s up to the participants, what\'s going
  to happen.

# Editor\'s corner

Help us shape [next issue](https://github.com/NixOS/nixos-weekly/issues)
of the NixOS weekly newsletter.
