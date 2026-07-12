{
  flake.modules.homeManager.desktop-profile =
    { lib, inputs, ... }:
    {
      # https://github.com/nix-community/home-manager/issues/3849#issuecomment-2115899992
      # Copy dotfiles recursively in home
      home.file =
        let
          listFilesRecursive =
            dir: acc:
            lib.flatten (
              lib.mapAttrsToList (
                k: v: if v == "regular" then "${acc}${k}" else listFilesRecursive dir "${acc}${k}/"
              ) (builtins.readDir "${dir}/${acc}")
            );

          toHomeFiles =
            dir:
            builtins.listToAttrs (
              map (x: {
                name = x;
                value = {
                  source = "${dir}/${x}";
                };
              }) (listFilesRecursive dir "")
            );
        in
        toHomeFiles "${inputs.nonfree}";
    };
  flake-file.inputs = {
    nonfree = {
      flake = false;
      url = "git+ssh://git@github.com/keenanweaver/nix-nonfree.git?shallow=1";
    };
  };
}
