	.text
	.global _start

_start:     LDR R0, =0xFF200000  // LEDR Base Address
	    MOV R1, #BIT_CODES   // BIT_CODES Address that has all number sequences
	    
            MOV R8, #0           // For blank Case
            MOV R3, #0           // For storing pressed key
            MOV R6, #0           // Counter

DISPLAY:    

PAUSED:	    LDR R5, [R0, #0x50]  	// Reads Key input
	    CMP R5, #0 			// When R5 is 1, a key is pressed                 
            BEQ PAUSED			// repeats until a key is pressed
            
PRESSED:    MOV R3, R5            	// R3 holds value of key press
    
WAIT: 	    LDR R5, [R0, #0x50] 	// Reads Key value
	    CMP R5, #0          	// When Key is not released, wait
            BNE WAIT			// When key is released, continue and go to corresponding subfunction
            
	    ANDS R2, R3, #0b00000001 	// KEY0 is pressed
            BGT ZERO
            
            ANDS R2, R3, #0b00000010 	// KEY1 is pressed
            BGT INCREASE
            
            ANDS R2, R3, #0b00000100 	// KEY2 is pressed
            BGT DECREASE
         
            ANDS R2, R3, #0b00001000 	// KEY3 is pressed
            BGT BLANK

ZERO:	    MOV R6, #0			// Counter is 0 
            MOV R1, #BIT_CODES		// R1 holds address of BIT_CODES
            LDRB R3, [R1]       	// Loads 0 into HEX
            STR R3, [R0, #0x20] 	// Stores bit code into hex
	    B DISPLAY      		// Display the 0

INCREASE:   ADD R1, #1         		// Adds one byte to R1 for the bit code of the next digit
	    ADD R6, #1         		// Increase counter by 1
	    CMP R6, #10        		// If increased to 10, need to reset
	    BGT NINETOZERO
            CMP R4, #0         		// Checks flag to see if KEY3 flag was raised before
            SUBEQ R1, #1       		// If flag was raised, subtract the 1 added to R1 
            LDRB R3, [R1]		// R3 holds bit code for the next number
            STR R3, [R0, #0x20] 	// Stores bit code into hex
	    B DISPLAY  			// Display the next number

NINETOZERO:   MOV R1, #BIT_CODES   	// Resets bitcode address
	      LDRB R3, [R1]
	      MOV R6, #0           	// Resets Counter to 0
	      STR R3, [R0, #0X20] 	// Displays 0 
	      B DISPLAY          

DECREASE:   SUB R1, #1           	// Subtracts R1 by one byte to get previous digit
	    SUB R6, #1         		// Subtracts Counter by 1
	    CMP R6, #0         		// Checks if Counter is at -1 to go back to 0
	    BLT ZEROTONINE
            CMP R4, #0           	// Checks flag to see if KEY3 flag was raised before
            ADDEQ R1, #1	 	// If flag was raised, add the 1 subtracted from R1 
            LDRB R3, [R1]		// R3 holds bit code for the next number
            STR R3, [R0, #0x20] 	// Stores bit code into hex
	    B DISPLAY			// Display the next number

ZEROTONINE:   MOV R1, #BIT_CODES  	// Resets bitcode address
	      ADD R1, #9		// Goes to number 9 in bit code
	      MOV R6, #10		// Adds 10 to counter that was at -1 to create 9
	      LDRB R3, [R1]  		// Loads bitcode for 9 in R3
	      STR R3, [R0, #0X20]   	// Stores bitcode in hex
	      B DISPLAY             	// Display 9

BLANK:        MOV R4, #0          	// When KEY3 is pressed, R4 flag is set to 0
              MOV R1, #BIT_CODES  	// Resets bitcode address
              STR R8, [R0, #0x20] 	// Stores 0 (R8) into Hex
              B DISPLAY			// displays nothing

BIT_CODES:  .byte   0b00111111, 0b00000110, 0b01011011, 0b01001111, 0b01100110
            .byte   0b01101101, 0b01111101, 0b00000111, 0b01111111, 0b01100111
            .skip   2      // pad with 2 bytes to maintain word alignment
