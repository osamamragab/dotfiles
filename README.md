# dotfiles

> NixOS system configurations.

## Hosts

| Host | OS    | Arch   |
| ---  | ---   | ---    |
| xlab | NixOS | x86_64 |


## Usage

```shell
git clone https://github.com/osamamragab/dotfiles.git
cd dotfiles
sudo nixos-rebuild switch --flake .#<host>
```
