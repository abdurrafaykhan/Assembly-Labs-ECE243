	.text
	.global _start

_start:   MOV     R3, #0                    // R3 acts as a counter 
	  LDR     R4, =0xFF200000           // R4 hold the LEDR Base Address

DISPLAY:  LDR     R1, [R4, #0x5C]           // R1 holds Edge Capture Value
	  CMP     R1, #0                    // If Edge Capture value is 0, key isnt pressed
	  BEQ     NOPRESS                   // If Edge Capture value is 1, key is pressed and code continues

PRESSED:  MOV     R1, #0b1111               // Reset Edge Capture by moving a 1 to that key
          STR     R1, [R4, #0x5C]           
          LDR     R1, [R4, #0x5C]           // Gets updated Edge Capture value
          B       UNPAUSE             

UNPAUSE:   LDR     R1, [R4, #0x5C]          // Scans for Edge Capture again
           CMP     R1, #0            	    // Compares it to 0 to see if the key is pressed again
           BEQ     UNPAUSE 		    // Once key is pressed again, move on

NOPRESS:      MOV     R1, #0b1111           // Reset Edge Capture by moving a 1 to that key
              STR     R1, [R4, #0x5C]
              LDR     R1, [R4, #0x5C]
              CMP     R3, #99		    // Checks to see if counter is at 99 to reset if necessary
              BEQ     _start                // Resets back to 0 if at 99

              LDR     R8, =0xFF200020       // Display Number in R3 (Counter) On the Hex Display
              MOV     R0, R3                
              BL      DIVIDE          
                                  
              MOV     R9, R1          
              BL      SEG7_CODE
              MOV     R5, R0          
              MOV     R0, R9         
                                      
              BL      SEG7_CODE
              LSL     R0, #8
              ORR     R5, R0

              STR     R5, [R8]

              LDR     R2, =500000

DELAY:        SUBS    R2, #1
              BNE     DELAY
              ADD     R3, #1
              B       DISPLAY

DIVIDE:       MOV    R2, #0                  // Divide to seperate the 10s and 1s digit

CONT:         CMP    R0, #10
              BLT    DIV_END
              SUB    R0, #10
              ADD    R2, #1
              B      CONT

DIV_END:      MOV    R1, R2                  // R1 has quotient
              MOV    PC, LR


/* Subroutine to display on HEX
 *    R0 = Decimal value of digit to display, converts to bit battern that is to be displayed
 */

SEG7_CODE:  MOV     R1, #BIT_CODES
            ADD     R1, R0         // index into the BIT_CODES "array"
            LDRB    R0, [R1]       // load the bit pattern (to be returned)
            MOV     PC, LR

BIT_CODES:  .byte   0b00111111, 0b00000110, 0b01011011, 0b01001111, 0b01100110
            .byte   0b01101101, 0b01111101, 0b00000111, 0b01111111, 0b01100111
            .skip   2      // pad with 2 bytes to maintain word alignment