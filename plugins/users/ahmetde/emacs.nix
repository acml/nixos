{ config, pkgs, lib, ... }:

let
  inherit (config.icebox.static.lib.configs) devices system;
  iceLib = config.icebox.static.lib;
  myEmacs = (pkgs.emacsUnstable.override {
    inherit (pkgs) imagemagick;
    withXwidgets = true;
  }).overrideAttrs (old: rec {
    # Compile with imagemagick support so I can resize images.
    configureFlags = (old.configureFlags or [ ]) ++ [ "--with-imagemagick" ];
  });
in {
  config.home-manager.users = iceLib.functions.mkUserConfigs' (name: cfg: {

    programs.emacs = {
      enable = true;
      # package = myEmacs;
      package = pkgs.emacsPgtkGcc;
      # package = pkgs.emacsGcc;
      # package = pkgs.emacsGit;
      # package = pkgs.emacs;
      extraPackages = (epkgs:
        (with epkgs; [
          # exwm
          vterm
          pdf-tools
        ]) ++

        # MELPA packages:
        (with epkgs.melpaPackages; [ ]));
    };

    # Home-manager settings.
    # User-layer packages
    home.packages = with pkgs; [
      binutils
      gnumake
      ## Doom dependencies
      global
      (ripgrep.override { withPCRE2 = true; })
      (pkgs.callPackage ./emacs-sandbox.nix { })
      gnutls # for TLS connectivity

      ## Optional dependencies
      jq
      fd # faster projectile indexing
      imagemagick # for image-dired
      (lib.mkIf (config.programs.gnupg.agent.enable)
        pinentry_emacs) # in-emacs gnupg prompts
      unzip
      zstd # for undo-fu-session/undo-tree compression

      ## Module dependencies
      # :checkers spell
      (aspellWithDicts (dicts: with dicts; [ en en-computers en-science tr ]))
      # :checkers grammar
      languagetool
      # :tools editorconfig
      editorconfig-core-c # per-project style config
      # :tools lookup & :lang org +roam
      gnuplot
      sqlite
      # :lang cc
      ccls # ccls is better than clang-tools
      # clang-tools
      cmake-language-server
      glslang
      # :lang go
      gocode
      gomodifytags
      gotests
      gore
      # :lang docker
      nodePackages.dockerfile-language-server-nodejs
      # :lang javascript
      nodePackages.javascript-typescript-langserver
      # :lang sh
      bashdb
      shellcheck
      nodePackages.bash-language-server
      # :lang latex & :lang org (latex previews)
      texlive.combined.scheme-tetex
      # :lang markdown
      mdl
      pandoc
      proselint
      # :lang rust
      (pkgs.latest.rustChannels.stable.rust.override {
        extensions = [
          "clippy-preview"
          # "miri-preview"
          "rls-preview"
          "rustfmt-preview"
          "llvm-tools-preview"
          "rust-analysis"
          "rust-std"
          "rustc-dev"
          "rust-src"
        ];
      })
      # :ui treemacs
      python3 # advanced git-mode and directory flattening features require python3
      man-pages
      posix_man_pages
      (makeDesktopItem {
        name = "centaur";
        desktopName = "Centaur Emacs";
        icon = "emacs";
        exec = "emacs --with-profile centaur";
      })
      # (makeDesktopItem {
      #   name = "doom";
      #   desktopName = "Doom Emacs";
      #   icon = "emacs";
      #   exec = "emacs --with-profile doom";
      # })
      (makeDesktopItem {
        name = "purcell";
        desktopName = "Purcell Emacs";
        icon = "emacs";
        exec = "emacs --with-profile purcell";
      })
      (makeDesktopItem {
        name = "prelude";
        desktopName = "Prelude Emacs";
        icon = "emacs";
        exec = "emacs --with-profile prelude";
      })
      (makeDesktopItem {
        name = "scimax";
        desktopName = "Scimax Emacs";
        icon = "emacs";
        exec = "emacs --with-profile scimax";
      })
      (makeDesktopItem {
        name = "spacemacs";
        desktopName = "Spacemacs Emacs";
        icon = "emacs";
        exec = "emacs --with-profile spacemacs";
      })
      (makeDesktopItem {
        name = "radian";
        desktopName = "Radian Emacs";
        icon = "emacs";
        exec = "emacs --with-profile radian";
      })
      (makeDesktopItem {
        name = "nano";
        desktopName = "Nano Emacs";
        icon = "emacs";
        exec = "emacs --with-profile nano -dark";
      })
    ];

    # Handwritten configs
    home.file = {
      # Handle multiple emacs installs
      # Chemacs
      ".emacs.d/chemacs.el".source = fetchGit { url = "https://github.com/plexus/chemacs2"; } + "/chemacs.el";
      ".emacs.d/early-init.el".source = fetchGit { url = "https://github.com/plexus/chemacs2"; } + "/early-init.el";
      ".emacs.d/init.el".source = fetchGit { url = "https://github.com/plexus/chemacs2"; } + "/init.el";
    };

    xdg.configFile = {
      "chemacs/profiles.el".text = ''
        (("centaur" . ((user-emacs-directory . "~/.config/emacs.d/centaur")))
         ("doom" . ((user-emacs-directory . "~/.config/emacs.d/doom")
                    (env . (("DOOMDIR" . "~/.config/emacs.d/doom-user")))))
         ("radian" . ((user-emacs-directory . "~/.config/emacs.d/radian-user")
                      (straight-p . t)))
         ("nano" . ((user-emacs-directory . "~/.config/emacs.d/nano")))
         ("purcell" . ((user-emacs-directory . "~/.config/emacs.d/purcell")))
         ("prelude" . ((user-emacs-directory . "~/.config/emacs.d/prelude")))
         ("scimax" . ((user-emacs-directory . "~/.config/emacs.d/scimax")))
         ("spacemacs" . ((user-emacs-directory . "~/.config/emacs.d/spacemacs")
                         (env . (("SPACEMACSDIR" . "~/.config/emacs.d/spacemacs-user"))))))
      '';
      # Doom Emacs
      # "emacs.d/doom" = {
      #   source = builtins.fetchGit {
      #     url = "https://github.com/hlissner/doom-emacs";
      #     ref = "develop";
      #   };
      #   recursive = true;
      #   #onChange = ''
      #   #  env DOOMDIR=~/.config/doom ~/.config/emacs.d/doom/bin/doom sync
      #   #'';
      # };
      "emacs.d/doom-user" = {
        source = (system.dirs.dotfiles + "/${name}/emacs/doom");
        recursive = true;
        # onChange = "$HOME/.config/emacs.d/doom/bin/doom sync";
      };
      #
      # Nano Emacs
      #
      "emacs.d/nano/lisp" = {
        source = builtins.fetchGit {
          url = "https://github.com/rougier/nano-emacs";
          ref = "master";
        };
        recursive = true;
      };
      "emacs.d/nano/init.el".text = ''
      ;;; Nano Emacs
      (add-to-list 'load-path "~/.config/emacs.d/nano/lisp")
      (load-file "~/.config/emacs.d/nano/lisp/nano.el")
      '';
      #
      # Centaur Emacs
      #
      "emacs.d/centaur" = {
        source = builtins.fetchGit {
          url = "https://github.com/seagle0128/.emacs.d";
          ref = "master";
        };
        recursive = true;
      };
      "emacs.d/centaur/custom.el".source = system.dirs.dotfiles
        + "/${name}/emacs/centaur/custom.el";
      #
      # Purcell Emacs
      #
      "emacs.d/purcell" = {
        source = builtins.fetchGit {
          url = "https://github.com/purcell/emacs.d";
          ref = "master";
        };
        recursive = true;
      };
      "emacs.d/purcell/init-local.el".source = system.dirs.dotfiles
        + "/${name}/emacs/purcell/init-local.el";
      #
      # Prelude Emacs
      #
      "emacs.d/prelude" = {
        source = builtins.fetchGit {
          url = "https://github.com/bbatsov/prelude";
          ref = "master";
        };
        recursive = true;
      };
      "emacs.d/prelude/personal/preload/font.el".source = system.dirs.dotfiles + "/${name}/emacs/prelude/preload/font.el";
      # "emacs.d/prelude/personal/prelude-modules.el".source = system.dirs.dotfiles + "/${name}/emacs/prelude/prelude-modules.el";
      #
      # Scimax
      #
      "emacs.d/scimax" = {
        source = pkgs.fetchFromGitHub {
          owner = "jkitchin";
          repo = "scimax";
          rev = "bd215e0f9e61cb4179d39cf43edf5033a3d25563";
          sha256 = "01sbbz143s68ax2p8kbj6a8q6dqxlvqp4d24j2pxbmsh8qsr8mnq";
          fetchSubmodules = true;
        };
        recursive = true;
      };
      "emacs.d/scimax/user/user.el".source = system.dirs.dotfiles
        + "/${name}/emacs/scimax/user.el";
      "emacs.d/scimax/user/preload.el".source = system.dirs.dotfiles
        + "/${name}/emacs/scimax/user.el";
      #
      # Spacemacs
      #
      "emacs.d/spacemacs" = {
        source = builtins.fetchGit {
          url = "https://github.com/syl20bnr/spacemacs";
          ref = "develop";
        };
        recursive = true;
      };
      "emacs.d/spacemacs-user" = {
        source = (system.dirs.dotfiles + "/${name}/emacs/spacemacs");
        recursive = true;
      };
    };

    services.emacs.enable = true;
    services.emacs.client.enable = true;
    services.emacs.client.arguments = [  "-a \"\"" "-c" ];
    services.emacs.socketActivation.enable = false;

    # home.sessionPath = [ "~/.local/bin" "\${xdg.configHome}/emacs.d/doom/bin" ];
    home.sessionVariables = {
      DOOMDIR = "\${HOME}/.config/emacs.d/doom-user";
      MINICOM="-con";
      SPACEMACSDIR = "\${HOME}/.config/emacs.d/spacemacs-user";
    };
  }) config.icebox.static.users.ahmetde;

  config.fonts.fonts = [ pkgs.emacs-all-the-icons-fonts ];
}
