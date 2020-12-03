[
  (self: super: with super; {
    my = {
      ant-dracula = (callPackage ./ant-dracula.nix {});
      cached-nix-shell =
        (callPackage
          (builtins.fetchTarball
            https://github.com/xzfc/cached-nix-shell/archive/master.tar.gz) {});
      linode-cli = (callPackage ./linode-cli.nix {});
      zunit = (callPackage ./zunit.nix {});
      sunflower = (callPackage ./sunflower.nix {});
    };
  })

  # emacsGit
  (import (fetchTarball "https://github.com/nix-community/emacs-overlay/archive/master.tar.gz"))
  (import (fetchTarball "https://github.com/mozilla/nixpkgs-mozilla/archive/master.tar.gz"))
]
