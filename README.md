# Keenan's Nix config

![Screenshot_20241115_105544](https://github.com/user-attachments/assets/c682e3e6-807b-437f-8b6e-c5bbdb23823c)

See [INSTALL.MD](INSTALL.md) for installation instructions.

This setup utilizes the following:
* BTRFS with tmpfs root and impermanence, encrypted by LUKS
* 'Modular' setup to keep things clean
* Flakes
* Mild hardening for security
* Performance tweaks
* KDE desktop environment with my preferred theming (Catppuccin) and options

If you fork this and try to use it without modifying anything, you will have a bad time. Here is a list of things you _probably_ want to change if you go this route:
* Username in [flake.nix](flake.nix)
* initialHashedPassword and authorizedKeys in [modules/components/users/default.nix](modules/components/users/default.nix)
* All secrets in [secrets](/secrets/secrets.yaml) (see [sops-nix](https://github.com/Mic92/sops-nix) for instructions)
* My specific stuff in all the modules. Have fun!

My suggestion is to just take the bits and pieces you like and morph them into your own config.

I'm always looking to simplify or make things better. Please let me know if you have suggestions.
