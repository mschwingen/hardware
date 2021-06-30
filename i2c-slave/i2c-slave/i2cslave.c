/******************************************************************************
 * "nasty" I2C slave device for master driver test / error injection
 * (C) 2021 Michael Schwingen
 *
 *  This program is free software: you can redistribute it and/or modify
 *  it under the terms of the GNU General Public License as published by
 *  the Free Software Foundation, either version 3 of the License, or
 *  (at your option) any later version.
 *
 *  This program is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *  GNU General Public License for more details.
 *
 *  You should have received a copy of the GNU General Public License
 *  along with this program.  If not, see <https://www.gnu.org/licenses/>.
 *
 * Hardware setup:
 * AtMega328P with 8.0MHz crystal OR AtMega88P with 7.3728MHz crystal
 * PB5: LED (active high)
 * PC2, PC4: SDA (A2, A4 on arduino)
 * PC3, PC5: SCL (A3, A5 on arduino)
 * PD0: UART TXD (D0 on arduino, optional)
 * PD1: UART RXD (D1 on arduino, optional)
 *
 * the device occupies 16 consecutive addresses, with the default base
 * address being 0x60.
 *
 * This assumes a master with working bit-level implementation that handles
 * clock stretching. With debug output enabled, the device is quite slow and
 * will keep SCL low until ready, but an additional delay may be needed on
 * the master side after a STOP.
 *
 * W 0x60 <data>: normal data transfer, count unlimited
 * R 0x60 <data>: normal data transfer, count unlimited, data is
 *                0x00 0x01 0x02 ...
 *
 * limited write, with NACK after n bytes to check error handling:
 * W 0x61 <data>: NACK after 1 byte
 * W 0x62 <data>: NACK after 2 bytes
 * W 0x63 <data>: NACK after 3 bytes
 * W 0x64 <data>: NACK after 4 bytes
 * W 0x65 <data>: NACK after 5 bytes
 * W 0x66 <data>: NACK after 6 bytes
 * W 0x67 <data>: NACK after 7 bytes
 *
 * limited read, with NACK after n bytes, included for symmetry. Since the
 * Master (N)ACKS the transmission, this basically means the slave will
 * disconnect after n bytes, and the master will read 0xFF from the bus.
 * R 0x61 <data>: (NACK after 1 byte)
 * R 0x62 <data>: (NACK after 2 bytes)
 * R 0x63 <data>: (NACK after 3 bytes)
 * R 0x64 <data>: (NACK after 4 bytes)
 * R 0x65 <data>: (NACK after 5 bytes)
 * R 0x66 <data>: (NACK after 6 bytes)
 * R 0x67 <data>: (NACK after 7 bytes)
 *
 * trigger bus hang by pulling SDA low, until a H-L transition is seen on
 * SCL, used to test bus-hang recovery procedures.
 * W 0x68       : pull SDA low until clock is seen
 * R 0x68       : pull SDA low until clock is seen
 *****************************************************************************/

#define BASE_ADDRESS 0x60 // must be multiple of 0x10

#define DEBUG 1
#if DEBUG
#define DPRINTF(...) printf(__VA_ARGS__)
#else
#define DPRINTF(...)
#endif

#include <avr/io.h>
#include <avr/interrupt.h>
#include <avr/pgmspace.h>
#include <util/delay.h>
#include <stdio.h>
#include "uart.h"
#include <util/twi.h>
#include <stdbool.h>

typedef struct
{
  unsigned int bit0:1;
  unsigned int bit1:1;
  unsigned int bit2:1;
  unsigned int bit3:1;
  unsigned int bit4:1;
  unsigned int bit5:1;
  unsigned int bit6:1;
  unsigned int bit7:1;
} _io_reg;
#define REGISTER_BIT(rg,bt) ((volatile _io_reg*)&rg)->bit##bt

#define LED1 		REGISTER_BIT(PORTB,5)
#define SCL 		REGISTER_BIT(PORTC,5)
#define SDA 		REGISTER_BIT(PORTC,4)

#define SCL2_PORT 	REGISTER_BIT(PORTC,3)
#define SDA2_PORT 	REGISTER_BIT(PORTC,2)
#define SCL2_DDR 	REGISTER_BIT(DDRC,3)
#define SDA2_DDR	REGISTER_BIT(DDRC,2)
#define SCL2_PIN 	REGISTER_BIT(PINC,3)
#define SDA2_PIN	REGISTER_BIT(PINC,2)

static FILE mystdio = FDEV_SETUP_STREAM(uart_putchar, uart_getchar, _FDEV_SETUP_RW);

#define TWCR_ACK   ((1<<TWEA) | (1<<TWINT) | (1<<TWEN))
#define TWCR_NOACK ((0<<TWEA) | (1<<TWINT) | (1<<TWEN))
#define TWCR_INT   ((1<<TWEA) | (1<<TWINT) | (1<<TWEN))
#define TWCR_OFF   ((0<<TWEA) | (0<<TWINT) | (0<<TWEN))

// generate RX data to be returned on read (slave transmitter)
static uint8_t gen_rxdata(uint8_t index)
{
  return index;
}

