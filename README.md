# dotfiles

> config files and scripts.

## Setup

> NOTE: The scripts may override your files; backup your files and read the
code before running it.

Clone the repo and run the `setup` script:
```sh
git clone https://github.com/osamamragab/dotfiles.git
cd dotfiles
./setup
```

Use the `sysinit` script instead to install the packages and setup the dotfiles
for a fresh [Artix Linux](https://artixlinux.org/) install:
```sh
./sysinit
```

## Post Install

### pam_ssh

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
