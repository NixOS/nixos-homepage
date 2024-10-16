---
title: The Rise of Special Project "infra"
date: 2022-08-12
extra:
  author: Ctem
---

_72 hours out. A bead of sweat slides from your brow, falls to the marred chassis of your local build server, and sizzles into mist, leaving a scant salt stain to tell the tale. It’s the start of the hottest Summer of Nix on record, and you have three days to [research](#phase-i-research), [provision](#phase-ii-provision), [configure](#phase-iii-configure), and [deploy](#phase-iv-deploy). With or without you, this lecture is going live._

The deadline was 19 July, 2022; at five o’clock on that glistening Tuesday afternoon, one Eelco Dolstra – a living legend to those who understand – would take to the webcam from the verdant city of Utrecht to deliver a highly anticipated slice of fresh perspective on his now-19-year-old brainchild, [Nix](https://nixos.org/learn.html). It was the inaugural event in the premier Summer of Nix (SoN) Public Lecture Series. The hype was real, but so was our predicament: no self-hosted livestreaming infrastructure was yet in place.

Would we simply fall back on the usual [gatekeeper](https://ec.europa.eu/info/strategy/priorities-2019-2024/europe-fit-digital-age/digital-markets-act-ensuring-fair-and-open-digital-markets_en) platforms, surrendering control of the narrative and feeding our own to corporate leviathans in a vacuum of moral agency?

The ubiquity of these platforms suggests that most would.[^ubiquity] This, however, is SoN, and we aren’t most. Defying norms of defeatism and manufactured consent, we dare to declare a world of configurability. We celebrate that self-hosting empowers us to maintain ownership of both our content and its presentation, allowing us to introduce to our audience – our community – a way to engage with said content free from third-party influence.

Note that our solidarity is no coincidence; SoN begins with a contractual agreement between each participant and Eelco himself to uphold both [NGI Zero](https://nlnet.nl/NGI0/)’s aim to contribute to an open internet and the [ACM Code of Ethics and Professional Conduct](https://www.acm.org/code-of-ethics), which emphasizes among other points the importance of respecting privacy.

Needless to say, the prospect of streaming Eelco’s lecture exclusively to closed-source, centralized, and infamously privacy-disrespecting services was an irony too plain to ignore. Fortunately, infrastructural improvement is a fundamental objective of the program, and Nix is the definitive tool for the job. In short, the Public Lecture Series livestreaming infrastructure was a natural first target. Time was not on our side, but good people were:

- The [NixOS Foundation](https://opencollective.com/nixos) was at the ready for server provisioning and DNS management.
- Personnel at [Tweag](https://www.tweag.io/) generously offered expertise in configuration and deployment in a pinch.
- A new SoN Special Project – tidily dubbed _infra_ – was launched to formalize the effort and attract participation.

With this kind of support, the odds were decidedly stacked in our favor, _but could we deliver?_ We’d find out soon enough...

### Phase I: Research

Everybody needs a saga. Ours was: self-host a secure livestreaming server to accommodate a sizable audience participating from all around the world and at variable network speeds, _fast_. Oh, and add a chat room for synchronous Q&A.

On the server side, we settled on the following stack: virtual private server (VPS) → NixOS → [Caddy](https://caddyserver.com/) → [Owncast](https://owncast.online/).

The media would originate on our intrepid moderator’s local [OBS Studio](https://obsproject.com/) and be streamed at archival quality over the Real-Time Messaging Protocol (RTMP) to our remote Owncast service. Owncast would transcode the video to multiple stream qualities (i.e., optimized variants of video bitrate and CPU usage) and present the selected variant to the user in an attractive, branded web UI with a convenient chat box.

### Phase II: Provision

Controlling the narrative has always called for a bit of hardware. For this exercise, we went with a single VPS equipped with dedicated vCPUs. The general provisioning procedure follows:

1. Choose a (preferably reputable and carbon negative) VPS provider.

1. Provision an instance appropriate to the task and estimated audience.

   - To minimize latency, select the available region that best approximates the location of the source stream as well as the mean location of the majority of expected participants where applicable. Note that _object storage_ and _CDN caching_ additionally may be leveraged to accommodate participants; object storage enables the streaming service to serve media files when the concurrent user count exceeds available bandwidth, and CDN caching enables users to download these assets from the nearest available server.
   - Select a server with enough (preferably dedicated) vCPU cores to handle video transcoding, which is a highly processor-intensive operation. Note that this should correspond to the stream variants selected in the [streaming service configuration](#streaming-service-configuration).

   The instance we provisioned for the first stress test included the following specs:

   | vCPU |   RAM | Local storage | Location |
   | ---: | ----: | ------------: | -------- |
   |    8 | 32 GB |        240 GB | Germany  |

1. Reserve a public IPv4 address and IPv6 subnet and associate with the provisioned instance.

1. Assuming registration of the desired domain name, use a/the DNS registrar-provided interface to update the (or create an) A record for the target subdomain (`live.nixos.org` in our case) with the IP address associated with the provisioned instance. Note that propagation may take up to 48 hours.

### Phase III: Configure

Perhaps unintuitively, this was the easiest part. Thanks to the [`nixpkgs`](https://github.com/NixOS/nixpkgs) community contributions of high-quality modules[^module] for production-ready services[^service], configuring a fully self-hosted livestreaming service safely behind a reverse proxy was scarcely more involved than toggling `enable`. Consider the following Nix code:

```nix
{
  networking.firewall.allowedTCPPorts = [ 80 443 ]
    ++ [ config.services.owncast.rtmp-port ];

  security.acme.defaults.email = "admin@example.com";

  services.owncast.enable = true;

  services.caddy = {
    enable = true;
    email = config.security.acme.defaults.email;
    virtualHosts = {
      "live.nixos.org".extraConfig = let
        owncastWebService = "http://${config.services.owncast.listen}:${
            toString config.services.owncast.port
          }";
      in ''
        encode gzip
        reverse_proxy ${owncastWebService}
      '';
    };
  };
}
```

Demonstrating the seamless UX of a well-written NixOS module, the Owncast configuration is completely out-of-the-box; using [all defaults](https://search.nixos.org/options?channel=unstable&from=0&size=50&sort=relevance&type=options&query=owncast), one line installs and activates the service, initializes all necessary state (including a SQLite database `owncast.db` that stores important service configuration such as administrative credentials) in `/var/lib/owncast`, and binds the web server to `127.0.0.1:8080`.

The Caddy module is similarly loaded (with goodies). The only customization necessary here was to specify the domain we prepared (in the last step of the provisioning phase above) as a virtual host from which Caddy can forward client requests to the backend Owncast web server. For good measure, we also specified an email address for Caddy to use when setting up SSL on our behalf. This is the email address to use for account creation and correspondence from the SSL certificate authority, which is [Let's Encrypt](https://letsencrypt.org/) by default.

The remaining configuration simply opens ports in the system firewall for HTTP, HTTPS, and RTMP. Note that the RTMP port is also an Owncast module-specified default.

That’s the entirety of the NixOS configuration specific to our use case; all additional configuration (e.g., importing generated hardware configuration, enabling SSH and adding appropriate keys, defining Nix garbage collection rules, etc.) is simply boilerplate.

### Phase IV: Deploy

With the instance provisioned and the configuration prepared, it was about time to introduce the two, marking the beautiful beginning of a successful working relationship. This is generally a two-step process:

1. Install NixOS on the instance. A provider may make this very easy (by providing a template image), moderately easy (by allowing [a custom ISO](https://github.com/nix-community/nixos-generators) to be uploaded), or hit-or-miss (by providing an image for a non-NixOS distribution from which NixOS may be converted with [NixOS-Infect](https://github.com/elitak/nixos-infect/) or [`NIXOS_LUSTRATE`](https://nixos.org/manual/nixos/stable/#sec-installing-from-other-distro)).

   Our provider didn’t do us too many favors in this regard. They were known to play nice with `nixos-infect`ed installations, however, so we went with that.

1. Deploy the configuration. Note that several tools exist to automate this process: [deploy-rs](https://github.com/serokell/deploy-rs) is wildly popular for flake-based configurations, and [Cachix Deploy](https://blog.cachix.org/posts/2022-07-29-cachix-deploy-public-beta/) is a promising new offering (just to name two).

   We were quite frankly in a hurry, however, and found it perfectly acceptable to do it the old-fashioned way:

   1. Access the host over SSH.
   1. Clone the configuration.
   1. Run `nixos-rebuild switch` to build and activate the configuration (and make it the boot default).

With this, we had a fully operational production server. For the finishing touches, we would make just a few program-specific tweaks.

#### Streaming service configuration

As previously mentioned, much of the Owncast configuration is stored as mutable state, enabling the service to be modified on-the-fly from the administrative web UI. A suggested procedure follows:

1.  Log in to the administrative web UI:

    - URL: `https://<target FQDN>/admin/` (e.g., `https://live.nixos.org/admin/`)
    - User name: `admin`
    - Password: `<stream key>` (`abc123` by default)

1.  In server settings, set a new Stream Key.

    Note that this is also the administrative web UI password.

1.  In general settings, modify instance details, tags, and social handles as appropriate.

1.  In video settings:

    - Add stream variants to enable adaptive bitrate streaming to accommodate users on various-quality networks.

      The following table may be used as a guideline:

      | Encoder | Name | Resolution (WxH) |        Bitrate | Framerate    |
      | ------- | ---- | ---------------- | -------------: | ------------ |
      | x264    | SD   | 854x480          |  800-1200 kbps | 25 or 30 fps |
      | x264    | HD   | 1280x720         | 1200-1900 kbps | 25 or 30 fps |
      | x264    | FHD  | 1920x1080        | 1900-4500 kbps | 25 or 30 fps |

      Note that some services recommend a higher bitrate for HD:

      | Encoder | Name | Resolution (WxH) |   Bitrate | Framerate    |
      | ------- | ---- | ---------------- | --------: | ------------ |
      | x264    | HD   | 1280x720         | 3000 kbps | 25 or 30 fps |
      | x264    | FHD  | 1920x1080        | 4500 kbps | 25 or 30 fps |

      Our stress tests showed that the use of standard variants with our VPS were reportedly adequate for most users but problematic for some in Japan, Thailand, and the UK. Based on these results, object storage and CDN caching are recommended.

      Additional notes:

      - For interactive live streams (e.g., lectures with Q&A sessions), consider decreasing the latency buffer to Low.
      - For further tuning, consider referring to a bitrate calculator (e.g., [Bitrate Calc](https://bitratecalc.com/)).

#### Streaming client configuration

With the server side all set, it was time to get streaming! The basic procedure follows:

1. On a local workstation, install and launch [OBS Studio](https://obsproject.com/) ([obs-studio](https://search.nixos.org/packages?channel=22.05&show=obs-studio&from=0&size=50&sort=relevance&type=options&query=obs-studio) in `nixpkgs`).

1. In stream settings, set the following values:

   - Service: `Custom...`
   - Server: `rtmp://<target FQDN>` (e.g., `rtmp://live.nixos.org`)
   - Stream key: `abc123` (by default)

1. Go live.

1. Confirm the stream at the designated URL (`https://live.nixos.org` in our case).

_It worked?_ It worked. Crisis averted with time to spare. 🍹

## Next Steps

Following a successful first lecture, the SoN infra team is concerned not only with maintenance and optimization of the infrastructure we’ve already deployed but also with innovation on a larger scale. The ultimate goal is to contribute _a scalable, fully self-hosted, documented, NixOS-based, general-purpose, FLOSS[^floss] conference suite_. In short, we’re working toward a turnkey solution that can accommodate use cases ranging from the SoN Public Lecture Series all the way to a full conference experience – namely [NixCon](https://nixcon.org/).

In addition to main conference components (e.g., administrative tools, breakout rooms, etc.) and general convenience features (e.g., collaboration tools such as shared whiteboards), a notable priority is the improvement of our accessibility story, e.g., through integration of the [Vosk speech recognition toolkit](https://alphacephei.com/vosk/) for livestream closed captioning/transcription/subtitling (in multiple languages).

To this end, we’re working together with other stalwart teams such as the SoN Special Project for [Jitsi](https://jitsi.org/) and have received guidance and insight from the gracious maintainers of the [NixCon 2020 livestreaming infrastructure](https://github.com/nixcon/nixcon-video-infra), the crucial project of which our efforts will be a continuation.

[^ubiquity]: In the context of this article, _ubiquity_ is scoped to societies who enjoy the free global exchange of information (i.e., unfiltered cross-border Internet traffic). Likewise, _most_ refers to the majority of members of such a society when faced with choosing a method for applicable content publishing.

[^module]:
    Service module quality, while service context-dependent, is generally evaluated with respect to such criteria as:

    - sensibility of included defaults (i.e., such that the service can be started without requiring excessive configuration for common use cases)
    - exposure of a balanced set of options (i.e., such that the service is sufficiently configurable but not at the expense of module maintainability)
    - inclusion of a balanced set of [integration tests](https://nixos.org/guides/integration-testing-using-virtual-machines.html) (i.e., that is sufficiently comprehensive for stable operation but not restrictively opinionated)

[^service]: A _production-ready service_ is characterized here as a service that is appropriately licensed and sufficiently stable, secure, performant, and featureful for a given use case. Note that in the context of FLOSS[^floss], active maintainership is additionally preferred.

[^floss]: While the term [FLOSS](https://www.gnu.org/philosophy/floss-and-foss.en.html) indicates a politically neutral position, this project prefers software that is licensed to protect the four essential freedoms of users as defined in the [Free Software Definition](https://www.gnu.org/philosophy/free-sw.en.html). As a bare minimum, the term _open source_ is used here to describe software that fulfills the conditions of the [Open Source Definition](https://opensource.org/osd).
