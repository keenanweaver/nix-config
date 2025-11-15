## Notes

### KDE Connect

Custom commands for KDE Connect

- Kill App

``` bash
ydotool key --key-delay 200 56:1 62:1 62:0 56:0
```

- MangoHud: Toggle FPS Limit

``` bash
ydotool key --key-delay 200 54:1 59:1 59:0 54:0
```

- MangoHud: Toggle Overlay

``` bash
ydotool key --key-delay 200 100:1 54:1 54:0 100:0
```

- Save GSR Replay

``` bash
gsr-save-replay
```

- Toggle Night Light

``` bash
qdbus org.kde.kglobalaccel /component/kwin invokeShortcut "Toggle Night Color"
```