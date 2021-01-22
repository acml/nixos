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

  config.environment.pathsToLink = [ "/share/zsh" ];

  config.home-manager.users = iceLib.functions.mkUserConfigs' (n: c: {
    # Home-manager settings.
    # User-layer packages
    home.packages = with pkgs;
      [
        # hunspell
        # hunspellDicts.en-us-large
      ] ++ c.extraPackages;

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
        # delta.enable = true;
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
        autocd = true;
        defaultKeymap = "emacs";
        dotDir = ".config/zsh";
        enable = true;
        enableAutosuggestions = true;
        enableCompletion = true;
        history = {
          ignoreDups = true;
          expireDuplicatesFirst = true;
        };
        initExtra = ''
          bindkey "^P" up-line-or-search
          bindkey "^N" down-line-or-search
        '';
        oh-my-zsh = {
          enable = true;
          plugins = [
            # "common-aliases"
            "dirhistory"
            "extract"
            "git"
            "gitignore"
            "pass"
            "ripgrep"
            "rsync"
            "safe-paste"
            "sudo"
            "systemadmin"
            "systemd"
          ];
          # theme = "agnoster";
        };
        plugins = [
          {
            name = "zsh-nix-shell";
            file = "nix-shell.plugin.zsh";
            src = pkgs.fetchFromGitHub {
              owner = "chisui";
              repo = "zsh-nix-shell";
              rev = "5dc081265cdd0d03631e9dc20b5e656530ae3af2";
              sha256 = "10y3jylx271j01i10vpqqz2ph4njbcyy34fnkn8ps39i9lfb7vhb";
            };
          }
          {
            name = "zsh-syntax-highlighting";
            src = pkgs.fetchFromGitHub {
              owner = "zsh-users";
              repo = "zsh-syntax-highlighting";
              rev = "62c5575848f1f0a96161243d18497c247c9f52df";
              sha256 = "0s1cjm8psjwmrg8qdhdg48qyvp8nqk7bdgvqivgc5v9m27m7h5cg";
            };
          }
          {
            name = "you-should-use";
            src = pkgs.fetchFromGitHub {
              owner = "MichaelAquilina";
              repo = "zsh-you-should-use";
              rev = "b4aec740f23d195116d1fddec91d67b5e9c2c5c7";
              sha256 = "0bq15d6jk750cdbbjfdmdijp644d1pn2z80pk1r1cld6qqjnsaaq";
            };
          }
          {
            name = "solarized-man";
            src = pkgs.fetchFromGitHub {
              owner = "zlsun";
              repo = "solarized-man";
              rev = "e69d2cedc3a51031e660f2c3459b08ab62ef9afa";
              sha256 = "1ljnqxfzhi26jfzm0nm2s9w43y545sj1gmlk6pyd9a8zc0hafdx8";
            };
          }
        ];
        shellAliases = {
          rm="rm -i";
          cp="cp -i";
          mv="mv -i";

          calc = "emacs -nw -Q -f full-calc";
          cat = "${pkgs.bat}/bin/bat";
          df = "df -h";
          # du = "${pkgs.du-dust}/bin/dust";
          du = "${pkgs.ncdu}/bin/ncdu --color dark";
          h = "${pkgs.tldr}/bin/tldr";

          # general use
          ls ="${pkgs.exa}/bin/exa";                                                         # ls
          l  ="${pkgs.exa}/bin/exa -lbF --git";                                              # list, size, type, git
          ll ="${pkgs.exa}/bin/exa -lbGF --git";                                             # long list
          llm="${pkgs.exa}/bin/exa -lbGd --git --sort=modified";                             # long list, modified date sort
          la ="${pkgs.exa}/bin/exa -lbhHigUmuSa --time-style=long-iso --git --color-scale";  # all list
          lx ="${pkgs.exa}/bin/exa -lbhHigUmuSa@ --time-style=long-iso --git --color-scale"; # all + extended list

          # specialty views
          lS="${pkgs.exa}/bin/exa -1";                                                      # one column, just names
          lt="${pkgs.exa}/bin/exa --tree --level=2";                                        # tree

          ns = "nix-shell";
          nsu = "nix-shell -I nixpkgs=channel:nixpkgs-unstable";
          ssh = "TERM=xterm-256color ssh";
          sw = "ssh sw";
          wipe = "${pkgs.srm}/bin/srm -vfr";

          update = "sudo nix-channel --update";
          rebuild = "sudo nixos-rebuild switch --upgrade";
        };
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
