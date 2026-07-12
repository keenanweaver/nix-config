{
  flake.modules.homeManager.gaming-profile = {
    services.flatpak = {
      overrides.global.Environment = {
        FLATPAK_GL_DRIVERS = "mesa-git";
      };
      packages = [
        {
          appId = "org.freedesktop.Platform.GL.mesa-git/x86_64/25.08";
          origin = "flathub-beta";
        }
        {
          appId = "org.freedesktop.Platform.GL32.mesa-git/x86_64/25.08";
          origin = "flathub-beta";
        }
        {
          appId = "org.freedesktop.Platform.GL.mesa-git/x86_64/24.08";
          origin = "flathub-beta";
        }
        {
          appId = "org.freedesktop.Platform.GL32.mesa-git/x86_64/24.08";
          origin = "flathub-beta";
        }
      ];
    };
  };
  flake.modules.nixos.gaming-profile = {
    chaotic.mesa-git.enable = true;
  };
}
