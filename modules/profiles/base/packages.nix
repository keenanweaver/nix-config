{
  flake.modules = {
    homeManager.base-profile = { config, pkgs, ... }: {
      home = {
        file = {
          current-packages = {
            enable = true;
            target = "${config.xdg.configHome}/packages-hm";
            text =
              let
                formatted-hm = builtins.concatStringsSep "\n" sortedUnique;
                packages = map (p: "${p.name}") config.home.packages;
                sortedUnique = builtins.sort builtins.lessThan (pkgs.lib.lists.unique packages);
              in
              formatted-hm;
          };
        };
        packages = with pkgs; [
          ## System ##
          (_7zz.override { enableUnfree = true; })
          aspell
          aspellDicts.en
          killall
          libnotify
          kmon
          repgrep
          unrar
          unzip
          usbutils
          viu
          wget
          zip
        ];
      };
    };
    nixos.base-profile = { config, pkgs, ... }: {
      environment = {
        etc = {
          "packages".text =
            let
              formatted = builtins.concatStringsSep "\n" sortedUnique;
              packages = map (p: "${p.name}") config.environment.systemPackages;
              sortedUnique = builtins.sort builtins.lessThan (pkgs.lib.lists.unique packages);
            in
            formatted;
        };
        systemPackages = with pkgs; [
          lm_sensors
          pciutils
          xdg-user-dirs
        ];
      };
    };
  };
}
