xrdb -merge ~/.Xresources
xsetroot -cursor_name left_ptr
setxkbmap -layout "fr, fr, us" -variant "oss, bepo" -option "grp:shifts_toggle"
xmodmap ~/.Xmodmap
#exec /usr/bin/qtile
exec /usr/bin/enlightenment_start
