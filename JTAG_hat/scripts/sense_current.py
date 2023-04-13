#!/usr/bin/env python3
from ina219 import INA219
from ina219 import DeviceRangeError

SHUNT_OHMS = 0.1

def read():
    ina = INA219(SHUNT_OHMS)
    ina.configure()
    print("Bus Voltage: {:.3f} V".format(ina.voltage()))
    try:
        print("Bus Current: {:.3f} mA".format(ina.current()))
        print("Power: {:.3f} mW".format(ina.power()))
        print("Shunt voltage: {:.3f} mV".format(ina.shunt_voltage()))
    except DeviceRangeError as e:
        # Current out of device range with specified shunt resister
        print(e)

if __name__ == "__main__":
    read()
