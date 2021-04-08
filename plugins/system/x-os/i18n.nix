{ config, pkgs, lib, ... }:

with lib;

let cfg = config.icebox.static.system.x-os;
in {
  options.icebox.static.system.x-os.ibus-engines = mkOption {
    type = types.listOf types.package;
    default = [ ];
    example = literalExample "with pkgs.ibus-engines; [ mozc hangul ]";
    description = "List of ibus engines to apply";
  };

  config = mkIf cfg.enable {
    # Set your time zone.
    time.timeZone = "Europe/Istanbul";

    # Select internationalisation properties.
    console = {
      font = "Lat2-Terminus16";
      useXkbConfig = true;
      # colors = [ "434759" "f07178" "c3e88d" "ffcb6b" "82aaff" "c792ea" "89ddff" "d0d0d0" "434758" "ff8b92" "ddffa7" "ffe585" "9cc4ff" "e1acff" "a3f7ff" "fefefe" ];
    };
    i18n = {
      defaultLocale = "en_US.UTF-8";
    };
  };
}
