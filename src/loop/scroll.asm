; ---[ SET X SCROLL ]---
	LDX x_scroll
	
	LDA scroll_direction
	CMP #$FF
	BEQ @scroll_left
	CMP #$00
	BEQ @scroll_right

	JMP @done_scrolling ;no_scroll
	
	@scroll_right:
		INX
		STX x_scroll
		CPX #$00
		BEQ @switch_nametable
		
		JMP @scroll_direction_set
	@scroll_left:
		DEX
		STX x_scroll
		CPX #$FF
		BEQ @switch_nametable
		
	@scroll_direction_set:
		JMP @done_scrolling
	
	@switch_nametable:	
		LDA ppu_ctrl_1
		EOR #%00000001
		STA ppu_ctrl_1

	@done_scrolling:
	
