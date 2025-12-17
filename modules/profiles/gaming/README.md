## Notes
### Gaming
* Use this env var if gamemode doesn't work properly (7950X3D CPU): `WINE_CPU_TOPOLOGY="15:1,2,3,4,5,6,7,16,17,18,19,20,21,22,23"` [Reference](https://discuss.cachyos.org/t/cpu-utilization-with-gamemode-vs-game-performance/2012/3)
* Enable h264 support in Steam: `steam steam://unlockh264/` and `xdg-open steam://unlockh264` (Flatpak Steam) [Reference](https://reddit.com/r/linux_gaming/comments/1jc4k6g/graphical_bug_on_fragpunk/mhzcfi8/?context=3#mhzcfi8)
* `PROTON_ENABLE_WAYLAND=1` will disable mouse capture in OBS when using `obs-gamecapture`
* Refer to `pkgs.proton-ge-bin` as `pkgs.proton-ge-bin.steamcompattool` outside Steam [Reference](https://github.com/NixOS/nixpkgs/issues/388413#issuecomment-2708811793)
* Get useful udev info like this: `udevadm info -n /dev/input/by-id/usb-your-joystick-name | grep -E 'ID_VENDOR_ID|ID_MODEL_ID|ID_MODEL'`
* VRR Setup:
  * In-game: uncap FPS, disable v-sync, exclusive fullscreen
  * KDE: Adaptive Sync set to 'Automatic'
  * MangoHud: `vsync=2`, `gl_vsync=1`, `fps_limit=352` 97% of your refresh rate
  * DXVK: `dxvk.tearFree = True`
* Sunshine: Keep KDE HDR setting to 'Prefer color accuracy' or colors are wrong
  * `KWIN_DRM_NO_AMS=1` breaks HDR streaming. Do not use.