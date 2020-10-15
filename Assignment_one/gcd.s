     AREA     appcode, CODE, READONLY
     EXPORT __main
     ENTRY 

__main  FUNCTION
	
	MOV R1 , #98  		; take any 2  numbers
					
	MOV R2 , #56
					
	LDR  R3, =0x20000000	; address to store result
					
loop	CMP   R1, R2		; check whether 1st no. is higher than 2nd no. or not

	SUBGT R1, R1, R2
					
	SUBLT R2, R2, R1
					
	BNE loop		; Till both numbers are equal , keep on subtracting lower no. from higher no.
					
	STR   R1, [R3]		
						
stop b stop

     ENDFUNC

     END
		 
		
