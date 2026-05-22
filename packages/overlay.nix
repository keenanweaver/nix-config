{ inputs }:

(final: prev: {
  #distrobox = inputs.nyx-loner.packages.${final.stdenv.hostPlatform.system}.distrobox_git;
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
  game-wrapper = prev.callPackage ./game-wrapper { };
  gamescope = inputs.nyx-loner.packages.${final.stdenv.hostPlatform.system}.gamescope_git;
  gpu-screen-recorder = prev.callPackage ./gpu-screen-recorder/gsr.nix { };
  gpu-screen-recorder-notification = prev.callPackage ./gpu-screen-recorder/notif.nix { };
  gpu-screen-recorder-ui = prev.callPackage ./gpu-screen-recorder/ui.nix { };
  inter = prev.callPackage ./inter { };
  mangohud = inputs.nyx-loner.packages.${final.stdenv.hostPlatform.system}.mangohud_git;
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
  openldap = prev.openldap.overrideAttrs {
    doCheck = !prev.stdenv.hostPlatform.isi686;
  };
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
  proton-cachyos =
    inputs.nix-gaming-edge.packages.${final.stdenv.hostPlatform.system}.proton-cachyos;
  proton-dw = final.dwproton-bin.override {
    steamDisplayName = "Proton DW";
  };
  proton-em = final.callPackage ./proton-em { };
  proton-ge = final.proton-ge-bin.override {
    steamDisplayName = "Proton GE";
  };
  relive = prev.callPackage ./relive { };
  rsdkv3 = prev.callPackage ./rsdk/v3 { };
  sonic3air = prev.callPackage ./sonic3air { };
  xlink-kai = prev.callPackage ./xlink-kai { };
})
