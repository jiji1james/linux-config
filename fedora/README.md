# Setup a new WSL2 Instance with Fedora
https://scottspence.com/posts/wsl-web-developer-setup-with-fedora-39

## Download the rootfs file
A search for “fedora container base” will point to this URL: https://koji.fedoraproject.org/koji/packageinfo?packageID=26387. 
Look for something like Fedora-Container-Base-39-20240311.0, open the link and download the xz image archive for the correct arch.
Drill into the file using 7z and fianally download hte layer.tar file.
This file will be imported into WSL

## Copy the layer.tar file to a destination
```
mkdir D:\wsl
cp ~\Downloads\layer.tar D:\wsl\fedora-layer.tar
```

## Import the rootfs to create a distro
```
mkdir D:\wsl\fedora 
wsl --import Fedora D:\wsl\fedora D:\wsl\fedora-layer.tar
```

## Login to Fedora and install common packages
```
wsl -d Fedora
```
Install packages
```
dnf -y upgrade
dnf install -y wget curl sudo nano ncurses dnf-plugins-core dnf-utils passwd findutils procps htop iputils
dnf group install -y "Minimal Install"
```

## Add default user
```
# create user and add them to sudoers list
useradd -G wheel fedora
# set password for user
passwd fedora
```

## Set the Default Configuration in /etc/wsl.conf
```
[boot]
systemd=true

[user]
default=fedora
```

## Shutdown WSL and Log back in
```
wsl --shutdown
wsl -d Fedora
```

### Check if the default user is set
```
whoami
```

### Check if systemd is working
```
sudo systemctl list-unit-files --type=service
```

## Set Fedora as the default disto
Open a new Powershell window and execute the below command
```
wsl -s Fedora
```

## Install WSL Utilities
```
sudo dnf copr enable wslutilities/wslu -y
sudo dnf install wslu -y
```

