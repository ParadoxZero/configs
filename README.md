# Sidhin's configuration files

This repo contains all my configurations I use accross my devices for
different tools and utilities.

The python script configure.py contains the logic to create sym links to 
the appropriate places. 

It will autodetect platform and apply appropriate configuration for it.

## Usage - 
```nu
cd configs
python configure.py
```

## Dependencies

Nil, this is supposed to be a lightweight script. As such, it will only depend standard library and nothing more.

## Laptop lid behavior (Sway, Linux)

Closing the lid disables the built-in display (`eDP-1`) and, via
`configs/sway/lid-suspend`, suspends the machine — but only if no external
display is connected at that moment. Reconnecting/disconnecting a display
later while the lid stays closed does not re-trigger the check.

This requires `systemd-logind` to not suspend on lid close on its own, which
needs a one-time, root-owned system config that `configure.py` does not (and
will not) apply automatically. Run `python configure.py` (without
`--skip-deps`) and read the "Laptop lid suspend behavior" section it prints
(or see `core/linux.py`) for the exact commands.

## Enabling Fast Connection in BlueZ
1. Open the main Bluetooth configuration file in a text editor: `sudoedit /etc/bluetooth/main.conf`
2. Find the line `#FastConnectable = false` and change it to `FastConnectable = true`.
3. Ensure `AutoEnable=true` is also uncommented under the `[Policy]` section.
4. Save the file and restart the Bluetooth service: `sudo systemctl restart bluetooth`
