{ pkgs, config, ... }:
{
	services.mpd = {
		enable = true;
		package = pkgs.mpd;
		enableSessionVariables = true;
		musicDirectory = config.xdg.userDirs.music;
		dataDir = "${config.xdg.dataHome}/mpd";
		playlistDirectory = "${config.xdg.dataHome}/mpd/playlists";
		dbFile = "${config.xdg.cacheHome}/mpd/mpd.db";
		network = {
			startWhenNeeded = true;
		};
		extraConfig = ''
			auto_update "yes"
			restore_paused "yes"
			audio_output {
				type "pipewire"
				name "PipeWire Sound Server"
			}
			audio_output {
				type "fifo"
				name "Visualizer feed"
				path "/tmp/mpd.fifo"
				format "48000:16:2"
			}
		'';
	};
}
