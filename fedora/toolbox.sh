#!/usr/bin/env bash

toolbox_verion='2.4.2.32922'
build_version=""
remove_existing=false

help_message() {
	echo 
	echo "Usage: $(basename $0) [-v $toolbox_version] [-r]"
	echo "options:"
	echo "h		Print the Help Message"
	echo "v		Toolbox Version"
	echo "r		Remove existing install"
	echo
}

while getopts ':v:rh' opt; do
	case "$opt" in 
		v)
			build_version="$OPTARG"
			echo "Using Toolbox Version = $build_version"
			;;
		r)
			remove_existing='true'
			echo "Remove exiting install of Toolbox from /opt"
			;;
		h)
			help_message
			exit 1
			;;
		:)
			echo "Option -$OPTARG requires and argument"
			help_message
			exit 1
			;;
		\?)
			echo "Invalid command option -$OPTARG"
			help_message
			exit 1
			;;
	esac
done
shift $(($OPTIND -1))

if [[ "$remove_existing" == 'true' ]]; then
	echo ">>> Deleting existing install"
	sudo rm -f /opt/jetbrains/toolbox
	sudo rm -rf /opt/jetbrains/jetbrains-toolbox*
else
	sysctl_file='/etc/sysctl.conf'
    file_watches_string='fs.inotify.max_user_watches=1048576'

    if ! grep -q -F "$file_watches_string" "$sysctl_file"; then
        echo "$file_watches_string" | sudo tee -a $sysctl_file
        sudo sysctl -p # reload the config

		# Install required software
		sudo dnf install -y gnome-software
    fi
fi

if [[ -n $build_version ]]; then
	echo ">>> Installing toolbox version $build_version in /opt"

	wget https://download.jetbrains.com/toolbox/jetbrains-toolbox-$build_version.tar.gz -P ~

	sudo mkdir -p /opt/jetbrains
	sudo mv ~/jetbrains-toolbox-$build_version.tar.gz /opt/jetbrains
	sudo tar -xvzf /opt/jetbrains/jetbrains-toolbox-$build_version.tar.gz -C /opt/jetbrains
	sudo ln -s /opt/jetbrains/jetbrains-toolbox-$build_version /opt/jetbrains/toolbox
	sudo rm /opt/jetbrains/jetbrains-toolbox-$build_version.tar.gz
fi

