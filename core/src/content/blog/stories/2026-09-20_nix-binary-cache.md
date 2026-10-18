---
id: nix-binary-cache
title: 'One Billion Objects and No Database: Inside cache.nixos.org'
date: 2026-09-20T12:00:00.000Z
category: stories
authors:
  - name: Rok Garbas
    discourse: garbas
  - name: Steve Swoyer
    discourse: reyows.evets
---

Amazon Web Services (AWS) has renewed its sponsorship for `cache.nixos.org`, the Nix public binary cache, enabling the operation of this foundational infrastructure for another year.

AWS's support started in 2023, when its Open Source Strategy and Marketing team, along with its Open Data team, stepped in when a previous sponsorship was discontinued.
At this time, the growth of the Nix ecosystem was reaching an inflection point, outpacing the NixOS Foundation's capacity to sustain it.
The cache is a foundational piece of Nix infrastructure, depended on by Nix users worldwide, and its maintenance a high priority for the entire community.

Ron Efroni, then a NixOS Foundation board member and now its president, in concert with [Dave Nalley](https://www.linkedin.com/in/davidnalley/), director of developer experience at AWS, led a conversation that, in the span of around two weeks, [resolved the concerns about the cache's stability](https://discourse.nixos.org/t/nixos-s3-short-term-resolution/29413).
AWS agreed to cover the cache's hosting costs for 12 months, a substantial contribution which was renewed in [2024](https://discourse.nixos.org/t/s3-sponsorship-extension-more-resources-to-build-a-more-sustainable-nix/50936), [2025](https://discourse.nixos.org/t/2025-s3-sponsorship-more-resources-for-a-sustainable-nix/67019), and now again for 2026.

## Not just any package repository

Users most often encounter the cache as the authoritative package repository for both NixOS and the Nix package manager.
Without a cache, every Nix client would build every package from source, which can take hours or even days and needs hardware many users do not have.
Most Nix workflows would grind to a halt.

In serving prebuilt packages, the cache resembles the repositories maintained by Debian, Fedora, and Homebrew.
For downloading and running software, the [Nix archive (NAR)](https://nix.dev/manual/nix/stable/protocols/nix-archive) fetched from `cache.nixos.org` is the same as a `.deb`, `.rpm`, or Homebrew bottle.
But underneath, the Nix cache differs radically in its implementation, reflecting Nix's radically different approach to software packaging.

Traditionally, installing software on Linux meant extracting the necessary files from a package archive and distributing them to conventional locations around the filesystem.
While simple, this approach has led to a number of inconveniences.
When packages depend on conflicting versions of the same library, for example, they cannot be installed at the same time, since the two versions' files have to be placed at the same paths.
This is a problem especially for developers, who routinely need to switch between different versions of their toolchains.

Nix solves this problem by doing away with conventional locations: each package or dependency is placed in its own [dedicated path](https://nixos.org/guides/nix-pills/18-nix-store-paths.html) under `/nix/store/`.
A NAR fetched from the cache contains the compressed contents of a unique Nix store path, the directories and files that make up a specific package, dependency, or build artifact.
This store path is _always_ unique because it includes a [hash derived from all the inputs](https://nixos.org/guides/nix-pills/18-nix-store-paths.html?highlight=hash#output-paths) used to build its contents.
Nix prepends this input-addressed hash to the package's name and version, like so: `/nix/store/s5w9gi7p8m7yx878yxkf8q8480i82qj7-cowsay-3.8.4`.

By using input-addressed store paths, Nix guarantees a set of properties that are analogous to the atomicity, consistency, isolation, and durability (ACID) guarantees of a relational database.

<img
  src="/images/blog/stories/nixs-acidic-properties.svg"
  alt="Table of Nix's ACID-like guarantees: atomicity, consistency, isolation, and durability, each with what Nix provides and its caveats."
  style="display: block; margin: 1rem auto; float: none; max-width: 100%; height: auto;"
  decoding="async"
  loading="lazy"
/>

These properties are what give you reproducible build- and run-time behavior, reliable rollbacks, automatic garbage collection, and safe multi-user installations.
This means that users can install, upgrade, or remove packages on the same system at the same time, including packages that pull in conflicting versions of the same dependencies.
For example, if you need to run `kubectl` 1.27 (built from an older package set that uses `glibc` 2.35) alongside Git 2.51 (built from a newer package set that uses `glibc` 2.40), _both_ programs can coexist on the same machine thanks to Nix's hashed, input-addressed store paths.
And once store objects (packages, build inputs, etc.) are no longer referenced by the global system or individual users' profiles, Nix can automatically reclaim that disk space.

### Populating the cache

The Nix binary cache is populated by an automated build pipeline centered around Nix's [Hydra CI system](https://github.com/NixOS/hydra), which directs a pool of geographically distributed builder machines.

When a maintainer makes a commit that updates a [Nix expression](https://nix.dev/manual/nix/stable/language/) in the [Nixpkgs GitHub repo](https://github.com/NixOS/nixpkgs), either by changing its version, dependencies, patches, build instructions, tests, or post-built actions, this triggers Hydra to:

- evaluate the commit's Nix expressions across the whole jobset (more than 211,000 packages);
- generate derivations from those expressions;
- compare them to what's already been built and cached;
- queue only the new or changed derivations for builds.

Hydra runs many jobsets several times per day as new commits land on active branches, although especially large and expensive jobsets (such as `nixos/unstable`) tend to run less frequently.
It signs and uploads successful builds to `cache.nixos.org`, where they're then available as prebuilt binaries.

Interestingly, since around July of 2026, Hydra runs nearly 40,000 _fewer_ build jobs than it did just a year ago.
The reason for this is that Nixpkgs recently dropped support for macOS platforms running on `x86-64`.
This coincides with Apple's planned transition away from Intel-based Macs — starting with the upcoming Golden Gate release, new versions of macOS will run only on Apple Silicon.

<img
  src="/images/blog/stories/nix-binary-cache-ci.svg"
  alt="The binary cache build pipeline: a maintainer commit to Nixpkgs triggers Hydra to evaluate expressions, calculate derivations, queue new builds, and upload signed results to the cache."
  style="display: block; margin: 1rem auto; float: none; max-width: 100%; height: auto;"
  decoding="async"
  loading="lazy"
/>

A number of artifacts from this CI pipeline end up in the cache.

- **[Nix Archive (NAR)](https://nix.dev/manual/nix/stable/protocols/nix-archive) files**

  These `nar.xz` or `nar.zst` files, stored at `nar/`, contain the compressed contents of a single `/nix/store/` path.
  The NAR format is comparable to `tar`, but much simpler: NARs don't need to support long filenames, POSIX attributes, a wide range of extensions, or rich metadata.
  They're designed to serialize a filesystem object tree, including bare directory structure, file contents, symlinks, and basic metadata.

  The NAR format is an excellent example of simple, stable design: it hasn't been revised or extended since its introduction — [more than 20 years ago](https://github.com/NixOS/nix/commit/a09e66da5af348dc25e3b372ec9f518d3532f863).

- **Archive information files**

  These are top-level files named `<store-hash>.narinfo`.
  Think of them as tiny text records that point to the compressed NAR, record its sizes and hashes, list the store paths it references as runtime dependencies, and carry the Hydra build farm's signature so clients can verify the artifact.
  Despite each individual file's negligible size, there are more than 90 GB of `narinfo` files in the S3 bucket used to host the Nix binary cache.

- **Build logs**

  The `log/` folder stores the output of Nix build jobs for debugging and auditing.
  This allows anyone to fetch the build log for a cached store path with `nix log /nix/store/<store-hash>-package-name`.

- **Content-addressed mappings**

  Metadata in the `realisations/` folder maps derivations to their content-addressed store paths.
  This is relevant for builds using [content-addressed derivations (CA-derivations)](https://wiki.nixos.org/wiki/Ca-derivations).

- **Store metadata**

  `nix-cache-info` is a small metadata file that describes the basic design of the cache as a whole, such as the cache version and its supported features.

### BYOBC

The _official_ `cache.nixos.org` lives in S3, but if you happen to have half a petabyte of available storage, you could definitely roll your own.
As we explained previously, each package in `cache.nixos.org` has been built from source by a pool of geographically distributed builders — bare-metal and cloud alike, spanning most of Europe — using Nix's own CI.

This build-time reproducibility is possible because the recipes Nix uses to build software, [derivations](https://nix.dev/manual/nix/stable/language/derivations.html) and [the Nix language](https://nix.dev/manual/nix/stable/language/), don't imperatively _prescribe_ anything.
Build recipes are expressed in the Nix language; Nix evaluates these to produce a derivation, or a low-level build specification.
The derivation records every declared input; so as long as inputs remain available (via `cache.nixos.org`, in Nixpkgs, or locally) Nix can reproduce any build, anywhere, at any time.

This makes it so _anyone_ can host their own Nix binary cache if they wanted, just by cloning the [Nixpkgs GitHub repo](https://github.com/NixOS/nixpkgs) and building every package from source.
They would need at least a terabyte of space just for the build step, and they will probably want to provision a pool of concurrent builders.
And they would need to foot the bill for the data egress charges associated with serving millions of users.
But this isn't just technically possible, it's _doable_.
The Flox Binary Cache is one such example: it applies the same principle of reproducible Nix builds to provide prebuilt packages (including [CUDA-accelerated packages](https://flox.dev/blog/the-flox-catalog-now-contains-nvidia-cuda/) like PyTorch and TensorFlow) directly from canonical Nixpkgs definitions.

And the best part is that, when built against the same Nixpkgs commits, packages in Flox's or anyone/anywhere's binary cache [are almost always _bit-for-bit identical_](https://luj.fr/blog/is-nixos-truly-reproducible.html) to those in `cache.nixos.org`. That's because Nix builds run inside an isolated sandbox.
This means that only explicitly declared inputs are available, so your toolchain can't silently pull in host libraries, environment variables, arbitrary metadata, or other kinds of state.
If the inputs match, the outputs match too.

Building deterministically at this scale is surprisingly difficult to achieve.
In practice, Nix's functional build pattern nails it for the overwhelming majority of packages ([about 99.9%](https://hal.science/hal-05630285v1)), with the remaining sliver being tracked (and continuously chipped away at) as non-deterministic outliers.

<img
  src="/images/blog/stories/byobc.svg"
  alt="Comparison of the official cache.nixos.org with a self-hosted binary cache, covering storage requirements, builder pool, and monthly costs."
  style="display: block; margin: 1rem auto; float: none; max-width: 100%; height: auto;"
  decoding="async"
  loading="lazy"
/>

## Operating on an enormous scale

The overwhelming majority of Nix clients fetch and use software packages from the Nix binary cache.
It fields approximately 5,700 requests per second — almost _15 billion_ requests per month — and accounts for the vast majority of traffic handled by the public Nix ecosystem's CDN endpoints.
It stores 636 TB of data, with around 545 TB in AWS's infrequent-access storage tier and 91 TB in standard storage.
Just as impressive, `cache.nixos.org`, contains more than 1 billion objects, making it one of the largest public software caches on the Internet.

<img
  src="/images/blog/stories/binary-cache-at-a-glance.svg"
  alt="cache.nixos.org by the numbers as of July 2026: 636 TB stored, ~15 billion requests per month, over 1 billion objects, 94.29% cache hit ratio, 892 TB of bandwidth per week."
  style="display: block; margin: 1rem auto; float: none; max-width: 100%; height: auto;"
  decoding="async"
  loading="lazy"
/>

Such a feat requires careful design.
Faced with this challenge, one may be tempted to start diagramming complex architectures with eventually-consistent distributed databases and the like.

In a scene from American novelist Cormac McCarthy's _Blood Meridian_, a character exhibits a giant petrified dinosaur bone before a group of mystified, stupefied cowboys."Your heart's desire is to be told some mystery. The mystery is that there is no mystery", he tells them.

There is no mystery to the Nix binary cache: it is just a huge, signed key–value store hosted in an Amazon S3 bucket.
Every key is derived from a unique hash, and because there's no database lookup required, _there is no backing database_.
This avoids a slew of wicked problems that tend to arise when you're attempting to scale a massive project backed by a database.

The "fresh" contents of `cache.nixos.org` live in a single S3 bucket in the AWS `us-east-1` region.
The Nix binary cache also contains packages that are at more than a decade old, software that in some cases has disappeared from the Internet.
Because the Nix community has preserved its source code and build definitions, it's possible to rebuild it today, on modern systems, using its required dependencies.
As a cost optimization, these older, historical packages typically live in cheaper AWS storage tiers.
The bucket for less-frequently used packages recently moved to [S3 Intelligent-Tiering](https://docs.aws.amazon.com/AmazonS3/latest/userguide/intelligent-tiering-overview.html), which automatically shifts objects among "Frequent", "Infrequent", "Archive Instant", and "Archive" tiers, based on how often they're accessed.
This is expected to reduce storage costs, as well as the effort required of the [Nix Infrastructure team](https://nixos.org/community/teams/infrastructure/) to manage archived packages.

If the design of the Nix binary cache is conceptually simple, _distributing_ cached artifacts efficiently and reliably to consumers spread out across the world is a much more difficult problem.
To this end, a content distribution network, [Fastly](https://en.wikipedia.org/wiki/Fastly), sits in front of `cache.nixos.org` as its global caching layer.
If a Nix package isn't already cached, Fastly streams it from S3 as it arrives, so users don't have to wait for it to download before starting.
For very large files, Fastly splits them up — ironically, to get around its own size limitations.
It also transparently rewrites certain kinds of S3 permission errors, so users see `404: Not Found` errors, rather than foreboding `403: Forbidden` messages.
Finally, Fastly handles TLS for the `cache.nixos.org` domain at the edge, providing secure HTTPS connections to clients while communicating with S3 over TLS.

<img
  src="/images/blog/stories/cdn.svg"
  alt="Architecture of cache.nixos.org: an S3 bucket in us-east-1 using Intelligent-Tiering, fronted by the Fastly CDN as a global caching layer."
  style="display: block; margin: 1rem auto; float: none; max-width: 100%; height: auto;"
  decoding="async"
  loading="lazy"
/>

### Amazon S3 just works

Even though the binary cache is simple enough to be host on many different architectures, S3 is particularly suited to the task for a few specific reasons.
At the time `cache.nixos.org` was created, _there was basically no other option_.
In 2007, if you wanted access to distributed, highly available, pay-as-you-go object storage, your choices were Amazon S3 or … running Hadoop and HDFS yourself.
But unlike S3, HDFS isn't a key–value store — it isn't even an object store!
It's a hierarchical, POSIX-like filesystem, not a global bucket that anyone can fetch from over HTTP.

For the Nix community's requirements, S3's key-addressed object storage was the perfect substrate for `cache.nixos.org`: `.nar` and `.narinfo` files could be persisted as object keys and exposed via S3's internet-facing REST APIs.
S3 could store a virtually unlimited number of blobs, serve them up directly over HTTP, replicate them for durability, and scale to meet growing demand.
This was revolutionary at the time, and perfect for the "not trying to do too much" design ethos of `cache.nixos.org`.

Today, the Nix binary cache could live in virtually any other hyperscale cloud.
Its design ethos focused on simplicity means that it is not locked into a specific platform.
The cache is there because S3 works, and the rational choice is to keep it where it works — `cache.nixos.org` has been hosted on S3 for almost two decades, after all.

<!-- - **Yes**, the Nix community _is_ getting good infrastructure from AWS, and to the extent we can speak for the community, we're especially grateful for support from the AWS Open Source Strategy & Marketing and OpenData teams. That said, these facts cannot and should not influence the Nix community's and the Nix Infrastructure team's decision making. -->

This status quo was challenged in 2023, when one of the NixOS Foundation's principal financial sponsors discontinued its support.
During this time, Nix saw enormous growth, meaning that stable infrastructure was a priority concern.
The NixOS Foundation responded to this challenge with radical transparency, and issued a call for assistance from the Nix community and commercial vendors.
Our employer, Flox, was one of the vendors that responded to this call, along with others in the Nix-adjacent space.

AWS Open Source pledged credits to help fund `cache.nixos.org` for the fiscal year, a contribution which proved central to the sustainability of the Nix ecosystem and started what has become a proven track record of support for the binary cache.

### Maintaining the cache

At its core, the binary cache is just a signed collection of blobs in S3, which is itself a basic key–value store, with no backing database and almost no service-dependent logic.
This primitivity has the advantage of making the cache comparatively simple to _maintain_.

But there's an absolute difference between theory and practice.
_In theory_ `cache.nixos.org` is an ideal design, implemented in an ideal cloud service with ideal users and ideal usage characteristics.
_In practice_, and at scale, the binary cache is _low-_ but by no means _no_-maintenance.

Even the best, most thoughtful designs need upkeep, after all.
For the most part, the Infrastructure team supporting the binary cache does its work behind the scenes, to the point that the cache itself seems to "just work".
Nevertheless, this team has had to put out its share of fires, as well as deal with occasional crises.
The fact that it manages to keep a low profile is a testament to the efforts of its members, present and past.
While Amazon and the folks at AWS kindly help offset the fiscal (and, to some extent, technological) burden of hosting the Nix binary cache; the infra team shoulders the operational burden of keeping it available, responsive, and up-to-date.

## Acknowledgments

On behalf of the NixOS Foundation, we want to express our gratitude to AWS for its ongoing support.
Their help frees the Infra team to focus on durable fixes rather than day-to-day firefighting.
It also gives the team headroom for much more ambitious work, like better garbage collection, new mirroring options, and partnering opportunities.

If you'd like to learn more about Nix infrastructure (along with the people who support and maintain it), [check out their team page](https://nixos.org/community/teams/infrastructure/).

_Special thanks to Nix-whisperer [Tom Bereknyei](https://discourse.nixos.org/u/tomberek) for consultation, feedback, and hugely constructive criticism during the drafting of this article._
