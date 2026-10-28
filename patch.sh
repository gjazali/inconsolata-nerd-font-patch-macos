#!/usr/bin/env bash

set -euo pipefail

inconsolata_version="${INCONSOLATA_VERSION:-v3.000}"
nerd_fonts_version="${NERD_FONTS_VERSION:-v3.5.1}"
font_directory="$HOME/Library/Fonts"
weights=(ExtraLight Light Regular Medium SemiBold Bold ExtraBold Black)

if ! command -v brew >/dev/null; then
  echo "Homebrew is not installed. See https://brew.sh" >&2
  exit 1
fi

if brew list --cask font-inconsolata-nerd-font >/dev/null 2>&1; then
  echo "font-inconsolata-nerd-font is installed." \
    "Run \`brew uninstall --cask font-inconsolata-nerd-font\`" >&2
  exit 1
fi

command -v fontforge >/dev/null || brew install fontforge

work_directory="$(mktemp -d)"
trap 'rm -rf "$work_directory"' EXIT
cd "$work_directory"

curl -fsSLO "https://github.com/googlefonts/Inconsolata/releases/download/\
$inconsolata_version/fonts_ttf.zip"
curl -fsSLO "https://github.com/ryanoasis/nerd-fonts/releases/download/\
$nerd_fonts_version/FontPatcher.zip"
unzip -q fonts_ttf.zip
unzip -q FontPatcher.zip -d patcher

mkdir out
for mono_flag in "" --mono; do
  printf '%s\n' "${weights[@]}" | xargs -P "${#weights[@]}" -I{} \
    fontforge -script patcher/font-patcher --complete \
    ${mono_flag:+"$mono_flag"} -q -out out fonts/ttf/Inconsolata-{}.ttf \
    >/dev/null 2>fontforge.log \
    || { cat fontforge.log >&2; exit 1; }
done

expected_count=$((${#weights[@]} * 2))
patched_count="$(find out -name 'InconsolataNerdFont*-*.ttf' | wc -l)"
if [ "$patched_count" -ne "$expected_count" ]; then
  echo "patched $patched_count fonts, want $expected_count" >&2
  exit 1
fi

mkdir -p "$font_directory"
cp out/*.ttf "$font_directory/"
echo "Installed $expected_count fonts into $font_directory"
