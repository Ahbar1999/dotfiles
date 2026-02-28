#!/bin/bash
scrot /tmp/screen.png
convert /tmp/screen.png -blur 0x8 /tmp/screen_blur.png
i3lock -i /tmp/screen_blur.png
