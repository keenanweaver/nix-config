# Installation

1. Boot system with NixOS ISO, change password for SSH

1. Identify the target disk:

   ```bash
   just disk-id <user@target>
   ```

1. Create the host directory and disko configuration:

   ```bash
   just init-host <hostname>
   ```

   Create `modules/hosts/<hostname>/disko.nix` using an existing host as a template.

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

1. Generate secure boot signing keys (optional):

   ```bash
   just gen-sbctl-keys <hostname>
   ```

1. Create the host configuration in `modules/hosts/<hostname>/default.nix`.

1. Deploy (also generates the facter report):

   ```bash
   just deploy <hostname> <user@target>
   ```

1. Enroll secure boot keys (optional, requires UEFI Setup Mode):

   Boot the target in UEFI Setup Mode, then SSH in and run:

   ```bash
   sbctl enroll-keys
   ```

   After enrollment, enable Secure Boot in the UEFI firmware settings.

1. Rebuild once for limine to sign the boot files (optional, secure boot only):

   ```bash
   just update <hostname> <user@target>
   ```

1. Clean up temporary key material:

   ```bash
   just clean-keys
   ```

# Hosts

See [HOSTS.md](./HOSTS.md) for host specific information

# Games

See [GAMES.md](./GAMES.md) for game information
