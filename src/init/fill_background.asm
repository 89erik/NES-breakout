FillBackground: 
        LDA #NAMETABLE1_H
        STA PPU_ADDRESS
        LDA #NAMETABLES_L
        STA PPU_ADDRESS
        
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
                
        
        
        RTS
        
        ; if brick exists at X,Y:
        ;   A <- brick_tile
        ; else
        ;   A <- #BLANK_BG_TILE
        CheckForBrick:
            TYA
            PHA         ; Push Y to stack
            LDY #0      ; Borrows Y as loop iterator
            @iterate_x_coordinates:
                LDA brick_present, Y
                BNE @end_x_matching ; Skip non-present blocks
                TXA
                CMP brick_x, Y      ; Compare(screen X, brick_x,)
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
                LDA #BLANK_BG_TILE
                RTS
            
            @found_match:
                PHA                 ; Y -> stack
                LDA brick_tile, Y   ; Loads tile
                STA tmp             ; tile -> tmp
                PLA
                TAY                 ; Puts screen Y back into its register
                LDA tmp             ; A <- tile
                
                RTS

        
        
        
        
        
FillNametable2:
        LDA #NAMETABLE2_H
        STA PPU_ADDRESS
        LDA #NAMETABLES_L
        STA PPU_ADDRESS
        
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
        STA PPU_ADDRESS
        LDA #38
        STA PPU_ADDRESS
        