bool sda_locked = false;

void lock_sda(void)
{
  DPRINTF("Lock SDA");
  SDA2_DDR = 1;    // set port to output: force SDA low
  sda_locked = true;
}

void check_unlock_sda(void)
{
  if (sda_locked && SCL2_PIN == 0) {
    while (SCL2_PIN == 0)
      ;
    SDA2_DDR = 0; // set port to input: release SDA
    DPRINTF(" - Unlock\n");
    sda_locked = false;
    TWCR = TWCR_ACK;
  }
}

// this is based on  TWI interrupt code, but called directly from main to
// remove interrupt overhead and to ease debug output
static void twi_handler(void) {
  static uint8_t index = 0;
  static uint8_t addr  = BASE_ADDRESS;
  uint8_t addr2;
  uint8_t data;

  bool enable_ack = true;

  uint8_t sr = TWSR & 0xF8;
  switch(sr) {

    // Slave Receiver Mode
    case TW_SR_ARB_LOST_SLA_ACK:
      index = 0;
      DPRINTF("ARB_LST_ACK ");
      /* FALLTHROUGH */
    case TW_SR_SLA_ACK: // Address byte: start of transfer, save used address
      addr = TWDR >> 1;
      index = 0;
      LED1 ^= 1;
      DPRINTF("\nS ADDR:%x ", addr);
      addr2 = addr & 0x0F;
      if (addr2 == 1)
	enable_ack = false;
      else if (addr2 == 8)
	lock_sda();
      break;
    case TW_SR_DATA_ACK:
      data = TWDR;
      index++;
      addr2 = addr & 0x0F;
      if ((addr2 >= 1 && addr2 <= 7) && (index+1) >= addr2)
	enable_ack = false;
      DPRINTF("R:%02x ", data);
      break;
    case TW_SR_DATA_NACK:
      data = TWDR;
      DPRINTF("NR:%02x ", data);
      break;
    case TW_SR_STOP:
      DPRINTF("P");
      break;
    case TW_SR_GCALL_ACK:
      index = 0;
      DPRINTF("GCALL_ACK ");
      break;
    case TW_SR_ARB_LOST_GCALL_ACK:
      index = 0;
      DPRINTF("ARB_LST_GCALL_ACK ");
      break;

      // Slave Transmitter Mode (read from slave)
    case TW_ST_SLA_ACK:
      addr = TWDR >> 1;
      index = 0;
      LED1 ^= 1;
      DPRINTF("\nS ADDR:%x ", addr);
      addr2 = addr & 0x0F;
      if (addr2 == 8)
      {
	lock_sda();
	break;
      }
      /* FALLTHROUGH */
    case TW_ST_DATA_ACK:
      data = gen_rxdata(index++);
      DPRINTF("T:%02x ", data);
      addr2 = addr & 0x0F;
      if ((addr2 >= 1 && addr2 <= 7) && index >= addr2)
	enable_ack = false;
      TWDR = data;
      break;
    case TW_ST_DATA_NACK:
      DPRINTF("TN ");
      break;
    case TW_ST_LAST_DATA:
      DPRINTF("TL ");
      break;

    case TW_SR_GCALL_DATA_ACK:
      DPRINTF("GC_DATA_ACK ");
      break;
    case TW_SR_GCALL_DATA_NACK:
      DPRINTF("GC_DATA_NACK ");
      break;

    case TW_ST_ARB_LOST_SLA_ACK:
      putchar('<');
      break;
    default:
      DPRINTF("	(%02x)", sr);
      TWCR = TWCR_OFF;
      _delay_ms(1);
      break;
  }

  if (sda_locked) {
    TWCR = TWCR_OFF;
  } else {
    if (enable_ack)
      TWCR = TWCR_ACK;
    else
      TWCR = TWCR_NOACK;
  }
}

int main(void)
{
  // enable pullups / set initial pin states
  PORTB = _BV(PB5);
  PORTC = _BV(PC4) | _BV(PC5);
  PORTD = 0x00;
  // set pins to output
  DDRB = _BV(PB5);
  DDRC = 0;
  DDRD = 0;

  LED1 = 1;
  SCL2_PORT = 0;
  SDA2_PORT = 0;

  uart_init();
  stdout = &mystdio;
  stdin = &mystdio;

  printf_P(PSTR("\r\n\r\nI2C error-test slave ready!\r\n"));
  LED1 = 1;

  TWAR = BASE_ADDRESS << 1; // set slave address
  TWAMR = 0x0f << 1;        // ignore lowest 4 address bits
  TWCR = TWCR_ACK;

  sei();      // enable interrupts

  if (SDA2_PIN == 0 || SCL2_PIN == 0) {
    printf("wait for bus free ...");
    while (SDA2_PIN == 0 || SCL2_PIN == 0)
      ;
  }
  // lock_sda(); // start in SDA-locked error state
  while(1) {
    if (!sda_locked && (TWCR & (1<<TWINT)))
      twi_handler();
    check_unlock_sda();
  }

  return 0;
}
