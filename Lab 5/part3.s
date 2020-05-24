	.text
	.global _start

_start:   LDR     R4, =0xFF200000       // Base Address for LEDR
          MOV     R3, #0                
		  
          LDR     R7, =0xFFFEC600       // Base Address of Automatic Timer
          LDR     R2, =50000000
	  STR     R2, [R7]              // Loads timer value into R7
          MOV     R2, #0b011
	  STR     R2, [R7, #8]          // Enable the A and E values to start timer and auto reload
		
MAIN:     LDR     R1, [R4, #0x5C]       // R1 holds Edge Capture value
		  CMP R1, #0            // If R1 is 0, no key was pressed
		  BEQ NOPRESS	        // If R1 is 1, key was pressed
		  
WAIT:     MOV     R1, #0b1111        	// If key pressed, assert 1 into Edge Capture register
          STR     R1, [R4, #0x5C]
	  LDR     R1, [R4, #0x5C]       // R1 holds new Edge Capture value
	  B       UNPAUSE
		  
UNPAUSE:  LDR     R1, [R4, #0x5C]       // Checks if button is pressed 
	  CMP     R1, #0		// If 0, check again
	  BEQ     UNPAUSE		// If 1, continue
		  
NOPRESS:      MOV     R1, #0b1111       // Resets the Edge Capture value for future use
              STR     R1, [R4, #0x5C]
	      LDR     R1, [R4, #0x5C]
		  
	      CMP     R3, #99		// If counter is at 99
	      BEQ     _start            // Restart from 0

              LDR     R8, =0xFF200020   // Otherwise display on HEX
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
	      ADD     R3, #1
		  
DELAY:    LDR     R2, [R7, #0xC]        // Reads interrupt status value, F
	  CMP     R2, #0
	  BEQ     DELAY             	// Continue to delay until timer reaches 0
	  STR     R2, [R7, #0xC]    	// Resets F
	  B       MAIN
	
DIVIDE:     MOV    R2, #0   		// Divide to seperate 10s and 1s digit 
CONT:       CMP    R0, #10
            BLT    DIV_END
            SUB    R0, #10
            ADD    R2, #1
            B      CONT
DIV_END:    MOV    R1, R2     
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