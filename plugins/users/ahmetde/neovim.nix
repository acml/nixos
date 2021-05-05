{ config, pkgs, lib, ... }:

let
    inherit (config.icebox.static.lib.configs) devices system;
    iceLib = config.icebox.static.lib;

in {
    config.home-manager.users = iceLib.functions.mkUserConfigs' (name: cfg: {

        home.packages = with pkgs.nixos-unstable; [
            fzf
            neovim-remote
            nodePackages.npm
            nodejs
            pkgs.nur.repos.crazazy.efm-langserver
            ranger
            ripgrep
            xclip
        ] ++ (with pkgs; [
        ]);

        programs.neovim = {
            enable = true;
            package = pkgs.neovim-nightly;
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
