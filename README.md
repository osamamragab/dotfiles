# dotfiles

> config files and scripts.

## Setup

> NOTE: The scripts may override your files; backup your files and read the
code before running it.

Clone the repo and run the `setup` script:
```sh
git clone https://gitlab.com/osamaragab/dotfiles.git
cd dotfiles
./setup
```

Use the `sysinit` script instead to install the packages and setup the dotfiles
for a fresh [Void Linux](https://voidlinux.org/) install:
```sh
./sysinit
```

## Post Install

### PAM config

#### dumb_runtime_dir

add the following to /etc/pam.d/system-login
```pamconf
...
-session   optional   pam_dumb_runtime_dir.so
```
[GitHub](https://github.com/ifreund/dumb_runtime_dir)

#### pam_ssh

add the following to /etc/pam.d/login
```pamconf
...
-auth        optional    pam_ssh.so    try_first_pass
...
-session     optional    pam_ssh.so
```
[Homepage](https://pam-ssh.sourceforge.net/)
[ArchWiki](https://wiki.archlinux.org/title/SSH_keys#pam_ssh)
