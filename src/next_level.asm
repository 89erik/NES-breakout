NextLevel:
	; Hold ball
	LDA #TRUE
    STA holding_ball
	
	; Hide ball (while scrolling)
	LDA #$FF
	STA ball_x
	STA ball_y

	; Reset racket width to default
	LDA #RACKET_START_WIDTH
    STA racket_width
    JSR DrawRacket
	
	; Load next level into next nametable
    LDX level
    INX
    CPX levels_n
    BCS @end_if_level_overflow ; TODO this doesn't work as it should
        STX level
    @end_if_level_overflow:
    JSR SetAndLoadLevel
    LDA #TRUE
    JSR DrawLevel

	; Scroll to next nametable
	@scroll:
        LDA scroll
        CMP #$FF
        BEQ @done_scrolling
        CLC
        ADC #SCROLL_SPEED
        BCC @no_overflow
            LDA #$FF
        @no_overflow:
        STA scroll
        LDX #1
        JSR Sleep
        JMP @scroll
	@done_scrolling:
	@set_to_next_nametable:
		LDA #0
		STA scroll
		LDA ppu_ctrl_1
        EOR #%00000001
        STA ppu_ctrl_1
	RTS
