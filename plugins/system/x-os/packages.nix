{ config, lib, pkgs, ... }:

with lib;

let cfg = config.icebox.static.system.x-os;
in mkIf cfg.enable {
  nixpkgs.config.allowUnfree = true;
  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    wineWowPackages.stable
    wget
    nixfmt
    gitAndTools.gitFull
    gitAndTools.qgit
    git-cola
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
    hicolor-icon-theme # fixes missing redshift tray icon
  ];

  # Fonts
  fonts = {
    enableFontDir = true;
    enableGhostscriptFonts = true;
    fonts = with pkgs; [
      font-awesome-ttf
      (nerdfonts.override {
        fonts = [
          "DejaVuSansMono"
          "DroidSansMono"
          "FiraCode"
          "FiraMono"
          "Hermit"
          "IBMPlexMono"
          "Inconsolata"
          "Iosevka"
          "Noto"
          "Overpass"
          "RobotoMono"
          "Ubuntu"
        ];
      })
      siji
      symbola
    ];
    fontconfig = {
      enable = true;
      defaultFonts = {
        sansSerif = [ "Ubuntu" ];
        monospace = [ "Fira Code" ];
      };
    };
  };

  # Setup zsh
  programs.zsh = {
    enable = true;

    # Prevent NixOS from clobbering prompts
    # See: https://github.com/NixOS/nixpkgs/pull/38535
    promptInit = lib.mkDefault "";
  };

  # lets users use sudo without password
  security.sudo.wheelNeedsPassword = false;
}
