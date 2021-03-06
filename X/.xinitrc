#!/bin/sh

# defaults if any
sysresources=/etc/X11/xinit/.Xresources
sysmodmap=/etc/X11/xinit/.Xmodmap
# personal preferences
userresources=$HOME/.Xresources
# remaping of some keys
usermodmap=$HOME/.Xmodmap
defaultbrowser="vivaldi-stable.desktop"

# merge in defaults and keymaps
[[ -f $sysresources ]] && xrdb -merge $sysresources
[[ -f $sysmodmap ]] && xmodmap $sysmodmap
[[ -f "$userresources" ]] && xrdb -merge -I$HOME "$userresources"
[[ -f "$usermodmap" ]] && xmodmap "$usermodmap"

# common defaults are in .Xresources but the dpi depends on
# the host
case "$HOSTNAME" in
  xps) dpi=168;;
  latitude) dpi=114;;
esac

# override dpi value for font configuration
# TODO: override font sizes too
echo "Xft.dpi: $dpi" | xrdb -load

# start some nice programs
if [ -d /etc/X11/xinit/xinitrc.d ] ; then
 for f in /etc/X11/xinit/xinitrc.d/?*.sh ; do
  [ -x "$f" ] && . "$f"
 done
 unset f
fi

# X settings
# change touchpad behaviour
# could use /usr/share/X11/xorg.conf.d/40-libinput.conf instead
if [[ $HOSTNAME == xps ]]; then
  xinput set-prop 'DLL075B:01 06CB:76AF Touchpad' \
    'libinput Tapping Enabled' 1
  xinput set-prop 'DLL075B:01 06CB:76AF Touchpad' \
    'libinput Natural Scrolling Enabled' 1
else
  true
fi

# ignore some font paths
# check which paths are know to xorg with xset q
xset -fp /usr/share/fonts/OTF/     # Remove the specified font path from Xorg's list of known font paths
xset -fp /usr/share/fonts/misc/     # Remove the specified font path from Xorg's list of known font paths

# set prefered web browser
[[ $(xdg-settings check default-web-browser $defaultbrowser) = "yes" ]] || \
xdg-settings set default-web-browser $defaultbrowser

# set correct DPI
xrandr --dpi $dpi

# give local programs access to X server (for Docker)
xhost +local:

# finally, start i3 window manager
exec i3
