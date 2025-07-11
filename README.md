### void-setup
Void Linux installation scripts

Requirements:
* [Void Linux ISO](https://voidlinux.org)
* bash (included on ISO)
* [wget](https://voidlinux.org/packages/?arch=86_64&q=wget)

**Please note these scripts only work for x86_64 and aarch64.**

Download a Void Linux ISO, and write it to a flash drive with a tool such
as [Rufus](https://rufus.ie) or [RPI Imager](https://github.com/raspberrypi/rpi-imager)
OR use the ISO in a VM and boot into the live environment:

> `Username: root ; Password: voidlinux`

When in the shell enter:
> `bash`

Update `xbps` package manager for live environment and install `wget`:
> `xbps-install -Syu xbps wget`

Download the `void-setup` script via `wget`:
> `wget https://playbooks.stpettersen.xyz/void-setup`

*Check the scripts if you wish for safety.*

Start Void Linux installation:
> `bash void-setup`

Please refer to original blog post for the available options
for void-setup:
https://stpettersen.xyz/blog/2024/03/27/void-linux-installation-scripts.html

Follow prompts to install Void Linux.
