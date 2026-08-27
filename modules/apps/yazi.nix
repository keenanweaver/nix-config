{
  flake.modules.homeManager.profile-base = { pkgs, ... }: {
    programs.yazi = {
      enable = true;
      enableBashIntegration = true;
      enableNushellIntegration = true;
      enableZshIntegration = true;
      extraPackages = with pkgs; [
        fd
        ripgrep
        fzf
        zoxide
        imagemagick
        ffmpegthumbnailer
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
      shellWrapperName = "y";
    };
  };
}
