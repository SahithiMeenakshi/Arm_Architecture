   area     appcode, CODE, READONLY
   export __main
   ENTRY 
__main  function		 

		VLDR.F32 s0, =3		;input value of x
		VLDR.F32 s1, =1		;num--> to store multiplication product			
		MOV R3 , #1    		;n value
		MOV R2 , #2		;to divide n by 2 and check it being odd/even
		LDR R6,=0		;
		VMOV s6,R6
		VCVT.F32.U32 s6,s6 	; result is stored in s6

outerloop       VMUL.F32 s1, s1, s0	; num =num*x-->inner loop for number of iterations
		VMOV s3, R3
		VCVT.F32.U32 s3,s3					
		VDIV.F32 s5, s1, s3 	; x^n/n
		UDIV  R4 , R3 , R2 	; To find quotient
		MLS   R4, R4, R2, R3	; To find remainder	
		CMP  R4,#0 		; Compare remainder with zero
		
		BNE loop
		BEQ loop1
loop		VADD.F32 s6, s6 , s5	; addition of all odd power terms with previous result
		B loop2

loop1		VSUB.F32 s6, s6 , s5	; subtraction of all even power terms with previous result

loop2		ADD R3,R3, #1
		CMP R3, #15		;number of iterations (R3-1)--> running this series for 14 times
		BLT outerloop					
stop B stop
   endfunc
   end
