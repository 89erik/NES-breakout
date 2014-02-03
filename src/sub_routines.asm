; ------------------------------------------------- ;
; -----------[ GENERAL SUB-ROUTINES ]-------------- ;
; ------------------------------------------------- ;
; This file contains some general sub-routines		;
; used at several parts of the system				;
; ------------------------------------------------- ;


LoadLevel:
	; TODO
	RTS
	
	
	
; Compares two numbers 'x' and 'y', passed by stack,
; where 'x' is pushed before 'y'.
;SignedComparison:
;	PLA						; Pull second argument
;	JSR SignedIsNegative
;	TAY						; Y <- negative(A)
	
;	PLA						; Pull first argument
;	JSR SignedIsNegative
;	TAX						; X <- negative(A)
		
;	CPX #0
;	BEQ @x_negative	

;	@x_negative:
;	RTS
	
; Is A negative?
; Yes: A <- 0
; No:  A <- 1
SignedIsNegative:
	CMP #LOWEST_SIGNED
	BCC @positive
	;@negative:
		LDA #0
		RTS
	@positive:
		LDA #1
		RTS

; A <- abs(A)
AbsoluteValue:
	STA sub_routine_tmp
	JSR SignedIsNegative
	BNE @end_of_sub_routine
		LDA #0
		CLC
		SBC sub_routine_tmp
	@end_of_sub_routine:
		RTS
	
; A <- A/2	
; Arithmetic Shift Right
ASR:
	PHA
	JSR SignedIsNegative
	BNE @positive
	@negative:
		PLA
		TAX
		CMP #-1
		BEQ @minus_one
		AND #%10000000
		BEQ @no_s_bit_preservation
		@s_bit_preservation:
			TXA
			LSR A
			ORA #%10000000
			RTS
		@minus_one:
			LDA #0
			RTS
		@no_s_bit_preservation:
			TXA
			LSR A
			RTS
	@positive:
		PLA
		LSR A
		RTS




