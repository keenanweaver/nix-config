{
  flake.modules.homeManager = {
    profile-base = { pkgs, ... }: {
      programs.yazi = {
        enable = true;
        extraPackages = with pkgs; [
          fd
          ripgrep
          fzf
          zoxide
        ];
        settings = {
          log.enabled = false;
          mgr = {
            linemode = "mtime";
            show_hidden = true;
            show_symlink = true;
            sort_by = "natural";
            sort_dir_first = true;
            sort_reverse = false;
            sort_sensitive = false;
          };
        };
      };
    };
    profile-desktop =
      { pkgs, ... }:
      {
        programs.yazi.extraPackages = with pkgs; [
          imagemagick
          ffmpegthumbnailer
        ];
      };
  };
}
