#!/usr/bin/env bash

files=(
    ".ideavimrc"
    ".vimrc"
    ".gitattributes"
    ".gitignore"
)

folders=(

)

echo "Removing existing config files"
for f in "${files[@]}"; do
  rm -f "$HOME/$f" || true
done

# Create the folders to avoid symlinking folders
for d in "${folders[@]}"; do
  rm -rf "${HOME:?}/$d" || true
  mkdir -p "$HOME/$d"
done

to_stow="$(find stow -maxdepth 1 -type d -mindepth 1 | awk -F "/" '{print $NF}' ORS=' ')"
IFS=' ' read -ra stow_array <<< "$to_stow"

for s in "${stow_array[@]}"; do
  echo "Stowing: $s"
  stow -d stow --verbose 1 --target "$HOME" "$s"
done