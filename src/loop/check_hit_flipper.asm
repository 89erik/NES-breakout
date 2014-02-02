; ------ [ FUNCTION CHECK HIT FLIPPER ] ------
; Returns offset in delta_racket_hit
; $FF means no hit
; On call, Y should contain data for which 
; racket should be checked for.
; Y = -1 means left racket
; Y = 1 means right racket
CheckHitFlipper:
		STY last_racket_hit

		CPY #-1
		BEQ @left_racket
		CPY #1
		BEQ @right_racket
		
	@left_racket:
		LDA left_racket_pos
		STA <racket
		JMP @racket_selected
	@right_racket:
		LDA right_racket_pos
		STA <racket
		;JMP @racket_selected
	@racket_selected:

		; -[SET UPPER LIMIT]-
		LDA racket
		SEC
		SBC #4
		CMP #233
		BCC @top_limit_set
		LDA #0
	@top_limit_set:
		TAX
		; -[SET LOWER LIMIT]-
		LDA racket
		CLC
		ADC #28
		CMP #233
		BCC @low_limit_set
		LDA #232 ; if (a>232)
	@low_limit_set:
		TAY
		
	; -[TEST UPPER LIMIT]-
		CPX ball_y
		BCS @no_hit ; if (X >= pos), (pos < X)
		
	; -[TEST LOWER LIMIT]-
		CPY ball_y
		BEQ @racket_hit
		BCC @no_hit ; if (Y <= pos), (pos > Y)
		
	; -[HIT]-
	@racket_hit:
		;set scroll
		LDA scroll_direction
		EOR #$FF
		STA scroll_direction
	
		LDA ball_y
		SEC
		SBC racket
		CMP #8
		BCC @high_hit ; ballpos < sweet_spot
		CMP #17
		BCS @low_hit ; ballpos > sweet_spot
	
	;RacketHitSweetSpot
		LDA #0
		JMP @hit_check_complete
	@high_hit:
		LDA #1
		STA delta_racket_hit_positive
		JMP @hit_check_complete
	@low_hit:
		LDA #0
		STA delta_racket_hit_positive
		LDA #1
		;JMP @hit_check_complete
		
	@hit_check_complete:	
		STA delta_racket_hit
		JMP @end_of_sub_routine
		
	@no_hit:
		LDA #$FF
		STA delta_racket_hit

	@end_of_sub_routine:
		RTS ; return