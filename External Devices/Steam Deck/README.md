To support my Logitech 923 wheel setup (or others) we want to install the [udev rules from Oversteer](https://github.com/berarma/oversteer/tree/master/data/udev) and then whitelist them so SteamOS doesn't remove them during its atomic OS updates.
After that Oversteer (can be installed via flatpak) can edit and modify wheel configurations and other userspace software should be able to easily interact with the wheel setups

# Install
```bash
cp wheel-support.conf /etc/atomic-update.conf.d/wheel-support.conf 
cp udev/* /etc/udev/rules.d/
```
Note: You may require `sudo` in front of the `cp` command to copy the files.

A quick reboot and hopefully everything is functioning.

# udev
The files found in the`udev/` subfolder originate from [Oversteer](https://github.com/berarma/oversteer/tree/master/data/udev) which I may perodically pull updates from to the copies found in this repo. Those files may also be licensed differently to the rest of this repo, please keep that in mind.
