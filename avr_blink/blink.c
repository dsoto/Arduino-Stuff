//#define F_CPU 1200000UL
// this clock speed is the 9.6MHz divided by the 8 clock prescaler
#define F_CPU 1200000UL

#include <avr/interrupt.h>
#include <avr/io.h>
#include <util/delay.h>

int i;

int main ()
{
    // pin 3 output
    DDRB |= _BV(DDB3);
    // initialize bit low
    PORTB &= ~_BV(PORTB3);

    // pin 4 input
    DDRB &= ~_BV(DDB4);
    // turn on pullup resistor to config as switch
    PORTB |= _BV(PORTB4);

    // initialize interrupts
    sei();
    GIMSK |= _BV(PCIE);
    PCMSK |= _BV(PCINT4);

    // loop while interrupts run the show
    while(1);
}

ISR (PCINT0_vect) {
    for (i=1;i<20;i++)
    {
		// toggle pin (^) is the XOR operator
		PORTB ^= _BV(PORTB3);
        _delay_ms(50);
    }
}