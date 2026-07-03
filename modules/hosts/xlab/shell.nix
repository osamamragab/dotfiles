{ ... }:
{
	programs.zsh = {
        enable = true;
        enableGlobalCompInit = false;
    };

	environment.pathsToLink = [ "/share/zsh" ];
}
