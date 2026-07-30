{
  flake.modules.homeManager.base-profile = {
    programs.yazi = {
      enable = true;
      enableBashIntegration = true;
      enableNushellIntegration = true;
      enableZshIntegration = true;
      settings = {
        manager = {
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
