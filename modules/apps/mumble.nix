{
  flake.modules.homeManager.profile-workstation =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [ master.mumble ];
    };
}
