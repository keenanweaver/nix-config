{ inputs }:

(final: prev: {
  fooyin = prev.callPackage ./fooyin { };
  gamemode = prev.gamemode.overrideAttrs {
    version = "1.8.2-unstable-09-04-2025";
    src = prev.fetchFromGitHub {
      owner = "FeralInteractive";
      repo = "gamemode";
      rev = "f0a569a5199974751a4a75ebdc41c8f0b8e4c909";
      hash = "sha256-9DB8iWiyrM4EJ94ERC5SE9acrhqeI00BF1wU0umeNFg=";
    };
  };
  gpu-screen-recorder = prev.callPackage ./gpu-screen-recorder/gsr.nix { };
  gpu-screen-recorder-notification = prev.callPackage ./gpu-screen-recorder/notif.nix { };
  gpu-screen-recorder-ui = prev.callPackage ./gpu-screen-recorder/ui.nix { };
  inter = prev.callPackage ./inter { };
  klassy = prev.klassy.overrideAttrs {
    version = "6.5.3";
    src = prev.fetchFromGitHub {
      owner = "paulmcauley";
      repo = "klassy";
      rev = "0f023c0464fcae67abb939551034346dcaab9b5e";
      hash = "sha256-2M1SGmYSEnZ1AlsOvhrM25oQi8mz/H8df4pzyFYybN8=";
    };
  };
  /*
    lutris-unwrapped = prev.lutris-unwrapped.overrideAttrs {
      version = "0.5.20";
      src = prev.fetchFromGitHub {
        owner = "lutris";
        repo = "lutris";
        rev = "c45a98a42b71b799d7169abd6ef3bd25f0065f9b";
        hash = "sha256-ycAlVV5CkLLsk/m17R8k6x40av1wcEVQU2GMbOuc7Bs=";
      };
    };
  */
  moondeck-buddy = prev.callPackage ./moondeck-buddy { };
  nero-umu = prev.nero-umu.overrideAttrs {
    version = "1.2.0-unstable-02-23-2026";
    src = prev.fetchFromGitHub {
      owner = "SeongGino";
      repo = "Nero-umu";
      rev = "6246d8d2d01426c55311d5e02bd55b34d5818524";
      hash = "sha256-j6JS1r7LrhYBuENpuJQxgW8PPME2XmJveTb57svYdEs=";
    };
  };
  nuked-sc55 = prev.callPackage ./nuked-sc55 { };
  openttd = prev.openttd.overrideAttrs {
    postPatch = ''
      substituteInPlace src/music/fluidsynth.cpp \
        --replace-fail "/usr/share/soundfonts/default.sf2" \
          "${final.soundfont-generaluser}/share/soundfonts/GeneralUser-GS.sf2"
    '';
  };
  openxcom = prev.openxcom.overrideAttrs {
    pname = "openxcom-extended";
    version = "8.5.5";
    src = prev.fetchFromGitHub {
      owner = "MeridianOXC";
      repo = "OpenXcom";
      rev = "9a10ae28b844d92d621817b302b0eb1655175653";
      hash = "sha256-dhXLYCSv8aQ7zMGLCmH7Os6YSBaVhB5MnLakSV87Kcg=";
    };
  };
  proton-cachyos-x86_64-v4 =
    inputs.nix-gaming-edge.packages.${final.stdenv.hostPlatform.system}.proton-cachyos-x86_64-v4;
  proton-dw = inputs.dw-proton.packages.${final.stdenv.hostPlatform.system}.dw-proton;
  proton-em = final.callPackage ./proton-em { };
  proton-ge = final.proton-ge-bin.override {
    steamDisplayName = "Proton GE";
  };
  /*
    proton-ge =
     (prev.proton-ge-bin.override {
       steamDisplayName = "Proton GE";
     }).overrideAttrs
       (old: rec {
         version = "GE-Proton10-32";
         src = prev.fetchzip {
           url = "https://github.com/GloriousEggroll/proton-ge-custom/releases/download/${version}/${version}.tar.gz";
           hash = "sha256-NxZ4OJUYQdRNQTb62jRET6Ef14LEhynOASIMPvwWeNA=";
         };
       });
  */
  relive = prev.callPackage ./relive { };
  rsdkv3 = prev.callPackage ./rsdk/v3 { };
  /*
    scummvm = prev.scummvm.overrideAttrs {
      version = "3.0.0-unstable-01-20-2026";
      src = prev.fetchFromGitHub {
        owner = "scummvm";
        repo = "scummvm";
        rev = "59f4176fd731eac3dedca125971fc8a41c9a5a55";
        hash = "sha256-w8Dsa8g9HcdTKVORCSaFhwMX8VlL1L6AY9HRbG4vZ40=";
      };
    };
  */
  xlink-kai = prev.callPackage ./xlink-kai { };
})
