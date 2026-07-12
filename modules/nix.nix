{
  flake.modules.nixos.base-profile = { config, lib, ... }: {
    nix = {
      channel.enable = false;
      settings = {
        auto-optimise-store = true;
        builders-use-substitutes = true;
        connect-timeout = 5;
        download-buffer-size = 500 * 1024 * 1024;
        experimental-features = [
          "flakes"
          "nix-command"
        ];
        extra-substituters = [
          "https://nix-community.cachix.org"
        ];
        extra-trusted-public-keys = [
          "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        ];
        fallback = true;
        keep-going = true;
        log-lines = lib.mkDefault 50;
        max-free = 1024 * 1024 * 1024;
        min-free = 100 * 1024 * 1024;
        trusted-users = [
          "${config.my.user}"
          "@wheel"
        ];
        warn-dirty = false;
      };
    };
  };
}
