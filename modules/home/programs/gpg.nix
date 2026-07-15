{
    pkgs,
    config,
    ...
}:
{
    programs.gpg = {
        enable = true;
        package = pkgs.gnupg;
        homedir = "${config.xdg.dataHome}/gnupg";
        mutableKeys = true;
        mutableTrust = true;
        settings = {
            personal-cipher-preferences = "AES256 AES192 AES";
            personal-digest-preferences = "SHA512 SHA384 SHA256";
            personal-compress-preferences = "ZLIB BZIP2 ZIP Uncompressed";
            default-preference-list = "SHA512 SHA384 SHA256 AES256 AES192 AES ZLIB BZIP2 ZIP Uncompressed";
            cert-digest-algo = "SHA512";
            s2k-digest-algo = "SHA512";
            s2k-cipher-algo = "AES256";
            charset = "utf-8";
            keyid-format = "long";
            list-options = "show-uid-validity";
            verify-options = "show-uid-validity";
            armor = true;
            throw-keyids = true;
            with-fingerprint = true;
            require-cross-certification = true;
            no-symkey-cache = true;
            no-emit-version = true;
            no-comments = true;
            no-greeting = true;
        };
        dirmngrSettings = {
            keyserver = [
                "hkps://keys.openpgp.org"
                "hkps://keys.gnupg.net"
                "hkps://pgp.mit.edu"
                "hkps://keyring.debian.org"
                "hkps://keyserver.ubuntu.com"
            ];
        };
    };
}
