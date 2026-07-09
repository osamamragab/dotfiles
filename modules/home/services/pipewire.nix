{ ... }:
{
    services.pipewire = {
        enable = true;
        configs = {
            "10-rates" = {
                "context.properties" = {
                    "default.clock.rate" = 48000;
                    "default.clock.allowed-rates" = [ 44100 48000 88200 96000 176400 192000 ];
                    "default.clock.quantum" = 1024;
                    "default.clock.min-quantum" = 32;
                    "default.clock.max-quantum" = 8192;
                };
            };
            "60-echo-cancel" = {
                "context.modules" = [
                    {
                        name = "libpipewire-module-echo-cancel";
                        args = {
                            "monitor.mode" = true;
                            "capture.props" = {
                                "node.name" = "echo-cancel-capture";
                                "node.passive" = true;
                                "node.force-quantum" = 512;
                            };
                            "source.props" = {
                                "node.name" = "echo-cancel-source";
                            };
                            "aec.args" = {
                                "webrtc.gain_control" = false;
                                "webrtc.extended_filter" = false;
                            };
                        };
                    }
                ];
            };
        };
        wireplumber = {
            enable = true;
            configs = {
                bluez = {
                    "monitor.bluez.properties" = {
                        "bluez5.enable-sbc-xq" = true;
                        "bluez5.enable-msbc" = true;
                        "bluez5.codecs" = [ "sbc" "sbc-xq" ];
                    };
                };
                disable-camera = {
                    "wireplumber.profiles" = {
                        main = {
                            "monitor.libcamera" = "disabled";
                        };
                    };
                };
                disable-suspension = {
                    "monitor.alsa.rules" = [
                        {
                            matches = [
                                {
                                    "node.name" = "~alsa_input.*";
                                }
                                {
                                    "node.name" = "~alsa_output.*";
                                }
                            ];
                            actions = {
                                update-props = {
                                    "session.suspend-timeout-seconds" = 0;
                                };
                            };
                        }
                    ];
                    "monitor.bluez.rules" = [
                        {
                            matches = [
                                {
                                    "node.name" = "~bluez_input.*";
                                }
                                {
                                    "node.name" = "~bluez_output.*";
                                }
                            ];
                            actions = {
                                update-props = {
                                    "session.suspend-timeout-seconds" = 0;
                                };
                            };
                        }
                    ];
                };
            };
        };
        pulseConfigs = {
            "10-source-volumes" = {
                "pulse.rules" = [
                    {
                        matches = [
                            {
                                application.name = "~Chromium.*";
                            }
                        ];
                        actions = {
                            quirks = [ "block-source-volume" ];
                        };
                    }
                    {
                        matches = [
                            {
                                "application.process.binary" = "Discord";
                            }
                        ];
                        actions = {
                            quirks = [ "block-source-volume" ];
                        };
                    }
                ];
            };
        };
    };
}
