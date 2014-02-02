 ; ---[ V-BLANK INTERRUPT ]---
		PHA				; Push A to stack
		LDA PPU_STATUS	; Clear adress part latch
			
		; -[PERFORM SCROLL]-
		;LDA x_scroll
		;STA PPU_SCROLL
		;LDA y_scroll
		;STA PPU_SCROLL
		
		; -[UPDATE PPU CONTROL REGISTERS]-
		LDA ppu_ctrl_1
		STA PPU_CTRL_1
		
		; -[DMA OAM UPDATE]-
		LDA #$00
		STA $2003
		LDA #$02
		STA $4014
		
		LDA #1
		STA wait_for_v_blank
		
		PLA	; Pull A from stack
		RTI ; ReTurn from Interrupt
		