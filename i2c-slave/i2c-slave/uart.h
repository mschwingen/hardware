#ifndef _UART_H
#define _UART_H

extern void uart_init(void);
extern int uart_putchar(char c, FILE *stream);
extern int uart_getchar(FILE *stream);
extern char uart_stat(void);


#endif
