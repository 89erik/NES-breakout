; ---[ MOVE BALL ]---
	; -[UPDATE X]-
	LDA ball_x
	CLC
	ADC x_vector
	TAX
	STA ball_x
	STA ball_x ; update OAM
	
	; -[UPDATE Y]-
	LDA ball_y
	CLC
	ADC y_vector
	TAY
	STA ball_y
	STA ball_y ; update OAM	
	
	
	
	
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

		
	; -[CHECK IF BALL WAS CAUGHT BY A RACKET]-
	@wall_hit: 
		JSR CheckHitFlipper
		LDA delta_racket_hit
		CMP #$FF
		BEQ FlipperNoHit ; NO HIT (breaks loop)

	; -[RACKET HIT]-
		
	; -[CHECK AND SET PANICK MODE]-
		LDA panick_mode
		CMP #1
		BEQ @end_of_panick_check
		
		LDX hit_count
		INX
		STX hit_count
		CPX #5
		JMP @end_of_panick_check ;BCC @end_of_panick_check ; X<5					;PANIC MODE DISABLED
		LDA #1
		STA panick_mode ; Enable panick mode
	@end_of_panick_check:
		
		
		
	; -[UPDATE Y-VECTOR]-
		LDA delta_racket_hit_positive
		CMP #1
		BEQ @negative_vector
		
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
; -------------------------------
		
		
	
	
	; -[HIT ROOF OR FLOOR?]-
TestEdgeY:
	CPY #232
	BCS @roof_floor_hit ; y >= 232
	CPY #0
	BEQ @roof_floor_hit
	
	JMP MainLoop ; No hit
	
	
	; ---[ROOF/FLOOR HIT]---
@roof_floor_hit:
	LDA #0
	SEC
	SBC y_vector
	STA y_vector
	JMP MainLoop