/* Program that finds the largest number in a list of integers */
.text // executable code follows
.global _start
_start:
		MOV R4, #RESULT // R4 points to result location
		LDR R0, [R4, #4] // R0 holds the number of elements in the list
		MOV R1, #NUMBERS // R1 points to the start of the list
		BL LARGE
		STR R0, [R4] // R0 holds the subroutine return value
		
		
END:    B END


/* Subroutine to find the largest integer in a list
* Parameters: R0 has the number of elements in the lisst
* R1 has the address of the start of the list
* Returns: R0 returns the largest item in the list
*/


LARGE:		LDR R2, [R1]  // R2 holds the largest number at the beginning

LOOP:	    SUBS R0, #1   // Decreases the loop counter by 1
			BEQ DONE      // Exit loop when all elements are looked through
			ADD R1, #4    // Points to the next number in the list
			LDR R3, [R1]  // Loads the next number in R3
			CMP R2, R3    // Compares R2 and R3 
			BGE LOOP      // If R3 is smaller than R2, go to next element in list and repeat
			MOV R2, R3    // Once R3 is bigger than R2, replace R2 with the value in R3
			B LOOP        // Continue to go through the list
		
DONE:       MOV R0, R2    // Stores the largest number in R0
			MOV PC, LR    // Stores the result address of the subfunction
			
			
RESULT:     .word 0
N:      	.word 7 // number of entries in the list
NUMBERS:	.word 4, 5, 3, 6 // the data
        	.word 1, 8, 2
        	.end