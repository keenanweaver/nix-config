{ inputs, self, ... }:
{
  flake.modules = {
    homeManager.desktop-profile = {
      imports = with self.modules.homeManager; [
        kde
        llm
        plasma-manager
      ];
    };
    nixos.desktop-profile = {
      imports = with self.modules.nixos; [
        inputs.ucodenix.nixosModules.default

        kde
      ];
      environment.sessionVariables = {
        NIXOS_OZONE_WL = "1"; # Electron apps
      };
      hardware = {
        graphics = {
          enable = true;
          enable32Bit = true;
        };
      };
      nix = {
        settings = {
          extra-substituters = [
            "https://attic.xuyh0120.win/lantian" # https://github.com/xddxdd/nix-cachyos-kernel?tab=readme-ov-file#binary-cache
            "https://nix-cache.tokidoki.dev/tokidoki"
          ];
          extra-trusted-public-keys = [
            "lantian:EeAUQ+W+6r7EtwnmYjeVwx5kOGEBpjlBfPlzGlTNvHc="
            "tokidoki:MD4VWt3kK8Fmz3jkiGoNRJIW31/QAm7l1Dcgz2Xa4hk="
          ];
        };
      };
      programs = {
        appimage = {
          enable = true;
          binfmt = true;
        };
        ydotool.enable = true;
      };
      services = {
        btrfs = {
          autoScrub = {
            enable = true;
            interval = "weekly";
          };
        };
        fstrim.enable = true;
        fwupd.enable = true;
        tuned = {
          enable = true;
          ppdSettings = {
            profiles = {
              balanced = "balanced";
              performance = "throughput-performance";
              power-saver = "desktop-powersave";
            };
          };
          settings = {
            dynamic_tuning = true;
          };
        };
        ucodenix.enable = true;
      };
      xdg.mime =
        let
          audioPlayer = "org.fooyin.fooyin.desktop";
          browser = "app.zen_browser.zen.desktop";
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
  flake-file.inputs = {
    ucodenix.url = "github:e-tho/ucodenix";
  };
}
