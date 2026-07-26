{
    pkgs,
    lib,
    config,
    ...
}:
let
    name = "Osama Ragab";
    gpgKey = "4F5D73863FBDBED9";
    passBin = "${config.programs.password-store.package}/bin/pass";
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
            passwordCommand = "${passBin} mail/${address} | sed 1q";
            gpg = {
                key = gpgKey;
                signByDefault = true;
            };
            signature = {
                command = ''printf "\n\n- ${name}\n"'';
                showSignature = "append";
            };
            imap = {
                host =
                    if flavor == "gmail.com" then
                        "imap.gmail.com"
                    else
                        lib.lists.last (lib.strings.splitString "@" address);
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
                extraAccounts =
                    let
                        outgoing =
                            if flavor == "gmail.com" then
                                "smtps://${lib.strings.replaceString "@" "%40" address}@smtp.gmail.com"
                            else
                                "smtps://${address}";
                        folderMapFile =
                            if flavor == "gmail.com" then "folder-map-gmail.conf" else "folder-map.conf";
                        folderMap = "${config.xdg.configHome}/aerc/${folderMapFile}";
                    in
                    {
                        inherit outgoing;
                        outgoing-cred-cmd = "${passBin} mail/${address} | sed 1q";
                        maildir-account-path = address;
                        folder-map = folderMap;
                    };
            };
        };
in
{
    accounts.email = {
        maildirBasePath = "${config.xdg.dataHome}/mail";
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
