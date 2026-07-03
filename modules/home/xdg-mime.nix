{
  lib,
  ...
}:

let
  plainTextEditor = [
    "org.gnome.TextEditor.desktop"
  ]
  ++ codeEditor;

  codeEditor = [
    "code.desktop"
  ];

  webBrowser = [
    "google-chrome.desktop"
    "google-chrome-stable.desktop"
  ];

  pdfReader = [
    "google-chrome.desktop"
    "google-chrome-stable.desktop"
  ];

  mediaPlayer = [
    "vlc.desktop"
  ];

  fileManager = [
    "nautilus.desktop"
  ];

  archiveOpener = [
    "file-roller.desktop"
  ];

  terminalEmulator = [
    "alacritty.desktop"
  ];

  imageViewer = [
    "org.gnome.eog.desktop"
  ]
  ++ webBrowser;
in
{
  xdg = {
    mimeApps = rec {
      enable = true;
      associations.added =
        (lib.genAttrs [
          "text/plain"
          "text/markdown"
          "application/x-cue"
        ] (_: plainTextEditor))

        //

          (lib.genAttrs [
            "application/x-shellscript"
            "text/x-nix"
            "application/x-nix"
            "text/rust"
            "text/x-go"
            "application/x-go"
            "text/javascript"
            "text/x-typescript"
            "text/x-ruby"
            "application/x-ruby"
            "text/json"
            "application/json"
            "text/x-yaml"
            "text/x-toml"
            "text/x-perl"
            "text/x-python"
            "text/x-c"
            "text/x-c++"
            "text/x-makefile"
            "application/xml"
          ] (_: codeEditor))

        //

          (lib.genAttrs [
            "text/html"
            "x-scheme-handler/http"
            "x-scheme-handler/https"
            "x-scheme-handler/about"
            "x-scheme-handler/unknown"
          ] (_: webBrowser))

        // (lib.genAttrs [
          "text/html"
          "x-scheme-handler/http"
          "x-scheme-handler/https"
          "x-scheme-handler/about"
          "x-scheme-handler/unknown"
        ] (_: webBrowser))

        // (lib.genAttrs [
          "application/pdf"
        ] (_: pdfReader))

        //

          (lib.genAttrs [
            "application/x-terminal-emulator"
            "x-scheme-handler/terminal"
          ] (_: terminalEmulator))

        //

          (lib.genAttrs [
            "inode/directory"
          ] (_: fileManager))

        //

          (lib.genAttrs [
            "video/mp4"
            "video/x-matroska"
            "audio/mpeg"
            "audio/ogg"
            "audio/flac"
            "audio/wav"
            "video/webm"
          ] (_: mediaPlayer))

        //

          (lib.genAttrs [
            "application/x-7z-compressed"
            "application/x-rar"
            "application/x-tar"
            "application/x-bzip"
            "application/x-bzip2"
            "application/x-gzip"
            "application/zip"
            "application/x-xz"
            "application/x-lzip"
            "application/x-lzma"
          ] (_: archiveOpener))

        //

          (lib.genAttrs [
            "image/jpeg"
            "image/png"
            "image/gif"
            "image/webp"
            "image/tiff"
            "image/bmp"
            "image/vnd.microsoft.icon"
            "image/svg+xml"
            "image/svg+xml-compressed"
          ] (_: imageViewer));
      defaultApplications = associations.added;
    };
  };
}
