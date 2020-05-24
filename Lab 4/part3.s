/* Part3 */

          .text                   // executable code follows
          .global _start                  
_start:                          
          MOV     R4, #TEST_NUM    // loads the words into R4
	  MOV     R5, #0           // R5 stores results of longest string of 1s 
          MOV     R6, #0           // R6 stores results of longest string of 0s
          MOV     R7, #0           // R7 stores results of longest sring of alternating 1s and 0s
           
	  LDR     R8, =0xFFFFFFFF  // converts to 1s
          LDR     R9, =0xAAAAAAAA  // converts to 101s
          LDR     R10, =0x55555555 // converts to 010s
     
MAIN:     LDR     R1, [R4], #4     // Gets the first word and advances R4 to next word
          CMP     R1, #0           // If the word is 0, end the program
          BEQ     END       

          BL      ONES             // If word exists, branch to subroutine for 1s
          CMP     R5, R0           // Compare new value of 1's to old one       
          MOVLT   R5, R0           // Move new value to R5 if its bigger than old one
          
          BL      ZEROS            // If word exists, branch to subroutine for 0s
	  CMP     R6, R0 	   // Compare new value of 0's to old one
          MOVLT   R6, R0           // Move new value to R6 if its bigger than old one

          BL      ALTERNATE1       // If word exists, branch to subroutine for 0101s
          CMP     R7, R0	   // Compare new value of 0101s to old one
          MOVLT   R7, R0           // Move new value to R7 if its bigger than old one

          BL      ALTERNATE0       // If word exists, branch to subroutine for 1010s
          CMP     R7, R0	   // Compare new value of 1010s to old one
          MOVLT   R7, R0           // Move new value to R7 if its bigger than old one

	  B       MAIN             // Repeat until all words have been scanned
	     
END:      B       END    

ONES:     MOV     R0, #0           // R0 stores the number of 1s in the word

LOOP:     CMP     R1, #0           // When theres no more 1s, end the subroutine
          BEQ     DONE             	
          LSR     R3, R1, #1       // Do a shift and then AND 
          AND     R1, R1, R3      
          ADD     R0, #1           // Counts string length so far and increments with every rep
          B       LOOP            

ZEROS:    MOV     R0, #0           // R0 stores the number of 1s in the word
          LDR     R1, [R4]
	  EOR     R1, R8           // Do an XOR with all 1s
	  B       LOOP	           // Repeat ONES subroutine process with new string

ALTERNATE1: MOV    R0, #0          // R0 stores the number of 010s in the word
           LDR    R1, [R4]
           EOR    R1, R9           // Do an XOR with all 1010s
	   B      LOOP		   // Repeat ONES subroutine process with new string


ALTERNATE0: MOV    R0, #0          // R0 stores the number of 101s in the word
           LDR    R1, [R4]
           EOR    R1, R10          // Do an XOR with all 0101s
	   B      LOOP		   // Repeat ONES subroutine process with new string


DONE:     MOV     PC, LR    	   // Goes back to Main

TEST_NUM: .word   0xFFFFFFFF
	  .word   0xAAAAAAAA
	  .word   0x55555555
          .word	  0  
	  .end                             
