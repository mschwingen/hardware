#include <stdio.h>
#include <string.h>
#include "globals.h"

#include "libmisc/delay.h"
#include "libmisc/stm32/hal.h"
#include "libmisc/stm32/gpio.h"
#include "libmisc/stm32/i2c.h"
#include "libmisc/timeout.h"

uint32_t lm_tick;

extern "C" void SysTick_Handler(void)
{
  lm_tick++;
}

void i2ctest2_lm(void);


int main(void)
{
  board_init();
  LED_PIN = 1;
  usart_init();
  setvbuf(stdout, 0, _IONBF, 0);

  i2c1.init();

  printf("\r\n-----------------------------------------------------------------------------\n");
  printf("I2CTEST " __DATE__ " " __TIME__ "\n");

  while(1) {
    i2ctest2_lm();
  }
}


void i2ctest2_lm(void)
{
  I2C_BASE::I2CResult rc;
  uint8_t buf[20];

  unsigned addr = 0x60;

  while(1) {

    printf("Write:\n");
    if(0) {
      printf("%x OK: ", addr + 1);
      rc = i2c1.write(addr + 1,0, buf, I2C_BASE::WriteMode::STOP);
      printf("%d\n", (int) rc);
      while(1)
	;
    }

    for(unsigned i = 0; i < sizeof(buf); i++)
      buf[i] = 0x10 + i;
    TRIGGER_PIN = 1;
    printf("%x OK: ", addr);
    rc = i2c1.write(addr + 0,16, buf, I2C_BASE::WriteMode::STOP);
    TRIGGER_PIN = 0;
    printf("%d\n", (int) rc);
    _delay_ms(20);

    for (int i = 1; i <= 7; i++) {
      printf("%x OK:  ", addr+i);
      rc = i2c1.write(addr + i,i-1, buf, I2C_BASE::WriteMode::STOP);
      printf("%d\n", (int) rc);
      _delay_ms(20);

      printf("%x BAD: ", addr+i);
      rc = i2c1.write(addr + i,i, buf, I2C_BASE::WriteMode::STOP);
      printf("%d\n", (int) rc);
      _delay_ms(20);
    }

    _delay_ms(20);
    printf("Read:\n");
    for (int i = 1; i <= 7; i++) {
      printf("%x OK:  ", addr+i);
      memset(buf, 0xaa, sizeof(buf));
      rc = i2c1.read(addr+i, i, buf);
      printf("%d -> %02X %02X %02X %02X %02X ", (int) rc, buf[0], buf[1], buf[2], buf[3], buf[4] );
      printf("\n");
      _delay_ms(20);
    }

    printf("Hang SDA(Read): ");
    rc = i2c1.read(addr+8, 0, buf);
    printf("%d\n", (int) rc);
    _delay_ms(20);

    printf("Read:\n");
    for (int i = 2; i <= 2; i++) {
      printf("%x OK:  ", addr+i);
      memset(buf, 0xaa, sizeof(buf));
      rc = i2c1.read(addr+i, i, buf);
      printf("%d -> %02X %02X %02X %02X %02X ", (int) rc, buf[0], buf[1], buf[2], buf[3], buf[4] );
      printf("\n");
      _delay_ms(20);
    }

    printf("Hang SDA(Write): ");
    rc = i2c1.write(addr+8, 0, buf, I2C_BASE::WriteMode::STOP);
    printf("%d\n", (int) rc);
    _delay_ms(20);

    printf("Write:\n");
    for (int i = 1; i <= 7; i++) {
      printf("%x OK:  ", addr+i);
      rc = i2c1.write(addr + i,i-1, buf, I2C_BASE::WriteMode::STOP);
      printf("%d\n", (int) rc);
      _delay_ms(20);
    }

    while(1)
      ;

  }
}
