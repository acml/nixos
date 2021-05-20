{ config, pkgs, lib, ... }:

let
  inherit (config.icebox.static.lib.configs) devices system;
  iceLib = config.icebox.static.lib;

in {
  config.home-manager.users = iceLib.functions.mkUserConfigs' (name: cfg: {

    home.packages = with pkgs.nixos-unstable;
      [
        bat
        fzf
        lazygit
        lolcat
        neovim-remote
        nodePackages.npm
        nodejs
        pkgs.nur.repos.crazazy.efm-langserver
        ranger
        ripgrep
        tree-sitter
        xclip
      ] ++ (with pkgs; [ ]);

    programs.neovim = {
      enable = true;
      package = pkgs.nixos-unstable.neovim-nightly;
      viAlias = true;
      vimAlias = true;
      vimdiffAlias = true;

      # nvim plugin providers
      withNodeJs = true;
      withRuby = true;
      withPython = true;
      withPython3 = true;
    };

  }) config.icebox.static.users.ahmetde;

}
