all: yoga.dtbo yoga_eeprom.eep

yoga.dtbo: yoga.dts
	dtc -I dts -O dtb -o $@ $<
	cp $@ /boot/overlays

yoga_eeprom.eep: yoga_eeprom.txt yoga.dtbo
	eepmake -v1 $< $@ yoga.dtbo

#dtoverlay i2c-gpio i2c_gpio_sda=0 i2c_gpio_scl=1 bus=9
program_eeprom: yoga_eeprom.eep
	eepflash.sh -y -w -t=24c64 -a=50 -f=$<

blank_eeprom:
	dd if=/dev/zero bs=8k count=1 of=blank.eep
	eepflash.sh -y -w -t=24c64 -a=50 -f=blank.eep

