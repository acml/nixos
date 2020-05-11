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
          emacs-libvterm
          pdf-tools
        ]));
    };

    # Home-manager settings.
    # User-layer packages
    home.packages = with pkgs;
      [
        ## Doom dependencies
        git
        (ripgrep.override {withPCRE2 = true;})
        gnutls              # for TLS connectivity

        ## Optional dependencies
        fd                  # faster projectile indexing
        imagemagick         # for image-dired
        (lib.mkIf (config.programs.gnupg.agent.enable)
          pinentry_emacs)   # in-emacs gnupg prompts
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
        # :lang javascript
        nodePackages.javascript-typescript-langserver
        # :lang latex & :lang org (latex previews)
        texlive.combined.scheme-tetex
        # :lang rust
        rustfmt
        rls
        # :ui treemacs
        python3 # advanced git-mode and directory flattening features require python3
      ];

    # Handwritten configs
    home.file = {
      # Handle multiple emacs installs
      ".emacs".source = (system.dirs.dotfiles + "/${name}/emacs/.emacs");
      ".emacs-profiles.el".source = (system.dirs.dotfiles + "/${name}/emacs/emacs-profiles.el");
    };

    xdg.configFile = {
      "doom" = { source = (system.dirs.dotfiles + "/${name}/emacs/doom"); recursive = true; };
      "spacemacs" = { source = (system.dirs.dotfiles + "/${name}/emacs/spacemacs"); recursive = true; };
    };

    home.sessionVariables = {
      SPACEMACSDIR="\${HOME}/.config/spacemacs";
      DOOMDIR="\${HOME}/.config/doom";
    };
  }) config.icebox.static.users.ahmetde;

  config.fonts.fonts = [
    pkgs.emacs-all-the-icons-fonts
  ];
}
