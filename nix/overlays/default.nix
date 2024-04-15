# import all nix files in the current folder, and execute them with args as parameters
# The return value is a list of all execution results, which is the list of overlays

args:
# execute and import all overlay files in the current directory with the given args
builtins.map
  (f: (import (./. + "/${f}") args))  # execute and import the overlay file
  (builtins.filter          # find all overlay files in the current directory
    (f: f != "default.nix")
    (builtins.attrNames (builtins.readDir ./.)))
