---
date: 2017-03-13
description: |
  Everything not saved will be lost. (Nintendo Quit Screen message)
title: '#04 - Everything not saved will be lost'
---

Nix, NixOS and nixpkgs are all moving ahead at good speed. The [17.03
milestone](https://github.com/NixOS/nixpkgs/milestone/10) is more than
50% complete, and we merged 144 pull requests for nixpkgs just in the
last seven days.

# News

- The [NixOS 17.03
  beta](http://lists.science.uu.nl/pipermail/nix-dev/2017-March/022979.html)
  has been announced.
- We now allow packages to be marked insecure, and you have to opt-in
  to install insecure packages similarly to how you opt in to non-free
  software. The option is called `permittedInsecurePackages`. See the
  [updated docs](https://github.com/NixOS/nixpkgs/pull/23130) for
  more.
- Robin finished the [systemd 232
  update](https://github.com/NixOS/nixpkgs/commit/a38f1911d34f2a72e15d5e98d76bece6cb8042a8)
  which opens up several new [opportunities for
  hardening](https://github.com/NixOS/nixpkgs/issues/20186). It will
  also allow us to move away from hard-coded user IDs for less
  important services. Just use `DynamicUser = true`.
- Thanks to Graham we now have [aarch64
  support](https://github.com/NixOS/nixpkgs/pull/23638), and it\'s
  even being built by Hydra! Many of you will have noticed already
  from the beautiful stream of emails for each succeeding and failing
  package.
- Progress on the [proposal for
  RFC](https://github.com/zimbatm/rfcs/pull/1) which started from a
  FOSDEM discussion.
- [Move NodeJS to separate overlay
  repository?](http://lists.science.uu.nl/pipermail/nix-dev/2017-March/023043.html)
  (discussion)

# Reading

- [From Vagrant to
  NixOps](https://blog.mayflower.de/5976-From-Vagrant-to-Nixops.html)
  by [Hendrik Schaeidt](https://twitter.com/hschaeidt)

  A walkthrough to configure a symfony2 project with nginx, mysql, and
  php-fpm from scratch.

# Presentations

- [Eric Sagnes](https://github.com/ericsagnes) gave an introductory
  NixOS talk in Japanese. The [slides are
  here](https://github.com/Tokyo-NixOS/presentations).
- [Maksim Bronsky](https://twitter.com/dvhfm) presented
  [Vulnix](https://github.com/flyingcircusio/vulnix) at [Chemnitzer
  Linux-Tage](https://chemnitzer.linux-tage.de/2017/en/programm/beitrag/314).
  The
  [slides](https://github.com/flyingcircusio/vulnix/raw/master/doc/2017-03-11-Vulnix.pdf)
  (PDF download, DE only) are in the repository.
- [Lenko Donchev](https://twitter.com/lenkodonchev) gave a lightning
  talk \"NixOS the purely functional Linux distribution\". The
  [slides](https://speakerdeck.com/lenkodonchev/nixos-the-purely-functional-linux-distribution)
  are available online.
- John Wiegley gave a presentation \"How I use nix for Haskell
  development\" at the Bay Area Nix/NixOS User Group.
  [Video](https://youtu.be/G9yiJ7d5LeI) available.

# Meetups

- **Mar 24, 2017**, [Tokyo NixOS
  Meetup](https://www.meetup.com/ja-JP/Tokyo-NixOS-Meetup/events/238329705/),
  Tokyo, Japan

  My Japanese isn\'t good enough to figure out the speaker, but if you
  live in Japan you should go!

- **Mar 29, 2017**, [Munich NixOS
  Meetup](https://www.meetup.com/Munich-NixOS-Meetup/events/237831744/?eventId=237831744)
  at [OpenLab
  Augsburg](https://maps.google.com/maps?f=q&hl=en&q=48.357765,10.886834),
  Augsburg, Germany

  John Darrington will give a talk about guix and guixSD, a package
  manager and a Linux distribution which are based on similar concepts
  as nix/NixOS.

  The talk will be in English.

## Meetups that just happened

- **Feb 24--26, 2017**,
  [HackIllinois](https://medium.com/@HackIllinois/open-source-2017-b322ad688471#.vim3uki6h),
  University of Illinois, USA

  For any university students in the US, the University of Illinois at
  Urbana-Champaign is holding a hackathon oriented towards getting
  people into open source development, and I\'m going to be mentoring
  people for Nix/NixOS/Haskell development. Be sure to put \"NixOS\"
  or \"Haskell\" into your application somewhere.

- **Feb 25, 2017**, [Amsterdam Nix
  Meetup](https://www.meetup.com/Amsterdam-Nix-Meetup/events/232753333/)
  at [Container
  Solutions](https://maps.google.com/maps?f=q&hl=en&q=de+Ruyterkade+142-143%2C+Amsterdam%2C+nl),
  Amsterdam, Netherlands

- **Mar 02, 2017**, [Bay Area Nix/NixOS User
  Group](https://www.meetup.com/Bay-Area-Nix-NixOS-User-Group/events/237430925/)
  at Takt, San Francisco, USA

  See the presentation about using Nix for Haskell development above.

- **Mar 12, 2017**, [London NixOS User
  Group](https://www.meetup.com/NixOS-London/events/237738532/) at
  [Smarkets](https://smarkets.com/about), London, UK

  Smarkets kindly offered us a space for our second community hackday!

  There will be talking, pizzas and lots of packaging going on. Bring
  your own projects or just tag along and help other people out.
  Whether you have some software that you\'d like to see packaged or
  questions about how everything fits together, there will be people
  available to help you.

# Questions

- [In a new nixos derivation, based on a binary distribution, why am I
  getting an error referring to
  nativeBuildInputs?](http://unix.stackexchange.com/questions/350997/in-a-new-nixos-derivation-based-on-a-binary-distribution-why-am-i-getting-an-e)
- [NixOS container
  networking](http://lists.science.uu.nl/pipermail/nix-dev/2017-March/023056.html).
- [LXC containers on
  NixOS](http://lists.science.uu.nl/pipermail/nix-dev/2017-March/023008.html).
- [Virtualization on
  NixOS](https://www.reddit.com/r/NixOS/comments/5xoewu/virtualization_on_nixos/).

# Jobs

> [Looking for some Nix developers? Let us help
> you.](https://github.com/NixOS/nixos-weekly/issues/new)

- The Blue Brain Project recruit and is looking for someone with
  packaging, NixOS / Nix packaging knowledges and with a software
  engineering background. If any of you might be interested :
  <http://emploi.epfl.ch/page-142376-en.html>, The job is in
  Switzerland, Geneva, Swiss salary and Work visa granted for EU
  citizen if recruited.

# Editor\'s corner

First time run for [me](https://twitter.com/jbornhold) to take care as
the editor for an edition of [NixOS Weekly]{.title-ref}. It has been
fantastic to see a few people spontaneously helping out to make it
happen after a call for help from [Rok](https://twitter.com/garbas).

Contributions are easy: Send a pull request to the
[repository](https://github.com/NixOS/nixos-weekly) or comment on the
open issue for the next edition by providing a hint regarding a
presentation, an event, a relevant change or discussion.
