#!/bin/bash
sudo ~/scripts/setup.sh
button_gpio=18
while true; do
  button=$(raspi-gpio get $button_gpio | sed 's@.*level=\([0-9]\).*@\1@')
  if [ "$button" -eq 0 ]; then
    echo 1000 >/sys/class/leds/hat_led/delay_on
    echo 0 >/sys/class/leds/hat_led/delay_off
    while [ "$button" -eq 0 ]; do
      button=$(raspi-gpio get $button_gpio | sed 's@.*level=\([0-9]\).*@\1@')
    done
    echo Running flash script:
    echo 250 >/sys/class/leds/hat_led/delay_on
    echo 250 >/sys/class/leds/hat_led/delay_off
    ~/flash/flash.sh
    if [ $? -ne 0 ]; then
      echo 50 >/sys/class/leds/hat_led/delay_on
      echo 50 >/sys/class/leds/hat_led/delay_off
      sleep 5
    else
      echo 1000 >/sys/class/leds/hat_led/delay_on
      echo 0 >/sys/class/leds/hat_led/delay_off
      sleep 3
    fi
    echo 100 >/sys/class/leds/hat_led/delay_off
    echo 0 >/sys/class/leds/hat_led/delay_on
    sleep 1
  else
    echo -n .
    sleep 0.3
  fi
done
