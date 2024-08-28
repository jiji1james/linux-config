#!/usr/bin/env bash

# Figure out if this is fedora/ubuntu
source /etc/os-release
echo ">>>> Linux OS Release: $PRETTY_NAME"

# Set Flags
if [[ $PRETTY_NAME == *"Ubuntu"* ]]; then
	export IS_UBUNTU=true
	export IS_FEDORA=false
	export IS_SUSE=false
elif [[ $PRETTY_NAME == *"Fedora"* ]]; then
	export IS_FEDORA=true
	export IS_UBUNTU=false
	export IS_SUSE=false
elif 
	[[ $PRETTY_NAME == *"openSUSE"* ]]; then
	export IS_SUSE=true
	export IS_FEDORA=false
	export IS_UBUNTU=false
fi

# Update the apt package list.
if $IS_UBUNTU; then
	echo ">>> Install Ubuntu Packages"
	sudo apt update -y
	sudo apt install -y stow
elif $IS_FEDORA; then
	echo ">>> Install Fedora Packages"
	sudo dnf upgrade
	sudo dnf install -y stow
	sudo dnf install -y dnf-plugins-core
	sudo dnf copr enable -y kopfkrieg/diff-so-fancy
	sudo dnf install -y diff-so-fancy
elif $IS_SUSE; then
	echo ">>> Install openSUSE Packages"
	sudo zypper ref
	sudo zypper list-updates --all
	sudo zypper -n update
	sudo zypper -n install stow
fi

files=(
  ".ideavimrc"
  ".vimrc"
  ".gitattributes"
  ".gitignore"
  ".zshrc"
  ".bashrc"
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