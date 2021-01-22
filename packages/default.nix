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
      worker = (callPackage ./worker.nix {});
    };
  })

  # emacsGit
  # (import (fetchTarball "https://github.com/nix-community/emacs-overlay/archive/master.tar.gz"))
  (import (fetchTarball {
      url = "https://github.com/nix-community/emacs-overlay/archive/e3da699893c4be3b946d3586143b03450f9680ee.tar.gz";
      sha256 = "1mld0agq52xhbhwfffjqrrpk0niyj0hkxjgy7ban0w0khla9ah4n";
    }))
  (import (fetchTarball "https://github.com/mozilla/nixpkgs-mozilla/archive/master.tar.gz"))
  (import (fetchTarball "https://github.com/mjlbach/neovim-nightly-overlay/archive/master.tar.gz"))
]
