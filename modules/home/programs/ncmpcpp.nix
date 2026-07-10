{
    lib,
    pkgs,
    config,
    ...
}:
{
    programs.ncmpcpp = {
        enable = true;
        package = pkgs.ncmpcpp;
        mpdMusicDir = lib.mkIf config.services.mpd.enable config.services.mpd.musicDirectory;
        settings = {
            ncmpcpp_directory = "${config.xdg.dataHome}/ncmpcpp";
            lyrics_directory = "${config.xdg.dataHome}/lyrics";
            external_editor = "nvim";
            use_console_editor = "yes";
            current_item_prefix = "$(cyan)$r$b";
            current_item_suffix = "$/r$(end)$/b";
            main_window_color = "white";
            empty_tag_color = "magenta";
            progressbar_look = "->";
            progressbar_elapsed_color = "blue:b";
            media_library_albums_split_by_date = "no";
            ignore_leading_the = "yes";
        };
        bindings = [
            {
                key = "j";
                command = "scroll_down";
            }
            {
                key = "k";
                command = "scroll_up";
            }
            {
                key = "J";
                command = "move_selected_items_down";
            }
            {
                key = "K";
                command = "move_selected_items_up";
            }
            {
                key = "h";
                command = "previous_column";
            }
            {
                key = "l";
                command = "next_column";
            }
            {
                key = "n";
                command = "next_found_item";
            }
            {
                key = "N";
                command = "previous_found_item";
            }
            {
                key = "G";
                command = "move_end";
            }
            {
                key = "g";
                command = "move_home";
            }
            {
                key = "t";
                command = "jump_to_position_in_song";
            }
            {
                key = "b";
                command = "jump_to_browser";
            }
            {
                key = ".";
                command = "seek_forward";
            }
            {
                key = ",";
                command = "seek_backward";
            }
            {
                key = "=";
                command = "volume_up";
            }
            {
                key = "+";
                command = "show_clock";
            }
            {
                key = "-";
                command = "volume_down";
            }
            {
                key = "_";
                command = "show_lyrics";
            }
            {
                key = "l";
                command = "enter_directory";
            }
            {
                key = "l";
                command = "run_action";
            }
            {
                key = "l";
                command = "play_item";
            }
            {
                key = "L";
                command = "show_lyrics";
            }
            {
                key = "H";
                command = "toggle_lyrics_fetcher";
            }
            {
                key = "U";
                command = "update_database";
            }
            {
                key = "P";
                command = "show_playlist";
            }
            {
                key = "s";
                command = "toggle_single";
            }
            {
                key = "f";
                command = "seek_forward";
            }
            {
                key = "d";
                command = "seek_backward";
            }
        ];
    };
}
