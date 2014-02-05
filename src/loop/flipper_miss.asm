; ---[ FLIPPER MISS ]---------------------
; Should be called whenever the ball gets below racket

FlipperNoHit:
		LDX p1_score
		INX
		STX p1_score
		TXA
		CMP #10
		BCS @p1_two_digits
		;@p1_one_digit
			CLC
			ADC #$10
			STA p1_score_tile
			JMP WaitForUser
		@p1_two_digits:
			JSR SplitDigits
			
			CLC
			ADC #$10
			STA p1_score_tile ; low digit
			
			TXA
			CLC
			ADC #$10
			LDY #4 ;offset for high digit			
			STA p1_score_tile, Y ; high digit
			
			JMP WaitForUser
		

		
	; Input: 	A = two-digit input
	; Output: 	X = high digit
	;			A = low digit
	SplitDigits:
		LDX #0
		@check_again:
			INX	
			SEC
			SBC #10
			CMP #10
			BCS @check_again
		RTS		
	
	

; ----------------------------------------


; ---[ WAITS FOR THE USER TO PUSH 'A' ]---
WaitForUser:
		LDA #1
		STA panic_mode
		LDA #1
		STA PLAYER1
		STA PLAYER2
		LDA #0
		STA PLAYER1
		STA PLAYER2
		
		LDA PLAYER1 ; A
		AND #1
		BNE @end_of_wait
		
		LDA PLAYER2 ; A
		AND #1
		BNE @end_of_wait
		
		JMP WaitForUser
	@end_of_wait:
		
		; -[DISABLE PANIC MODE]-
		LDA #0
		STA panic_mode 
		
		; -[RE-INITIALIZE GAME]
		
			; -[INIT BALL POSITION]-
			LDA #50
			STA ball_x
			LDA racket_pos
			STA ball_y
		
			; -[INIT BALL X VECTOR]-
			LDA #2
			STA x_vector
			
			JMP @init_y_vector

		@init_y_vector:	
			LDA ball_y
			CMP #116
			BCS @ball_rise
			
			@ball_fall:
				LDA #1
				JMP :+
			@ball_rise:
				LDA #-1
			:	
			STA y_vector
		JMP MainLoop
; ----------------------------------------
	
	; La det stå "Player X is victorious!!" elns når player X vinner