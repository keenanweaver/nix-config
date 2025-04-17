{
  username,
  ...
}:
{
  imports = [
    ./pi.nix
  ];

  networking = {
    hostName = "regretpi";
    interfaces.end0 = {
      ipv4.addresses = [
        {
          address = "10.20.20.31";
          prefixLength = 24;
        }
      ];
    };
    defaultGateway = {
      address = "10.20.1.1";
      interface = "end0";
    };
    nameservers = [ "10.20.1.1" ];
  };

  services = {
    home-assistant = {
      enable = true;
      config = {
        default_config = { };
      };
      extraComponents = [
        "openweathermap"
        # Components required to complete the onboarding
        "analytics"
        "google_translate"
        "met"
        "radio_browser"
        "shopping_list"
        # Recommended for fast zlib compression
        # https://www.home-assistant.io/integrations/isal
        "isal"
      ];
      openFirewall = true;
    };
  };

  home-manager.users.${username} = { pkgs, ... }: { };
}
