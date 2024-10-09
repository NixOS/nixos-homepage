---
title: Perl Diving with Nix
date: 2021-10-01 # estimated
extra:
    author: Thomas Sean Kelly
---

## Introduction

This is a record of my time in the Summer of Nix holding my breath and diving into the depths of Nix to gain some Perls of wisdom.

Going through the issues assigned to my team I came across the the package for [OpenFoodFacts](https://world.openfoodfacts.org/discover) a collaborative database that collects and provides open data on 1 million food products from around the world and counting!

Not knowing what we are eating seems like a strange thing.
But really, how much do we know what goes into those vacuum packed bags that we open and consume daily?

OpenFoodFacts, I see your [quote](https://world.openfoodfacts.org/discover) and raise you a Newman!

> We are living in a world today where lemonade is made from artificial flavors and furniture polish is made from real lemons.
>
> — Alfred E. Newman

Anyway, enough preamble…

This project represents a deviation from the common usage of Nix to create [derivations](https://nixos.org/manual/nix/unstable/expressions/derivations.html) that package binaries.
Instead, its main application [Product Opener](https://github.com/openfoodfacts/openfoodfacts-server) is a large app that requires many languages and dependencies which end up as a web service.

The back-end is served using Apache with the Perl Module [`mod_perl`](https://en.wikipedia.org/wiki/Mod_perl) enabled (modules being how Apache is extended).
This embeds a Perl interpreter into the Apache server, which handles the production of dynamic content.

As you can imagine there is a lot of Perl which is dynamically loaded by the Apache config file.

A word to the wise: there is a lot that goes into an Apache config file and the wonder of Nix is that it abstracts most of it away including the loading of the above-mentioned [Apache modules](https://www.ibm.com/docs/en/i/7.2?topic=functionality-apache-modules).
Unless you really know what you're doing, it's best to use the `extraConfig` option, which appends configuration to the Nix auto-generated one, as it has many twists and turns.
It is possible to override the configuration file completely with the `configFile` option, but make sure you understand the auto-generated one first.

To have a look for your self run


```console
nix build nixpkgs#apacheHttpd && cd result/conf
```

A minimal ApacheHttpd configuration in Nix:

```nix
services.httpd = {
  enable = true;
  enablePerl = true;
  adminAddr = "test@test.com";
  extraConfig = builtins.readFile "${src}/apache.conf";
};
```

The `enablePerl` option is what loads up `mod_perl` for us. :hands-up:

Slight detour into Perl: [CPAN][cpan] stands for **Comprehensive Perl Archive Network** and serves as the central repository for Perl modules. One way of defining the dependencies of a Perl project is writing a plain text file called `cpanfile` that requires all the modules to be loaded from CPAN.

[cpan]: https://www.cpan.org/

So before even looking into the code contained in the project my first step was looking at all the Perl dependencies that were cataloged in the `cpanfile` – of which there were 65.

```
requires 'CGI', '>= 4.51, < 5.0'; # libcgi-pm-perl
requires 'Tie::IxHash'; # libtie-ixhash-perl
requires 'LWP::Authen::Digest'; # libwww-perl
requires 'LWP::Simple'; # libwww-perl
...
```

In the Nix community there is a ever growing list of `*2nix` tools that *translates* one package manager's lock files into something that fits within the Nix ecosystem of immutable declarative packaging.
It was at this point that I started wondering if there were any tools like that for Perl.

The short answer is no.
But there is some great support for adding something from [`meta::cpan`](https://metacpan.org/) (a repository containing what seems to be the entire Perl universe) to `nixpkgs`.
It takes the form of the function `nix-generate-from-cpan`, which is also exposed as a utility in `nixpkgs`.

```console
nix run nixpkgs#nix-generate-from-cpan <CPAN::MODULE>
```

for the win!

So a few `nix run nixpkgs#nix-generate-from-cpan <Perl::Module>`'s later I had 40 odd shiny new Perl packages. :)

This utility was great, but perhaps the reason there isn't a `*2nix` tool for the Perl world is that it is not fool proof.
In my experience it *just worked™* 70% of the time, with the other 30% of the time needing minor fixes: either adding packages to `propagatedBuildInputs` or running `nix-generate-from-cpan` for a Perl package that was needed as a dependency.

This might be an issue with the Perl ecosystem itself, as a `cpanfile` is not a lock file.
The above example demonstrates it can be very vague (`>=4.51, < 5.0`), and vagueness is the enemy of reproducible and thus the enemy of Nix.

However in one case it failed drastically, and truth be told I was stuck on which way to go for a few days.

The intransigent bugger was [`Barcode::Zbar`](https://metacpan.org/release/SPADIX/Barcode-ZBar-0.04/view/ZBar.pm), a module that provides a Perl interface to the [ZBar Barcode Reader](https://github.com/mchehab/zbar).
OpenFoodFacts has the rather excellent feature where you can just scan a bar code as a discovery mechanism.

The aforementioned `nix-generate-from-cpan` kindly provided

```nix
 BarcodeZBar = buildPerlPackage {
    pname = "Barcode-ZBar";
    version = "0.04";
    src = fetchurl {
      url = "mirror://cpan/authors/id/S/SP/SPADIX/Barcode-ZBar-0.04.tar.gz";
      sha256 = "d57e1ad471b6a29fa4134650e6eec9eb834d42cbe8bf8f0608c67d6dd0f8f431";
    };
    meta = {
    };
  };
```

Hmmm, rather bare. It didn't even include the Zbar binary as part of its `propagatedBuildInputs`.

**Side note**: `propagatedBuildInputs` here means anything that is a run-time dependency, whereas `buildInputs` are for dependencies that are exclusively build-time dependencies (e.g. tests and `Makefile` generators) - see [Perl Packaging in Nix](https://nixos.org/manual/nixpkgs/stable/#ssec-perl-packaging)

After fixing the inputs it was time to give it a try.

```nix
buildInputs = [ TestMore ExtUtilsMakeMaker ];
propagatedBuildInputs = [ zbar PerlMagick ];
```

Where upon it failed with the message:

```
perl5.34.0-Barcode-ZBar> ZBar.xs: In function 'XS_Barcode__ZBar_version':
perl5.34.0-Barcode-ZBar> ZBar.xs:202:9: error: too few arguments to function 'zbar_version'
```

On investigation it seems that this module was last updated in 2009, and since then the `zbar` project has been forked and continued developing.
The ZBar project now uses [semantic versioning][semver] while the module is stuck with `major.minor` versioning.

[semver]: https://semver.org/

`nixpkgs` topping repology's list for [Projects up to date](https://repology.org/repositories/statistics/newest) obviously meant that it wasn't slouching when it came to `zbar` and had zoomed ahead of the Perl module to version `0.23.90`. (It was never clear what version the module was expecting, but 2009 put it at either `0.9` or `0.10`).

It appeared to me that I had two options:
1. Naively patch this function so it takes 3 arguments in the Perl module and hope that works.
2. More realistically, create an overlay for `zbar` for a version that was compatible with the Perl module.

## Option 1 - The Patch

Summer of Nix is all about learning, so I figured it was worth a shot.
After a quick watch of the excellent [How to create a patch for any package](https://www.youtube.com/watch?v=5K_2RSjbdXc) by Jon Ringer (go check it out) and a quick fiddle in `git` I had a patch file.

```
From e51b51a77eab1251babc58929a4d2107172a041f Mon Sep 17 00:00:00 2001
From: Thomas Sean Dominic Kelly <thomassdk@pm.me>
Date: Fri, 6 Aug 2021 12:35:06 +0100
Subject: [PATCH] version patch

---
 ZBar.xs | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/ZBar.xs b/ZBar.xs
index ad6fc56..97bd2c0 100644
--- a/ZBar.xs
+++ b/ZBar.xs
@@ -198,9 +198,10 @@ zbar_version()
     PREINIT:
 	unsigned major;
         unsigned minor;
+        unsigned patch;
     CODE:
-        zbar_version(&major, &minor);
-        RETVAL = newSVpvf("%u.%u", major, minor);
+        zbar_version(&major, &minor, &patch);
+        RETVAL = newSVpvf("%u.%u.%u", major, minor, patch);
     OUTPUT:
         RETVAL
 
-- 
2.32.0
```

Applying patches in Nix is the simplest thing in the world:
just add it to the [patch phase](https://nixos.org/manual/nixpkgs/stable/#ssec-patch-phase) and your golden.

The manual is a bit sparse in this regard.
The code looks something like:

```nix
patchPhase = [ ./version.patch ];
```

This is possible as `buildPerlPackage` is built on top of [`stdenv`](https://nixos.org/manual/nixpkgs/stable/#idm140737320528768), allowing us to customise everything in the usual `nixpkgs` way.

Aha – something is happening! It seems to successfully compile, but fails the tests.

The full logs are below, but tl;dr the salient line seems to be:

```
#Error:  Can't load '/build/Barcode-ZBar-0.04/blib/arch/auto/Barcode/ZBar/ZBar.so' for module Barcode::ZBar: /build/Barcode-ZBar-0.04/blib/arch/auto/Barcode/ZBar/ZBar.so: undefined symbol: zbar_scanner_reset at /nix/store/n7hbdyp3bsmdxy2lcxivaxnq4nv8ndv3-perl-5.32.1/lib/perl5/5.32.1/x86_64-linux-thread-multi/DynaLoader.pm line 193.
```

Ooof, `undefined symbol`… OK, so the module is looking for a symbol and not finding it in the `zbar` shared object.

There goes my naivety.

#### Logs

<details>
    <summary>Click to see full logs</summary>

```
this derivation will be built:
  /nix/store/gww59146rs399rjc3fnawrjng4pqf6dl-perl5.32.1-Barcode-ZBar-0.04.drv
building '/nix/store/gww59146rs399rjc3fnawrjng4pqf6dl-perl5.32.1-Barcode-ZBar-0.04.drv'...
unpacking sources
unpacking source archive /nix/store/g5kazmm00923w6rgcf5h6rzrlp7b1nhj-Barcode-ZBar-0.04.tar.gz
source root is Barcode-ZBar-0.04
setting SOURCE_DATE_EPOCH to timestamp 1256327204 of file Barcode-ZBar-0.04/META.yml
patching sources
applying patch /nix/store/3ix6dz6lmifqrmbs24jbjh9z07wbscbi-0001-version-patch.patch
patching file ZBar.xs
configuring
patching ./examples/processor.pl...
patching ./examples/scan_image.pl...
patching ./examples/read_one.pl...
patching ./examples/paginate.pl...
Checking if your kit is complete...
Looks good
Use of uninitialized value $thispth in concatenation (.) or string at /nix/store/n7hbdyp3bsmdxy2lcxivaxnq4nv8ndv3-perl-5.32.1/lib/perl5/5.32.1/ExtUtils/Liblist/Kid.pm line 162.
Use of uninitialized value $thispth in concatenation (.) or string at /nix/store/n7hbdyp3bsmdxy2lcxivaxnq4nv8ndv3-perl-5.32.1/lib/perl5/5.32.1/ExtUtils/Liblist/Kid.pm line 166.
Use of uninitialized value $thispth in concatenation (.) or string at /nix/store/n7hbdyp3bsmdxy2lcxivaxnq4nv8ndv3-perl-5.32.1/lib/perl5/5.32.1/ExtUtils/Liblist/Kid.pm line 171.
Use of uninitialized value $thispth in concatenation (.) or string at /nix/store/n7hbdyp3bsmdxy2lcxivaxnq4nv8ndv3-perl-5.32.1/lib/perl5/5.32.1/ExtUtils/Liblist/Kid.pm line 173.
Use of uninitialized value $thispth in concatenation (.) or string at /nix/store/n7hbdyp3bsmdxy2lcxivaxnq4nv8ndv3-perl-5.32.1/lib/perl5/5.32.1/ExtUtils/Liblist/Kid.pm line 181.
Use of uninitialized value $thispth in concatenation (.) or string at /nix/store/n7hbdyp3bsmdxy2lcxivaxnq4nv8ndv3-perl-5.32.1/lib/perl5/5.32.1/ExtUtils/Liblist/Kid.pm line 183.
Use of uninitialized value $thispth in concatenation (.) or string at /nix/store/n7hbdyp3bsmdxy2lcxivaxnq4nv8ndv3-perl-5.32.1/lib/perl5/5.32.1/ExtUtils/Liblist/Kid.pm line 187.
Warning (mostly harmless): No library found for -lzbar
Generating a Unix-style Makefile
Writing Makefile for Barcode::ZBar
Invalid LICENSE value 'lgpl' ignored
Writing MYMETA.yml and MYMETA.json
no configure script, doing nothing
building
build flags: SHELL=/nix/store/xvvgw9sb8wk6d2c0j3ybn7sll67s3s4z-bash-4.4-p23/bin/bash
cp ZBar.pm blib/lib/Barcode/ZBar.pm
cp ZBar/Processor.pod blib/lib/Barcode/ZBar/Processor.pod
cp ZBar/ImageScanner.pod blib/lib/Barcode/ZBar/ImageScanner.pod
cp ZBar/Image.pod blib/lib/Barcode/ZBar/Image.pod
cp ZBar/Symbol.pod blib/lib/Barcode/ZBar/Symbol.pod
Running Mkbootstrap for ZBar ()
chmod 644 "ZBar.bs"
"/nix/store/n7hbdyp3bsmdxy2lcxivaxnq4nv8ndv3-perl-5.32.1/bin/perl" -MExtUtils::Command::MM -e 'cp_nonempty' -- ZBar.bs blib/arch/auto/Barcode/ZBar/ZBar.bs 644
"/nix/store/n7hbdyp3bsmdxy2lcxivaxnq4nv8ndv3-perl-5.32.1/bin/perl" "/nix/store/n7hbdyp3bsmdxy2lcxivaxnq4nv8ndv3-perl-5.32.1/lib/perl5/5.32.1/ExtUtils/xsubpp"  -typemap '/nix/store/n7hbdyp3bsmdxy2lcxivaxnq4nv8ndv3-perl-5.32.1/lib/perl5/5.32.1/ExtUtils/typemap' -typemap '/build/Barcode-ZBar-0.04/typemap'  ZBar.xs > ZBar.xsc
mv ZBar.xsc ZBar.c
cc -c   -D_REENTRANT -D_GNU_SOURCE -fwrapv -fno-strict-aliasing -pipe -fstack-protector-strong -I/no-such-path/include -D_LARGEFILE_SOURCE -D_FILE_OFFSET_BITS=64 -O2   -DVERSION=\"0.04\" -DXS_VERSION=\"0.04\" -fPIC "-I/nix/store/n7hbdyp3bsmdxy2lcxivaxnq4nv8ndv3-perl-5.32.1/lib/perl5/5.32.1/x86_64-linux-thread-multi/CORE"   ZBar.c
rm -f blib/arch/auto/Barcode/ZBar/ZBar.so
cc  -shared -O2 -L/nix/store/gk42f59363p82rg2wv2mfy71jn5w4q4c-glibc-2.32-48/lib -fstack-protector-strong  ZBar.o  -o blib/arch/auto/Barcode/ZBar/ZBar.so  \
      \

chmod 755 blib/arch/auto/Barcode/ZBar/ZBar.so
Manifying 5 pod documents
running tests
check flags: SHELL=/nix/store/xvvgw9sb8wk6d2c0j3ybn7sll67s3s4z-bash-4.4-p23/bin/bash VERBOSE=y test
"/nix/store/n7hbdyp3bsmdxy2lcxivaxnq4nv8ndv3-perl-5.32.1/bin/perl" -MExtUtils::Command::MM -e 'cp_nonempty' -- ZBar.bs blib/arch/auto/Barcode/ZBar/ZBar.bs 644
PERL_DL_NONLAZY=1 "/nix/store/n7hbdyp3bsmdxy2lcxivaxnq4nv8ndv3-perl-5.32.1/bin/perl" "-MExtUtils::Command::MM" "-MTest::Harness" "-e" "undef *Test::Harness::Switches; test_harness(0, 'blib/lib', 'blib/arch')" t/*.t
t/Decoder.t ....... 1/13
#   Failed test 'use Barcode::ZBar;'
#   at t/Decoder.t line 10.
#     Tried to use 'Barcode::ZBar'.
#     Error:  Can't load '/build/Barcode-ZBar-0.04/blib/arch/auto/Barcode/ZBar/ZBar.so' for module Barcode::ZBar: /build/Barcode-ZBar-0.04/blib/arch/auto/Barcode/ZBar/ZBar.so: undefined symbol: zbar_scanner_reset at /nix/store/n7hbdyp3bsmdxy2lcxivaxnq4nv8ndv3-perl-5.32.1/lib/perl5/5.32.1/x86_64-linux-thread-multi/DynaLoader.pm line 193.
#  at t/Decoder.t line 10.
# Compilation failed in require at t/Decoder.t line 10.
# BEGIN failed--compilation aborted at t/Decoder.t line 10.
Bareword "Barcode::ZBar::Symbol::PARTIAL" not allowed while "strict subs" in use at t/Decoder.t line 48.
Bareword "Barcode::ZBar::Symbol::NONE" not allowed while "strict subs" in use at t/Decoder.t line 27.
Bareword "Barcode::ZBar::SPACE" not allowed while "strict subs" in use at t/Decoder.t line 57.
Bareword "Barcode::ZBar::Symbol::QRCODE" not allowed while "strict subs" in use at t/Decoder.t line 61.
Bareword "Barcode::ZBar::Config::ENABLE" not allowed while "strict subs" in use at t/Decoder.t line 61.
Bareword "Barcode::ZBar::Symbol::PARTIAL" not allowed while "strict subs" in use at t/Decoder.t line 69.
Bareword "Barcode::ZBar::Symbol::NONE" not allowed while "strict subs" in use at t/Decoder.t line 69.
Bareword "Barcode::ZBar::Symbol::EAN13" not allowed while "strict subs" in use at t/Decoder.t line 73.
Bareword "Barcode::ZBar::BAR" not allowed while "strict subs" in use at t/Decoder.t line 81.
Bareword "Barcode::ZBar::Symbol::EAN13" not allowed while "strict subs" in use at t/Decoder.t line 85.
Execution of t/Decoder.t aborted due to compilation errors.
# Looks like your test exited with 255 just after 1.
t/Decoder.t ....... Dubious, test returned 255 (wstat 65280, 0xff00)
Failed 13/13 subtests
t/Image.t ......... 1/22
#   Failed test 'use Barcode::ZBar;'
#   at t/Image.t line 10.
#     Tried to use 'Barcode::ZBar'.
#     Error:  Can't load '/build/Barcode-ZBar-0.04/blib/arch/auto/Barcode/ZBar/ZBar.so' for module Barcode::ZBar: /build/Barcode-ZBar-0.04/blib/arch/auto/Barcode/ZBar/ZBar.so: undefined symbol: zbar_scanner_reset at /nix/store/n7hbdyp3bsmdxy2lcxivaxnq4nv8ndv3-perl-5.32.1/lib/perl5/5.32.1/x86_64-linux-thread-multi/DynaLoader.pm line 193.
#  at t/Image.t line 10.
# Compilation failed in require at t/Image.t line 10.
# BEGIN failed--compilation aborted at t/Image.t line 10.
Bareword "Barcode::ZBar::Symbol::EAN13" not allowed while "strict subs" in use at t/Image.t line 101.
Execution of t/Image.t aborted due to compilation errors.
# Looks like your test exited with 255 just after 1.
t/Image.t ......... Dubious, test returned 255 (wstat 65280, 0xff00)
Failed 22/22 subtests
t/pod-coverage.t .. skipped: Test::Pod::Coverage required for testing pod coverage
t/pod.t ........... skipped: Test::Pod 1.00 required for testing POD
t/Processor.t ..... 1/20
#   Failed test 'use Barcode::ZBar;'
#   at t/Processor.t line 10.
#     Tried to use 'Barcode::ZBar'.
#     Error:  Can't load '/build/Barcode-ZBar-0.04/blib/arch/auto/Barcode/ZBar/ZBar.so' for module Barcode::ZBar: /build/Barcode-ZBar-0.04/blib/arch/auto/Barcode/ZBar/ZBar.so: undefined symbol: zbar_scanner_reset at /nix/store/n7hbdyp3bsmdxy2lcxivaxnq4nv8ndv3-perl-5.32.1/lib/perl5/5.32.1/x86_64-linux-thread-multi/DynaLoader.pm line 193.
#  at t/Processor.t line 10.
# Compilation failed in require at t/Processor.t line 10.
# BEGIN failed--compilation aborted at t/Processor.t line 10.
Bareword "Barcode::ZBar::Symbol::EAN13" not allowed while "strict subs" in use at t/Processor.t line 58.
Execution of t/Processor.t aborted due to compilation errors.
# Looks like your test exited with 255 just after 1.
t/Processor.t ..... Dubious, test returned 255 (wstat 65280, 0xff00)
Failed 20/20 subtests
t/Scanner.t ....... 1/3
#   Failed test 'use Barcode::ZBar;'
#   at t/Scanner.t line 10.
#     Tried to use 'Barcode::ZBar'.
#     Error:  Can't load '/build/Barcode-ZBar-0.04/blib/arch/auto/Barcode/ZBar/ZBar.so' for module Barcode::ZBar: /build/Barcode-ZBar-0.04/blib/arch/auto/Barcode/ZBar/ZBar.so: undefined symbol: zbar_scanner_reset at /nix/store/n7hbdyp3bsmdxy2lcxivaxnq4nv8ndv3-perl-5.32.1/lib/perl5/5.32.1/x86_64-linux-thread-multi/DynaLoader.pm line 193.
#  at t/Scanner.t line 10.
# Compilation failed in require at t/Scanner.t line 10.
# BEGIN failed--compilation aborted at t/Scanner.t line 10.
Can't locate object method "new" via package "Barcode::ZBar::Scanner" (perhaps you forgot to load "Barcode::ZBar::Scanner"?) at t/Scanner.t line 14.
# Looks like your test exited with 255 just after 1.
t/Scanner.t ....... Dubious, test returned 255 (wstat 65280, 0xff00)
Failed 3/3 subtests
t/ZBar.t .......... 1/3
#   Failed test 'use Barcode::ZBar;'
#   at t/ZBar.t line 10.
#     Tried to use 'Barcode::ZBar'.
#     Error:  Can't load '/build/Barcode-ZBar-0.04/blib/arch/auto/Barcode/ZBar/ZBar.so' for module Barcode::ZBar: /build/Barcode-ZBar-0.04/blib/arch/auto/Barcode/ZBar/ZBar.so: undefined symbol: zbar_scanner_reset at /nix/store/n7hbdyp3bsmdxy2lcxivaxnq4nv8ndv3-perl-5.32.1/lib/perl5/5.32.1/x86_64-linux-thread-multi/DynaLoader.pm line 193.
#  at t/ZBar.t line 10.
# Compilation failed in require at t/ZBar.t line 10.
# BEGIN failed--compilation aborted at t/ZBar.t line 10.
Undefined subroutine &Barcode::ZBar::version called at t/ZBar.t line 14.
# Looks like your test exited with 255 just after 1.
t/ZBar.t .......... Dubious, test returned 255 (wstat 65280, 0xff00)
Failed 3/3 subtests

Test Summary Report
-------------------
t/Decoder.t     (Wstat: 65280 Tests: 1 Failed: 1)
  Failed test:  1
  Non-zero exit status: 255
  Parse errors: Bad plan.  You planned 13 tests but ran 1.
t/Image.t       (Wstat: 65280 Tests: 1 Failed: 1)
  Failed test:  1
  Non-zero exit status: 255
  Parse errors: Bad plan.  You planned 22 tests but ran 1.
t/Processor.t   (Wstat: 65280 Tests: 1 Failed: 1)
  Failed test:  1
  Non-zero exit status: 255
  Parse errors: Bad plan.  You planned 20 tests but ran 1.
t/Scanner.t     (Wstat: 65280 Tests: 1 Failed: 1)
  Failed test:  1
  Non-zero exit status: 255
  Parse errors: Bad plan.  You planned 3 tests but ran 1.
t/ZBar.t        (Wstat: 65280 Tests: 1 Failed: 1)
  Failed test:  1
  Non-zero exit status: 255
  Parse errors: Bad plan.  You planned 3 tests but ran 1.
Files=7, Tests=5,  0 wallclock secs ( 0.02 usr  0.00 sys +  0.20 cusr  0.03 csys =  0.25 CPU)
Result: FAIL
Failed 5/7 test programs. 5/5 subtests failed.
make: *** [Makefile:1040: test_dynamic] Error 255
error: builder for '/nix/store/gww59146rs399rjc3fnawrjng4pqf6dl-perl5.32.1-Barcode-ZBar-0.04.drv' failed with exit code 2;
       last 10 log lines:
       >   Non-zero exit status: 255
       >   Parse errors: Bad plan.  You planned 3 tests but ran 1.
       > t/ZBar.t        (Wstat: 65280 Tests: 1 Failed: 1)
       >   Failed test:  1
       >   Non-zero exit status: 255
       >   Parse errors: Bad plan.  You planned 3 tests but ran 1.
       > Files=7, Tests=5,  0 wallclock secs ( 0.02 usr  0.00 sys +  0.20 cusr  0.03 csys =  0.25 CPU)
       > Result: FAIL
       > Failed 5/7 test programs. 5/5 subtests failed.
       > make: *** [Makefile:1040: test_dynamic] Error 255
       For full logs, run 'nix log /nix/store/gww59146rs399rjc3fnawrjng4pqf6dl-perl5.32.1-Barcode-ZBar-0.04.drv'.
```
</details>

## Option 2: The Overlay

Let's just overlay the source code with `0.10`, [a version from 2009](https://github.com/mchehab/zbar/releases/tag/0.10).

This wasn't very successful as it seems the steps to build ZBar have [changed significantly](https://github.com/NixOS/nixpkgs/commit/57ffe86efa988788b6c58a1e3b682ee8f80c74a3#diff-2793faccce1027ffbb3d7e8658912e32422bdb8907db45e295f97c2768c526c2) between versions.

However, I chose `0.10` not only for the fact that it was from 2009. It was the [oldest version](https://github.com/NixOS/nixpkgs/blob/7147ef8e80ae9f5d7f13b0c29bbf7a4d27982d3d/pkgs/tools/graphics/zbar/default.nix) in `nixpkgs`.

So let's substitute the current package with this old one.

A handy tool I found along the way was [Nix package versions](https://lazamar.co.uk/nix-versions/) which gives a nice web interface for finding older versions of packages and giving you the revision that they were in.

Armed with a really hacky `zbar` overlay, let's try this again.

```nix
zbar = final: prev: {
     zbar = (import (builtins.fetchGit {
       url = "https://github.com/NixOS/nixpkgs/";
       ref = "refs/heads/nixpkgs-unstable";
       rev = "12408341763b8f2f0f0a88001d9650313f6371d5";
       }) { system = "x86_64-linux"; }).zbar;
};
```

Sidenote: A more Nix'y way of doing this would be to import this ancient version of `nixpkgs` as an input into your flake:

```nix
inputs.nixpkgs-ancient = {
    url = "github:NixOS/nixpkgs?rev=12408341763b8f2f0f0a88001d9650313f6371d5";
    flake = false;
}
```

and then use it via:

```nix
zbar = final.callPackage ./zbar.nix { pkgs = final; pkgsAncient = import nixpkgs-ancient { system = final.system; }; };
```

where `zbar.nix` is:

```nix
{ pkgs, pkgsAncient }:

let zbar = pkgsAncient.zbar; in
 
with pkgs;
with perlPackages;
 
buildPerlPackage {
  pname = "Barcode-ZBar";
  version = "0.04";
  src = fetchurl {
    url = "mirror://cpan/authors/id/S/SP/SPADIX/Barcode-ZBar-0.04.tar.gz";
    sha256 = "d57e1ad471b6a29fa4134650e6eec9eb834d42cbe8bf8f0608c67d6dd0f8f431";
  };
  doCheck = true;
  buildInputs = [ pkg-config TestMore ExtUtilsMakeMaker TestHarness ];
  propagatedBuildInputs = [ zbar PerlMagick ];
  meta = {
    homepage = "https://github.com/mchehab/zbar";
    description = "Perl interface to the ZBar Barcode Reader";
    license = with lib.licenses; [ gpl2Plus ];
  };
}
```

Thanks to [Las](https://las.rs) for this Flake-ier way of doing things.

Sadly this still fails with the `undefined symbol` error.
It seems we need an even more ancient version of Zbar

## Where things float

It seems that we have reached the point of diminishing returns and that it does not seem worthwhile to figure out how to build ever older versions of ZBar in the hope that this *might* someday work.

So what next?

Perhaps we can convince upstream to take on the maintenance of this Perl module and bring it (and their own project) kicking and screaming into the decade of the 2020s. ([Sometimes your brain just needs some downtime](https://www.scientificamerican.com/article/mental-downtime/))

A few days after putting this project on the back burner I woke up with an inexplicable renewed enthusiasm for tackling this issue.

Looking back through all the resources I noticed that the maintained version of `ZBar` has a series of folders named after various programming languages and platforms, including *Perl*.

Interesting…

It seems that when forking ZBar, @mchehab, the new maintainer, also made the sage decision to include all the myriad interfaces for the library and maintain them!

Armed with this new Perl module that we **knew** worked with the latest ZBar library it was possible to construct a new `buildPerlPackage` that reused the `src` from the ZBar packaged in `nixpkgs`.

```nix
BarcodeZBar = buildPerlPackage {
  pname = "Barcode-ZBar";
  version = "0.04";
  src = "${zbar.src}/perl";
  postPatch = ''
    substituteInPlace Makefile.PL --replace "-lzbar" "-L${zbar.lib}/lib -lzbar"
    # This test requires network access
    rm t/Processor.t
  '';
  doCheck = true;
  buildInputs = [ TestPodCoverage TestPod DevelChecklib TestMore ExtUtilsMakeMaker ];
  propagatedBuildInputs = [ zbar PerlMagick ];
  meta = {
    homepage = "https://github.com/mchehab/zbar/tree/master/perl";
    description = "Perl interface to the ZBar Barcode Reader";
    license = with lib.licenses; [ gpl2Plus ];
  };
};
```

Et voilà, we have a Perl Module that interfaces with the current version of ZBar!

## Addendum

The keen-eyed among you will have noticed that there is a bit of trickery happening with the `postPatch` hook.

Perl has the incredibly unhelpful error command:

`Warning (mostly harmless): No library found for -lzbar`

As you can imagine this is unquestionably harmful and causes the tests, and of lesser importance the final output 😛, to fail.

This happens because for some reason our `propagatedBuildInputs` are not being added to the sandbox for the `Makefile` (which adds paths to `NIX_LDFLAGS`). Instead these had to be added manually by linking them directly in the `Makefile`.

It is unclear to me why this is and perhaps a issue needs to be opened that addresses this.

## A quick refresher on `NIX_LDFLAGS`.

Nix differs drastically from other Linux distributions (and in difference is strength) and does not store header files and libraries in the traditional `/usr/include` where the compiler expects them.
Instead, everything is in the Nix Store.

This means that somehow we need to make the compiler aware of the correct paths to these headers and libraries.
This is where `NIX_LDFLAGS` (and its partner in compile `NIX_CFLAGS_COMPILE`) come in.
The ALL CAPS should give you a clue that they are *environment variables* which are used to furnish the compiler (by way of command line arguments) with these correct paths.
This is all done using shell scripts that wrap around the actual compiler.
For more information see the [C section](https://nixos.wiki/wiki/C) on the Nixos Wiki.

