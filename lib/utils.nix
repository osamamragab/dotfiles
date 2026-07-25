{
    lib,
    ...
}:
let
    importDir =
        dir:
        lib.lists.filter (path: lib.strings.hasSuffix ".nix" (lib.toString path)) (
            lib.filesystem.listFilesRecursive dir
        );
    importDirs =
        dirs:
        lib.lists.concatMap (dir: importDir dir) (
            lib.lists.filter (dir: dir != null) dirs
        );
in
{
    inherit importDir importDirs;
}
