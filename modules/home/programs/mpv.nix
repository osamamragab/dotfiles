{
    pkgs,
    lib,
    config,
    ...
}:
{
    programs.mpv = {
        enable = true;
        package = pkgs.mpv;
        config = {
            hwdec = "auto";
            profile = "gpu-hq";
            video-sync = "display-resample";
            gpu-context = "wayland";
            vo = "gpu";
            sub-font-size = 30;
        };
        bindings = {
            l = "seek 5 exact";
            h = "seek -5 exact";
            k = "seek 60 exact";
            j = "seek -60 exact";
            c = "cycle sub";
            "-" = "add volume -5";
            "=" = "add volume 5";
            "ctrl+r" = "cycle_values video-rotate 90 180 270 0";
        };
        scripts = [
            pkgs.mpvScripts.mpris
            pkgs.mpvScripts.reload
        ];
    };

    home.file."${config.xdg.binHome}/webcam" = lib.mkIf config.programs.mpv.enable {
        source = pkgs.writeShellScript "mpv-webcam" ''
            exec "${config.programs.mpv.package or pkgs.mpv}/bin/mpv" \
                --untimed \
                --profile=low-latency \
                --framedrop=no \
                --demuxer-lavf-o=video_size=640x480,input_format=mjpeg \
                --wayland-app-id=terminal-floating \
                av://v4l2:/dev/video0
        '';
    };
}
