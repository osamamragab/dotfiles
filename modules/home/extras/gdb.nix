{ pkgs, ... }:
{
    home.packages = [ pkgs.gdb ];
    xdg.configFile."gdb/gdbinit".text = ''
        set breakpoint pending on
        set disassembly-flavor intel
    '';
}
