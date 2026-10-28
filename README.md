# Inconsolata Nerd Font for macOS

This project builds Inconsolata Nerd Font and Inconsolata Nerd Font Mono on
macOS and installs them. (Nerd Fonts is a project that adds icon glyphs to
programming fonts.)

The prebuilt Inconsolata Nerd Font from Homebrew has two problems: (1) it
contains only the `Regular` and `Bold` weights and (2) it does not contain every
Nerd Fonts icon set.

This build patches eight weights, from `ExtraLight` to `Black`, for the default
and the `Mono` variant. The `Mono` variant keeps each icon one cell wide (this
prevents icons from overlapping with the next character in the terminal).

## Requirements

- macOS
- Homebrew (to install it, follow the instructions on
  [Homebrew's official website](https://brew.sh))

If FontForge is not on your `PATH`, the script will install it using Homebrew.
(FontForge is the font editor that the Nerd Fonts patcher uses.)

## Installing with the script

1. If the Homebrew cask is installed, remove it:

   ```sh
   brew uninstall --cask font-inconsolata-nerd-font
   ```

2. Run the script:

   ```sh
   ./patch.sh
   ```

The script will install the fonts into `~/Library/Fonts`. The family names are
"Inconsolata Nerd Font" and "Inconsolata Nerd Font Mono".

To use other upstream releases, set `INCONSOLATA_VERSION` or
`NERD_FONTS_VERSION` through:

```sh
NERD_FONTS_VERSION=v3.5.1 ./patch.sh
```

## Installing by hand

1. Install FontForge:

   ```sh
   brew install fontforge
   ```

2. Download and extract the static Inconsolata fonts and the Nerd Fonts patcher:

   ```sh
   mkdir -p /tmp/inconsolata && cd /tmp/inconsolata
   github=https://github.com
   curl -fsSLO \
     $github/googlefonts/Inconsolata/releases/download/v3.000/fonts_ttf.zip
   curl -fsSLO \
     $github/ryanoasis/nerd-fonts/releases/download/v3.5.1/FontPatcher.zip
   unzip -q fonts_ttf.zip
   unzip -q FontPatcher.zip -d patcher
   ```

3. Patch each normal-width weight:

   ```sh
   mkdir out
   for weight in ExtraLight Light Regular Medium SemiBold Bold ExtraBold \
     Black; do
     fontforge -script patcher/font-patcher --complete -q -out out \
       "fonts/ttf/Inconsolata-$weight.ttf"
     fontforge -script patcher/font-patcher --complete --mono -q -out out \
       "fonts/ttf/Inconsolata-$weight.ttf"
   done
   ```

4. Copy the fonts into your font directory:

   ```sh
   cp out/*.ttf ~/Library/Fonts/
   ```

## Uninstall

```sh
rm ~/Library/Fonts/InconsolataNerdFont*-*.ttf
```
