cliphist list |
awk '{ print substr($0, 1, 80) }' |
wofi --dmenu --width 80% |
cliphist decode |
wl-copy