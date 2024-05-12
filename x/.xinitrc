xrandr --setprovideroutputsource modsetting NVIDIA-0
autorandr --change
xrdb -merge ~/.Xresources

xset r rate 250 40
xsetroot -cursor_name left_ptr &
xinput set-prop "ELAN06FA:00 04F3:3140 Touchpad" "libinput Tapping Enabled" 1

exec xmonad
