{
    pkgs,
    lib,
    config,
    ...
}:
let
    name = "Osama Ragab";
    mkEmailAccount =
        {
            address,
            flavor ? "plain",
            primary ? false,
        }:
        {
            inherit primary address flavor;
            realName = name;
            userName = address;
            maildir.path = address;
            passwordCommand = "${pkgs.pass}/bin/pass mail/${address} | sed 1q";
            gpg = {
                key = "4F5D73863FBDBED9";
                signByDefault = true;
            };
            signature = {
                command = ''printf "\n\n- ${name}\n"'';
                showSignature = "append";
            };
            imap = {
                host = if flavor == "gmail.com" then "imap.gmail.com" else lib.last (lib.splitString "@" address);
                port = 993;
                tls = {
                    enable = true;
                    useStartTls = false; # IMAPS, not STARTTLS
                };
            };
            mbsync = {
                enable = true;
                create = "both";
                expunge = "both";
                patterns = [ "*" ];
                extraConfig = {
                    account = {
                        AuthMechs = "LOGIN";
                    };
                    channel = {
                        CopyArrivalDate = "yes";
                        MaxMessages = 0;
                        ExpireUnread = "no";
                        SyncState = "*";
                    };
                    local = {
                        Subfolders = "Verbatim";
                    };
                };
            };
            aerc = {
                enable = true;
                extraAccounts = {
                    outgoing =
                        if flavor == "gmail.com" then
                            "smtps://${lib.replaceStrings [ "@" ] [ "%40" ] address}@smtp.gmail.com"
                        else
                            "smtps://${address}";
                    outgoing-cred-cmd = "${pkgs.pass}/bin/pass mail/${address} | sed 1q";
                    maildir-account-path = address;
                    folder-map = "${config.xdg.configHome}/aerc/${
                        if flavor == "gmail.com" then "folder-map-gmail.conf" else "folder-map.conf"
                    }";
                };
            };
        };
in
{
    accounts.email = {
        maildirBasePath = "${config.home.homeDirectory}/.local/share/mail";
        accounts = {
            main = mkEmailAccount {
                primary = true;
                address = "theosamaragab@gmail.com";
                flavor = "gmail.com";
            };
            alt = mkEmailAccount {
                address = "iosamaify@gmail.com";
                flavor = "gmail.com";
            };
            disroot = mkEmailAccount {
                address = "osamaragab@disroot.org";
                flavor = "plain";
            };
            uni = mkEmailAccount {
                address = "osamamuhammad@std.mans.edu.eg";
                flavor = "gmail.com";
            };
        };
    };
}
