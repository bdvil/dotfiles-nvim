# Sway configuration

Install `stow`, then run:
```
stow -t ~/.config .
```

## DBus keyring issues
Update `/usr/share/xdg-desktop-portal/sway-portals.conf` with:

```
[preferred]
default=wlr;gtk
org.freedesktop.impl.portal.Secret=gnome-keyring;
```

Add sway in UseIn in `/usr/share/xdg-desktop-portal/portals/gnome-keyring.portal`.
Reboot the computer (not just the session).
