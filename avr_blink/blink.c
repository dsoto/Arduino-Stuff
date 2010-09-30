//#define F_CPU 1200000UL
// this clock speed is the 9.6MHz divided by the 8 clock prescaler
#define F_CPU 1200000UL

#include <avr/io.h>
#include <util/delay.h>

int main (void)
{
    DDRB  = 0xff;
    // initialize bit high
    PORTB |= _BV(PORTB3);

    while(1)
    {
		//PORTB = 0xff;
		// toggle pin (^) is the XOR operator
		PORTB ^= _BV(PORTB3);
        _delay_ms(500);
		//PORTB = 0x00;
		// toggle pin agin
		PORTB ^= _BV(PORTB3);
        _delay_ms(50);
    }
}

