/* Display R5 on HEX1-0, R6 on HEX3-2 and R7 on HEX5-4 */
DISPLAY:	PUSH	{R4, R8, R9, R10, LR}	// To not change values of these registers after process

		LDR 	R8, =0XFF200020  	// Base address of Hex3-0
		MOV	R0, R5			// R5 displays HEX1-0
		BL	DIVIDE			// Performs sub function to divide 
		
		MOV	R9, R1			// Saves the tens digit
		BL 	SEG7_CODE 		// Branches to seg 7
		MOV 	R4, R0			// Saves bit code to R4
		MOV	R0, R9 			// Retrieves the tens digit and gets bit code
		
		BL 	SEG7_CODE		// Branches to seg 7
		LSL 	R0, #8
		ORR 	R4, R0
		
		MOV	R0, R6			// R6 displays HEX3-2
		BL	DIVIDE			// Performs sub function to divide 
		
		MOV 	R9, R1			// Saves the tens digit
		BL 	SEG7_CODE		// Branches to seg 7
		MOV 	R10, R0			// Saves bit code to R10
		MOV 	R0, R9			// Retrieves the tens digit and gets bit code
		
		BL 	SEG7_CODE		// Branches to seg 7
		LSL 	R0, #24
		LSL 	R10, #16
		ORR 	R0, R10
		ORR 	R4, R0
		STR	R4, [R8]		// Displays numbers from R6 and R5	
		
		LDR 	R8, =0XFF200030		// Base address of HEX5-HEX4	

		MOV 	R0, R7			// R7 displays HEX504
		BL	DIVIDE			// Performs sub function to divide 
		
		MOV   	R9, R1			// Saves the tens digit
		BL 	SEG7_CODE		// Branches to seg 7
		MOV 	R4, R0			// Saves bit code to R4
		MOV	R0, R9			// Retrieves the tens digit and gets bit code
		
		BL	SEG7_CODE		// Branches to seg 7
		LSL	R0, #8			
		ORR 	R4, R0
		STR 	R4, [R8]		// Displays numbers from R7	
		
		POP 	{R4, R8, R9, R10, LR}
		MOV	PC, LR
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		

		
		
		
		
