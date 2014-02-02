LoadBuffer:

		LDX #0 ; column count
		LDY #0 ; row count
		

	NextTileToBuffer:
		CPX #5
		BEQ Draw_Row5
		
		LDA #$FF
		JMP Draw 			; default draw
		
	Draw_Row5:	
		CPY #10
		BEQ Draw_B
		CPY #18
		BEQ Draw_E
		CPY #26
		BEQ Draw_D
		
		LDA #$FF
		JMP Draw 			; default draw

	Draw_A:
		LDA #$0A
		JMP Draw
	Draw_B:
		LDA #$0B
		JMP Draw
	Draw_C:
		LDA #$0C
		JMP Draw
	Draw_D:
		LDA #$0D
		JMP Draw
	Draw_E:
		LDA #$0E
		JMP Draw
	Draw_F:
		LDA #$0F
		JMP Draw
		
		
	; Preload A with tile number
	Draw:
		JSR Multiply
		TYA
		PHA
		LDY nametable_offset
		STA nametable, Y
		PLA
		TAY
		JMP Draw_Finish

		
	Draw_Finish:	
		INX
		CPX #$20
		BEQ NextRow
		JMP NextTileToBuffer

		
		; nametable_offset = X*Y 
	Multiply:
			PHA
			STX tmp1
			STY tmp2
			
			LDX #0
			
		@again:
			CLC
			ADC tmp2 ;(A=A+Y)
			INX
			CPX tmp1
			BNE @again
			
			STA nametable_offset
			PLA
			RTS


		
		
	NextRow:
		INY
		LDX #0
		CPY #$1E
		BNE NextTileToBuffer

		RTS
	
	
	
	
	
	
	
	; DRAW BUFFER TO SCREEN
DrawBuffer:
		LDX #0
		LDY #0
		
		LDA #$20
		STA PPU_ADRESS
		LDA #0
		STA PPU_ADRESS
		
	@next:
		JSR Multiply
		TYA
		PHA
		LDY nametable_offset
		LDA nametable, Y
		STA PPU_VALUE
		
		INX
		CPX #$20
		BEQ @next_row
		JMP @next
		
		
	@next_row:
		INY
		LDX #0
		CPY #$1E
		BNE @next
	
		RTS
	
	
	
	