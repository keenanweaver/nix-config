{
  flake.modules.nixos.profile-base =
    { lib, config, ... }:
    {
      nix = {
        channel.enable = false;
        settings = {
          builders-use-substitutes = true;
          connect-timeout = 5;
          download-buffer-size = 500 * 1024 * 1024;
          experimental-features = [
            "flakes"
            "nix-command"
            "pipe-operators"
          ];
          extra-substituters = [
            "https://cache.numtide.com"
            "https://cache.thalheim.io"
            "https://nix-community.cachix.org"
          ];
          extra-trusted-public-keys = [
            "cache.thalheim.io-1:R7msbosLEZKrxk/lKxf9BTjOOH7Ax3H0Qj0/6wiHOgc="
            "niks3.numtide.com-1:DTx8wZduET09hRmMtKdQDxNNthLQETkc/yaX7M4qK0g="
            "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
          ];
          fallback = true;
          keep-going = true;
          log-lines = lib.mkDefault 50;
          max-free = 1024 * 1024 * 1024;
          min-free = 100 * 1024 * 1024;
          trusted-users = [
            config.my.user
            "@wheel"
          ];
          warn-dirty = false;
        };
      };
    };
}
