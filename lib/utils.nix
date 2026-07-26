{
    lib,
    ...
}:
let
    importDir =
        dir:
        dir
        |> lib.filesystem.listFilesRecursive
        |> lib.lists.filter (path: lib.strings.hasSuffix ".nix" (lib.toString path));
    importDirs =
        dirs:
        dirs |> lib.lists.filter (dir: dir != null) |> lib.lists.concatMap importDir;
in
{
    inherit importDir importDirs;
}
