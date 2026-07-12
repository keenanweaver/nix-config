{
  flake-file = {
    inputs.import-tree.url = "github:vic/import-tree";

    outputs = ''
      inputs: inputs.flake-parts.lib.mkFlake { inherit inputs; } (inputs.import-tree ./modules)
    '';
  };
}
