let
  interface = "mullvad";
  stateDirectory = "/var/lib/mullvad-tunnel";
in
{
  flake = {
    # A Mullvad WireGuard tunnel that carries only traffic sent from its own address, for jobs that
    # should not hit a site from the home IP. Everything else keeps using the LAN as before.
    lib.mullvadTunnel = {
      inherit interface;
      # Sets $vpn_address for binding a client to the tunnel (wget --bind-address, curl --interface),
      # or exits when the tunnel is down so nothing falls back to the home IP.
      requireAddress = ''
        if [ ! -e /sys/class/net/${interface} ] || [ ! -s ${stateDirectory}/address ]; then
          echo "the Mullvad tunnel is not up (systemctl status mullvad-tunnel)" >&2
          exit 1
        fi
        vpn_address=$(cut -d/ -f1 ${stateDirectory}/address)
      '';
    };
    modules.nixos.mullvad-tunnel =
      {
        lib,
        config,
        pkgs,
        ...
      }:
      let
        routingTable = "51820";
        tunnel = pkgs.writeShellApplication {
          name = "mullvad-tunnel";
          runtimeInputs = with pkgs; [
            coreutils
            curl
            iproute2
            jq
            wireguard-tools
          ];
          text = ''
            state=${stateDirectory}

            down() {
              while ip -4 rule del pref 100 2>/dev/null; do :; done
              while ip -4 rule del pref 101 2>/dev/null; do :; done
              ip link del ${interface} 2>/dev/null || true
            }

            if [ "''${1:-}" = down ]; then
              down
              exit 0
            fi

            # Registers this machine's key with the account once. The key and address persist, since
            # every registration takes one of the account's five device slots.
            # Problems a restart cannot fix exit 2, which does not restart the service.
            if [ ! -s "$state/private.key" ] || [ ! -s "$state/address" ]; then
              if ! account=$(tr -d '[:space:]' <${config.sops.secrets."mullvad/account".path} 2>/dev/null) ||
                [[ ! $account =~ ^[0-9]{16}$ ]]; then
                echo "mullvad/account is missing from the secrets or is not a 16-digit account number" >&2
                exit 2
              fi
              key=$(wg genkey)
              # The account goes in on stdin so it never shows up in the process list. No curl
              # retries: a throttled reply asks for an hour, and systemd's growing delay handles that.
              response=$(printf '%s' "$account" | curl -sS -w '\n%{http_code}' https://api.mullvad.net/wg \
                --data-urlencode account@- --data-urlencode pubkey="$(wg pubkey <<<"$key")")
              status=''${response##*$'\n'}
              response=''${response%$'\n'*}
              case "$status" in
                2??) ;;
                429 | 5??)
                  echo "Mullvad is unavailable or throttling registrations (HTTP $status): $response" >&2
                  exit 1
                  ;;
                *)
                  echo "Mullvad refused the registration (HTTP $status): $response" >&2
                  exit 2
                  ;;
              esac
              address=''${response%%,*}
              if [[ ! $address =~ ^10\.[0-9]+\.[0-9]+\.[0-9]+/32$ ]]; then
                echo "unexpected response from Mullvad: $response" >&2
                exit 2
              fi
              (umask 077 && printf '%s\n' "$key" >"$state/private.key")
              printf '%s\n' "$address" >"$state/address"
            fi
            address=$(cat "$state/address")

            if curl -fsS --retry 3 -o "$state/relays.json.new" https://api.mullvad.net/public/relays/wireguard/v2; then
              mv "$state/relays.json.new" "$state/relays.json"
            elif [ ! -s "$state/relays.json" ]; then
              echo "could not fetch the Mullvad relay list" >&2
              exit 1
            fi
            read -r relay endpoint public_key < <(
              jq -r --arg location ${lib.escapeShellArg config.my.mullvadTunnel.location} '
                [.wireguard.relays[] | select(.active and (.location | startswith($location)))]
                | .[now | floor % length]
                | "\(.hostname) \(.ipv4_addr_in) \(.public_key)"
              ' "$state/relays.json"
            )

            down
            ip link add ${interface} type wireguard
            wg set ${interface} private-key "$state/private.key" \
              peer "$public_key" endpoint "$endpoint:51820" allowed-ips 0.0.0.0/0 persistent-keepalive 25
            ip -4 addr add "$address" dev ${interface}
            ip link set ${interface} up
            ip -4 route replace default dev ${interface} table ${routingTable}
            ip -4 rule add from "''${address%/*}" lookup ${routingTable} pref 100
            # If the tunnel's route ever goes missing, traffic from its address fails instead of
            # leaving through the LAN.
            ip -4 rule add from "''${address%/*}" unreachable pref 101
            echo "connected to $relay as $address"
          '';
        };
      in
      {
        config = {
          networking.networkmanager.unmanaged = [ "interface-name:${interface}" ];
          preservation.preserveAt."/persist".directories = [ stateDirectory ];
          sops.secrets."mullvad/account" = { };
          systemd.services.mullvad-tunnel = {
            description = "Mullvad WireGuard tunnel for traffic bound to its address";
            wantedBy = [ "multi-user.target" ];
            after = [ "network-online.target" ];
            wants = [ "network-online.target" ];
            serviceConfig = {
              ExecStart = lib.getExe tunnel;
              ExecStop = "${lib.getExe tunnel} down";
              RemainAfterExit = true;
              Restart = "on-failure";
              RestartMaxDelaySec = "1h";
              RestartPreventExitStatus = 2;
              RestartSec = "1min";
              RestartSteps = 6;
              StateDirectory = "mullvad-tunnel";
              StateDirectoryMode = "0755";
              Type = "oneshot";
            };
          };
        };
        options.my.mullvadTunnel.location = lib.mkOption {
          default = "us-chi";
          description = "Mullvad relay location prefix (country or country-city code) to pick a relay from.";
          type = lib.types.str;
        };
      };
  };
}
