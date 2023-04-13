#!/bin/bash
echo "timer" >/sys/class/leds/hat_led/trigger
echo 0 >/sys/class/leds/hat_led/delay_on
echo 200 >/sys/class/leds/hat_led/delay_off
chown -R root.gpio /sys/devices/platform/leds@11/leds/hat_led
chmod -R g+w /sys/devices/platform/leds@11/leds/hat_led
