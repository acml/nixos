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
      ".emacs-profiles.el".source = (system.dirs.dotfiles + "/${name}/emacs/emacs-profiles.el");
    };

    xdg.configFile = {
      "doom" = { source = (system.dirs.dotfiles + "/${name}/emacs/doom"); recursive = true; };
      "spacemacs" = { source = (system.dirs.dotfiles + "/${name}/emacs/spacemacs"); recursive = true; };
    };

    home.sessionVariables = {
      SPACEMACSDIR = "\${HOME}/.config/spacemacs";
      DOOMDIR = "\${HOME}/.config/doom";
    };
  }) config.icebox.static.users.ahmetde;

  config.fonts.fonts = [
    pkgs.emacs-all-the-icons-fonts
  ];
}
