/* Program that finds the largest number in a list of integers   */


         .text                  // Executable code follows
         .global  _start
_start:      
         MOV      R4, #RESULT   // R4 points to result location
         LDR      R2, [R4, #4]  // R2 holds number of elements in the list
         MOV      R3, #NUMBERS  // R3 points to the list of integers
         LDR      R0, [R3]      // R0 holds the largest number so far


LOOP:    SUBS     R2, #1        // Decrement the loop counter
         BEQ      DONE          // if result is equal to 0, branch
         ADD      R3, #4
         LDR      R1, [R3]      // Get the next number
         CMP      R0, R1        // Check if larger number found
         BGE      LOOP
         MOV      R0, R1        // Update the largest number
         B        LOOP

DONE:    STR      R0, [R4]      // Store largest number into result location


END:     B        END

RESULT:  .word    0
N:       .word    7             // Number of entries in the list
NUMBERS: .word    4, 5, 3, 6   
         .word    1, 8, 2

         .end     