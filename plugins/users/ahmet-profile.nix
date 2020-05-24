{ pkgs, lib, config, ... }:

with lib;

let
  inherit (config.icebox.static.lib.configs) system;
  iceLib = config.icebox.static.lib;
  gnomeEnable = config.services.xserver.desktopManager.gnome3.enable;
  cfg = config.icebox.static.users.ahmet-profile;
in {
  options.icebox.static.users.ahmet-profile = with lib;
    mkOption {
      type = types.submodule {
        options = {
          enable = mkEnableOption
            "the user tweaks flavoured by ahmet"; # If this is off, nothing should be configured at all.

          configs = mkOption {
            type = with types;
              attrsOf (submodule {
                options = {
                  enable = mkEnableOption
                    "the user tweaks flavoured by ahmet for certain user.";
                  extraPackages = mkOption {
                    type = with types; listOf package;
                    description =
                      "Extra packages to install for user <literal>ahmet</literal>.";
                  };
                };
              });
            default = { };
          };
        };
      };
    };

  config.home-manager.users = iceLib.functions.mkUserConfigs' (n: c: {
    # Home-manager settings.
    # User-layer packages
    home.packages = with pkgs;
      [ hunspell hunspellDicts.en-us-large ] ++ c.extraPackages;

    # Package settings
    programs = {
      # GnuPG
      gpg = {
        enable = true;
        settings = { throw-keyids = false; };
      };

      # Git
      git = {
        enable = true;
        delta.enable = true;
        userName = "Ahmet Cemal Özgezer";
        userEmail = "ahmet.ozgezer@andasis.com";
        # signing = {
        #   signByDefault = true;
        #   key = "0xAE53B4C2E58EDD45";
        # };
        extraConfig = { credential = { helper = "store"; }; };
      };

      gnome-terminal = mkIf (gnomeEnable) {
        enable = true;
        profile.aba3fa9f-5aab-4ce9-9775-e2c46737d9b8 = {
          default = true;
          visibleName = "Ahmet";
          font = "Fira Code weight=450 10";
        };
      };

      # zsh
      zsh = {
        enable = true;
        enableCompletion = true;
        enableAutosuggestions = true;
        autocd = true;
        dotDir = ".config/zsh";
        initExtra = ''
          prompt off
          bindkey "^P" up-line-or-search
          bindkey "^N" down-line-or-search
        '';
        profileExtra =
          ''
          if [ -d "$HOME/.local/bin" ]; then
             export PATH="$PATH:$HOME/.local/bin"
          fi
          if [ -d "$HOME/.emacs.d/doom/bin" ]; then
             export PATH="$PATH:$HOME/.emacs.d/doom/bin"
          fi
        '';
        defaultKeymap = "emacs";
        oh-my-zsh = {
          enable = true;
          plugins = [
            ## appearence
            "common-aliases"

            "extract"

            ## programs
            "git"
            "pass"

            "gitignore"
            "sudo"
          ];
          # theme = "agnoster";
        };
        plugins = [
          {
            name = "zsh-syntax-highlighting";
            src = pkgs.fetchFromGitHub {
              owner = "zsh-users";
              repo = "zsh-syntax-highlighting";
              rev = "0.7.0-beta1";
              sha256 = "0xk9fwii31zrwvhd441p3c0cr7lqhf97fqif3nys4wkgnvhd5s4x";
            };
          }
        ];
      };
    };

    # Setting GNOME Dconf settings
    dconf.settings = mkIf (gnomeEnable) {
      # Touchpad settings
      "org/gnome/desktop/peripherals/touchpad" = {
        disable-while-typing = false;
        tap-to-click = true;
        two-finger-scrolling-enabled = true;
      };
      # Favorite apps
      "org/gnome/shell" = {
        favorite-apps = [
          "firefox.desktop"
          "telegram-desktop.desktop"
          "org.gnome.Nautilus.desktop"
          "org.gnome.Terminal.desktop"
          "emacs.desktop"
        ];
      };
    };

  }) cfg;
}
