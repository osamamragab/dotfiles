# dotfiles

> config files and scripts.

## Setup

> [!NOTE]
> By default the `setup` script will symlink the dotfiles to your home directory
and copy files from `etc` directory to your root `/etc` directory, this will
override your files. Backup your files and read the code before running it.

Clone the repo and run the `setup` script:

```sh
git clone https://github.com/osamamragab/dotfiles.git
cd dotfiles
./setup dotfiles
```

However, if you want to install the packages and setup everything for a fresh
[Void Linux](https://voidlinux.org/), run the `setup` script with `install`
subcommand instead:

```sh
./setup install
```
