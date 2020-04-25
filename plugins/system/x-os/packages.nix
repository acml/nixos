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

  # xdg.icons.enable = true;

  # Fonts
  fonts.fonts = with pkgs; [
    emacs-all-the-icons-fonts
    noto-fonts
    noto-fonts-cjk
    noto-fonts-emoji
    fira-code
    fira-code-symbols
  ];

  # Setup zsh
  programs.zsh.enable = true;
}