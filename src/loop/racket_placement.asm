; ---[ RACKET PLACEMENT ]---
; Writes the racket placement to OAM
	LDX #0 ; offset
	LDY #0 ; offset x4
RacketPlacement:	; previous "RightRacket"
	; -[X-COORDINATE]-
	LDA racket_pos
	
	CPX #1
	BEQ @add_one
	CPX #2
	BEQ @add_two
	JMP @finished_adding
	
	@add_one:
		CLC
		ADC #8
		JMP @finished_adding
	@add_two:
		CLC
		ADC #16
	@finished_adding:
	STA player_x, Y
	

	; -[Y-COORDINATE]-
	LDA #250
	STA player_y, Y
	
	INX
	TXA
	ASL
	ASL ; y = x *4
	TAY
	
	CPX #3
	BNE RacketPlacement
	

	
		
; ---[RIGHT RACKET INPUT ]---
; Updates racket position according to input from player

;RightRacketInput:
		; Signal controller to be read
		LDA #1
		STA PLAYER1
		LDA #0
		STA PLAYER1
		
		; Read controller, sequence is as follows:
		; A, B, Select, Start, Up, Down, Left, Right
		LDA PLAYER1 ; A
		LDA PLAYER1 ; B
		LDA PLAYER1 ; Select
		LDA PLAYER1 ; Start
		LDA PLAYER1 ; Up
		LDA PLAYER1 ; Down
		
	; -[CHECK LEFT BUTTON]-
		LDA PLAYER1 ; Up
		CMP #$41
		BNE @right_button
		LDA racket_pos
		SEC
		SBC #4
		CMP #214 ; 232 - 18
		BCC @up_not_OOR ; A < 232
		LDA #0
	@up_not_OOR:
		STA racket_pos

		JMP @end_of_task
	
	; -[CHECK RIGHT BUTTON]-
	@right_button:
		LDA PLAYER1 ; Down
		CMP #$41
		BNE @end_of_task
		LDA racket_pos
		CLC
		ADC #4
		CMP #214 ; 232 - 18
		BCC @down_not_OOR ; A < 232
		LDA #214 ; 232 - 18
	@down_not_OOR:
		STA racket_pos
		
	@end_of_task:
