//#define F_CPU 1200000UL
// this clock speed is the 9.6MHz divided by the 8 clock prescaler
#define F_CPU 1200000UL

#include <avr/interrupt.h>
#include <avr/io.h>
#include <util/delay.h>

int i;
int volatile duration = 1000;
int state = 1   ;

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
    while(1)
    {
		// toggle pin (^) is the XOR operator
		PORTB ^= _BV(PORTB3);
        _delay_ms(duration);
    }

}

ISR (PCINT0_vect) {
    // simple debounce routine
    // read button
    int button1 = PINB & _BV(DDB4);
    // pause 50ms
    _delay_ms(50);
    // read button
    int button2 = PINB & _BV(DDB4);
    // if readings are equal and low, run code
    if ((button1 == button2) && (button1==0))
    {}
    else
    {return;}

    switch (state)
    {
        case 0:
            duration = 25;
            break;
        case 1:
            duration = 50;
            break;
        case 2:
            duration = 75;
            break;
        default:
            break;
    }
    state ++;
    if (state==3) state = 0;

}