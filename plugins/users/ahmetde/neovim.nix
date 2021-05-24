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
        my.neovide
        neovim-nightly
        neovim-remote
        nodePackages.npm
        nodejs
        pkgs.nur.repos.crazazy.efm-langserver
        ranger
        ripgrep
        tree-sitter
        xclip
        universal-ctags
      ] ++ (with pkgs; [ ]);

    xdg.configFile."nvim/init.lua".source = (system.dirs.dotfiles + "/${name}/neovim/init.lua");

  }) config.icebox.static.users.ahmetde;

}
