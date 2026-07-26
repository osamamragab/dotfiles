{
    pkgs,
    lib,
    config,
    ...
}:
let
    outputs = lib.lists.map (e: e.output) (
        lib.lists.filter (
            e: e ? output && e.output != { }
        ) config.services.kanshi.settings
    );
    parsePos =
        output:
        let
            pos = lib.strings.splitString "," (output.position or "0,0");
        in
        {
            x = lib.strings.toInt (lib.lists.elemAt pos 0);
            y = lib.strings.toInt (lib.lists.elemAt pos 1);
        };
    parseDims =
        output:
        let
            dims = lib.strings.splitString "x" (output.mode or "0x0");
            scale = output.scale or 1.0;
            width = lib.strings.toInt (lib.lists.elemAt dims 0);
            height = lib.strings.toInt (lib.lists.elemAt dims 1);
        in
        {
            w = lib.floor (width / scale);
            h = lib.floor (height / scale);
        };
    relativePos =
        rel: criteria:
        let
            output = lib.lists.findFirst (e: e.criteria == criteria) { } outputs;
            dims = parseDims output;
            pos = parsePos output;
            x = pos.x + dims.w;
            y = pos.y + dims.h;
            newPos = lib.attrsets.getAttr rel {
                left = {
                    x = x;
                    y = pos.y;
                };
                right = {
                    x = -x;
                    y = pos.y;
                };
                top = {
                    x = pos.x;
                    y = y;
                };
                bottom = {
                    x = pos.x;
                    y = -y;
                };
            };
        in
        "${lib.toString newPos.x},${lib.toString newPos.y}";
in
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
                    position = relativePos "left" "eDP-1";
                    scale = 1.0;
                };
            }
            {
                output = {
                    criteria = "DP-2";
                    mode = "1680x1050";
                    position = relativePos "left" "HDMI-A-1";
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
