#define F_CPU 16000000UL

#include <avr/io.h>
#include <util/delay.h>

int main (void)
{
    DDRB = 0b11111111;
    DDRC = 0b11111111;
    DDRD = 0b11111111;

    while(1)
    {
		PORTB = 0b11111110;
//		PORTC = 0b11111111;
		PORTD = 0b11111111;
        _delay_ms(1000);
		PORTB = 0b00000001;
//		PORTC = 0b00000011;
		PORTD = 0b00000000;
        _delay_ms(1000);
    }
    return(0);
}

