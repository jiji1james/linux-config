# Update Ubuntu
```shell
sudo apt update-y && sudo apt -y upgrade
```
# Instal Gnome & RDP
```shell
sudo apt install -y xrdp ubuntu-gnome-desktop
```
# Setup XRDP
```shell
sudo cp /etc/xrdp/xrdp.ini /etc/xrdp/xrdp.ini.bak
sudo sed -i 's/3389/3390/g' /etc/xrdp/xrdp.ini
sudo sed -i 's/max_bpp=32/#max_bpp=32\nmax_bpp=128/g' /etc/xrdp/xrdp.ini
sudo sed -i 's/xserverbpp=24/#xserverbpp=24\nxserverbpp=128/g' /etc/xrdp/xrdp.ini
```
# Configure
## Edit the startwm.sh file
```shell
sudo vim /etc/xrdp/startwm.sh
```
Comment out lines
```shell
test -x /etc/X11/Xsession && exec /etc/X11/Xsession
exec /bin/sh /etc/X11/Xsession
```
Add Gnome to the end of the file
```shell
gnome-session
```
## Enable xrdp Service
```shell
# Start xrdp service
sudo /etc/init.d/xrdp start
# Enable xrdp auto start
sudo /etc/init.d/xrdp status
```
# Shutdown WSL
In a powershell window
```shell
wsl --shutdown
```
