<!--toc:start-->

- [Installation](#installation)
  - [1. Common steps](#1-common-steps)
  - [2a. x86_64 -- nixos-anywhere](#2a-x86_64----nixos-anywhere)
  - [2b. Raspberry Pi -- sdImage](#2b-raspberry-pi----sdimage)
- [Hosts](#hosts)
- [Games](#games)
- [TODO](#todo)

<!--toc:end-->

# Installation

Deploy type depends on the target: **x86_64** hosts are provisioned remotely
with [nixos-anywhere][def5]; **Raspberry Pi** hosts have no kexec support, so
they're provisioned by building a complete, bootable SD card image.

## 1. Common steps

1. Create the host directory:

   ```bash
   just init-host <hostname>
   ```

1. Generate an SSH host key:

   ```bash
   just gen-host-key <hostname>
   ```

   This writes the private key to `/tmp/extra-files/<hostname>/persist/etc/ssh/`
   and commits the public key to `assets/hosts/<hostname>/`.

1. Derive the age key and update `.sops.yaml`:

   ```bash
   just age-key <hostname>
   ```

   Add the printed age key to `.sops.yaml` under a `&<hostname>` anchor, add
   it to the relevant `creation_rules` key group, then re-encrypt secrets:

   ```bash
   just sops-rekey
   ```

## 2a. x86_64 -- nixos-anywhere

1. Boot the target with NixOS ISO installation media, set a password for SSH
   (`passwd`).

1. Identify the target disk:

   ```bash
   just disk-id <user@target>
   ```

1. Create `modules/hosts/<hostname>/disko.nix` using an existing x86_64 host
   as a template.

1. Generate secure boot signing keys (optional):

   ```bash
   just gen-sbctl-keys <hostname>
   ```

1. Create `modules/hosts/<hostname>/host.nix`, importing `profile-base` and
   the relevant desktop/server profile.

1. Deploy (this also generates the facter hardware report, by kexec'ing into
   an installer environment on the real target before installing):

   ```bash
   just deploy <hostname> <user@target>
   ```

1. Enroll secure boot keys (optional, requires UEFI Setup Mode): boot the
   target in UEFI Setup Mode, SSH in, and run `sbctl enroll-keys`. Then
   enable Secure Boot in firmware settings.

1. Redeploy once for limine to sign the boot files (optional, secure boot
   only):

   ```bash
   just deploy-update <hostname> <user@target>
   ```

1. Clean up temporary key material:

   ```bash
   just clean-keys
   ```

## 2b. Raspberry Pi -- sdImage

1. Create `modules/hosts/<hostname>/host.nix`, importing `profile-base` and
   `profile-pi`, plus the board's hardware modules from the
   [`nixos-raspberrypi`][def4] flake input (`inject-overlays`,
   `trusted-nix-caches`, `raspberry-pi-4.base`, `sd-image`). Copy
   `regret`/`remorse` as a template.

1. Build the image:

   ```bash
   just sd-image <hostname>
   ```

1. Flash it to a microSD card:

   ```bash
   zstd -d --stdout result/sd-image/nixos-image-*.img.zst \
     | sudo dd of=/dev/sdX bs=4M status=progress conv=fsync
   ```

1. Boot the Pi.

1. Generate facter.json and redeploy so it takes effect:

   ```bash
   just facter <hostname> <user@target>
   just deploy-update <hostname> <user@target>
   ```

1. Clean up temporary key material:

   ```bash
   just clean-keys
   ```

# Hosts

See [HOSTS.md][def] for host specific information.

# Games

See [GAMES.md][def2] for game information.

# TODO

See [TODO.md][def3] for TODO items.

[def]: ./HOSTS.md
[def2]: ./GAMES.md
[def3]: ./TODO.md
[def4]: https://github.com/nvmd/nixos-raspberrypi
[def5]: https://github.com/nix-community/nixos-anywhere
