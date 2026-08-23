{
    flake.aspects.shell = {
        homeManager = { config, ... }: {
            home.file.${config.xdg.binHome} = {
                source = ./bin;
                recursive = true;
            };
        };
    };
}
