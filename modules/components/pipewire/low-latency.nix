{
  lib,
  config,
  username,
  pkgs,
  ...
}:
let
  cfg = config.low-latency;
in
{
  options = {
    low-latency = {
      enable = lib.mkEnableOption "Enable low-latency in NixOS & home-manager";
    };
  };
  config = lib.mkIf cfg.enable {
    # Enable the threadirqs kernel parameter to reduce pipewire/audio latency
    boot = lib.mkIf config.services.pipewire.enable {
      # - Inpired by: https://github.com/musnix/musnix/blob/master/modules/base.nix#L56
      kernelParams = [ "threadirqs" ];
    };

    # From https://github.com/wimpysworld/nix-config/blob/main/nixos/_mixins/desktop/features/pipewire/default.nix
    # Allow members of the "audio" group to set RT priorities
    security = {
      # Inspired by musnix: https://github.com/musnix/musnix/blob/master/modules/base.nix#L87
      pam.loginLimits = [
        {
          domain = "@audio";
          item = "memlock";
          type = "-";
          value = "unlimited";
        }
        {
          domain = "@audio";
          item = "rtprio";
          type = "-";
          value = "99";
        }
        {
          domain = "@audio";
          item = "nofile";
          type = "soft";
          value = "99999";
        }
        {
          domain = "@audio";
          item = "nofile";
          type = "hard";
          value = "99999";
        }
      ];
      rtkit.enable = true;
    };
    services = {
      pipewire = {
        wireplumber = {
          configPackages = [
            (pkgs.writeTextDir "share/wireplumber/main.lua.d/99-alsa-lowlatency.lua" ''
              alsa_monitor.rules = {
                {
                  matches = {{{ "node.name", "matches", "*_*put.*" }}};
                  apply_properties = {
                    ["audio.format"] = "S16LE",
                    ["audio.rate"] = 48000,
                    -- api.alsa.headroom: defaults to 0
                    ["api.alsa.headroom"] = 128,
                    -- api.alsa.period-num: defaults to 2
                    ["api.alsa.period-num"] = 2,
                    -- api.alsa.period-size: defaults to 1024, tweak by trial-and-error
                    ["api.alsa.period-size"] = 512,
                    -- api.alsa.disable-batch: USB audio interface typically use the batch mode
                    ["api.alsa.disable-batch"] = false,
                    ["resample.disable"] = false,
                    ["session.suspend-timeout-seconds"] = 0,
                  },
                },
              }
            '')
          ];
        };
        extraConfig = {
          pipewire = {
            "92-low-latency" = {
              "context.properties" = {
                "default.clock.quantum" = lib.mkForce 128;
                "default.clock.min-quantum" = lib.mkForce 128;
                "default.clock.max-quantum" = lib.mkForce 128;
              };
              "context.modules" = [
                {
                  name = "libpipewire-module-rt";
                  args = {
                    "nice.level" = -11;
                    "rt.prio" = 88;
                  };
                }
              ];
            };
          };
          pipewire-pulse = {
            "92-low-latency" = {
              "pulse.properties" = {
                "pulse.default.format" = "S16";
                "pulse.fix.format" = "S16LE";
                "pulse.fix.rate" = "48000";
                "pulse.min.frag" = "64/48000"; # 1.3ms
                "pulse.min.req" = "64/48000"; # 1.3ms
                "pulse.default.frag" = "64/48000"; # 1.3ms
                "pulse.default.req" = "64/48000"; # 1.3ms
                "pulse.max.req" = "64/48000"; # 1.3ms
                "pulse.min.quantum" = "64/48000"; # 1.3ms
                "pulse.max.quantum" = "64/48000"; # 1.3ms
              };
              "stream.properties" = {
                "node.latency" = "64/48000"; # 1.3ms
                "resample.quality" = 4;
                "resample.disable" = false;
              };
            };
          };
        };
      };
      # use `lspci -nn`
      udev.extraRules = ''
        # Remove AMD Audio devices; if present
        ACTION=="add", SUBSYSTEM=="pci", ATTR{vendor}=="0x1002", ATTR{class}=="0xab28", ATTR{power/control}="auto", ATTR{remove}="1"
        # Remove NVIDIA Audio devices; if present
        ACTION=="add", SUBSYSTEM=="pci", ATTR{vendor}=="0x10de", ATTR{class}=="0x040300", ATTR{power/control}="auto", ATTR{remove}="1"
        # Expose important timers the members of the audio group
        # Inspired by musnix: https://github.com/musnix/musnix/blob/master/modules/base.nix#L94
        KERNEL=="rtc0", GROUP="audio"
        KERNEL=="hpet", GROUP="audio"
        # Allow users in the audio group to change cpu dma latency
        DEVPATH=="/devices/virtual/misc/cpu_dma_latency", OWNER="root", GROUP="audio", MODE="0660"
      '';
    };
    users.users.${username}.extraGroups =
      lib.optional config.security.rtkit.enable "rtkit"
      ++ lib.optional config.services.pipewire.enable "audio";
    home-manager.users.${username} = { };
  };
}
