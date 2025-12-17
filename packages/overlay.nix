{ inputs }:

(final: prev: {
  fooyin = prev.callPackage ./fooyin { };
  gpu-screen-recorder = prev.callPackage ./gpu-screen-recorder/gsr.nix { };
  gpu-screen-recorder-notification = prev.callPackage ./gpu-screen-recorder/notif.nix { };
  gpu-screen-recorder-ui = prev.callPackage ./gpu-screen-recorder/ui.nix { };
  inter = prev.callPackage ./inter { };
  lutris-unwrapped = prev.lutris-unwrapped.overrideAttrs {
    version = "0.5.19-unstable-12-08-2025";
    src = prev.fetchFromGitHub {
      owner = "lutris";
      repo = "lutris";
      rev = "bf6d1dfebda74027557c522549d76f7b8020a225";
      hash = "sha256-vUpKy/DMk1EEhUi+68JJTmbxWFrWieYtWQB88UmZx+Q=";
    };
  };
  moondeck-buddy = prev.callPackage ./moondeck-buddy { };
  nero-umu = prev.nero-umu.overrideAttrs {
    version = "1.2.0-unstable-12-16-2025";
    src = prev.fetchFromGitHub {
      owner = "SeongGino";
      repo = "Nero-umu";
      rev = "ef117073b521ebe07dcb255b42e7a09b5d9bbc93";
      hash = "sha256-+BLE7VVGUsGtmM5GUkdDfpIgDej+nsati17m9AmEw8k=";
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
    version = "8.4.4";
    src = prev.fetchFromGitHub {
      owner = "MeridianOXC";
      repo = "OpenXcom";
      rev = "d6eeaac0c7e10d5b85ded92a224fdc324c7f9a88";
      hash = "sha256-vppJmd+wrud9Xvx13aGM6O+YDQH5ZDxfHYTlMtAq6uE=";
    };
  };
  proton-cachyos =
    inputs.proton-cachyos.packages.${final.stdenv.hostPlatform.system}.proton-cachyos-x86_64_v4;
  proton-em = final.callPackage ./proton-em { };
  proton-ge = final.proton-ge-bin;
  relive = prev.callPackage ./relive { };
  rsdkv3 = prev.callPackage ./rsdk/v3 { };
  rsdkv4 = prev.callPackage ./rsdk/v4 { };
  scummvm = prev.scummvm.overrideAttrs {
    version = "3.0.0-unstable-12-14-2025";
    src = prev.fetchFromGitHub {
      owner = "scummvm";
      repo = "scummvm";
      rev = "5fa26ec824050a0cce86d0324addf69f6479e02f";
      hash = "sha256-qYW3hXZaNEBtBhf7qGS9+tcXRPfaXYSRYVx6dfjFd2o=";
    };
  };
  xlink-kai = prev.callPackage ./xlink-kai { };
})
