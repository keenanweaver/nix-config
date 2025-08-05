# Notes
* Do not use USB 2.0 port 1, as it extends boot time dramatically. (Manual reference: 1.4 I/O Panel, **3 USB 2.0 Ports (USB_12)**, page 9)

# Hardware
* [ASRock X870E Taichi](https://www.asrock.com/mb/AMD/X870E%20Taichi/index.asp)
* AMD Ryzen 9 7950X3D
* XFX Speedster MERC310 AMD Radeon RX 7900XTX
* CORSAIR VENGEANCE DDR5 RAM 64GB (2x32GB) 6400MHz
* NZXT Kraken Elite 360mm AIO CPU Cooler
* Corsair RM850e (2023) PSU
* Crucial T700 2TB Gen5 NVMe M.2 SSD
* Samsung 990 PRO 2TB SSD NVMe M.2 PCIe Gen4
* [GIGABYTE - AORUS FO27Q3 - 27" QD OLED Gaming Monitor](https://www.gigabyte.com/Monitor/AORUS-FO27Q3)
* Lenovo Legion Y27q-20 Gaming Monitor, 27”
* Fractal Design North XL ATX mATX Mid Tower PC Case
# Peripherals
### Input
* 8BitDo Retro Mechanical Keyboard N Edition
* Logitech G502X
* Elgato Stream Deck MK.2
### Audio
* Schiit Modi+ DAC
* Rolls MX51s Mini-Mix 2
* Edifier R1850DB Bookshelf Speakers
* Audiotechnica ATH-AD700X
* Beyerdynamic DT 880 Premium 600 OHM Headphones
### Game

* 8BitDo Arcade Stick for Xbox
* GameSir Cyclone 2 Wireless Controller
* Junkfood Snack Box MICRO XL
* Logitech G920 Racing Wheel
* Sony Dualsense Controller
### Other
* Anker Powered USB Hub for Laptop, 7 Ports USB 3.0 Data Hub (UPC: 848061071467)
* BenQ ScreenBar Halo 2 LED Monitor Light
* CyberPower CP1500AVRLCD3 Intelligent LCD UPS System
* FlexiSpot Kana Pro Bamboo Standing Desk
# BIOS settings
* OC Tweaker -> Gaming Mode: **Disabled** (Wrong cores are parked when enabled)
* OC Tweaker -> DRAM Profile Configuration: **XMP1-6400**
* Advanced/AMD Overclocking/Accept --> Precision Boost Overdrive: **Enabled**
* Advanced/PCI Configuration -> Above 4G Decoding: **Enabled**
* Advanced/PCI Configuration -> Resizable BAR: **Enabled**
* Advanced/PCI Configuration -> SR-IOV Support: **Enabled**
* Advanced/Onboard Device Configuration -> RGB LED: **Off**
* Advanced/Onboard Device Configuration -> BT On/Off: **On**
* Advanced/AMD CBS/NBIO Common Options/GFX Configuration -> DGPU Only Mode: **Enabled**
* Advanced/AMD CBS/SMU Common Options -> CPPC Dynamic Preferred Cores: **Driver** ([AMD 3D VCache CCD cores](https://wiki.cachyos.org/configuration/general_system_tweaks/#amd-3d-v-cache-optimizer))
* Boot -> CSM: **Disabled**
* Boot -> Fast Boot: **Disabled**