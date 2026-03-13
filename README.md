# nut-shells

NixOS flake templates for [nut](https://github.com/Francesco149/nut).

## usage

```sh
nix shell nixpkgs#git   # if you don't have git

mkdir my-config && cd my-config

# replace <template> with the template name. see below for a list
nix flake init -t github:Francesco149/nut-shells#<template>

git init
git add .

# generate hardware config for your current machine
nixos-generate-config --dir ./hosts/nixos/ --force

sudo nixos-rebuild boot --flake .#nixos
sudo reboot

# log in as headpats with password changeme and change your password.
# NOTE: some templates like the default one have no users,
# so you just log in as root with your root password
passwd
```

if there's a non-root user, the default username is always `headpats` with
`changeme` as the initial password. remember to run `passwd` to change it, then
remove `users.users.headpats.initialPassword = "changeme";` in
`hosts/nixos/nixos.nix` .

if for whatever reason the config doesn't boot, you can select the previous
generation in grub to roll back. NixOS perks!

refer to the [nut docs](https://github.com/Francesco149/nut) for next steps.

---

## templates

| name                    | description                                       |
| ----------------------- | ------------------------------------------------- |
| [`default`](#default)   | blank flake using nut                             |
| [`hyprland`](#hyprland) | tiling desktop with frosted catpuccino aesthetics |

### `default`

blank flake using nut

---

### `hyprland`

tiling desktop with frosted catpuccino aesthetics

<video src="templates/hyprland/pics/demo.gif" controls></video>

---

## maintaining this repo

after adding, removing, or renaming a template, regenerate the nix attrset and
this README:

```sh
nix run nixpkgs#python3 -- ./gen-templates.py
```

then open `README.md` in vscode and save to auto-format.
