FillNametable1:	
		LDA #$20
		STA PPU_ADRESS
		LDA #0
		STA PPU_ADRESS

		LDX #30		;remaining rows

	@save_row:
		LDY #16
		
	@save_tiles:
		LDA #$20
		STA PPU_VALUE
		LDA #$21
		STA PPU_VALUE
		DEY
		BNE @save_tiles
		DEX
		BNE @save_row

		

FillNametable2:
		LDA #$24
		STA PPU_ADRESS
		LDA #0
		STA PPU_ADRESS
		
		LDX #30		;remaining rows
		
	@save_row:
		LDY #16
		
	@save_tiles:
		LDA #$20
		STA PPU_VALUE
		LDA #$21
		STA PPU_VALUE
		DEY
		BNE @save_tiles
		DEX
		BNE @save_row

		LDA #$28
		STA PPU_ADRESS
		LDA #38
		STA PPU_ADRESS
		