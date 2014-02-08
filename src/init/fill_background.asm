JSR LoadLevel1

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
                
                JSR CheckForBrick   ; A <- brick tile
                CMP #$FF
                BNE @tile_selected  ; Not null -> tile_selected
                
                @default:
                    LDA #BLANK_BG_TILE
                    JMP @tile_selected
                @wall:
                    LDA #WALL_TILE
                    JMP @tile_selected

            @tile_selected:
                STA PPU_VALUE
        
                INX
                CPX #TILES_X
                BCC @column     ; Next column
                INY
                CPY #TILES_Y
                BCC @row        ; Next row
                
        
        
        JMP FillNametable2
        
        ; if brick exists at X,Y:
        ;   A <- brick_tile
        ; else
        ;   A <- $FF
        ; TODO: check if present
        CheckForBrick:
            TYA
            PHA         ; Push Y to stack
            LDY #0      ; Borrows Y as loop iterator
            @iterate_x_coordinates:
                TXA
                CMP brick_x, Y      ; Compare(brick_x, screen X)
                BNE @end_x_matching ; X match?
                    PLA             ; Retrieve screen Y
                    CMP brick_y, Y  ; Compare(brick_y, screen Y)
                    BEQ @found_match; Both matches
                    PHA             ; Push screen Y back to stack
                @end_x_matching:
                INY
                CPY n_bricks
                BCC @iterate_x_coordinates
            @no_x_match:
                PLA
                TAY         ; Retrieves Y from stack
                LDA #$FF    ; Signals failure
                RTS
            
            @found_match:
                PHA
                LDA brick_tile, Y ; Loads tile
                PLA
                TAY         ; Puts screen Y back into its register
                
                RTS

        
        
        
        
        
FillNametable2:
        LDA #$24
        STA PPU_ADRESS
        LDA #0
        STA PPU_ADRESS
        
        LDX #30     ;remaining rows
        
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
        
