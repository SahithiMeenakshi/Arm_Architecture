     AREA     appcode, CODE, READONLY
     EXPORT __main
     ENTRY 

__main  FUNCTION		         

	MOV R0,#0x00  		; entering first 2 fibonacci series numbers as 0,1

	MOV R1,#0x01   

	MOV R2,#0x05 		; count of series to be generated

	MOV   R3, #0x20000000 	; to store the values in this address

loop    ADD R0,R1
			
	STR  R0, [R3] 		; in R0 series can be observed
			
	ADD  R3,#0x04 		; to go to next address which is byte addressable
			
	MOV  R4,R0
			
	MOV R0,R1
			
	MOV R1,R4
			
	SUB  R2,#0x01 		; decrement the counter till 0
			
	CMP  R2,#0x00
			
	BNE loop
			 
stop b stop

     ENDFUNC

     END
