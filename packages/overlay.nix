{ inputs }:

(final: prev: {
  #distrobox = inputs.chaotic.packages.${final.stdenv.hostPlatform.system}.distrobox_git;
  fooyin = prev.callPackage ./fooyin { };
  gamemode = prev.gamemode.overrideAttrs {
    version = "1.8.2-unstable-06-15-2026";
    src = prev.fetchFromGitHub {
      owner = "FeralInteractive";
      repo = "gamemode";
      rev = "a74b8106a2236d1f2696aa44c93bc4c8ef13b42e";
      hash = "sha256-k5pq83KceoPS/bGVur6jhvKNXGJr1KBD0v6YNGB7RMY=";
    };
  };
  game-wrapper = prev.callPackage ./game-wrapper { };
  gamescope = inputs.chaotic.legacyPackages.${final.stdenv.hostPlatform.system}.gamescope_git;
  gpu-screen-recorder = prev.callPackage ./gpu-screen-recorder/gsr.nix { };
  gpu-screen-recorder-notification = prev.callPackage ./gpu-screen-recorder/notif.nix { };
  gpu-screen-recorder-ui = prev.callPackage ./gpu-screen-recorder/ui.nix { };
  inter = prev.callPackage ./inter { };
  lgogdownloader = prev.callPackage ./lgogdownloader { };
  mangohud =
    inputs.chaotic.legacyPackages.${final.stdenv.hostPlatform.system}.mangohud_git.overrideAttrs
      (
        finalAttrs: prevAttrs: {
          patches = prevAttrs.patches ++ [
            (prev.fetchpatch {
              # X3D Cores https://github.com/flightlessmango/MangoHud/pull/1984
              url = "https://github.com/flightlessmango/MangoHud/pull/1984.patch";
              hash = "sha256-4JErvglfYSJQMBwf5BewtkNHYyUOiNoXqMb+d6d6UE0=";
            })
          ];
        }
      );
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
  openxcom = prev.openxcom.overrideAttrs {
    pname = "openxcom-extended";
    version = "8.6.1";
    src = prev.fetchFromGitHub {
      owner = "MeridianOXC";
      repo = "OpenXcom";
      rev = "602847529e79bde07aa73bb5d5fde11fef74ebc1";
      hash = "sha256-f+reHdXBsmGyc0a/JVjM82uLvHQ3LJw1gz8HiBkZW+s=";
    };
  };
  pnpm_10_29_2 = final.pnpm_10;
  proton-dw = final.dwproton-bin.override {
    steamDisplayName = "Proton DW";
  };
  proton-em = final.callPackage ./proton-em { };
  relive = prev.callPackage ./relive { };
  rsdkv3 = prev.callPackage ./rsdk/v3 { };
  sonic3air = prev.callPackage ./sonic3air { };
  xlink-kai = prev.callPackage ./xlink-kai { };
})
