{ inputs, ... }:
{
  imports = [ inputs.flake-file.flakeModules.dendritic ];
  flake-file.inputs = {
    flake-file.url = "github:denful/flake-file";
    import-tree.url = "github:denful/import-tree";
  };
}
