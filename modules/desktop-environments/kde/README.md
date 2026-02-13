## Notes

### KDE Connect

Custom commands for KDE Connect

- HDR: Toggle

``` bash
/home/keenan/Games/toggle-hdr.sh
```

- Kill App

``` bash
ydotool key --key-delay 200 56:1 62:1 62:0 56:0
```

- Kill EXEs

``` bash
pkill -9 -f '\.(exe|EXE)$' 2>/dev/null; killall -9 -r '.*\.(exe|EXE)$' 2>/dev/null; true
```

- MangoHud: Toggle FPS Limit

``` bash
ydotool key --key-delay 200 54:1 59:1 59:0 54:0
```

- MangoHud: Toggle Overlay

``` bash
ydotool key --key-delay 200 42:1 54:1 54:0 42:0
```

- Save GSR Replay

``` bash
gsr-save-replay
```

- VRR: Toggle

``` bash
/home/keenan/Games/toggle-hdr.sh
```