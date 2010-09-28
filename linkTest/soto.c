#include "soto.h"
#include <avr/io.h>
#include <util/delay.h>

void setPorts() {
          PORTB = 0b11111110;
      //PORTC = 0b11111111;
      PORTD = 0b11111111;
      _delay_ms(100);
      PORTB = 0b00000001;
      //PORTC = 0b00000011;
      PORTD = 0b00000000;
      _delay_ms(100);

}