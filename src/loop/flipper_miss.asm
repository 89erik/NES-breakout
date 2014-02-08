; ---[ FLIPPER MISS ]---------------------
; Should be called whenever the ball gets below racket

FlipperNoHit:
		LDX p1_score
		INX
		STX p1_score
		TXA
		CMP #10
		BCS @p1_two_digits
		@p1_one_digit:
			CLC
			ADC #$10
			STA p1_score_tile
			JMP @flipper_missed
		@p1_two_digits:
			JSR @split_digits
			
			CLC
			ADC #$10
			STA p1_score_tile ; low digit
			
			TXA
			CLC
			ADC #$10
			LDY #4 				 ;offset for high digit			
			STA p1_score_tile, Y ; high digit
			
			JMP @flipper_missed
		

		
	; Input: 	A = two-digit input
	; Output: 	X = high digit
	;			A = low digit
	@split_digits:
		LDX #0
		@check_again:
			INX	
			SEC
			SBC #10
			CMP #10
			BCS @check_again
		RTS		

	@flipper_missed:
		LDA #TRUE
		STA holding_ball
		RTS
