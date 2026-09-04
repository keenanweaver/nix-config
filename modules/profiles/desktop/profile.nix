{ self, inputs, ... }:
{
  flake.modules = {
    homeManager.profile-desktop.imports = with self.modules.homeManager; [
      catppuccin
      kde
      plasma-manager
      zen-browser
    ];
    nixos.profile-desktop =
      {
        lib,
        config,
        pkgs,
        ...
      }:
      {
        imports = with self.modules.nixos; [
          inputs.omniflake.flakes.ucodenix.nixosModules.default

          catppuccin
          kde
        ];
        boot.kernelParams = lib.mkIf config.services.ucodenix.enable [ "microcode.amd_sha_check=off" ];
        console = {
          font = "ter-v28b";
          packages = with pkgs; [
            terminus_font
          ];
        };
        environment = {
          sessionVariables = {
            ELECTRON_OZONE_PLATFORM_HINT = "wayland";
            NIXOS_OZONE_WL = "1";
          };
          stub-ld.enable = true;
        };
        hardware.graphics = {
          enable = true;
          enable32Bit = true;
        };
        my.permittedInsecurePackages = [
          "electron-40.10.5" # ?
          "olm-3.2.16" # Neochat
        ];
        nix.settings = {
          extra-substituters = [
            "https://attic.xuyh0120.win/lantian" # https://github.com/xddxdd/nix-cachyos-kernel?tab=readme-ov-file#binary-cache
            "https://nix-cache.tokidoki.dev/tokidoki"
          ];
          extra-trusted-public-keys = [
            "lantian:EeAUQ+W+6r7EtwnmYjeVwx5kOGEBpjlBfPlzGlTNvHc="
            "tokidoki:MD4VWt3kK8Fmz3jkiGoNRJIW31/QAm7l1Dcgz2Xa4hk="
          ];
        };
        programs = {
          appimage = {
            enable = true;
            binfmt = true;
          };
          ydotool.enable = true;
        };
        security.pam.services = {
          login.enableKwallet = true;
          sddm.enableKwallet = true;
        };
        services = {
          btrfs.autoScrub = {
            enable = true;
            interval = "weekly";
          };
          fstrim.enable = true;
          fwupd.enable = true;
          tuned = {
            enable = true;
            ppdSettings.profiles = {
              balanced = "balanced";
              performance = "throughput-performance";
              power-saver = "desktop-powersave";
            };
            settings.dynamic_tuning = true;
          };
          ucodenix.enable = true;
        };
        xdg.mime =
          let
            audioPlayer = "org.fooyin.fooyin.desktop";
            browser = "zen-beta.desktop";
            editor = "org.kde.kate.desktop";
            imageViewer = "org.kde.gwenview.desktop";
            pdfViewer = "org.kde.okular.desktop";
            videoPlayer = "org.kde.haruna.desktop";
          in
          {
            enable = true;
            defaultApplications = {
              "application/json" = editor;
              "application/pdf" = pdfViewer;
              "application/toml" = editor;
              "application/vnd.microsoft.portable-executable" = "nero-umu.desktop";
              "application/x-alcohol" = "cdemu-client.desktop";
              "application/x-bat" = editor;
              "application/x-cue" = "cdemu-client.desktop";
              "application/x-dosexec" = "nero-umu.desktop";
              "application/x-gd-rom-cue" = "cdemu-client.desktop";
              "application/x-ms-ne-executable" = "nero-umu.desktop";
              "application/x-msdownload" = "nero-umu.desktop";
              "application/x-shellscript" = editor;
              "application/x-yaml" = editor;
              "application/xhtml+xml" = browser;
              "application/xml" = editor;
              "audio/*" = audioPlayer;
              "image/*" = imageViewer;
              "inode/directory" = "org.kde.dolphin.desktop";
              "text/*" = editor;
              "text/html" = browser;
              "text/plain" = editor;
              "video/*" = videoPlayer;
              "x-scheme-handler/bottles" = "com.usebottles.bottles.desktop";
              "x-scheme-handler/http" = browser;
              "x-scheme-handler/https" = browser;
              "x-scheme-handler/ror2mm" = "r2modman.desktop";
              "x-scheme-handler/sgnl" = "signal.desktop";
              "x-scheme-handler/signalcaptcha" = "signal.desktop";
              "x-scheme-handler/terminal" = "org.wezfurlong.wezterm.desktop";
            };
          };
      };
  };
}
