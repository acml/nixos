{ config, pkgs, lib, ... }:

let
  inherit (config.icebox.static.lib.configs) devices system;
  iceLib = config.icebox.static.lib;
in {
  config.home-manager.users = iceLib.functions.mkUserConfigs' (name: cfg: {

    programs.firefox = {
      enable = true;
      extensions = with pkgs.nur.repos.rycee.firefox-addons; [
        darkreader
        https-everywhere
        privacy-badger
        ublock-origin
      ];
      profiles.main = {
        id = 0;
        name = "home-manager";
        settings = {
          # Fix issues with having a dark GTK theme
          "ui.use_standins_for_native_colors"   = true;
          "widget.content.allow-gtk-dark-theme" = false;
          "widget.chrome.allow-gtk-dark-theme"  = false;
          "widget.content.gtk-theme-override"   = "Adwaita:light";
          # Disable WebRTC because it's scary
          "media.peerconnection.enabled" = false;

          "browser.search.defaultenginename" = "DuckDuckGo";
          "browser.search.selectedEngine" = "DuckDuckGo";
          "browser.urlbar.placeholderName" = "DuckDuckGo";
          "browser.search.region" = "US";

          # "font.name.monospace.x-western" = "Roboto Mono";
          # "font.name.sans-serif.x-western" = "Roboto";
          # "font.name.serif.x-western" = "Roboto Slab";
        };
      };
    };

  }) config.icebox.static.users.ahmetde;
}
