# TODO

## Fixes

- [EasyEffects](../modules/apps/_easyeffects.nix). Hangs Pipewire on login.
- [Yeetmouse](../modules/profiles/gaming/_yeetmouse.nix) config does not save appropriately. May be an upstream issue.
- Klassy application style makes Dolphin selection text unreadable with Catppuccin theme, use Breeze for now.

## Hacks

These are hacks/temporary workarounds that should be reverted once upstream/other sources add them.

- [KDE slowness hack](../modules/desktop-environments/kde/kde.nix)

## Flake

- Consider tagging commits as releases
- Consider Cachix/other caching

## Config

- Add configs for work
- Flatpak runtimes: update all runtimes to 26.08 when available. lsfg-vk, obs, vkbasalt, mesa-git
- MiSTer/`nixos-htpc` save sync in `regret` pi
- Consider adding custom [coolercontrol](https://github.com/Daaboulex/coolercontrol-nix) module
