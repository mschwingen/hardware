#PROGRAM ?= i2cslave_m328
PROGRAM ?= i2cslave_m88

all: $(PROGRAM).hex

CFLAGS_OPT = -Os -flto
LDFLAGS_OPT = -Os -flto

FREQ_i2cslave_m328	:= 8000000
MCU_i2cslave_m328	:= atmega328p
BAUD_i2cslave_m328	:= 19200
AVRDUDE_i2cslave_m328   = $(AVRDUDE_STK200)
LDFLAGS_i2cslave_m328   =
CFLAGS_i2cslave_m328   +=

i2cslave_m328.elf: uart2.o i2cslave.o
	$(CC) -o $@ $(LDFLAGS) -Wl,-Map,$*.map $^ $(EXTRA_LIBS)
	$(SIZE) $@

FUSE_L_i2cslave_m328	:= 0xED
FUSE_H_i2cslave_m328	:= 0xDD
FUSE_E_i2cslave_m328	:= 0xFE


#############################################################################
FREQ_i2cslave_m88	:= 7372800
MCU_i2cslave_m88	:= atmega88p
BAUD_i2cslave_m88	:= 115200
AVRDUDE_i2cslave_m88   = $(AVRDUDE_STK200)
LDFLAGS_i2cslave_m88   =
CFLAGS_i2cslave_m88   +=

i2cslave_m88.elf: uart2.o i2cslave.o
	$(CC) -o $@ $(LDFLAGS) -Wl,-Map,$*.map $^ $(EXTRA_LIBS)
	$(SIZE) $@

FUSE_L_i2cslave_m88	:= 0xED
FUSE_H_i2cslave_m88	:= 0xDE
FUSE_E_i2cslave_m88	:= 0xF9

include ./Makefile.common

CFLAGS += -std=gnu99



