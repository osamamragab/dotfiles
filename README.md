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
[Artix Linux](https://artixlinux.org/), run the `setup` script with `install`
subcommand instead:

```sh
./setup install
```

## Post Install

### pam_ssh

Add the following to /etc/pam.d/login

```pamconf
...
-auth        optional    pam_ssh.so    try_first_pass
...
-session     optional    pam_ssh.so
```

- [Homepage](https://pam-ssh.sourceforge.net/)
- [ArchWiki](https://wiki.archlinux.org/title/SSH_keys#pam_ssh)
