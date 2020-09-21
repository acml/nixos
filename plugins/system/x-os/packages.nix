{ config, lib, pkgs, ... }:

with lib;

let cfg = config.icebox.static.system.x-os;
in mkIf cfg.enable {
  nixpkgs.config.allowUnfree = true;
  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    wget
    nixfmt
    git
    gnupg
    neofetch
    bind
    usbutils
    pciutils
    shfmt
    shellcheck
    smartmontools
    efibootmgr
    ncdu
    gnome3.adwaita-icon-theme
    hicolor-icon-theme #fixes missing redshift tray icon
  ];

  # Fonts
  nixpkgs.overlays = [ (import (builtins.fetchTarball https://github.com/lightdiscord/nix-nerd-fonts-overlay/archive/master.tar.gz)) ];
  fonts = {
    enableFontDir = true;
    enableGhostscriptFonts = true;
    fonts = with pkgs; [
      # dejavu_fonts
      # fira
      # fira-code
      # fira-code-symbols
      # nerdfonts
      # noto-fonts
      # noto-fonts-emoji
      # ubuntu_font_family
      font-awesome-ttf
      nerd-fonts.dejavusansmono
      nerd-fonts.firacode
      nerd-fonts.firamono
      nerd-fonts.inconsolata
      nerd-fonts.iosevka
      nerd-fonts.noto
      nerd-fonts.ubuntu
      siji
      symbola
    ];
    fontconfig = {
      enable = true;
      defaultFonts = {
        sansSerif = ["Ubuntu"];
        monospace = ["Fira Code"];
      };
    };
  };

  # Setup zsh
  programs.zsh.enable = true;

  # lets users use sudo without password
  security.sudo.wheelNeedsPassword = false;
}
