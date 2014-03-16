FillBackground: 
    LDA #NAMETABLE1_H
    STA PPU_ADDRESS
    LDA #NAMETABLES_L
    STA PPU_ADDRESS
    
    JSR @fill_nametable
    
    LDA #NAMETABLE2_H
    STA PPU_ADDRESS
    LDA #NAMETABLES_L
    STA PPU_ADDRESS
    
    JSR @fill_nametable
    
    RTS
    
    @fill_nametable:
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
                    LDA #BLANK_BG_TILE
                    JMP @store_tile
                @wall:
                    LDA #WALL_TILE
                    JMP @store_tile
                @store_tile:
                    STA PPU_VALUE
                @column_loop_maintenance:
                    INX
                    CPX #TILES_X
                    BCC @column     ; Next column
            @row_loop_maintenance:
                INY
                CPY #TILES_Y
                BCC @row        ; Next row            
        RTS
