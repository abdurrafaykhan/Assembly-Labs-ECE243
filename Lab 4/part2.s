/* Program that counts consecutive 1's */

          .text                   
          .global _start                  
_start:                             
          MOV     R4, #TEST_NUM   // loads the words into R4
          MOV     R5, #0          // R5 stores results and is set to 0 initially


MAIN:     LDR     R1,[R4],#4      // Gets the first word and advances R4 to next word
          CMP     R1, #0          // If the word is 0, end the program
	  BEQ     END

          BL      ONES            // If word exists, branch to subroutine

          CMP     R5, R0 	  // Compare new value of 1's to old one
	  MOVLT   R5, R0          // Move new value to R5 if its bigger than old one

	  B       MAIN            // Repeat until all words have been scanned

END:      B       END

ONES:     MOV	  R0, #0          // R0 stores the number of 1s in the word

LOOP:     CMP     R1, #0          // When theres no more 1s, end the subroutine
          BEQ     END_ONES
          LSR     R2, R1, #1      // Do a shift and then AND 
          AND     R1, R1, R2      
          ADD     R0, #1          // Counts string length so far and increments with every rep
          B       LOOP            

END_ONES: MOV     PC, LR  	  // Goes back to Main

TEST_NUM: .word   0x00000001  
	  .word   0x00000002
	  .word   0x00000003
	  .word   0x0000000a
	  .word   0x0000002f
	  .word   0xffffffff
	  .word   0x0000003f
	  .word   0x00000007
	  .word   0x00000008
	  .word   0x103fe00f
	  .word   0
          .end                            
