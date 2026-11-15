{ inputs, ... }:
{
  flake.modules.homeManager.profile-gaming =
    { lib, ... }:
    {
      # https://github.com/nix-community/home-manager/issues/3849#issuecomment-2115899992
      # Copy dotfiles recursively in home
      home.file =
        let
          dir = "${inputs.nonfree}";
        in
        lib.genAttrs' (lib.filesystem.listFilesRecursive dir) (
          p:
          lib.nameValuePair (builtins.unsafeDiscardStringContext (lib.removePrefix "${dir}/" p)) {
            source = p;
          }
        );
    };
  flake-file.inputs.nonfree = {
    flake = false;
    url = "github:keenanweaver/nix-nonfree";
  };
}
