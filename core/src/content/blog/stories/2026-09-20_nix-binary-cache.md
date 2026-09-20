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

AWS has renewed its support for `cache.nixos.org`, the public Nix binary cache, covering its hosting costs for another year. The cache is a foundational piece of Nix infrastructure, serving prebuilt packages to Nix and NixOS users worldwide at enormous scale. This is an excellent excuse for us to publish an article exploring what the binary cache is, how it works, how packages get into it, and why its architecture has remained both simple and effective for nearly two decades. This article also looks at the relationship between the cache and Nix’s core design, the infrastructure required to operate `cache.nixos.org` at global scale, and (most important) the people and organizations that help keep the binary cache running.

A few years ago, AWS's Open Source Strategy and Marketing group, joined by its OpenData group, stepped in at a crucial moment to help the NixOS Foundation cover a budget gap.

The relationship was kicked off by [a call-to-action post on NixOS Discourse](https://discourse.nixos.org/t/nixos-s3-short-term-resolution/29413), which led to a conversation between Ron Efroni–then a NixOS Foundation board member; now its president–and [Dave Nalley](https://www.linkedin.com/in/davidnalley/), director of developer experience with AWS. In just two weeks, and with heroic assists from several contributors across the Nix community, AWS agreed to sponsor the hosting costs for the Nix public binary cache for a 12-month period.

Since then, AWS picked up the hosting costs for the [2023, 2024, and 2025 fiscal years](https://discourse.nixos.org/t/2025-s3-sponsorship-more-resources-for-a-sustainable-nix/67019), too. For 2026, AWS agreed once again to cover the cost of hosting the binary cache for the next 12 months.

This article explains what the Nix binary cache is, why it matters, how it works, and how it’s architected. It also talks a little bit about Nix itself, showing how the properties that make Nix _Nix_—atomicity, isolation, determinism, input-addressing, and declarativity—are integral to the design and operation of `cache.nixos.org`.

## About `cache.nixos.org`

The Nix binary cache is the authoritative package repository for both NixOS and the Nix package manager.

If it did not exist, every Nix client everywhere would need to build every package from source. Not only can this take hours, days, or even weeks, it can also require resources some users just don't have.

So without `cache.nixos.org`, most Nix-based workflows would grind to a halt.

The role of the binary cache is comparable to package repositories maintained by the Debian, Fedora, and Homebrew projects. Just like with those repos, clients rely on the Nix binary cache (also known as `cache.nixos.org`) to download prebuilt software, saving them the time and trouble of building it from source themselves. At this level of abstraction, the [Nix archives (NAR)](https://nix.dev/manual/nix/stable/protocols/nix-archive) you get from `cache.nixos.org` are comparable to the `.deb` and `.rpm` packages you get from Debian and Fedora repos, or the bottles you get from Homebrew. In a more fundamental sense, however, they’re radically different.

Let’s talk a little bit about that difference.

## How Nix Is Different

Unlike `.deb` and `.rpm` packages, which typically install globally in the root filesystem (`/`), Nix puts each package or dependency into its own [dedicated path](https://nixos.org/guides/nix-pills/18-nix-store-paths.html) under `/nix/store/`. So when you fetch software from the Nix binary cache, the `.nar` files you download contain the compressed contents of a unique Nix store path: basically, all the folders and files for a specific package, dependency, or build artifact. The store path is _always_ unique because it includes a [hash derived from all the inputs](https://nixos.org/guides/nix-pills/18-nix-store-paths.html?highlight=hash#output-paths) used to build its contents. Nix prepends this input-addressed hash to the package’s name and version, like so: `/nix/store/<hash>-cowsay-3.8.4`.

If this seems like madness, there's a method to it. By using input-addressed store paths, Nix is able to guarantee some compelling properties, analogous in some respects to the ACID properties backed by a relational database. These properties enable benefits like reproducible build- and run-time behavior, reliable rollbacks, garbage-collected disk usage, and safe multi-user installs.

Nix can automatically reclaim disk space once Nix store objects (packages, build inputs, etc.) are no longer referenced by the global system, or by individual users’ profiles. Even better, multiple users can install, upgrade, or remove packages (even those that include _conflicting versions of the same dependencies_) on the same system, at the same time. For instance, say you need to run `kubectl` 1.27 (built from an older package set that uses glibc 2.35) alongside Git 2.51 (built from a newer package set that uses glibc 2.40): Thanks to Nix’s hashed, input-addressed store paths, _both_ CLIs can coexist peacefully in the same environment.

<img
  src="/images/blog/stories/nixs-acidic-properties.svg"
  alt="Table of Nix's ACID-like guarantees: atomicity, consistency, isolation, and durability, each with what Nix provides and its caveats."
  style="display: block; margin: 0 auto; float: none; max-width: 100%; height: auto;"
  decoding="async"
  loading="lazy"
/>

## Infinite Jest

The overwhelming majority of Nix clients fetch and use software packages from the Nix binary cache. It fields approximately ~5,700 requests per second—which works out to almost _15 billion_ requests per month!—and accounts for the vast majority of traffic handled by the public Nix ecosystem’s CDN endpoints. It stores 636 TB of data, with ~545 TB in AWS’ infrequent-access storage tier and ~91 TB in standard storage. Just as impressive, `cache.nixos.org`, contains more than 1 billion objects, making it one of the largest public software caches on the Internet.

And it does all this without creaking, groaning, or complaining.

How? What’s the mystery to designing a public package repository that supports near-infinite scaling?

<img
  src="/images/blog/stories/binary-cache-at-a-glance.svg"
  alt="cache.nixos.org by the numbers as of July 2026: 636 TB stored, ~15 billion requests per month, over 1 billion objects, 94.29% cache hit ratio, 892 TB of bandwidth per week."
  style="display: block; margin: 0 auto; float: none; max-width: 100%; height: auto;"
  decoding="async"
  loading="lazy"
/>

There’s a scene in American novelist Cormac McCarthy’s _Blood Meridian_ where a character exhibits a giant petrified dinosaur bone before a group of mystified, stupefied cowboys.

“Your heart’s desire is to be told some mystery. The mystery is that there is no mystery,” he tells them.

**The mystery is that there is no mystery**: The Nix binary cache is just a huge, signed key-value store that lives in an Amazon S3 bucket. Every key is derived from a unique hash, and because there's no database lookup required, _there's no backing database_. This avoids a slew of wicked problems that tend to arise when you're attempting to scale a massive project backed by a database.

## Where Does the Binary Cache Live?

The “fresh” contents of `cache.nixos.org` live in a single S3 bucket in the AWS `us-east-1` region.

As a cost optimization, older, historical packages typically live in cheaper AWS storage tiers. This bucket recently moved to [S3 Intelligent-Tiering](https://docs.aws.amazon.com/AmazonS3/latest/userguide/intelligent-tiering-overview.html), which automatically shifts objects among “Frequent,” “Infrequent,” “Archive Instant,” and “Archive” tiers based on how often they’re accessed. The expectation is that this will reduce storage costs, as well as minimize the effort the [Nix Infrastructure team](https://nixos.org/community/teams/infrastructure/) spends managing archived packages.

Side note: The Nix binary cache contains packages that are at least a decade old: software that in some cases has disappeared from the Internet. Because the Nix community has preserved its source code and build definitions, it’s possible to rebuild it today, on modern systems, using its required dependencies.

If the design of the Nix binary cache is conceptually simple, _distributing_ cached artifacts efficiently and reliably to consumers spread out across the world is a much more difficult problem.

To this end, a content distribution network, [Fastly](https://en.wikipedia.org/wiki/Fastly), sits in front of `cache.nixos.org` as its global caching layer. If a Nix package isn’t already cached, Fastly streams it from S3 as it arrives, so users don’t have to wait for it to download before starting. For very large files, Fastly splits them up—ironically, to get around its own size limitations. It also transparently rewrites certain kinds of S3 permission errors, so users see `404` errors, rather than the foreboding `403: Forbidden` messages. Finally, Fastly handles TLS for the `cache.nixos.org` domain at the edge, providing secure HTTPS connections to clients while communicating with S3 over TLS.

<img
  src="/images/blog/stories/cdn.svg"
  alt="Architecture of cache.nixos.org: an S3 bucket in us-east-1 using Intelligent-Tiering, fronted by the Fastly CDN as a global caching layer."
  style="display: block; margin: 0 auto; float: none; max-width: 100%; height: auto;"
  decoding="async"
  loading="lazy"
/>

## What Stuff Goes Into It?

What’s _actually stored_ in the Nix binary cache? It’s pretty basic:

- **[NAR](https://nix.dev/manual/nix/stable/protocols/nix-archive) files**. These `nar.xz` or `nar.zst` files contain the compressed contents of a single `/nix/store/` path. They live in `nar/`. The NAR format is comparable to `tar`, just much simpler: NARs don’t need to support long file names, POSIX attributes, a wide range of extensions, or rich metadata. They’re designed to serialize a filesystem object tree, including bare directory structure, file contents, symlinks, and basic metadata.

- **`narinfo`**. These are top-level files named `<store-hash>.narinfo`. Think of them as tiny text records that point to the compressed NAR, record its sizes and hashes, list the store paths it references as runtime dependencies, and carry the Hydra build farm’s signature so clients can verify the artifact. Tiny or no, there are more than 90GB of `narinfo` files in the S3 bucket used to host the Nix binary cache.

- **Build logs directory.** The `log/` folder stores the output of Nix build jobs for debugging and auditing. For example, you can fetch the build log for a cached store path with: `nix log /nix/store/<store-hash>-package-name`.

- **Content-addressed mappings.** Metadata in the `realisations/` folder maps derivations to their content-addressed store paths. This is relevant for builds using [content-addressed derivations (CA-derivations)](https://wiki.nixos.org/wiki/Ca-derivations).

- **Descriptive metadata**. This lives in `nix-cache-info`: a small metadata file that describes the basic design of the cache as a whole. It includes info about cache version, supported features, etc.

**Side note**: The NAR format is an excellent example of simple, stable design: it hasn’t been revised or extended since its introduction—[more than 20 years ago](https://github.com/NixOS/nix/commit/a09e66da5af348dc25e3b372ec9f518d3532f863)! This simple-by-design continuity contrasts with that of archives like `.deb` or `.rpm`, both of which offer a rich set of features and metadata, but at a cost: each has seen a series of format revisions and breaking changes (like new compression methods, novel metadata fields, and other mods) over the same period.

<img
  src="/images/blog/stories/binary-cache-structure-explained.svg"
  alt="Directory structure of the Nix binary cache, showing the nar/, log/, and realisations/ directories alongside top-level narinfo files and nix-cache-info."
  style="display: block; margin: 0 auto; float: none; max-width: 100%; height: auto;"
  decoding="async"
  loading="lazy"
/>

## How Does This Stuff Get There?

The Nix binary cache is populated by an automated build pipeline centered around Nix’s [Hydra CI system](https://github.com/NixOS/hydra), which directs a pool of geographically distributed builder machines.

When a maintainer makes a commit that updates a [Nix expression](https://nix.dev/manual/nix/stable/language/) in the [Nixpkgs GitHub repo](https://github.com/NixOS/nixpkgs), either by changing its version, dependencies, patches, build instructions, tests, or post-built actions, this triggers Hydra to:

- Evaluate the commit’s Nix expressions across the whole jobset (≈211,000+ packages);
- Generate derivations from those expressions;
- Compare them to what's already been built and cached;
- Queue only the new or changed derivations for builds.

Hydra runs many jobsets several times per day as new commits land on active branches, although especially large and expensive jobsets (such as `nixos/unstable`) tend to run less frequently. It signs and uploads successful builds to `cache.nixos.org`, where they’re made available as prebuilt binaries.

Interestingly, Hydra circa July of 2026 runs nearly 40,000 _fewer_ build jobs than it did just a year ago. The reason for this is that `nixpkgs` recently dropped support for macOS platforms running on x86-64. This coincides with Apple’s planned transition away from Intel-based Macs. Starting with the upcoming Golden Gate release, new versions of macOS will run only on Apple Silicon.

<img
  src="/images/blog/stories/nix-binary-cache-ci.svg"
  alt="The binary cache build pipeline: a maintainer commit to nixpkgs triggers Hydra to evaluate expressions, calculate derivations, queue new builds, and upload signed results to the cache."
  style="display: block; margin: 0 auto; float: none; max-width: 100%; height: auto;"
  decoding="async"
  loading="lazy"
/>

## Why Amazon S3?

If the Nix binary cache is so simple, couldn’t it live anywhere? Why in S3?

At the time `cache.nixos.org` was created, _there was basically no other option_. In 2007, if you wanted access to distributed, highly available, pay-as-you-go object storage, your choices were Amazon S3 or … running Hadoop and HDFS yourself. But unlike S3, HDFS isn’t a key-value store. It isn’t even an object store! It’s a hierarchical, POSIX-like file system, not a global bucket that anyone can fetch from over HTTP.

For the Nix community’s requirements, S3’s key-addressed object storage was the perfect substrate for `cache.nixos.org`: `.nar` and `.narinfo` files could be persisted as object keys and exposed via S3’s Internet-facing REST APIs. S3 could store a near-infinite number of blobs, serve them up directly over HTTP, replicate them for durability, and scale to meet growing demand. This was revolutionary at the time, and perfect for the “not trying to do too much” design ethos of `cache.nixos.org`.

Fast-forward to today: the Nix binary cache could live in virtually any other hyperscale cloud. But it’s still in S3. Why? Because of inertia? Did the project over-optimize for S3, violating its “not trying to do too much” ethos and locking itself into a specific platform? Or is it just because the Nix community is getting such great infrastructure from Amazon and AWS?

To answer these questions in order:

- **No**, `cache.nixos.org` is not in any sense locked-in to AWS and S3;
- **No**, the project isn’t being complacent (or complaisant, for that matter); and
- **Yes**, the Nix community _is_ getting good infrastructure from AWS, and to the extent we can speak for the community, we’re especially grateful for support from the AWS Open Source Strategy & Marketing and OpenData teams. That said, these facts cannot and should not influence the Nix community’s and the Nix Infrastructure team’s decision making.

The cache is there because S3 works, because the rational, non-disruptive choice is to keep it where it works, and (yes) because AWS has a proven track record supporting the binary cache.

The backstory to this is that even though `cache.nixos.org` has been hosted on S3 for almost two decades, Amazon and AWS weren’t always footing the bill. About two years ago, one of the NixOS Foundation’s principal financial sponsors discontinued its support. This happened just as usage of Nix was starting to ramp up, causing S3 costs to ramp up too. The NixOS Foundation responded to this crisis with radical transparency, opening its finances and asking both the Nix community and commercial vendors for help. The company we work for, Flox, was one of the vendors that stepped up, along with others in the Nix-adjacent space. And AWS Open Source stepped up in a big way, pledging credits to help fund `cache.nixos.org` for the fiscal year.

## Care and Feeding of the Binary Cache

At its core, the binary cache is just a signed collection of blobs in S3, which is itself a basic key-value store, with no backing database and almost no service-dependent logic. This primitivity has the advantage of making the cache comparatively simple to _maintain_.

But we all know there’s an absolute difference between theory and practice. _In theory_ `cache.nixos.org` is an ideal design, implemented in an ideal cloud service with ideal users and ideal usage characteristics. _In practice_, and at scale, the binary cache is _low-_ but by no means _no_-maintenance.

Even the best, most thoughtful designs need upkeep, after all. For the most part, the Infrastructure team supporting the binary cache does its work behind the scenes, to the point that the cache itself seems to “just work.” Nevertheless, this team has had to put out its share of fires, as well as deal with occasional crises. The fact that it manages to keep a low profile is a testament to the efforts of its members, present and past.

All of this is to say: An article discussing the finer points of the Nix binary cache that doesn’t laud the efforts of the infra team and its members would be a poor article indeed. Amazon and the folks at AWS kindly help offset the fiscal (and, to some extent, technological) burden of hosting the Nix binary cache; the infra team shoulders the operational burden of keeping it available, responsive, and up-to-date.

## BYOBC

The _official_ `cache.nixos.org` lives in S3, but if you happen to have half a petabyte of available storage, you could definitely roll your own. As we explained in **How Does This Stuff Get There?**, each package in `cache.nixos.org` has been built from source by a pool of geographically distributed builders—bare-metal and cloud alike, spanning most of Europe—using Nix’s own CI.

This build-time reproducibility is possible because the recipes Nix uses to build software, [derivations](https://nix.dev/manual/nix/stable/language/derivations.html) and [the Nix language](https://nix.dev/manual/nix/stable/language/), don’t imperatively _prescribe_ anything. Build recipes are expressed in the Nix language; Nix evaluates these to produce a derivation, or a low-level build specification. The derivation records every declared input; so as long as inputs remain available (via `cache.nixos.org`, in `nixpkgs`, or locally) Nix can reproduce any build, anywhere, at any time.

This makes it so _anyone_ can host their own Nix binary cache if they wanted, just by cloning the [Nixpkgs GitHub repo](https://github.com/NixOS/nixpkgs) and building every package from source. Sure, they’d need at least ~1 TB of space just for the build step, and they’d probably want to provision a pool of concurrent builders. And—oh yes—they’d need to foot the bill for the data egress charges associated with serving millions of users. But this isn’t just “possible,” it’s downright _doable_. The Flox Binary Cache is one such example: it applies the same principle of reproducible Nix builds to provide prebuilt packages (including [CUDA-accelerated packages](https://flox.dev/blog/the-flox-catalog-now-contains-nvidia-cuda/) like PyTorch and Tensorflow) directly from canonical nixpkgs definitions.

And that brings us to the best part of all: when built against the same Nixpkgs commits, packages in Flox’s or anyone/anywhere’s binary cache [are almost always _bit-for-bit identical_](https://luj.fr/blog/is-nixos-truly-reproducible.html) to those in `cache.nixos.org`. _That’s because Nix builds run inside an isolated sandbox_. This means only the inputs you explicitly declare are available, so your toolchain can’t silently pull in host libraries, environment variables, arbitrary metadata, or other kinds of random state. If the inputs match, the outputs match too.

Building deterministically at this scale is surprisingly difficult to achieve. In practice, Nix’s functional build pattern nails it for the overwhelming majority of packages ([about 99.9%](https://hal.science/hal-05630285v1)), with the remaining sliver being tracked (and continuously chipped away at) as non-deterministic outliers.

<img
  src="/images/blog/stories/byobc.svg"
  alt="Comparison of the official cache.nixos.org with a self-hosted binary cache, covering storage requirements, builder pool, and monthly costs."
  style="display: block; margin: 0 auto; float: none; max-width: 100%; height: auto;"
  decoding="async"
  loading="lazy"
/>

## Acknowledgements

On behalf of the NixOS Foundation, we want to stress that we’re quite grateful to AWS for its ongoing support. Their help frees the Infra team to focus on durable fixes rather than day-to-day firefighting. It also gives the team headroom for much more ambitious work, like better garbage collection, new mirroring options, and partnering opportunities.

If you’d like to learn more about Nix infrastructure (along with the people who support and maintain it), [check out their team page](https://nixos.org/community/teams/infrastructure/).

_Special thanks to Nix-whisperer [Tom Bereknyei](https://discourse.nixos.org/u/tomberek) for consultation, feedback, and hugely constructive criticism during the drafting of this article._
