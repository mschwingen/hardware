#include <stdio.h>
#include <avr/io.h>
#include <avr/interrupt.h>

#include "uart.h"

#define UART_TX_USE_IRQ 0

#ifndef UART_TX_BUFSIZE
# define UART_TX_BUFSIZE 128
#endif

#ifndef UART_RX_BUFSIZE
# define UART_RX_BUFSIZE 4
#endif

static unsigned char RxBuffer[UART_RX_BUFSIZE];
static volatile unsigned char RxHead = 0;
static volatile unsigned char RxTail = 0;
#define RxLength   (unsigned char)(RxHead - RxTail)

/* UBRR baudrate value for asynch. normal mode */
#define MKBAUD(rate) ((F_CPU/(16l*(rate)))-1)

void uart_init(void)
{
  /* set up UART, 8N1 async mode */
  UBRR0 = MKBAUD(F_BAUDRATE);

  RxHead = 0;
  RxTail = 0;

  UCSR0C = _BV(UCSZ01) | _BV(UCSZ00);
  UCSR0B = _BV(RXCIE0) | _BV(RXEN0) | _BV(TXEN0);
}


//! UART receive interrupt handler
//ISR(SIG_USART_RECV)

#if defined __AVR_ATmega644__ || defined __AVR_ATmega644A__ || defined __AVR_ATmega644P__ || defined __AVR_ATmega644PA__
ISR(USART0_RX_vect)
#else
ISR(USART_RX_vect)
#endif
{
  if (RxLength < UART_RX_BUFSIZE)
    RxBuffer[RxHead++ & (UART_RX_BUFSIZE - 1)] = UDR0;
}

int uart_getchar(FILE *stream)
{
  char c;

  while (RxLength == 0)
    ;
  c = RxBuffer[RxTail & (UART_RX_BUFSIZE - 1)];
  RxTail++;
  return c;
}

char uart_stat(void)
{
  return RxLength;
}


#if UART_TX_USE_IRQ

static unsigned char TxBuffer[UART_TX_BUFSIZE];
static volatile unsigned char TxHead = 0;
static volatile unsigned char TxTail = 0;
#define TxLength   (unsigned char)(TxHead - TxTail)

//! UDRE handler
#if defined __AVR_ATmega644__ || defined __AVR_ATmega644A__ || defined __AVR_ATmega644P__ || defined __AVR_ATmega644PA__
ISR(USART0_UDRE_vect)
#else
ISR(USART_UDRE_vect)
#endif
{
  char c;
  if (TxLength) // more data
  {
    c = TxBuffer[TxTail & (UART_TX_BUFSIZE - 1)];
    TxTail++;
    UDR0 = c;
  }
  else
    UCSR0B &= ~_BV(UDRIE0);

}

void _uart_putchar(char c)
{
  while (TxLength >= UART_TX_BUFSIZE)
    ;
  TxBuffer[TxHead++ & (UART_TX_BUFSIZE - 1)] = c;
  UCSR0B |= _BV(UDRIE0);
}

int uart_putchar(char c, FILE *stream)
{
  if (c == '\n')
    _uart_putchar('\r');
  _uart_putchar(c);
  return 0;
}


#else
int uart_putchar(char c, FILE *stream)
{
  if (c == '\n')
  {
    loop_until_bit_is_set(UCSR0A, UDRE0);
    UDR0 = '\r';
  }

  loop_until_bit_is_set(UCSR0A, UDRE0);
  UDR0 = c;
  return 0;
}
#endif
