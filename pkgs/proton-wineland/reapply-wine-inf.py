            self.upgrade_pfx(old_ver)

            # wineboot re-applies wine.inf only when its mtime changes, which never happens in the Nix store
            applied_inf = self.prefix_dir + ".nix-wine-inf-sha256"
            try:
                with open(applied_inf, "r") as f:
                    applied = f.read().strip()
            except OSError:
                applied = None
            if applied != "@wineInfSha256@" and os.path.isdir(self.prefix_dir):
                if file_exists(self.prefix_dir + ".update-timestamp", follow_symlinks=False):
                    os.remove(self.prefix_dir + ".update-timestamp")
                with open(applied_inf, "w") as f:
                    f.write("@wineInfSha256@\n")
