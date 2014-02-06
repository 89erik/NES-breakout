BallPlacement:
	@move_ball:
		; -[UPDATE X]-
		LDA ball_x		; Load x position
		CLC				; Clear carry bit
		ADC x_vector	; Add vector to position
		TAX				; Copy A to X
		STA ball_x 		; Update OAM
		
		; -[UPDATE Y]-
		LDA ball_y		; Load y position
		CLC				; Clear carry bit
		ADC y_vector	; Add vector to position
		TAY				; Copy A to X
		STA ball_y 		; Update OAM	
	
	
	; ---[ HIT ONE OF THE WALLS? ]---
	@check_x_edge:
		CPX #LEFT_WALL
		BCC @wall_hit
		CPX #RIGHT_WALL
		BCS @wall_hit
		JMP @check_y_edge

		@wall_hit:
			LDA #0
			SEC
			SBC x_vector
			STA x_vector ; Inverts x_vector
			JMP @end_of_task ; JMP to @check_y_edge?

		
		; -[HIT ROOF OR FLOOR?]-
	@check_y_edge:
		LDA y_vector
		JSR SignedIsNegative	; Check if y-vector is negative
		BEQ @ball_moves_upward

		@ball_moves_downward:
			LDA ball_y
			CMP #RACKET_Y-SPRITE_SIZE
			BCS @check_racket ; greater or equal
			JMP @end_of_task ; No hit
		
		@ball_moves_upward:
			LDA ball_y
			CMP #ROOF
			BEQ @invert_y_vector
			CMP #FLOOR+1	; Past roof, underflow
			BCS @invert_y_vector
			JMP @end_of_task; No hit
	
		@check_racket:
			CMP #RACKET_Y-SPRITE_SIZE + 1 + RACKET_MISS_TOLERANCE_Y
			BCS @past_racket
			
			JSR CheckHitFlipper ; A <- diff(ball, racket)
			STA tmp				; Pushes diff(ball, racket)
			JSR AbsoluteValue	; A <- abs(diff)
			CMP #(RACKET_WIDTH/2)+1+RACKET_MISS_TOLERANCE_X ; Hit?
			BCS @end_of_task	; No hit (ignores for now)
			LDA tmp				; Pulls diff(ball, racket)
			JSR ASR				; Reduce diff
			JSR ASR				; Reduce diff
			JSR ASR				; Reduce diff
			
			CLC
			ADC x_vector
			STA x_vector
			JMP @invert_y_vector

		
		@past_racket:
			; Ball is below racket limit, reached bottom yet?
			CMP #FLOOR+SPRITE_SIZE
			BCS FlipperNoHit ; NO HIT (breaks loop)
			JMP @end_of_task
			
		@invert_y_vector:
			; Bounce ball
			LDA #0
			SEC
			SBC y_vector
			STA y_vector
			JMP @end_of_task

	
@end_of_task:
