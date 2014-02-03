; ---[ MOVE BALL ]---
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
		CPX #LEFT_WALL
		BCC @wall_hit
		CPX #RIGHT_WALL
		BCS @wall_hit
		JMP TestEdgeY

		@wall_hit:
			LDA #0
			SEC
			SBC x_vector
			STA x_vector ; Inverts x_vector
			JMP @end_of_task ; JMP to TestEdgeY?
		
	; -[CHECK AND SET PANIC MODE]-
;		LDA panic_mode
;		CMP #1
;		BEQ @end_of_panic_check
;		
;		;LDX hit_count
;		;INX
;		;STX hit_count
;		CPX #5
;		JMP @end_of_panic_check ;BCC @end_of_panic_check ; X<5					;PANIC MODE DISABLED
;		LDA #1
;		STA panic_mode ; Enable panic mode
;	@end_of_panic_check:
		
		
		
; THIS IS SOME WIERD STUFF. SKIP EVERYTHING. REMOVE LATER UNLESS NEEDED.
JMP @end_of_wierd_stuff
	; -[UPDATE Y-VECTOR]-
		;LDA delta_racket_hit_positive
		;CMP #1
		;BEQ @negative_vector
		
	;@positive_vector
		LDA y_vector
		CLC
		ADC delta_racket_hit
		
		;CMP #10 				; KONSTANT.MAX_Y_VECTOR
		;BCC @size_ok
		;LDA #10					; KONSTANT.MAX_Y_VECTOR
		;JMP @size_ok
		
	@negative_vector:
		LDA y_vector
		SEC
		SBC delta_racket_hit
		;CMP #-10				; KONSTANT.MIN_Y_VECTOR
		;BCS @size_ok
		;LDA #-10				; KONSTANT.MIN_Y_VECTOR
		JMP @size_ok

	@size_ok:
		STA y_vector
		
		LDA #0
		SEC
		SBC x_vector
		STA x_vector
		JMP TestEdgeY
@end_of_wierd_stuff:
		
		
	
	
	; -[HIT ROOF OR FLOOR?]-
TestEdgeY:
	LDA y_vector
	JSR SignedIsNegative	; Check if y-vector is negative
	BEQ @ball_moves_upward

	@ball_moves_downward:
		LDA ball_y
		CMP #RACKET_Y
		BCS @floor_hit ; greater or equal
		JMP @end_of_task ; No hit
	
	@ball_moves_upward:
		LDA ball_y
		CMP #ROOF	; y = 0
		BEQ @invert_y_vector
		CMP #FLOOR+1
		BCS @invert_y_vector
		JMP @end_of_task ; No hit
	
@floor_hit:
	JSR CheckHitFlipper
	LDA delta_racket_hit
	JSR AbsoluteValue
	CMP #(RACKET_WIDTH/2)+1
	BCS FlipperNoHit ; NO HIT (breaks loop)
	LDA delta_racket_hit
	JSR ASR
	
	CLC
	ADC x_vector
	STA x_vector
	;JMP @invert_y_vector
	
@invert_y_vector:
	LDA #0
	SEC
	SBC y_vector
	STA y_vector
	JMP @end_of_task

@end_of_task:
