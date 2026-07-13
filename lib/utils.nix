{ lib, ... }:
let
    importDir =
        dir:
        lib.filter (path: lib.hasSuffix ".nix" (builtins.toString path)) (
            lib.filesystem.listFilesRecursive dir
        );
    importDirs =
        dirs: builtins.concatMap (dir: importDir dir) (builtins.filter (dir: dir != null) dirs);
in
{
    inherit
        importDir
        importDirs
        ;
}
