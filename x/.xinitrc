xrandr --setprovideroutputsource modsetting NVIDIA-0
autorandr --change
xrdb -merge ~/.Xresources

xset r rate 250 40
xsetroot -cursor_name left_ptr &

exec xmonad
