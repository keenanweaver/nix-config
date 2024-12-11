{
  lib,
  config,
  pkgs,
  username,
  ...
}:
let
  cfg = config.fonts;
  apple-fonts = pkgs.stdenv.mkDerivation rec {
    pname = "apple-fonts";
    version = "1";
    pro = pkgs.fetchurl {
      url = "https://devimages-cdn.apple.com/design/resources/download/SF-Pro.dmg";
      sha256 = "sha256-IccB0uWWfPCidHYX6sAusuEZX906dVYo8IaqeX7/O88=";
    };
    compact = pkgs.fetchurl {
      url = "https://devimages-cdn.apple.com/design/resources/download/SF-Compact.dmg";
      sha256 = "sha256-PlraM6SwH8sTxnVBo6Lqt9B6tAZDC//VCPwr/PNcnlk=";
    };
    mono = pkgs.fetchurl {
      url = "https://devimages-cdn.apple.com/design/resources/download/SF-Mono.dmg";
      sha256 = "sha256-bUoLeOOqzQb5E/ZCzq0cfbSvNO1IhW1xcaLgtV2aeUU=";
    };
    ny = pkgs.fetchurl {
      url = "https://devimages-cdn.apple.com/design/resources/download/NY.dmg";
      sha256 = "sha256-HC7ttFJswPMm+Lfql49aQzdWR2osjFYHJTdgjtuI+PQ=";
    };
    nativeBuildInputs = [ pkgs.p7zip ];
    sourceRoot = ".";
    dontUnpack = true;
    installPhase = ''
      7z x ${pro}
      cd SFProFonts 
      7z x 'SF Pro Fonts.pkg'
      7z x 'Payload~'
      mkdir -p $out/fontfiles
      mv Library/Fonts/* $out/fontfiles
      cd ..

      7z x ${mono}
      cd SFMonoFonts
      7z x 'SF Mono Fonts.pkg'
      7z x 'Payload~'
      mv Library/Fonts/* $out/fontfiles
      cd ..

      7z x ${compact}
      cd SFCompactFonts
      7z x 'SF Compact Fonts.pkg'
      7z x 'Payload~'
      mv Library/Fonts/* $out/fontfiles
      cd ..

      7z x ${ny}
      cd NYFonts
      7z x 'NY Fonts.pkg'
      7z x 'Payload~'
      mv Library/Fonts/* $out/fontfiles

      mkdir -p $out/usr/share/fonts/OTF $out/usr/share/fonts/TTF
      mv $out/fontfiles/*.otf $out/usr/share/fonts/OTF
      mv $out/fontfiles/*.ttf $out/usr/share/fonts/TTF
      rm -rf $out/fontfiles
    '';
  };
in
{
  options = {
    fonts = {
      enable = lib.mkEnableOption "Enable fonts in NixOS or home-manager";
    };
  };

  config = lib.mkIf cfg.enable {
    fonts = {
      enableDefaultPackages = false;
      fontDir = {
        enable = true;
        decompressFonts = true;
      };
      packages = with pkgs; [
        #atkinson-hyperlegible
        apple-fonts
        #b612
        #barlow
        #caladea
        #carlito
        corefonts
        #fira-sans
        #font-awesome
        #geist-font
        ibm-plex
        inter
        #lato
        #lexend
        liberation_ttf
        material-design-icons
        monaspace
        #nerd-fonts.iosevka
        nerd-fonts.jetbrains-mono
        noto-fonts
        noto-fonts-cjk-sans
        noto-fonts-emoji
        noto-fonts-lgc-plus
        #poppins
        rubik
        source-han-sans
        source-han-sans-japanese
        source-han-serif-japanese
        ubuntu-sans
        ultimate-oldschool-pc-font-pack
        wqy_zenhei
      ];
      fontconfig = {
        allowBitmaps = false;
        defaultFonts = {
          monospace = [
            "JetBrainsMono Nerd Font"
            "BlexMono Nerd Font"
            "Noto Color Emoji"
          ];
          sansSerif = [
            "Inter"
            "IBM Plex Sans"
            "Noto Color Emoji"
          ];
          serif = [
            "IBM Plex Serif"
            "Noto Color Emoji"
          ];
          emoji = [ "Noto Color Emoji" ];
        };
        hinting = {
          enable = true;
          style = "slight";
        };
        subpixel.rgba = "rgb";
      };
    };
    environment = {
      sessionVariables = {
        #https://www.reddit.com/r/linux_gaming/comments/16lwgnj/comment/k1536zb/?utm_source=reddit&utm_medium=web2x&context=3
        FREETYPE_PROPERTIES = "cff:no-stem-darkening=0 autofitter:no-stem-darkening=0";
        # https://reddit.com/r/kde/comments/1bjgajv/fractional_scaling_still_seems_to_look_worse_than/kvshkoz/?context=3
        QT_SCALE_FACTOR_ROUNDING_POLICY = "RoundPreferFloor";
      };
    };
    home-manager.users.${username} = {
      #fonts.fontconfig.enable = true;
    };
  };
}
