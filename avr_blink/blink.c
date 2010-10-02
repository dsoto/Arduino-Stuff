//#define F_CPU 1200000UL
// this clock speed is the 9.6MHz divided by the 8 clock prescaler
#define F_CPU 1200000UL

#include <avr/interrupt.h>
#include <avr/io.h>
#include <util/delay.h>

int i;
int duration = 50;
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
    while(1);
}

void blink(int duration)
{
    for (i=0;i<10;i++)
    {
		// toggle pin (^) is the XOR operator
		PORTB ^= _BV(PORTB3);
        _delay_ms(duration);
    }
}

ISR (PCINT0_vect) {
    // read button
    int button1 = PINB & _BV(DDB4);
    // pause 50ms
    //_delay_ms(50);
    // read button
    int button2 = PINB & _BV(DDB4);
    // if readings are equal run code
    if ((button1 == button2) && (button1==0)) {}
    else {return;}

    switch (state)
    {
        case 0:
            blink(25);
            break;
        case 1:
            blink(200);
            break;
        case 2:
            blink(75);
            break;
        default:
            break;
    }
    state ++;
    if (state==3) state = 0;

}