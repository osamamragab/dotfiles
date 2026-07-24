{
    inputs,
    pkgs,
    lib,
    config,
    custom,
    ...
}:
{
    imports = [
        ./hardware.nix
        ./file-system.nix
        ./boot.nix
        ./packages.nix
        inputs.mangowm.nixosModules.mango
        inputs.noctalia-greeter.nixosModules.default
    ];

    networking.hostName = custom.systemInfo.host;
    system.stateVersion = custom.systemInfo.stateVersion;

    home-manager = {
        useGlobalPkgs = true;
        useUserPackages = true;
        extraSpecialArgs = { inherit inputs custom; };
        users.${custom.systemInfo.user} = ./../../modules/home;
    };

    networking = {
        wireless = {
            enable = true;
            scanOnLowSignal = true;
        };
        firewall = {
            # TODO: enable Docker DNS.
            allowedTCPPorts = [
                22000 # Syncthing TCP sync
                53317 # LocalSend TCP transfer
            ];
            allowedUDPPorts = [
                22000 # Syncthing QUIC sync
                21027 # Syncthing discovery
                53317 # LocalSend UDP discovery
            ];
        };
    };

    services.logind = {
        enable = true;
        settings = {
            Login = {
                HandlePowerKey = "ignore";
                HandleLidSwitchDocked = "ignore";
            };
        };
    };

    services.udev = {
        enable = true;
        extraRules = ''
            # IO Scheduler
            # HDD
            ACTION=="add|change", KERNEL=="sd[a-z]*", ATTR{queue/rotational}=="1", ATTR{queue/scheduler}="bfq"
            # SSD
            ACTION=="add|change", KERNEL=="sd[a-z]*|mmcblk[0-9]*", ATTR{queue/rotational}=="0", ATTR{queue/scheduler}="bfq"
            # NVMe SSD
            ACTION=="add|change", KERNEL=="nvme[0-9]*", ENV{DEVTYPE}=="disk", ATTR{queue/scheduler}="none"
        '';
    };

    services.keyd.keyboards.redragon-k613 = lib.mkIf config.services.keyd.enable {
        ids = [ "258a:002a" ];
        settings = lib.recursiveUpdate config.services.keyd.keyboards.default.settings {
            main = {
                esc = "`";
            };
        };
    };

    services.printing = {
        enable = true;
        package = pkgs.cups;
    };

    security.polkit = {
        enable = true;
        package = pkgs.polkit;
    };

    services.power-profiles-daemon = {
        enable = true;
        package = pkgs.power-profiles-daemon;
    };

    services.upower = {
        enable = true;
        package = pkgs.upower;
        usePercentageForPolicy = true;
        allowRiskyCriticalPowerAction = false;
        percentageLow = 20;
        percentageCritical = 10;
        percentageAction = 5;
        timeLow = 1200;
        timeCritical = 300;
        timeAction = 120;
        criticalPowerAction = "HybridSleep";
    };

    programs.dconf.enable = true;
    documentation.dev.enable = true;

    services.gnome.gnome-keyring.enable = true;

    programs.nix-ld = {
        enable = true;
        package = pkgs.nix-ld;
    };

    programs.nix-index = {
        enable = true;
        package = pkgs.nix-index;
    };

    programs.appimage = {
        enable = true;
        binfmt = true;
        package = pkgs.appimage-run;
    };

    programs.zsh = {
        enable = true;
        enableGlobalCompInit = false;
    };

    users = {
        users.${custom.systemInfo.user} = {
            isNormalUser = true;
            shell =
                if config.programs.zsh.enable then
                    config.programs.zsh.package or pkgs.zsh
                else
                    config.programs.bash.package or pkgs.bashInteractive;
            extraGroups = [
                "wheel"
                "video"
                "audio"
                "dialout"
                "kvm"
            ]
            ++ lib.optional config.hardware.i2c.enable "i2c"
            ++ lib.optional config.services.printing.enable "lp"
            ++ lib.optional config.networking.networkmanager.enable "networkmanager";
        };
        groups.${custom.systemInfo.user} = { };
    };

    programs.gpu-screen-recorder.enable = true;

    programs.noctalia-greeter = {
        enable = true;
        greeter-args = "";
        settings = {
            session.default = "mango";
            keyboard.layout = "us";
            idle.timeout = 600;
            appearance.hide_logo = true;
            cursor = {
                package = pkgs.nordzy-cursor-theme;
                name = "Nordzy-cursors";
                size = 32;
            };
        };
    };

    programs.mango = {
        enable = true;
        addLoginEntry = true;
    };
}
