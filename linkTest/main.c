#include <avr/io.h>
#include <util/delay.h>
#include "soto.h"

int main (void)
{
  DDRB = 0b11111111;
  DDRC = 0b11111111;
  DDRD = 0b11111111;

  while(1)
    {
      setPorts();
    }
  return(0);
}

