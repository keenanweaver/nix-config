{
  configurations.nixos.nixos-desktop.module = {
    programs.gamemode = {
      settings = {
        cpu = {
          pin_cores = "1-7,16-23"; # Skip core 0, testing https://kish1n.io/posts/is-core-0-sabotaging-your-performance/
        };
      };
    };
  };
}
