#!/bin/sh
modprobe gpib_bitbang
gpib_config
echo oneshot >/sys/class/leds/hat_led/trigger
chown -R gpib /sys/class/leds/hat_led/

