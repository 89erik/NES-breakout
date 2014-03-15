 ; ---[ V-BLANK INTERRUPT ]---
        PHA             ; Preserve A
        TXA
        PHA             ; Preserve X
        TYA
        PHA             ; Preserve Y
        
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
            JSR @update_background
        @end_update_background:
                
        ; -[SET SCROLL]-
        LDA #0
        STA PPU_SCROLL
        STA PPU_SCROLL

        ; -[PREPARE FOR RETURN]-
        LDA #TRUE
        STA v_blank_complete

        PLA
        TAY             ; Retrieve Y
        PLA
        TAX             ; Retrieve X
        PLA             ; Retrieve A
        RTI             ; ReTurn from Interrupt
        
        
    @update_background:
        @store_ppu_address:
            LDX first_brick_to_update
            LDA bricks_to_update, X
            TAX                     ; X <- bricks_to_update[i]
            LDA brick_x, X          ; A <- brick_x[X]
            PHA                     ; push(brick_x[X])
            LDA brick_y, X          ; A <- brick_y[X]
            STA sub_routine_arg1
            LDA #NAME_TABLE_WIDTH
            STA sub_routine_arg2
            @multiply_rows:
                JSR MultiplyLong        ; XY <- brick_y[X] * NAME_TABLE_WIDTH
            @add_column:
                PLA                     ; A <- pull(brick_y[X])
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
            LDX first_brick_to_update
            LDA bricks_to_update, X
            TAX                     ; X <- bricks_to_update[i]
            LDA brick_present
            BEQ @brick_present
            @brick_not_present:
                LDA #BLANK_BG_TILE
                JMP @end_brick_presence_check
            @brick_present:
                LDA brick_tile, X       ; A <- brick_tile[X]
            @end_brick_presence_check:
            STA PPU_VALUE
        @increase_index:
            LDX first_brick_to_update
            INX                     ; X <- i+1
            STX first_brick_to_update
        RTS