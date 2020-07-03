{ config, pkgs, lib, ... }:

let
  inherit (config.icebox.static.lib.configs) devices system;
  iceLib = config.icebox.static.lib;
  cfg = config.icebox.static.users.ahmetde;

  pass = "${pkgs.pass}/bin/pass";
  head = "${pkgs.coreutils}/bin/head";
  grep = "${pkgs.gnugrep}/bin/grep";
  sed = "${pkgs.gnused}/bin/sed";
  getPassword = service: "${pass} show '${service}' | ${head} -n 1";
  getAppPassword = service: "${pass} show '${service}' | ${grep} \"App Password\" | ${sed} 's/.*: //'";

  maildir = "/home/ahmet/Mail";

  # Personal Info
  name = "Ahmet Cemal Özgezer";

in {
  config.home-manager.users = iceLib.functions.mkUserConfigs' (n: c: {

    accounts.email = {
      maildirBasePath = "Mail";
      accounts = {
        Andasis = {
          address = "ahmet.ozgezer@andasis.com";
          msmtp.enable = true;
          passwordCommand = getPassword "Andasis/ahmet.ozgezer@andasis.com";
          primary = true;
          realName = name;
          userName = "ahmet.ozgezer@andasis.com";
          imap = {
            host = "imap.secureserver.net";
            port = 993;
          };
          smtp = {
            host = "smtpout.secureserver.net";
            port = 465;
            tls.enable = true;
          };
          mbsync = {
            create = "both";
            enable = true;
            expunge = "both";
            remove = "none";
          };
        };
        "GMail" = {
          address = "ozgezer@gmail.com";
          flavor = "gmail.com";
          msmtp.enable = true;
          passwordCommand = getAppPassword "GMail";
          realName = name;
          mbsync = {
            create = "both";
            enable = true;
            expunge = "both";
            remove = "none";
            # Exclude everything under the internal [Gmail] folder, except the interesting folders
            patterns = [
              "*"
              "![Gmail]*"
              "[Gmail]/All Mail"
              "[Gmail]/Sent Mail"
              "[Gmail]/Starred"
            ];
          };
        };
        "MSN" = {
          address = "ozgezer@msn.com";
          msmtp.enable = true;
          passwordCommand = getPassword "MSN/ozgezer@msn.com";
          realName = name;
          userName = "ozgezer@msn.com";
          imap = {
            host = "imap-mail.outlook.com";
          };
          smtp = {
            host = "smtp-mail.outlook.com";
          };
          mbsync = {
            create = "both";
            enable = true;
            expunge = "both";
            remove = "none";
          };
        };
        "Yahoo" = {
          address = "ozgezer@yahoo.com";
          msmtp.enable = true;
          passwordCommand = getAppPassword "Yahoo Mail/ozgezer";
          realName = name;
          userName = "ozgezer@yahoo.com";
          imap = {
            host = "imap.mail.yahoo.com";
            port = 993;
          };
          smtp = {
            host = "smtp.mail.yahoo.com";
            port = 465;
          };
          mbsync = {
            create = "both";
            enable = true;
            expunge = "both";
            remove = "none";
          };
        };
      };
    };

    home.packages = with pkgs; [
      mu
    ];

    programs = {
      msmtp.enable = true;
      mbsync.enable = true;
    };

    services = {
      mbsync = {
        enable = true;
        # postExec = "${pkgs.mu}/bin/mu init -m ${maildir} --my-address ahmet.ozgezer@andasis.com --my-address ozgezer@gmail.com --my-address ozgezer@msn.com --my-address ozgezer@yahoo.com; ${pkgs.mu}/bin/mu index";
        postExec = "${pkgs.mu}/bin/mu index";
      };
    };

  }) cfg;
}
