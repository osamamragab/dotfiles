{
    pkgs,
    config,
    ...
}:
{
    services.kanshi = {
        enable = true;
        package = pkgs.kanshi;
        systemdTarget = config.wayland.systemd.target;
        settings = [
            {
                output = {
                    criteria = "eDP-1";
                    mode = "1920x1080";
                    position = "0,0";
                    scale = 1.25;
                };
            }
            {
                output = {
                    criteria = "HDMI-A-1";
                    mode = "1920x1200";
                    position = "1536,0";
                    scale = 1.0;
                };
            }
            {
                output = {
                    criteria = "DP-2";
                    mode = "1680x1050";
                    position = "3456,0";
                    scale = 1.0;
                };
            }
            {
                profile = {
                    name = "laptop";
                    outputs = [
                        {
                            criteria = "eDP-1";
                            status = "enable";
                        }
                    ];
                };
            }
            {
                profile = {
                    name = "monitor";
                    outputs = [
                        {
                            criteria = "eDP-1";
                            status = "enable";
                        }
                        {
                            criteria = "HDMI-A-1";
                            status = "enable";
                        }
                    ];
                };
            }
            {
                profile = {
                    name = "monitor-only";
                    outputs = [
                        {
                            criteria = "eDP-1";
                            status = "disable";
                        }
                        {
                            criteria = "HDMI-A-1";
                            status = "enable";
                        }
                    ];
                };
            }
            {
                profile = {
                    name = "dock";
                    outputs = [
                        {
                            criteria = "eDP-1";
                            status = "enable";
                        }
                        {
                            criteria = "HDMI-A-1";
                            status = "enable";
                        }
                        {
                            criteria = "DP-2";
                            status = "enable";
                        }
                    ];
                };
            }
            {
                profile = {
                    name = "dock-only";
                    outputs = [
                        {
                            criteria = "eDP-1";
                            status = "disable";
                        }
                        {
                            criteria = "HDMI-A-1";
                            status = "enable";
                        }
                        {
                            criteria = "DP-2";
                            status = "enable";
                        }
                    ];
                };
            }
        ];
    };
}
