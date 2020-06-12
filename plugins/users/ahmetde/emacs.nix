{ config, pkgs, lib, ... }:

let
  inherit (config.icebox.static.lib.configs) devices system;
  iceLib = config.icebox.static.lib;
in {
  config.home-manager.users = iceLib.functions.mkUserConfigs' (name: cfg: {

    programs.emacs = {
      enable = true;
      # Compile with imagemagick support so I can resize images.
      package = pkgs.emacsUnstable.override { inherit (pkgs) imagemagick; };
      extraPackages = (epkgs:
        (with epkgs; [
          # exwm
          vterm
          pdf-tools
        ]));
    };

    # Home-manager settings.
    # User-layer packages
    home.packages = with pkgs;
      [
        ## Doom dependencies
        global
        (ripgrep.override {withPCRE2 = true;})
        gnutls              # for TLS connectivity

        ## Optional dependencies
        fd                  # faster projectile indexing
        imagemagick         # for image-dired
        (lib.mkIf (config.programs.gnupg.agent.enable)
          pinentry_emacs)   # in-emacs gnupg prompts
        unzip
        zstd                # for undo-fu-session/undo-tree compression

        ## Module dependencies
        # :checkers spell
        aspell
        aspellDicts.en
        aspellDicts.en-computers
        aspellDicts.en-science
        aspellDicts.tr
        # :checkers grammar
        languagetool
        # :tools editorconfig
        editorconfig-core-c # per-project style config
        # :tools lookup & :lang org +roam
        sqlite
        # :lang cc
        ccls
        glslang
        # :lang javascript
        nodePackages.javascript-typescript-langserver
        # :lang latex & :lang org (latex previews)
        texlive.combined.scheme-tetex
        # :lang markdown
        pandoc
        # :lang rust
        # (pkgs.latest.rustChannels.stable.rust.override {
        #   extensions = [
        #     "clippy-preview"
        #     # "miri-preview"
        #     "rls-preview"
        #     "rustfmt-preview"
        #     "llvm-tools-preview"
        #     "rust-analysis"
        #     "rust-std"
        #     "rustc-dev"
        #     "rust-src"
        #   ];
        # })
        # :ui treemacs
        python3 # advanced git-mode and directory flattening features require python3
      ];

    # Handwritten configs
    home.file = {
      # Handle multiple emacs installs
      ".emacs".source = pkgs.fetchFromGitHub {
       owner = "plexus";
       repo = "chemacs";
       rev = "233bb7fb4d176f81fe4e7dccbb7f1cba793010e6";
       sha256 = "0rljwgnns38g95zdlvch63zsicdvbyaq6xfq2f2mqag051yn9pwb";
      } + "/.emacs";
      ".emacs-profiles.el".text = ''
        (("default" . ((user-emacs-directory . "~/.emacs.d/doom")
                      (env . (("DOOMDIR" . "~/.config/doom")))))
         ("spacemacs" . ((user-emacs-directory . "~/.emacs.d/spacemacs")
                         (env . (("SPACEMACSDIR" . "~/.config/spacemacs"))))))
      '';
      # ".emacs.d/doom" = {
      #   source = builtins.fetchGit {
      #     url = "https://github.com/hlissner/doom-emacs";
      #     ref = "develop";
      #   };
      #   recursive = true;
      #   # onChange = ''
      #   #   ~/.emacs.d/doom/bin/doom sync
      #   # '';
      # };
      ".emacs.d/spacemacs" = {
        source = builtins.fetchGit {
          url = "https://github.com/syl20bnr/spacemacs";
          ref = "develop";
        };
        recursive = true;
      };
    };

    xdg.configFile = {
      "doom" = { source = (system.dirs.dotfiles + "/${name}/emacs/doom"); recursive = true; };
      "spacemacs" = { source = (system.dirs.dotfiles + "/${name}/emacs/spacemacs"); recursive = true; };
    };

        programs.zsh.initExtra = ''
                        # function to enable the shell to send information to vterm via properly escaped sequences
                        function vterm_printf(){
                            if [ -n "$TMUX" ]; then
                                # Tell tmux to pass the escape sequences through
                                # (Source: http://permalink.gmane.org/gmane.comp.terminal-emulators.tmux.user/1324)
                                printf "\ePtmux;\e\e]%s\007\e\\" "$1"
                            elif [ "''${TERM%%-*}" = "screen" ]; then
                                # GNU screen (screen, screen-256color, screen-256color-bce)
                                printf "\eP\e]%s\007\e\\" "$1"
                            else
                                printf "\e]%s\e\\" "$1"
                            fi
                        }
                        # clears the current buffer from the data that it is not currently visible
                        if [[ "$INSIDE_EMACS" = 'vterm' ]]; then
                            alias clear='vterm_printf "51;Evterm-clear-scrollback";tput clear'
                        fi
                        '';

    home.sessionVariables = {
      SPACEMACSDIR = "\${HOME}/.config/spacemacs";
      DOOMDIR = "\${HOME}/.config/doom";
    };
  }) config.icebox.static.users.ahmetde;

  config.fonts.fonts = [
    pkgs.emacs-all-the-icons-fonts
  ];
}
