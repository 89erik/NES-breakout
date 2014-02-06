; ---[ RACKET PLACEMENT ]---
; Writes the racket placement to OAM
	LDX #0 ; offset
	LDY #0 ; offset x4
RacketPlacement:
	; -[X-COORDINATE]-
	LDA racket_pos
	CPX #1
	BEQ @add_one
	CPX #2
	BEQ @add_two
	JMP @finished_adding
	
	@add_one:
		CLC
		ADC #SPRITE_SIZE
		JMP @finished_adding
	@add_two:
		CLC
		ADC #SPRITE_SIZE*2
	@finished_adding:
	STA player_x, Y
	
	; -[Y-COORDINATE]-
	LDA #RACKET_Y
	STA player_y, Y
	
	INX
	TXA
	ASL
	ASL ; y = x *4
	TAY
	
	CPX #3
	BNE RacketPlacement

	
		
; ---[ RACKET INPUT ]---
; Updates racket position according to input from player

@racket_input:
		; Signal controller for read
		LDA #1
		STA PLAYER1_CTRL
		LDA #0
		STA PLAYER1_CTRL
		
		; Read controller, sequence is as follows:
		; A, B, Select, Start, Up, Down, Left, Right
		LDA PLAYER1_CTRL ; A
		LDA PLAYER1_CTRL ; B
		LDA PLAYER1_CTRL ; Select
		LDA PLAYER1_CTRL ; Start
		LDA PLAYER1_CTRL ; Up
		LDA PLAYER1_CTRL ; Down
		
	; -[CHECK LEFT BUTTON]-
		LDA PLAYER1_CTRL ; Left
		AND #1
		BEQ @right_button
		LDA racket_pos
		SEC
		SBC #4
		CMP #RIGHT_WALL+1
		BCC @left_move_in_bounds ; A < RIGHT == A >= 0
		LDA #LEFT_WALL
	@left_move_in_bounds:
		STA racket_pos

		JMP @end_of_task
	
	; -[CHECK RIGHT BUTTON]-
	@right_button:
		LDA PLAYER1_CTRL ; Right
		AND #1
		BEQ @end_of_task
		LDA racket_pos
		CLC
		ADC #4
		CMP #RIGHT_WALL - RACKET_WIDTH + SPRITE_SIZE
		BCC @right_move_in_bounds
		LDA #RIGHT_WALL - RACKET_WIDTH + SPRITE_SIZE
	@right_move_in_bounds:
		STA racket_pos
		
	@end_of_task:
