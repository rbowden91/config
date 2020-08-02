#!/bin/bash

backlight_dir=/sys/class/backlight/
fraction_per_press=0.10

if [[ "$1" == "up" ]]; then
    multiplier=1.0
elif [[ "$1" == "down" ]]; then
    multiplier=-1.0
else
    exit
fi

cd "$backlight_dir"
for i in *; do
    brightness_file="$i/brightness"
    old_brightness=$(cat $brightness_file)
    max_brightness=$(cat "$i/max_brightness")

    # in the "step=" line, the division by 1 truncates the float
    bc_cmd="\
	step=($max_brightness*$multiplier*$fraction_per_press)/1;\
     	brightness=$old_brightness+step;\
     	if (brightness < 0) { 0 } \
     	else if (brightness > $max_brightness) { $max_brightness } \
	else { brightness }"
    echo "$bc_cmd" | bc | sudo tee "$brightness_file" > /dev/null
done
