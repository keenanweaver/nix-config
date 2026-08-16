# TODO

## Fixes

- [EasyEffects](../modules/apps/_easyeffects.nix). Hangs Pipewire on login.
- [Fluxer](../modules/apps/fluxer.nix). Desktop entry name creates dupe on second monitor taskbar with Plasma Manager.
- [Yeetmouse](../modules/profiles/gaming/_yeetmouse.nix) config does not save appropriately. May be an upstream issue.

## Hacks

These are hacks/temporary workarounds that should be reverted once upstream/other sources add them.

- N/A

## Flake

- Set up CI/CD
  - [Renovate Bot](https://docs.renovatebot.com/). Flake updates, other dependencies I may refer to in the config. (i.e., artifacts that use fetchurl like DXVK config)
  - Workflows for MRs
- Protect `dendritic` branch
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
- [GPU Screen Recorder](../modules/apps/gpu-screen-recorder.nix). Remove module when upstreamed.
- [Helix](../modules/apps/helix.nix). Cleanup or remove.
- Plymouth. Consider Steam theme for `nixos-htpc`
- [Sunshine](../modules/apps/sunshine.nix). Remove if Moonshine suits my needs. Also remove fake display EDID stuff.
