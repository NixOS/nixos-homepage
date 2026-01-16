---
title: "Calling All Hardware Vendors: Partner with the NixOS Hardware Team"
date: 2025-01-21
author: "Jörg Thalheim"
---

_An open invitation to hardware manufacturers: Let's make your hardware shine on NixOS._

If you're a hardware vendor reading this, we have a simple message: we want to work with you.
The NixOS Hardware Team is actively seeking partnerships with manufacturers who want their hardware to work flawlessly on NixOS.
Here's why you should care and how we can help each other.

## Who We Are

The NixOS Hardware Team maintains the [nixos-hardware repository](https://github.com/NixOS/nixos-hardware),
a comprehensive collection of hardware-specific configurations that make devices work optimally with NixOS.

Our team consists of:

- **Jörg Thalheim (Mic92)** - Lead Maintainer
- **Sebastian Kraus (ra33it0)** - Partnership Liaison (also on the NixOS Foundation Board)
- **RossComputerGuy** - Core Team Member

We've already created configurations for hundreds of devices, from laptops and desktops to single-board computers and enterprise servers with the help of the community.
But we know we can do better—with your help.

## Why Partner With Us?

### Your Customers Are Already Using NixOS
NixOS users are developers, system administrators, DevOps engineers, and tech enthusiasts.
When they buy hardware, they expect it to work with their operating system of choice.
Currently, they're cobbling together configurations from forum posts and GitHub issues.
We can do better than that.

### Simplify Your Linux Support
Instead of maintaining lengthy distribution-specific guides, you can point NixOS users to a single hardware profile:

```nix
{
  imports = [
    <nixos-hardware/your-company/your-device>
  ];
}
```

That's it. No more "edit this file, add these kernel parameters, install these drivers, sacrifice a goat under the full moon."

### Reduce Support Tickets
Every user who can't get their hardware working generates a support ticket.
By ensuring your hardware has excellent NixOS support, you reduce your support burden while improving customer satisfaction.

### Gain Visibility
We showcase our hardware partners at NixCon, in our documentation, and throughout the NixOS community.
Your commitment to open-source support doesn't go unnoticed.

## What We Need From You

### 1. Communication
Reach out to us at **hardware@nixos.org**. Tell us about your hardware and what specific support challenges you're facing with NixOS users.

### 2. Hardware Access (Optional but Helpful)
While not always necessary, having access to hardware helps us create and test configurations.
Some partners send us devices, others provide remote access, and some simply share detailed specifications.

### 3. Technical Information
Share any Linux-specific quirks, required firmware, or special configurations your hardware needs.
If you already have patches or know about specific issues, let us know.

### 4. Ongoing Collaboration
The best partnerships are ongoing.
Establish a dedicated point of contact on your team who we can work with directly.
Having a two-way communication channel ensures we can quickly address issues, share updates, and coordinate on new releases.
When you release new hardware or update firmware, give us a heads up so we can ensure continued compatibility.

## What You Get

### Professional Hardware Profiles
We create and maintain high-quality configurations that handle:
- Kernel parameters and modules
- Firmware requirements
- Power management optimizations
- Display and graphics settings
- Audio configurations
- Device-specific quirks

### Community Maintenance
Once a profile is in nixos-hardware, the entire NixOS community helps maintain it. Users report issues, submit improvements, and test new kernel versions.

### Documentation
We help simplify your NixOS installation guides to a single line pointing to the hardware profile.

### Testing and Feedback
Our community provides real-world testing and feedback that can inform your Linux driver development and hardware design.

## Success Stories in Progress

We're already working with several hardware vendors who recognize the value of first-class NixOS support.
These partnerships have resulted in better hardware support, fewer support tickets, and happier customers on both sides.

Companies have reached out to us for everything from fixing sensor rotation on laptops to optimizing power management on new CPU architectures.
Each collaboration makes NixOS better for everyone.

## How to Get Started

1. **Email us** at hardware@nixos.org
2. **Join our Matrix channel** at #nixos-hardware:nixos.org
3. **Attend our community meetings** (3rd Friday each month at 17:00 UTC on https://jitsi.lassul.us/Hardware-team)
4. **Check out our existing work** at [github.com/NixOS/nixos-hardware](https://github.com/NixOS/nixos-hardware)

## The Bottom Line

Your hardware deserves to work brilliantly on every operating system, including NixOS. Our users deserve hardware that works out of the box.
Let's make both happen.

In return, you get reduced support burden, increased visibility in a technical community, and the satisfaction of supporting open source.

Ready to ensure your hardware just works on NixOS? Let's talk.

---

*Contact the NixOS Hardware Team at hardware@nixos.org or find us on Matrix at #nixos-hardware:nixos.org*
