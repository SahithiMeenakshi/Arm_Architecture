     AREA    hammingcode, CODE, READONLY
     EXPORT __main
	   IMPORT printMsg
	   IMPORT print_encoded
	   IMPORT print_errorcorrection
	   IMPORT print_error_msg
	   IMPORT print_noerror
	   IMPORT print_error_before

__main  FUNCTION

	; Implementation of (31,26) hamming code using even parity --> 31 bit codeword-->26 message bits + 5 parity bits  
	; Load test value in R0-->26 bits , d26-d1
	; R1 --> 31 bit codeword
	
	LDR R0,=0x3886F13							
	AND R2,R0,#0x1									;Mask all bits of R0 except d1
	MOV R1,R2,LSL #2								;Align d1 in codeword

	AND R2,R0,#0xE									;Mask all bits of R0 except d2-d4
	ORR R1,R1,R2,LSL #3							;Align d2-d4 in codeword

	AND R2,R0,#0x7F0								;Mask all bits of R0 except d5-d11
	ORR R1,R1,R2,LSL #4 						;Align d5-d11 in codeword

	LDR R3,=0x3FFF800
	AND R2,R0,R3										;Mask all bits of R0 except d12-d26
	ORR R1,R1,R2,LSL #5 						;Align d12-d26 in codeword
	
	; 31 bit codeword in R1 with message bits in correct positions and parity bits with '0' value	
	
	; Generate parity bit P1 using following bits in R1
	; P1-->1,3,5,7,9,11,13,15,17,19,21,23,25,27,29,31
	
	EOR	R2, R1, R1, LSR #2						; xor of 1,3 bits of 	R1 	
	EOR	R2, R2, R2, LSR #4						; xor of 5,7 bits along with 1,3  bits in R1
	EOR	R2, R2, R2, LSR #8						; xor of 9,11,13,15 bits in R2 with previous result 
	EOR	R2, R2, R2, LSR #16						; xor of 17,19,21,23,25,27,29,31 bits in R2 with previous result
	AND	R2, R2, #0x1									; Mask all bits of R2 except P1 
	ORR	R1, R1, R2									  ; Align P1 in codeword
	
	; Generate parity bit P2 using following bits in R1
	; P2-->2,3,6,7,10,11,14,15,18,19,22,23,26,27,30,31
	
	EOR	R2, R1, R1, LSR #1							
	EOR	R2, R2, R2, LSR #4						
	EOR	R2, R2, R2, LSR #8						
	EOR	R2, R2, R2, LSR #16						
	AND	R2, R2, #0x2									;Mask all bits of R2 except P2 
	ORR	R1, R1, R2									  ;Align P2 in codeword
	
	; Generate parity bit P3 using following bits in R1
	; P3-->4,5,6,7,12,13,14,15,20,21,22,23,28,29,30,31
	
	EOR	R2, R1, R1, LSR #1							
	EOR	R2, R2, R2, LSR #2						
	EOR	R2, R2, R2, LSR #8						
	EOR	R2, R2, R2, LSR #16						
	AND	R2, R2, #0x8									;Mask all bits of R2 except P3 
	ORR	R1, R1, R2									  ;Align P3 in codeword
	
	; Generate parity bit P4 using following bits in R1
	; P4-->8,9,10,11,12,13,14,15,24,25,26,27,28,29,30,31
	
	EOR	R2, R1, R1, LSR #1							
	EOR	R2, R2, R2, LSR #2						
	EOR	R2, R2, R2, LSR #4					
	EOR	R2, R2, R2, LSR #16					
	AND	R2, R2, #0x80								  ;Mask all bits of R2 except P4 
	ORR	R1, R1, R2									  ;Align P4 in codeword
	
	; Generate parity bit P5 using following bits in R1
	; P5-->16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31
	
	EOR	R2, R1, R1, LSR #1							
	EOR	R2, R2, R2, LSR #2						
	EOR	R2, R2, R2, LSR #4						
	EOR	R2, R2, R2, LSR #8						
	AND	R2, R2, #0x8000							  ;Mask all bits of R2 except P5 
	ORR	R1, R1, R2									  ;Align P5 in codeword
	
	;save the register contents in R8,R9 so that they are not lost while printing
	MOV R8,R1
	MOV R9,R0
	BL print_encoded
	MOV R0,R8
	BL printMsg
	
	;Move the register contents back to R0,R1
	MOV R1,R8
	MOV R0,R9
	MOV R11,R1
	; 31 bit codeword in R1 with parity bits is generated.

	; Introduce a single bit error by flipping any bit in R1
	EOR	R1,R1, #0x4							      ;Flip bit 3 to test
	MOV R8, R1
	MOV R9,R0
	MOV R0,R8
	BL print_error_before
	
	MOV R1,R8
	MOV R0,R9
	; Error detection using check parity bits C1-C5

	; Generate  check parity bit C1 using following bits in R1
	; C1-->1,3,5,7,9,11,13,15,17,19,21,23,25,27,29,31

	EOR	R2, R1, R1, LSR #2
	EOR	R2, R2, R2, LSR #4						
	EOR	R2, R2, R2, LSR #8						
	EOR	R2, R2, R2, LSR #16
	AND	R2, R2, #0x1									;Mask all bits of R2 except C1 

	; caculate error bit position by performing C1*1 + C2*2 + C3*4 + C4*8 + C5*16
	; R10 contains bit error position
	
	MOV R10, R2										    ; R10 = C1*1
	
	; Generate  check parity bit C2 using following bits in R1
	; C2-->2,3,6,7,10,11,14,15,18,19,22,23,26,27,30,31

	EOR	R2, R1, R1, LSR #1							
	EOR	R2, R2, R2, LSR #4						
	EOR	R2, R2, R2, LSR #8						
	EOR	R2, R2, R2, LSR #16
	AND	R2, R2, #0x2									;Mask all bits of R2 except C2 
						
	ADD R10, R10, R2									; R0 = C1*1 + C2*2 
	
	; Generate parity bit C3 using following bits in R1
	; C3-->4,5,6,7,12,13,14,15,20,21,22,23,28,29,30,31

	EOR	R2, R1, R1, LSR #1							
	EOR	R2, R2, R2, LSR #2						
	EOR	R2, R2, R2, LSR #8						
	EOR	R2, R2, R2, LSR #16						
	AND	R2, R2, #0x8									;Mask all bits of R2 except C3 
	
	MOV R2,R2,LSR #1								
  ADD R10, R10, R2								  ; R10 = C1*1 + C2*2 + C3*4 

	; Generate parity bit C4 using following bits in R1
	; C4-->8,9,10,11,12,13,14,15,24,25,26,27,28,29,30,31
	
	EOR	R2, R1, R1, LSR #1							
	EOR	R2, R2, R2, LSR #2						
	EOR	R2, R2, R2, LSR #4						
	EOR	R2, R2, R2, LSR #16						
	AND	R2, R2, #0x80								;Mask all bits of R2 except C4 

	MOV R2,R2,LSR #4
	ADD R10, R10, R2								; R10 = C1*1 + C2*2 + C3*4 + C4*8 

	; Generate parity bit C5 using following bits in R1
	; C5-->16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31

	EOR	R2, R1, R1, LSR #1							
	EOR	R2, R2, R2, LSR #2						
	EOR	R2, R2, R2, LSR #4						
	EOR	R2, R2, R2, LSR #8						
	AND	R2, R2, #0x8000							  ;Mask all bits of R2 except C5

	MOV R2,R2,LSR #11
	ADD R10, R10, R2									; R10 = C1*1 + C2*2 + C3*4 + C4*8 + C5*16

	; correct the bit which is flipped
	
	CMP R10,#0
	BGT correction
  B print
correction 	MOV R3,#1
				SUB R10,R10,#1
				LSL R3,R3,R10
				EOR R1,R1,R3  						  ;R1 contains the corrected hamming codeword
				
				;save the register contents in R8,R9 so that they are not lost while printing
print		MOV R8,R1
				MOV R9,R0
				BL print_errorcorrection
				MOV R0,R8
				BL printMsg
				
				;Move the register contents back to R0,R1
				MOV R1,R8
				MOV R0,R9
			
				CMP R1,R11
				BEQ stop
				BNE printerror
printerror   BL print_error_msg
stop B stop
	 ENDFUNC
     END
