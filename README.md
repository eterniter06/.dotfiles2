# Dotfiles2

## Requirements
 * Arch linux
 * Git
 * Xmonad
 * Xmobar
 * Stow
 * Bash (>=4.0)
 * (To be updated)

## Usage

### Cloning the repository

**IMPORTANT:** This repository contains a submodule[^1]. To use this repo, clone the repo with[^2]:
```
git clone --recurse-submodules https://github.com/eterniter06/.dotfiles2.git
```

However, if you have already cloned the repository without the `--recurse-submodules` flag, you can run the following to initialize and fetch the submodule[^2]:
```
git submodule init
git submodule update
```

### Installation

The installation script comprises 6 functions:
1. Installing important packages from the official arch repo
2. Installing all packages from the previous install
3. Install rofi templates[^3]
4. Setting up pacman hooks
5. Enabling bluetooth and pipewire-pulse
6. Installing grub themes (selected is vimix)

You can comment out the functions you don't need and then run the script with:
```
./install.bash
```

### Stow
Inspect the stow script(and comment out packages not needed) and then run the script:
```
./stow.bash
```

## Wallpaper links
- [Dark Break](https://www.deviantart.com/kasjopaja87/art/Dark-Break-Multicolors-537281115)
- [Morning](https://wallspic.com/image/21185-biome-mountain-daytime-creative_arts-mount_scenery)
- [Lakeside Sunset by Louis Coyle](https://dribbble.com/shots/1828176-Lakeside-Sunset)
- [The Valley by Louis Coyle](https://dribbble.com/shots/12078823-The-Valley)
- I could not find the original source for the yosemite-forest wallpaper. Please let me know if anyone finds the original source

If I'm accidentally infringing on any copyrights pertaining to any of the resources I have used such as but not limited to wallpapers, themes and fonts, please send me a message and I will remove the resource immediately.

[^1]: [Rofi-bluetooth fork](https://github.com/eterniter06/rofi-bluetooth)
[^2]: [Cloning submodules](https://git-scm.com/book/en/v2/Git-Tools-Submodules#_cloning_submodules)
[^3]: [Rofi templates](https://github.com/adi1090x/rofi)
