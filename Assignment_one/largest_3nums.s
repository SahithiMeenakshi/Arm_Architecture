     AREA     appcode, CODE, READONLY
     EXPORT __main
     ENTRY 

__main  FUNCTION
	
	MOV R1 , #0x05  	; to check among 3 numbers
					
	MOV R2 , #0x04
					
	MOV R3 , #0x06
					
	LDR  R4, =0x20000000	; address to store result
					
	CMP   R1, R2		; check whether 1st no. is higher than 2nd no. or not

	BHI   loopa		; If so, then compare 1st no. with 3rd no.
					
	MOV  R1, R2		; Else move the highest no. into  R1 for further comparision
					
loopa 	CMP  R1, R3

	BHI  loopb
					
	MOV  R1, R3
					
loopb	STR   R1, [R4]
						
stop b stop

     ENDFUNC

     END
		 
		
