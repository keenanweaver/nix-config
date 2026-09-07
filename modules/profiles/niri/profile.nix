{ self, ... }:
{
  flake.modules = {
    homeManager.profile-niri = {
      imports = with self.modules.homeManager; [
        niri
        noctalia
      ];
      xdg = {
        autostart.enable = true;
        userDirs = {
          enable = true;
          createDirectories = true;
          projects = null;
          publicShare = null;
          setSessionVariables = true;
          templates = null;
        };
      };
    };
    nixos.profile-niri = {
      imports = with self.modules.nixos; [
        niri
        noctalia
      ];
      environment.sessionVariables = {
        ELECTRON_OZONE_PLATFORM_HINT = "wayland";
        NIXOS_OZONE_WL = "1";
      };
      hardware.graphics = {
        enable = true;
        enable32Bit = true;
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
            "application/pdf" = pdfViewer;
            "audio/*" = audioPlayer;
            "image/*" = imageViewer;
            "inode/directory" = "org.kde.dolphin.desktop";
            "text/*" = editor;
            "text/html" = browser;
            "text/plain" = editor;
            "video/*" = videoPlayer;
            "x-scheme-handler/http" = browser;
            "x-scheme-handler/https" = browser;
          };
        };
    };
  };
}
