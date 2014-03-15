 ; ---[ V-BLANK INTERRUPT ]---
        PHA             ; Preserve A
        TXA
        PHA             ; Preserve X
        TYA
        PHA             ; Preserve Y
        LDA fp
        PHA             ; Preserve frame pointer
        
        LDA PPU_STATUS  ; Clear adress part latch
        
        ; -[UPDATE PPU CONTROL REGISTERS]-
        LDA ppu_ctrl_1
        STA PPU_CTRL_1      
        
        ; -[DMA OAM UPDATE]-
        LDA #$00
        STA SPR_RAM_ADDRESS
        LDA #$02
        STA SPR_RAM_DMA
        
        ; -[UPDATE BACKGROUND]- does not work in NTSC!
        LDA first_brick_to_update
        CMP last_brick_to_update
        BEQ @end_update_background
        @init_frame:
            PHA
        @init_frame_pointer:
            TSX
            STX fp
        @loop:
            @store_ppu_address:
                LDY @i
                LDA (<fp), Y
                TAX                     ; X <- i
                LDA bricks_to_update, X
                TAX                     ; X <- bricks_to_update[i]
                LDA brick_x, X          ; A <- brick_y[X]
                PHA                     ; brick_y[X] -> stack
                
                LDA brick_y, X          ; A <- brick_y[X]
                STA sub_routine_arg1
                LDA #NAME_TABLE_WIDTH
                STA sub_routine_arg2
                @multiply_rows:
                    JSR MultiplyLong        ; XY <- brick_y[X] * NAME_TABLE_WIDTH
                    
                @add_column:
                    PLA                     ; A <- brick_y[X] <- stack
                    
                    JSR AccumulateLong
                @add_name_table_offset:
                    LDA #NAMETABLE1_H
                    STA sub_routine_arg1
                    LDA #NAMETABLES_L
                    STA sub_routine_arg2
                    
                    JSR AddLong
                    
                STX PPU_ADDRESS
                STY PPU_ADDRESS
            @store_tile_to_ppu:
                LDY @i
                LDA (<fp), Y            ; A <- i
                TAX                     ; X <- i
                LDA bricks_to_update, X 
                TAX                     ; X <- bricks_to_update[i]
                LDA brick_tile, X       ; A <- brick_tile[X]
                STA PPU_VALUE
            @loop_maintenance:
                LDY @i
                LDA (<fp), Y            ; A <- i
                TAX
                INX                     ; X <- i+1
                TXA
                STA (<fp), Y            ; i <- i+1
                CMP last_brick_to_update
                BNE @loop
        @end_loop:
            PLA
            LDA #0
            STA first_brick_to_update
            STA last_brick_to_update
            JMP @end_update_background
            LDA #$23
            STA PPU_ADDRESS
            LDA #$BF
            STA PPU_ADDRESS
            LDA #0
            STA PPU_VALUE
        @end_update_background:
                
        ; -[SET SCROLL]-
        LDA #0
        STA PPU_SCROLL
        STA PPU_SCROLL

        ; -[PREPARE FOR RETURN]-
        LDA #TRUE
        STA v_blank_complete
        
        PLA
        STA fp          ; Retrieve frame pointer
        PLA
        TAY             ; Retrieve Y
        PLA
        TAX             ; Retrieve X
        PLA             ; Retrieve A
        RTI             ; ReTurn from Interrupt
        
        @i:     .byte 1
