host := `hostname`
flake := justfile_directory()

# `just` with no args lists recipes
default:
    @just --list

# ══ 1) check / lint ═════════════════════════════════════════
lint:
    statix check .
    deadnix --fail .
    pedantix --check $(git ls-files '*.nix')

# full gate: lint + evaluate/build every host
check: lint
    nix flake check

# quick sanity: does *this* host evaluate / what would it build
eval:
    nix build --dry-run .#nixosConfigurations.{{ host }}.config.system.build.toplevel

# ══ 2) fix (autofix + format) ═══════════════════════════════
fix:
    statix fix .
    deadnix --edit .
    pedantix
    nix fmt
    just --fmt --unstable
    mdformat .

# ══ 3) pre-rebuild maintenance ══════════════════════════════
pre:
    nix run .#write-flake
    git add -N .
    nix flake check

# ══ 4) build for next boot ══════════════════════════════════
boot: pre
    nh os boot . -H {{ host }}

# ══ 5) build + switch now ═══════════════════════════════════
switch: pre
    nh os switch . -H {{ host }}

# ══ 6) update inputs, then boot ═════════════════════════════
update-boot: && boot
    nix flake update

# ══ 7) update inputs, then switch ═══════════════════════════
update-switch: && switch
    nix flake update

# ══ iteration / maintenance helpers ═════════════════════════
# fast loop: activate now, NO bootloader entry, skips flake check
test:
    nh os test . -H {{ host }}

# switch without the full flake check (trust your edits)
switch-fast:
    nix run .#write-flake
    git add -N .
    nh os switch . -H {{ host }}

# preview what would change vs the current system
diff:
    nh os build . -H {{ host }} -o result
    nvd diff /run/current-system result

gc:
    nh clean all

repl:
    nix repl .#nixosConfigurations.{{ host }}

# ══ Host provisioning / deployment ══════════════════════════

# List disk IDs on remote target
disk-id target:
    ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no {{ target }} -- ls /dev/disk/by-id/

# Create host directory
init-host host:
    mkdir -p modules/hosts/{{ host }}

# Generate SSH host key for a new host
gen-host-key host:
    mkdir -p /tmp/extra-files/{{ host }}/persist/etc/ssh
    ssh-keygen -t ed25519 -f /tmp/extra-files/{{ host }}/persist/etc/ssh/ssh_host_ed25519_key -N "" -C "root@{{ host }}"
    cp /tmp/extra-files/{{ host }}/persist/etc/ssh/ssh_host_ed25519_key.pub modules/hosts/{{ host }}/

# Generate secure boot signing keys
gen-sbctl-keys host:
    mkdir -p /tmp/extra-files/{{ host }}/persist/var/lib/sbctl
    sbctl create-keys --disable-landlock --export /tmp/extra-files/{{ host }}/persist/var/lib/sbctl/keys --database-path /tmp/extra-files/{{ host }}/persist/var/lib/sbctl/GUID

# Show age key derived from host SSH key
age-key host:
    cat modules/hosts/{{ host }}/ssh_host_ed25519_key.pub | ssh-to-age

# Re-encrypt all sops secrets after updating .sops.yaml
sops-rekey:
    find modules -path '*/secrets/*.yaml' -exec sops updatekeys {} \;

# Deploy a host using nixos-anywhere
[script('bash')]
deploy host target:
    args=(--generate-hardware-config nixos-facter modules/hosts/{{ host }}/facter.json --flake .#{{ host }} --extra-files /tmp/extra-files/{{ host }})
    for key in /tmp/extra-files/{{ host }}/persist/secrets/*.key; do
        [ -f "$key" ] && args+=(--disk-encryption-keys "${key#/tmp/extra-files/{{ host }}}" "$key")
    done
    args+=({{ target }})
    nix run github:nix-community/nixos-anywhere -- "${args[@]}"

# Clean up temporary key material
clean-keys:
    rm -rf /tmp/extra-files

# Update a deployed (remote) host — distinct from local `update-switch`
deploy-update host target:
    nixos-rebuild switch --flake .#{{ host }} --build-host {{ target }} --target-host {{ target }} --ask-sudo-password
