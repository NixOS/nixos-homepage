---
date: 2017-04-03
description: |
  Tonight We Ride - Said The King To The River from La Dispute
title: '#05 - Tonight We Ride'
---

The [17.03 \"Gorilla\"
release](http://lists.science.uu.nl/pipermail/nix-dev/2017-March/023302.html)
has been tagged! There are too many good things in this release to pick
favourites. I refer you to the [release
notes](https://github.com/NixOS/nixpkgs/blob/master/nixos/doc/manual/release-notes/rl-1703.xml)
instead.

Some fun stats:

- \~ 900 new packages since 16.09
- \~ 80 new contributors (very inexact science this)
- \~ 60 new services

# News

- Did I mention the release? [Robin](https://github.com/globin) has
  been doing a fantastic job, thank him when you meet him! He\'s also
  had a lot of help of course, so thanks to all those people as well.
  It\'s a pretty long list and you can get it with
  \"`git shortlog 8def08..17.03`\".
- [Extra capacity is coming for Hydra OSX
  builds](https://twitter.com/nixos_org/status/847018039115702272),
  thanks to all the great people that have donated to NixOS
  Foundation.
- We now have an [official RFC
  process](https://github.com/NixOS/rfcs). Thanks to zimbatm for
  writing our first ever RFC. We already have [three pull
  requests](https://github.com/NixOS/rfcs/pulls) so go forth and
  comment.
- [remove-perl](https://github.com/NixOS/nix/pull/1027) branch just
  got merged to master. Time to celebrate.
- Sander [released Disnix 0.7](https://nixos.org/disnix)
- Théophane has started his work on typing Nix. You can [follow along
  here](https://typing-nix.regnat.ovh/). He\'s also answering some
  questions in [this mailing list
  thread](http://lists.science.uu.nl/pipermail/nix-dev/2017-March/023274.html).

# Reading

- One long-standing issue in Nix has been the storage of secrets.
  Right now [many of our
  services](https://github.com/NixOS/nixpkgs/issues/24288) store their
  secrets in `/nix` where they are world readable. This means you
  can\'t have root-only secrets, multi-user systems are problematic,
  and if one of your services is compromised it can be used to steal
  all your other secrets. Eelco created an RFC for [encrypting secrets
  at rest](https://github.com/NixOS/rfcs/pull/5/files).
- [Monte](https://monte.readthedocs.io/en/latest/index.html) is a
  dynamic language inspired by Python and E. It uses Nix, _under the
  hook_, for its
  [packaging](https://monte.readthedocs.io/en/latest/packaging.html).
  Worth checking out if you are writing a new languge and want to see
  how Nix help you.
- [A Gentle Introduction to the Nix Family](http://ebzzry.io/en/nix/)
  by Rommel Martinez.

# Meetups

- **Apr 4, 2017**, [NixOS April
  Meetup](https://www.meetup.com/NixOS-Dublin/events/238418033),
  Dublin, Ireland

  Two presentations:

  - Immutable deployments in Rapid7 by Ulrich Dangel
  - Basics of Nix by Kevin Cox

- (Future) Let us know if you are organizing a Nix / NixOS event.

# Editor\'s corner

A substantial part of the effort of publishing the \"weekly\" news is
collecting the news in the first place. If you see anything cool, want
to share a job, meetup or presentation add a comment with your item at
<https://github.com/NixOS/nixos-weekly>. It\'s super helpful!
