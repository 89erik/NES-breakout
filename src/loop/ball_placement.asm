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
		BCC @hit_left_wall
		CPX #RIGHT_WALL
		BCS @hit_right_wall
		; else
		JMP TestEdgeY
		
		@hit_left_wall:
			LDY #-1
			JMP @wall_hit
		@hit_right_wall:
			LDY #1
			JMP @wall_hit

		
	@wall_hit: 

	; -[RACKET HIT]-
		
	; -[CHECK AND SET PANIC MODE]-
		LDA panic_mode
		CMP #1
		BEQ @end_of_panic_check
		
		;LDX hit_count
		;INX
		;STX hit_count
		CPX #5
		JMP @end_of_panic_check ;BCC @end_of_panic_check ; X<5					;PANIC MODE DISABLED
		LDA #1
		STA panic_mode ; Enable panic mode
	@end_of_panic_check:
		
	; INVERT X-VECTOR
	LDA #0
	SEC
	SBC x_vector
	STA x_vector
	JMP @end_of_task ; JMP to TestEdgeY?
		
		
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
	CPY #FLOOR
	BCS @floor_hit ; y >= 232
	CPY #ROOF
	BEQ @roof_hit
	JMP @end_of_task ; No hit
	
@roof_hit:
	LDA #0
	SEC
	SBC y_vector
	STA y_vector
	JMP @end_of_task

@floor_hit:
	JSR CheckHitFlipper
	LDA delta_racket_hit
	CMP #$FF
	BEQ FlipperNoHit ; NO HIT (breaks loop)



	
@end_of_task:
