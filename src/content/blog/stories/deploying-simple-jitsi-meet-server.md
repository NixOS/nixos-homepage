---
title: Deploying a simple Jitsi Meet server with NixOS
date: 2022-07-28
extra:
  author: Simon Bruder
---
## Introduction

During the COVID-19 pandemic,
video conferencing turned out to be an invaluable tool for online collaboration.
While many used proprietary tools for this,
there is one proven free and open source video conferencing tool
that also gained much traction and stayed popular:
[Jitsi Meet](https://jitsi.org/jitsi-meet/)

Primarily known for its publicly available service [meet.jit.si](https://meet.jit.si),
it is also possible to self-host Jitsi Meet on your own server.

### Reasons to self-host

There are a variety of reasons
why you may consider hosting Jitsi Meet yourself
instead of relying on an already existing hosted instance:

 * You stay in control of your own data.
   When relying on a third-party service,
   you have to trust them,
   and in case you are using the service professionally,
   you may be legally required to sign a contract on data processing with the provider.
 * You can have your own branding.
   Not only does the service run on your own domain,
   but you can also customise the logo, welcome page, etc.
 * You can configure it to your liking.
   Depending on the typical use case of the instance,
   some optional features might be desirable
   that are not commonly found on other instances.
 * You can update the service when you want.
   If you need the service to work,
   the user interface totally changing during an important meeting may be problematic.
   By hosting it yourself, you can decide when to update it.

### Why NixOS

So why deploy this on NixOS and not on Debian or with Docker?
NixOS has many advantages for running servers.
It allows you to configure your whole server declaratively,
so you can reuse the same configuration for multiple servers.
Also, because it is reproducible,
setting up a server with the same NixOS configuration
will ensure that it runs the exact same software with the same configuration.
Finally, if an update breaks your setup,
NixOS makes rollbacks as easy as running one command or rebooting,
so you can minimise downtime.

## Requirements

We will implement a small single-server deployment,
so you need one server (e.g., a VPS).
Its required specifications depend on how you want to use it.

For just trying things out, one CPU core and 2 GB RAM should be enough,
though you will run into limitations pretty quickly.
The [official Jitsi Meet devops guide](https://jitsi.github.io/handbook/docs/devops-guide/devops-guide-requirements) recommends 4 CPU cores and 8 GB RAM.

If you don’t care about meeting recordings,
a 15 GiB disk could be enough,
though it doesn’t hurt to have more.
Recordings, however, will dramatically increase the resource consumption.
You will need at least 8 GB RAM, if possible even more,
and a CPU fast enough to keep up with handling the meeting while simultaneously encoding it.
Obviously, it also requires a larger disk to store the recordings on.

You will also need a domain where Jitsi Meet should be available.

If you already have a NixOS server set up
that has the required resources available,
you can skip to [Getting basic Jitsi Meet service running](#getting-basic-jitsi-meet-service-running).

For configuring and deploying it,
[Nix](https://nixos.org) with flakes support is required to be installed on your local system.
If you have Nix version 3 or above, everything is already set up.
Otherwise, you need to [enable it explicitly](https://nixos.wiki/wiki/Flakes#Enable_flakes).

## Setting up NixOS

You can either set up a NixOS system [as described in the NixOS manual](https://nixos.org/manual/nixos/stable/index.html#sec-installation)
or you can replace the default image of your provider with NixOS,
either manually by using [NixOS Lustrate](https://nixos.org/manual/nixos/stable/#sec-installing-from-other-distro)
or automatically with [nixos-infect](https://github.com/elitak/nixos-infect).

If you use `nixos-infect`,
you must ensure that your public SSH key is already added to root’s `authorized_keys` before the script gets run,
otherwise you won’t be able to log in to the new NixOS system.
Consider reading [`nixos-infect`’s documentation](https://github.com/elitak/nixos-infect/blob/master/README.md) before using it
to avoid destroying important data.

After the new NixOS system is up,
we will set up the configuration file used to deploy it.
For this we’ll use [deploy-rs](https://github.com/serokell/deploy-rs),
so you need that available.
You can either install it into your environment
or just enter a shell environment to make it available temporarily:

```
nix shell github:serokell/deploy-rs
```

You then need to create the file `flake.nix` in a new directory
that specifies the skeleton for the deployment:

```nix
{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-22.05"; # change this to your desired NixOS version
    deploy-rs.url = "github:serokell/deploy-rs";
  };

  outputs = { self, nixpkgs, deploy-rs }: {
    nixosConfigurations.jitsi-meet = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux"; # if your target system isn’t x86_64, change this
      modules = [ ./jitsi-meet/configuration.nix ];
    };

    deploy.nodes.jitsi-meet = {
      hostname = "meet.example.com"; # change this to your FQDN of the server
      sshUser = "root";
      # When deploying for the first time, the server doesn’t yet have IPv6 connectivity.
      # This forces ssh to connect over IPv4 and can be removed after the first successful deployment.
      sshOpts = [ "-4" ];

      profiles.system = {
        path = deploy-rs.lib.x86_64-linux.activate.nixos self.nixosConfigurations.jitsi-meet;
      };
    };

    checks = builtins.mapAttrs (system: deployLib: deployLib.deployChecks self.deploy) deploy-rs.lib;
  };
}
```

Now you need to create the NixOS configuration in `jitsi-meet/configuration.nix`:

```nix
{ modulesPath, ... }:

{
  networking.hostName = "jitsi-meet";

  imports = [
    # You can change this to match your target system
    # (or remove it entirely if it doesn’t need special configuration).
    # An introduction to NixOS profiles can be found in the manual: https://nixos.org/manual/nixos/stable/#ch-profiles
    (modulesPath + "/profiles/qemu-guest.nix")
  ];

  networking = {
    # replace those details with your network interface, the IPv6 gateway, address and prefix length
    # IPv4 will automatically get configured over DHCP (if your provider supports it)
    defaultGateway6 = { address = "fe80::1"; interface = "ens3"; };
    interfaces.ens3.ipv6.addresses = [ { address = "2a01:db8:abcd:1234::"; prefixLength = 64; } ];
  };

  services.openssh.enable = true;
  users.users.root.openssh.authorizedKeys.keys = [
    # don’t forget to add your SSH public key(s) here!
    "ssh-ed25519 AAAA…"
  ];

  # if your disk device is called differently, you need to change this
  boot.loader.grub.device = "/dev/sda";
  fileSystems."/" = {
    device = "/dev/sda1";
    fsType = "ext4";
  };

  system.stateVersion = "22.05"; # change this to the NixOS version you first installed the system with
}
```

Now, you can just run `deploy` and everything should be set up automatically.
After it worked successfully,
you can remove the `sshOpts = [ "-4" ];` line from the flake,
because it should now have IPv6 connectivity.

## Getting basic Jitsi Meet service running

What makes using Jitsi Meet with NixOS so nice
is that there is a module for it.
That means, you can enable a basic — but working — Jitsi Meet instance
just by adding the following to your system configuration:

```nix
{
  services.jitsi-meet = {
    enable = true;
    hostName = "meet.example.com"; # change this to your domain
  };

  services.jitsi-videobridge.openFirewall = true;

  security.acme = {
    acceptTerms = true; # ensure that you have read the subscriber agreement (https://letsencrypt.org/repository/)
    defaults.email = "nospam@example.com"; # change this to your email address
  };

  networking.firewall.allowedTCPPorts = [ 80 443 ];
}
```

After you deploy this configuration,
you should already have a working Jitsi Meet service.

## Advanced configuration

### Customisation

For customising the features and look of the Jitsi Meet web application,
there are two options available.

One is the interface configuration (`interface_config.js`),
which is deprecated but still required to configure some things.
It can be modified by setting the NixOS option `services.jitsi-meet.interfaceConfig`.
A commented list of all options and their default values can be found [in the Jitsi Meet source code](https://github.com/jitsi/jitsi-meet/blob/master/interface_config.js).

An example configuration that hides the Jitsi watermark could look like this:

```nix
{
  services.jitsi-meet.interfaceConfig = {
    SHOW_JITSI_WATERMARK = false;
  };
}
```

In the future, all options from `interface_config.js` will be moved to `config.js`.
Many options are already configurable from it.
Like with the interface configuration, a commented list of all options and their default values can be found [in the Jitsi Meet source code](https://github.com/jitsi/jitsi-meet/blob/master/config.js).

There is one option I recommend you to set,
`prejoinPageEnabled`, which enables a page to set up microphone and camera
and lets the user disable them *before* joining a meeting.

There are many more options available,
so it might be useful to look at the options and set up everything to your liking.

An example configuration could look like this:

```nix
{
  services.jitsi-meet.config = {
    prejoinPageEnabled = true;
    disableModeratorIndicator = true;
  };
}
```

### Recordings

Using the Jitsi Meet component Jibri,
it is possible to record a meeting remotely — that means without running additional software on the participants’ clients.

This currently is achieved by running a Chromium instance in a virtual X11 framebuffer,
which then is recorded by [ffmpeg](https://ffmpeg.org/).
Because of this, it is currently not possible to run multiple instances of Jibri on the same host
and therefore it is only possible to have one conference recording running at a time.
In theory it is possible to bypass these limits by running each Jibri in its own container,
but this is not officially supported by the Jibri developers and hasn’t yet been implemented for NixOS.
Moreover, the current NixOS module only allows them to run on the same host as all other Jitsi services,
which means they have to compete for resources.
It therefore is very important
that this server has enough resources to be able to handle this.

To enable Jibri, add:

```nix
{
  services.jitsi-meet.jibri.enable = true;
}
```

By default, it will record to `/tmp/recordings`.
This and more options can be configured by setting `services.jibri.config`,
for which a reference configuration file can be found [in the jibri source code](https://github.com/jitsi/jibri/blob/master/src/main/resources/reference.conf),
or `services.jibri.finalizeScript`.
The latter has a [useful example in the NixOS module documentation](https://search.nixos.org/options?channel=22.05&show=services.jibri.finalizeScript&from=0&size=50&sort=relevance&type=packages&query=services.jibri.).

An example that changes the recording destination directory
and tunes the encoding options,
but does not upload the recordings to a different server,
could look like this:

```nix
{ config, ... }:

{
  services.jibri.config = {
    recording = {
      recordings-directory = "/var/lib/jitsi-meet-recordings";
    };
    ffmpeg = {
      #framerate = 30;
      #video-encode-preset = "veryfast"; # https://trac.ffmpeg.org/wiki/Encode/H.264#a2.Chooseapresetandtune
      h264-constant-rate-factor = 21; # https://trac.ffmpeg.org/wiki/Encode/H.264#a1.ChooseaCRFvalue
    };
  };

  # This is required if the recordings directory can’t be created by Jibri itself
  # e.g. due to missing permissions.
  # If it is under /tmp/ (like the default), this is not needed.
  systemd.tmpfiles.rules = [
    "d ${config.services.jibri.config.recording.recordings-directory} 0750 jibri jibri -"
  ];
}
```

## Outlook

That concludes this blog post on how to set up a simple Jitsi Meet server on NixOS.
But it still only scratches the surface of what is possible with Jitsi Meet.
In the future, support for many of Jitsi Meet’s other features will be added to NixOS.
Some possible features include clustering,
authenticated participants,
and joining a meeting via telephone.

Stay tuned!
