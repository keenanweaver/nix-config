host := `hostname`
flake := justfile_directory()

# `just` with no args lists recipes
default:
    @just --list

# ══ 1) check / lint ═════════════════════════════════════════
check:
    nix flake check --log-format internal-json -v |& nom --json

eval:
    nix build --dry-run .#nixosConfigurations.{{ host }}.config.system.build.toplevel

# ══ 2) fix (autofix + format) ═══════════════════════════════
fix:
    nix fmt

# ══ 3) pre-rebuild maintenance ══════════════════════════════
pre:
    nix run .#write-flake
    git add flake.nix flake.lock
    git add -N .

hooks:
    nix develop -c pre-commit run --all-files

# ══ 4) iteration / dev feedback ══════════════════════════════
# quick build, just to see whether it compiles (leaves ./result)
build:
    nh os build . -H {{ host }}

# try the configuration without committing to it as the boot entry
test:
    nh os test . -H {{ host }}

diff:
    nh os build . -H {{ host }} -o result
    nvd diff /run/current-system result

repl:
    nix repl .#nixosConfigurations.{{ host }}

# ══ 5) build for next boot ══════════════════════════════════
boot: pre
    nh os boot . -H {{ host }}

# ══ 6) build + switch now ═══════════════════════════════════
switch: pre
    nh os switch . -H {{ host }}

# ══ 7) update inputs, then boot / switch ════════════════════
update:
    nix flake update
    nix run .#write-flake
    git add flake.nix flake.lock
    nix flake check --log-format internal-json -v |& nom --json

update-boot: && boot
    just update

update-switch: && switch
    just update

# ══ 8) maintenance ═══════════════════════════════════════════
clean:
    nh clean all

# ══ Git ══════════════════════════════════════════════════════
# Push the current branch to both Codeberg and Tangled
push:
    git pushall

# ══ Secrets ═════════════════════════════════════════════════
sops-edit file:
    sops modules/sops/secrets/{{ file }}

sops-rekey:
    find modules -path '*/secrets/*.yaml' -exec sops updatekeys {} \;

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
    cp /tmp/extra-files/{{ host }}/persist/etc/ssh/ssh_host_ed25519_key.pub assets/hosts/{{ host }}/

# Generate secure boot signing keys
gen-sbctl-keys host:
    mkdir -p /tmp/extra-files/{{ host }}/persist/var/lib/sbctl
    sbctl create-keys --disable-landlock --export /tmp/extra-files/{{ host }}/persist/var/lib/sbctl/keys --database-path /tmp/extra-files/{{ host }}/persist/var/lib/sbctl/GUID

# Show age key derived from host SSH key (→ add to .sops.yaml, then sops-rekey)
age-key host:
    cat assets/hosts/{{ host }}/ssh_host_ed25519_key.pub | ssh-to-age

# Deploy a host using nixos-anywhere.
# The disk-encryption-keys loop is a no-op on hosts without LUKS (glob finds nothing).
[script('bash')]
deploy host target:
    args=(--generate-hardware-config nixos-facter assets/hosts/{{ host }}/facter.json --flake .#{{ host }} --extra-files /tmp/extra-files/{{ host }})
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
