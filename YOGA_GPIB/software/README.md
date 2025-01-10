# YOGA: software installation

The YOGA board uses the existing Linux GPIB project. In my use case, the
Raspberry Pi with the YOGA board is integrated with a LC display and a motor
driver board into a box that takes SCPI commands via two TCP ports and
controls two turntable/antenna positioners for an EMC test setup (directly
via the motor driver and indirectly via an existing maturo MCU unit
connected via GPIB). If you only need the bare GPIB interface, you can skip
those parts that you do not need.

## General setup

*  Use [Rasbperry Pi Imager](https://www.raspberrypi.org/software/) to image
the micro SD card with 'Raspberry Pi OS Lite' (32-bit bookworm). Enable ssh
and add ssh keys to the image. Default username is "gpib" for the following
instructions - if you change the username, some of the scripts may require
changes.

* Boot the pi, and check your DHCP server to determine the IP address

* Copy the software subdirectory to the raspberry (on host):

		scp -r software/* gpib@<raspberry-ip>:

* ssh into the Raspberry Pi, user gpib. Use "sudo -i" for steps done as root.

* (optional) set HTTP proxy (as root)

		echo "Acquire::http::Proxy \"http://172.17.0.2:8000\"; " >/etc/apt/apt.conf.d/99proxy

* Install required packages (as root)

        apt update && apt dist-upgrade
		apt install joe mc aptitude screen telnet # optional
		apt install git libdevice-i2c-perl linux-headers overlayroot flex m4 linux-kbuild-6.1 device-tree-compiler i2c-tools gpiod raspi-gpio build-essential python3-smbus bison m4
		apt install lcdproc libio-lcdproc-perl

* Set boot options to enable serial console and LED (as root)

        raspi-config nonint do_spi 1
        raspi-config nonint do_serial_hw 0
        raspi-config nonint do_serial_cons 0
        raspi-config nonint do_camera 1
		sed -i -e 's@display_auto_detect=1@display_auto_detect=0@' /boot/firmware/config.txt
		echo "[all]" >>/boot/firmware/config.txt
		echo "gpio=4=op,dl" >>/boot/firmware/config.txt
		echo "gpu_mem=16" >>/boot/firmware/config.txt
		echo "dtoverlay=disable-bt"       >>/boot/firmware/config.txt
		echo "dtoverlay=uart-rtscts.dtbo" >>/boot/firmware/config.txt
		echo "dtoverlay=gpio-led,gpio=4,trigger=heartbeat,label=hat_led" >>/boot/firmware/config.txt

* Set boot options to switch to software I2C (the hardware I2C block in the
  Raspberry Pi has a bug that leads to bus hangs if a device needs clock
  stretching) (as root)

        raspi-config nonint do_i2c 0
		sed -i -e 's@dtparam=i2c_arm=on@dtparam=i2c_arm=off@' /boot/firmware/config.txt
		echo "dtoverlay=i2c-gpio,i2c_gpio_sda=2,i2c_gpio_scl=3,i2c_gpio_delay_us=2,bus=1"  >>/boot/firmware/config.txt

		echo "i2c-dev" >>/etc/modules

* display IP address on console (as root)

		sed -ie 's@ \\n \\l@  \\4{eth0}  \\n \\l@' /etc/issue

* Install config files

		# copy the config files to their destination - the paths in config/ match the target filesystem layout:
		cd configs/etc
		sudo cp -rv * /etc/

* Configure networking and locale (as root)

		apt install isc-dhcp-client ifupdown resolvconf
		apt purge modemmanager network-manager ppp avahi-daemon
		apt autoremove
		dpkg-reconfigure locales
		-> set en_US.UTF-8 UTF-8
		-> setup desired network config in /etc/network/interfaces

* Compile and install the device tree overlay for the serial console with
  RTS/CTS handshake (as root)

		cd rtscts
		sudo make

* setup user/groups (as root)

		adduser gpib
		adduser gpib plugdev
		adduser gpib sudo
		adduser gpib dialout
		adduser gpib i2c
		adduser gpib gpio

* Compile linux-gpib code (as user gpib)

		cd ~
		git clone git://git.code.sf.net/p/linux-gpib/git linux-gpib-git
		cd ~/linux-gpib-git/linux-gpib-kernel/
		# apply separate patches
		patch -p2 <~/0001-YOGA-do-not-access-GPIO4-LED-since-is-is-already-all.patch
		patch -p2 <~/0002-provide-LED-trigger-for-boards-that-do-not-use-direc.patch
		make clean
		make -j4
		sudo make install
		cd ~/linux-gpib-git/linux-gpib-user/
		./bootstrap
		./configure --prefix=/
		make clean
		make -j4
		sudo make install
		sudo ldconfig
		cd ~/linux-gpib-git/linux-gpib-user/language/perl
		perl Makefile.PL
		make
		make test
		sudo make install

* Reboot the system

		sudo reboot

* Load GPIB module (as root)

		echo "options gpib_bitbang sn7516x_used=0 pin_map=yoga debug=0 gpio_offset=0" >/etc/modprobe.d/gpib.conf
		modprobe gpib_bitbang
		gpib_config
		#echo "gpib-act" >/sys/class/leds/hat_led/trigger

* Test it

		echo "*IDN?" | ibterm -d 4
		->
		ibterm>HEWLETT-PACKARD,34401A,0,3-1-1
		ibterm>
		ibterm: Done.

* Enable auto-start for GPIB module and TCP servers (as root)

		systemctl enable gpib-ifc.service  gpib-maturo.service  lcd_status_ip.service  motor-tcp.service

* When everything works, enable the overlay filesystem so that no data is
  lost when turning off the device without a clean shutdown

		run raspi-config
		4 Performance-Options -> P2 Overlay Filesystem

	Remember to disable the overlay filesystem when you need to make changes
    to the system.


## TCP setup for R&S Elektra / EMC32

The GPIB interface is exposed via TCP on port 5021, handled by
gpib-maturo.service / maturo-tcp-proxy.pl. To be compatible with the
existing setup in R&S EMC32, zero-zerminated strings are used.

The Antenna positioner is exposed via TCP on port 5022, handled by
motor-tcp.service / motor-tcp-server.pl. Here, LF is used as termination,
and the supported commands match the defaults for a "generic turntable" in
R&S Elektra.

Because we use a raw IPv4 socket in EMC32/Elektra, there is no easy way for
the perl script to know if it needs to return an answer string to a command
or not. In the EMC32/Elektra setup, each command can be defined as either
"read/write" or "write only", and this must match what the perl script
does - when the script returns a string that is not read by EMC32/Elektra,
commands and responses become de-synchronized and fail.

The GPIB->Maturo script needs to work with the existing "Maturo turntable"
setup, so it has a list of which commands shall return a result string.

The Motor Driver script always returns a result. In EMC32/Elektra, all
used commands must be set to "read/write".

## LC Display

The complete setup includes a HD44780-based 2x16 LCD which is connected to
the I2C bus via a PCF8574 port extender. The display is driven by LCDproc,
with 3 screens for the various components which are cycled periodically:

* lcd_status_ip.pl displays the currect IP address of the device
* maturo-tcp-proxy.pl displays the *IDN? response after startup, or the
  result of the last command
* motor-tcp-server.pl displays the current antenna polarization in degrees
  (0 = horizontal / 90 = vertical)


## License

Copyright Michael Schwingen 2024.

The documentation is released under [Attribution-ShareAlike 4.0 International](https://creativecommons.org/licenses/by-sa/4.0/legalcode)

The Linux GPIB code and my modifications to it are under their original license.

<!--  LocalWords:
-->
