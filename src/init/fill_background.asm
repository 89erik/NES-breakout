FillNametable1:	
		LDA #$20
		STA PPU_ADRESS
		LDA #0
		STA PPU_ADRESS

		LDY #0
		@row:
			LDX #0			
			@column:
				CPX #0
				BEQ @wall
				CPX #TILES_X-1
				BEQ @wall
				CPY #0
				BEQ @wall
								
				@default:
					LDA #BLANK_BG_TILE
					JMP @done
				@wall:
					LDA #WALL_TILE
					JMP @done
				@wall2:

			@done:
				STA PPU_VALUE
		
				INX
				CPX #TILES_X
				BCC @column		; Next column
				INY
				CPY #TILES_Y
				BCC @row		; Next row
				
		
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
		