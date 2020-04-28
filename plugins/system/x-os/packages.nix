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
    zsh
  ];

  # xdg.icons.enable = true;

  # Fonts
  fonts = {
    enableFontDir = true;
    enableGhostscriptFonts = true;
    fonts = with pkgs; [
      dejavu_fonts
      fira-code
      fira-code-symbols
      font-awesome-ttf
      nerdfonts
      noto-fonts
      noto-fonts-cjk
      noto-fonts-emoji
      siji
      symbola
      ubuntu_font_family
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
  # programs.zsh.enable = true;
}
