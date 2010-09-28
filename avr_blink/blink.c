#define F_CPU 1200000UL

#include <avr/io.h>
#include <util/delay.h>

int main (void)
{
    DDRB = 0b11111111;
//    DDRC = 0b11111111;
//    DDRD = 0b11111111;

    while(1)
    {
		PORTB = 0b11110111;
//		PORTC = 0b11111111;
//		PORTD = 0b11111111;
        _delay_ms(500);
		PORTB = 0b00001000;
//		PORTC = 0b00000011;
//		PORTD = 0b00000000;
        _delay_ms(500);
    }
    return(0);
}

