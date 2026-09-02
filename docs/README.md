<!--toc:start-->

- [Installation](#installation)
- [Hosts](#hosts)
- [Games](#games)
- [TODO](#todo)

<!--toc:end-->

# Installation

1. Boot system with installation media, change password for SSH.

   - **x86_64**: boot the NixOS ISO.

   - **Raspberry Pi**: [`nixos-raspberrypi`][def4] doesn't support kexec.

     ```bash
     nix build github:nvmd/nixos-raspberrypi#nixosConfigurations.rpi4-installer.config.system.build.sdImage --accept-flake-config
     ```

     Flash to a microSD card, boot the Pi, `ssh root@<ip>` and set a root
     password (`passwd`) before continuing.

1. Identify the target disk:

   ```bash
   just disk-id <user@target>
   ```

1. Create the host directory and disko configuration:

   ```bash
   just init-host <hostname>
   ```

   Create `modules/hosts/<hostname>/disko.nix` using an existing host as a
   template.

1. Generate an SSH host key:

   ```bash
   just gen-host-key <hostname>
   ```

1. Derive the age key and update `.sops.yaml`:

   ```bash
   just age-key <hostname>
   ```

   Add the age key to `.sops.yaml`, then re-encrypt secrets:

   ```bash
   just sops-rekey
   ```

1. Generate secure boot signing keys (optional, **x86_64 only**):

   ```bash
   just gen-sbctl-keys <hostname>
   ```

1. Create the host configuration in `modules/hosts/<hostname>/host.nix`.

   - **x86_64**: import `profile-base` and the relevant desktop/server
     profile.
   - **Raspberry Pi**: import `profile-base` and `profile-pi`, plus the
     board's hardware modules from the `nixos-raspberrypi` flake input
     (`inject-overlays`, `trusted-nix-caches`, `raspberry-pi-4.base`).
     (Copy `remorse`/`regret`)

1. Deploy (also generates the facter report):

   ```bash
   just deploy <hostname> <user@target>
   ```

1. Enroll secure boot keys (optional, requires UEFI Setup Mode, **x86_64
   only**):

   Boot the target in UEFI Setup Mode, then SSH in and run:

   ```bash
   sbctl enroll-keys
   ```

   After enrollment, enable Secure Boot in the UEFI firmware settings.

1. Rebuild once for limine to sign the boot files (optional, secure boot
   only, **x86_64 only**):

   ```bash
   just update <hostname> <user@target>
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
