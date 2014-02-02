
; ---[ FLIPPER MISS ]---------------------
FlipperNoHit:
		LDY last_racket_hit
		CPY #1
		BEQ @p1_win
		CPY #-1
		BEQ @p2_win
		;JMP PanickMode
	@p1_win:
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
		
	@p2_win:
		LDX p2_score
		INX
		STX p2_score
		TXA
		CMP #10
		BCS @p2_two_digits
		;@p2_one_digit
			CLC
			ADC #$10
			STA p2_score_tile
			JMP WaitForUser
		@p2_two_digits:
			JSR SplitDigits			
			
			CLC
			ADC #$10
			STA p2_score_tile ; low digit
			
			TXA
			CLC
			ADC #$10
			LDY #4 ;offset for high digit			
			STA p2_score_tile, Y ; high digit
			
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
		STA panick_mode
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
		
		; -[DISABLE PANICK MODE]-
		LDA #0
		STA panick_mode 
	
		; -[SET BG COLOR]-
		LDA #$3F
		STA PPU_ADRESS
		LDA #$00
		STA PPU_ADRESS
		LDA #BG_COLOR
		STA PPU_VALUE
		

		
		CPY #1
		BEQ @p2_start
		
		@p1_start:
			; -[INIT BALL POSITION]-
			LDA #50
			STA ball_x
			LDA left_racket_pos
			STA ball_y
		
			; -[INIT BALL X VECTOR]-
			LDA #2
			STA x_vector
			
			; -[INIT SCROLL DIRECTION]-
			LDA #$00
			STA scroll_direction
			
			JMP @init_y_vector
			
		
		@p2_start:
			; -[INIT BALL POSITION]-
			LDA #200
			STA ball_x
			LDA right_racket_pos
			STA ball_y
		
			; -[INIT BALL X VECTOR]-
			LDA #-2
			STA x_vector
			
			; -[INIT SCROLL DIRECTION]-
			LDA #$FF
			STA scroll_direction
			
			;JMP @init_y_vector
			
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