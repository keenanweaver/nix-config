# TODO

## Fixes

- [EasyEffects](../modules/apps/_easyeffects.nix). Hangs Pipewire on login.
- [Yeetmouse](../modules/profiles/gaming/_yeetmouse.nix) config does not save appropriately. May be an upstream issue.

## Hacks

These are hacks/temporary workarounds that should be reverted once upstream/other sources add them.

- N/A

## Flake

- Consider tagging commits as releases
- Consider Cachix/other caching
- Consider 'flattening' `flake.lock`. See: https://flake-file.denful.dev/guides/lock-flattening/
- Explore more Pedantix options
- Secrets. Create more secrets, consider moving to private repo.

## Config

- Add configs for work
- Add configs for Niri and Noctalia if I decide to move to that.
- Flatpak runtimes: update all runtimes to 26.08 when available. gamescope, lsfg-vk, mangohud, obs, vkbasalt, mesa-git
- [Ghostty](../modules/apps/ghostty.nix). Explore various options.
- [Helix](../modules/apps/helix.nix). Cleanup or remove.
- Plymouth. Consider Steam theme for `nixos-htpc`
- MiSTer/`nixos-htpc` save sync in `regret` pi
