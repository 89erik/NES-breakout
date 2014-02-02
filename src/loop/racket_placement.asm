; ---[ RIGHT RACKET PLACEMENT ]---
	LDX #0 ; offset
	LDY #0 ; offset x4
RightRacket:
	; -[Y-KOORDINAT]-
	LDA right_racket_pos
	
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
	STA right_racket_y, Y
	

	; -[X-KOORDINAT]-
	LDA #250
	STA right_racket_x, Y
	
	INX
	TXA
	ASL
	ASL ; y = x *4
	TAY
	
	CPX #3
	BNE RightRacket
	

	
; ---[ LEFT RACKET PLACEMENT ]---
	LDX #0 ; offset
	LDY #0 ; offset x4
LeftRacket:
	; -[Y-KOORDINAT]-
	LDA left_racket_pos
	
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
	STA left_racket_y, Y
	
	; -[X-KOORDINAT]-
	LDA #0
	STA left_racket_x, Y
	
	INX
	TXA
	ASL
	ASL ; y = x *4
	TAY
	
	CPX #3
	BNE LeftRacket
	
	
	
	
	
	
	
		
; ---[RIGHT RACKET INPUT ]---
RightRacketInput:
		;A, B, Select, Start, Up, Down, Left, Right
		LDA #1
		STA PLAYER2
		LDA #0
		STA PLAYER2
		LDA PLAYER2 ; A
		LDA PLAYER2 ; B
		LDA PLAYER2 ; Select
		LDA PLAYER2 ; Start
		
		; -[CHECK UP BUTTON]-
		LDA PLAYER2 ; Up
		CMP #$41
		BNE @not_up
		LDA right_racket_pos
		SEC
		SBC #4
		CMP #214 ; 232 - 18
		BCC @up_not_OOR ; A < 232
		LDA #0
	@up_not_OOR:
		STA right_racket_pos

		JMP @end_of_task
		
	@not_up:
		; -[CHECK DOWN BUTTON]-
		LDA PLAYER2 ; Down
		CMP #$41
		BNE @end_of_task
		LDA right_racket_pos
		CLC
		ADC #4
		CMP #214 ; 232 - 18
		BCC @down_not_OOR ; A < 232
		LDA #214 ; 232 - 18
	@down_not_OOR:
		STA right_racket_pos
		
	@end_of_task:
	
	

	
; ---[LEFT RACKET INPUT ]---
LeftRacketInput:
		;A, B, Select, Start, Up, Down, Left, Right
		LDA #1
		STA PLAYER1
		LDA #0
		STA PLAYER1
		
		LDA PLAYER1 ; A
		LDA PLAYER1 ; B
		LDA PLAYER1 ; Select
		LDA PLAYER1 ; Start
		
		; -[CHECK UP BUTTON]-
		LDA PLAYER1 ; Up
		CMP #$41
		BNE @not_up
		LDA left_racket_pos
		SEC
		SBC #4
		CMP #214 ; 232 - 18
		BCC @up_not_OOR ; A < 232
		LDA #0
	@up_not_OOR:
		STA left_racket_pos
		JMP @end_of_task
		
	@not_up:
		; -[CHECK DOWN BUTTON]-
		LDA PLAYER1 ; Down
		CMP #$41
		BNE @end_of_task
		LDA left_racket_pos
		CLC
		ADC #4
		CMP #214 ; 232 - 18
		BCC @down_not_OOR ; A < 232
		LDA #214 ; 232 - 18
	@down_not_OOR:
		STA left_racket_pos
		
	@end_of_task:
		
		