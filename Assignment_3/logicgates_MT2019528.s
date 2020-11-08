   PRESERVE8
   area     appcode, CODE, READONLY
   export __main
   import print_logicgate
   import print_heading
   import print_not_heading
   import print_not_input
   import print_inputs
   import print_output

   ENTRY 
__main  function

					MOV R1, #0						;input X1
					MOV R2, #0						;input X2
					MOV R3, #0						;input X3
					MOV R4, #1						;To choose the logic operation 

					;1 - AND
					;2 - OR
					;3 - NOT
					;4 - XOR
					;5 - XNOR
					;6 - NAND
					;7 - NOR

					MOV R9, #0
					MOV R10,#0

conversion	VMOV.F32 s2,R1				;converting inputs to floating point values into s2, s4, s8
					VCVT.F32.U32 s2,s2		
					VMOV.F32 s4,R2
					VCVT.F32.U32 s4,s4
					VMOV.F32 s8,R3
					VCVT.F32.U32 s8,s8

 ;----------------------------------------------------------------------------------------------------------------------
 ;Implementation of switch case (case1-case7,default) depending on input from R4
 ;----------------------------------------------------------------------------------------------------------------------

case1	 	    CMP R4, #1						
					BNE case2
					BL AND_logic					;result is stored in R0 for printing and then moved to R5  
					B start_printing

case2			CMP R4, #2						
					BNE case3
					BL OR_logic		  
					B start_printing

case3	 		CMP R4, #3						
					BNE case4
					BL NOT_logic		  
					B start_printing

case4	 		CMP R4, #4						
					BNE case5
					BL XOR_logic		
				    B start_printing

case5	 		CMP R4, #5						
					BNE case6
					BL XNOR_logic		  
					B start_printing

case6	 		CMP R4, #6						
					BNE case7
					BL NAND_logic		  
					B start_printing

case7	 		CMP R4, #7						
					BNE default
					BL NOR_logic		  
					B start_printing

default			B stop								;this is to exit by default

 ;-----------------------------------------------------------------------------------------------------------------------------------------
 ;changing inputs to traverse from 000-->111 and print output based on given inputs,logic gates
 ;-----------------------------------------------------------------------------------------------------------------------------------------

start_printing	MOV R5,R0			
					MOV R6,R1
					MOV R7,R2
					MOV R8,R3
					CMP R4, #3						;To print results of NOT gate
					BNE input_check
					ADD R10,R10,#1
					CMP R10, #1
					BNE not_input
					MOV R0,R4
					BL print_logicgate
					BL print_not_heading

not_input		MOV R1,R6
					BL print_not_input
					MOV R0,R5
					BL print_output
					MOV R1,R6
					MOV R2,R7
					MOV R3,R8
					CMP R1, #0
					MOV R1, #1
					MOVNE R1, #0
					ADDNE R4,R4, #1
					B conversion

input_check	 ADD R9,R9,#1
					CMP R9, #9
					MOVGE R9, #1
					CMP R9, #1
					BNE inputs
					MOV R0,R4
					BL print_logicgate		 
					BL print_heading

inputs	 		MOV R1,R6
					MOV R2,R7
					MOV R3,R8
					BL print_inputs
					MOV R0,R5
					BL print_output						;prints output of logic gate
					MOV R1,R6
					MOV R2,R7
					MOV R3,R8
					CMP R3, #0
					BNE addin1
					MOV R3,#1
					B conversion

addin1			MOV R3, #0
					CMP R2, #0
					BNE addin2							;change inputs to traverse from 000 to 111
					MOV R2,#1
					B conversion

addin2 			MOV R2, #0
					CMP R1, #0
					MOV R1, #1
					MOVNE R1,#0
					ADDNE R4,R4, #1
					B conversion

   endfunc

 ;-----------------------------------------------------------------------------------------------------------
 ;Implementation of 7 logic gates
 ;-----------------------------------------------------------------------------------------------------------

AND_logic	function

					PUSH{LR}
					VLDR.F32 s9, = 0.5			    ;threshold for sigmoid output
					VLDR.F32 s10, = 0.1			    ;W1
					VLDR.F32 s11, = 0.1			    ;W2
					VLDR.F32 s12, = 0.1				;W3
					VLDR.F32 s13, = -0.2			;Bias
					VMOV.F32 s0,s13					;s0 = Bias
					VFMA.F32 s0,s10,s2				;s0 = Bias + W1*X1
					VFMA.F32 s0,s11,s4				;s0 = Bias + W1*X1 + W2*X2
					VFMA.F32 s0,s12,s8				;s0 = Bias + W1*X1 + W2*X2 + W2*X3
					BL exponent							
					VCMP.F32 s6,s9					;checks if output is > 0.5
					VMRS APSR_nzcv, FPSCR	;converts FPSCR to APSR so that LT,GT can be used
					MOVLE R0, #0						;output = 0 if sigmoid funct3ion result is < 0.5	
					MOVGT R0, #1						;output = 1 if sigmoid function result is > 0.5
					POP{LR}
					BX lr					

		endfunc

OR_logic	function

					PUSH{LR}
					VLDR.F32 s9, = 0.5			    ;threshold for sigmoid output
					VLDR.F32 s10, = 0.2	
					VLDR.F32 s11, = 0.3	
					VLDR.F32 s12, = 0.2	
					VLDR.F32 s13, = -0.1	
					VMOV.F32 s0,s13		
					VFMA.F32 s0,s10,s2	
					VFMA.F32 s0,s11,s4	
					VFMA.F32 s0,s12,s8	
					BL exponent							
					VCMP.F32 s6,s9		
					VMRS APSR_nzcv, FPSCR	
					MOVLE R0, #0		
					MOVGT R0, #1		
					POP{LR}
					BX lr					

		endfunc

NOT_logic	function

					PUSH{LR}
					VLDR.F32 s9, = 0.5			    ;threshold for sigmoid output
					VLDR.F32 s10, = -0.2
					VLDR.F32 s13, = 0.1
					VMOV.F32 s0,s13		
					VFMA.F32 s0,s10,s2
					BL exponent
					VCMP.F32 s6,s9		
					VMRS APSR_nzcv, FPSCR	
					MOVLE R0, #0		
					MOVGT R0, #1
					POP{LR}
					BX lr		

		endfunc

NAND_logic	function

					PUSH{LR}
					VLDR.F32 s9, = 0.5			    ;threshold for sigmoid output
					VLDR.F32 s10, = -0.1	
					VLDR.F32 s11, = -0.1	
					VLDR.F32 s12, = -0.1	
					VLDR.F32 s13, = 0.3	
					VMOV.F32 s0,s13		
					VFMA.F32 s0,s10,s2	
					VFMA.F32 s0,s11,s4	
					VFMA.F32 s0,s12,s8	
					BL exponent							
					VCMP.F32 s6,s9		
					VMRS APSR_nzcv, FPSCR
					MOVLE R0, #0		
					MOVGT R0, #1		
					POP{LR}
					BX lr					

		endfunc

NOR_logic	function

					PUSH{LR}
					VLDR.F32 s9, = 0.5			    ;threshold for sigmoid output
					VLDR.F32 s10, = -0.2	
					VLDR.F32 s11, = -0.3	
					VLDR.F32 s12, = -0.2	
					VLDR.F32 s13, = 0.1	
					VMOV.F32 s0,s13		
					VFMA.F32 s0,s10,s2	
					VFMA.F32 s0,s11,s4	
					VFMA.F32 s0,s12,s8	
					BL exponent							
					VCMP.F32 s6,s9		
					VMRS APSR_nzcv, FPSCR	
					MOVLE R0, #0		
					MOVGT R0, #1		
					POP{LR}
					BX lr					

		endfunc
		
XOR_logic	function

					PUSH{LR}
					VLDR.F32 s9, = 0.7			    ;threshold for sigmoid output
					VLDR.F32 s10, = -10	
					VLDR.F32 s11, = 0.1	
					VLDR.F32 s12, = 0.5	
					VLDR.F32 s13, = 1	
					VMOV.F32 s0,s13		
					VFMA.F32 s0,s10,s2	
					VFMA.F32 s0,s11,s4	
					VFMA.F32 s0,s12,s8	
					BL exponent							
					VCMP.F32 s6,s9		
					VMRS APSR_nzcv, FPSCR	
					MOVLE R0, #0		
					MOVGT R0, #1		
					POP{LR}
					BX lr					

		endfunc

XNOR_logic	function

					PUSH{LR}
					BL XOR_logic
					VMOV.F32 s2,R0
					VCVT.F32.U32 s2,s2
					BL NOT_logic		
					POP{LR}
					BX lr					

		endfunc

 ;-----------------------------------------------------------------------------------------------------------
 ;Implementation of sigmoid function and stores result in s6
 ;-----------------------------------------------------------------------------------------------------------

exponent	function

					PUSH{LR}
					VNEG.F32 s0,s0					;Takes 'x' as input stored in 's0' and negates it so that e^(-x) can be calculated
					VLDR.F32 s1, =1					;num--> to store multiplication product			
					MOV R11 , #1    					;n value
					VLDR.F32 s6, =1					;final sum i.e; result is stored in s6
innerloop       VMUL.F32 s1,s1,s0				; num =num*x-->inner loop for number of iterations

 ;Start of calculating factorial part
					MOV R12, R11
					VLDR.F32 s7, =1					; s7 contains (n)! result
factorialloop	CMP R12, #0
					VMOV s3,R12		
					VCVT.F32.U32 s3,s3
					VMULHI.F32 s7,s3,s7
					SUBHI R12,R12,#1
					BHI factorialloop
 ;End of caclculating factorial part

					VDIV.F32 s5,s1,s7 				; x^n/(n!)
					VADD.F32 s6,s6,s5				; addition with previous result
					ADD R11,R11, #1					;n++
					CMP R11, #101						;number of iterations (R3-1)--> running this series for 100 times
					BLT innerloop
					B sigmoid

 ;Takes 's6' as input ,computes the sigmoid function 1/(1+e^-x) and stores it in 's6'

sigmoid 		VLDR.F32 s1, =1
					VADD.F32 s6,s6,s1
					VDIV.F32 s6,s1,s6
					POP{LR}
					BX lr

		endfunc					

stop B stop												; stop program
   end