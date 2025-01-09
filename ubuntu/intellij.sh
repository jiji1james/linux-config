#!/usr/bin/env bash

idea_version='2024.3.1.1'
use_ultimate='true'
use_community='true'


if [[ "$use_ultimate" == 'true' || "$use_community" == 'true' ]]; then
	mkdir -p ~/.jetbrains/software

	sysctl_file='/etc/sysctl.conf'
	file_watches_string='fs.inotify.max_user_watches=1048576'

	if ! grep -q -F "$file_watches_string" "$sysctl_file"; then
		echo "$file_watches_string" | sudo tee -a $sysctl_file
		sudo sysctl -p # reload the config
	fi

	# Install required software
	sudo apt install -y gnome-software
fi

# Find download link from https://www.jetbrains.com/idea/download/other.html
echo "Installing version: $idea_version"
if [[ "$use_ultimate" == 'true' ]]; then
	wget https://download.jetbrains.com/idea/ideaIU-$idea_version.tar.gz -P ~/.jetbrains
	tar -zxvf ~/.jetbrains/ideaIU-$idea_version.tar.gz -C ~/.jetbrains/software
	rm -f ~/.jetbrains/ideaIU-$idea_version.tar.gz 
	ln -s ~/.jetbrains/software/idea-IU* ~/.jetbrains/ideau
fi

if [[ "$use_community" == 'true' ]]; then
	wget https://download.jetbrains.com/idea/ideaIC-$idea_version.tar.gz -P ~/.jetbrains
	tar -zxvf ~/.jetbrains/ideaIC-$idea_version.tar.gz -C ~/.jetbrains/software
	rm -f ~/.jetbrains/ideaIC-$idea_version.tar.gz 
	ln -s ~/.jetbrains/software/idea-IC* ~/.jetbrains/ideac
fi