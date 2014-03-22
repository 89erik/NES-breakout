DisablePpuRendering:
    LDA #0
    STA PPU_CTRL_1
    STA PPU_CTRL_2
    RTS

EnablePpuRendering:
    LDA #%10010000 ; V-Blank interrupt ON, Sprite size = 8x8, Nametable 0
    STA ppu_ctrl_1 ; BG tiles = $1000, Spr tiles = $0000, PPU adr inc = 1B
    STA PPU_CTRL_1
    LDA #%00011110
    STA PPU_CTRL_2
    RTS

; Draws/updates the current score on screen
DrawScore:
    LDA score
    LDY #4 ; Offset for high digit
    CMP #10
    BCS @p1_two_digits
    @p1_one_digit:
        CLC
        ADC #SPRITE_NUMBERS_OFFSET
        STA score_tile ; low digit
        LDA #SPRITE_NUMBERS_OFFSET
        STA score_tile, Y ; high digit
        
        RTS
    @p1_two_digits:
        JSR @split_digits
        
        CLC
        ADC #SPRITE_NUMBERS_OFFSET
        STA score_tile ; low digit
        
        TXA
        CLC
        ADC #SPRITE_NUMBERS_OFFSET
        STA score_tile, Y ; high digit
        
        RTS
        
    ; Input:    A = two-digit input
    ; Output:   X = high digit
    ;           A = low digit
    @split_digits:
        LDX #0
        @check_again:
            INX 
            SEC
            SBC #10
            CMP #10
            BCS @check_again
        RTS

; Queues all bricks of the currently loaded level to
; be updated by the V-blank.
DrawLevel:
    LDX #0
    STX first_brick_to_update
    STX last_brick_to_update
    @loop:
        TXA
        PHA
        JSR UpdateBackgroundTile
        PLA
        TAX
        INX
        CPX n_bricks
        BCC @loop
    STX last_brick_to_update
    RTS

; Adds tile to the list of background tiles to be updated,
; indexed by A. Also calculates PPU addresses to take a load
; off the V-Blank routine.
UpdateBackgroundTile:
    PHA
    LDA first_brick_to_update
    CMP last_brick_to_update
    BNE @end_equality_check
        LDA #0
        STA first_brick_to_update
        STA last_brick_to_update
    @end_equality_check:

    @add_tile_to_list:
        PLA
        LDX last_brick_to_update
        STA bricks_to_update, X

    @calculate_ppu_address:
        LDX last_brick_to_update
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
        @store_addresses:
            TXA
            LDX last_brick_to_update
            STA brick_to_update_high_addrs, X
            TYA
            STA brick_to_update_low_addrs, X
        INX
        STX last_brick_to_update
    RTS

; Draws/updates racket on screen.
DrawRacket:
    LDX racket_width
    DEX
    STX sub_routine_tmp
    
    LDX #0 ; offset
    LDY #0 ; offset x4
    @left_edge_of_racket:
        LDA #RACKET_LEFT_TILE
        STA player_tile, Y
        LDA #RACKET_ATTRIBUTE
        STA player_attribute, Y
        JSR IncrementOffset

    CPX sub_routine_tmp
    BCS @right_edge_of_racket
    
    @center_racket:
        LDA #RACKET_CENTER_TILE
        STA player_tile, Y
        LDA #RACKET_ATTRIBUTE
        STA player_attribute, Y
        JSR IncrementOffset
        CPX sub_routine_tmp
        BCC @center_racket
    
    @right_edge_of_racket:
        LDA #RACKET_RIGHT_TILE
        STA player_tile, Y
        LDA #RACKET_ATTRIBUTE
        STA player_attribute, Y
        JSR IncrementOffset
    
    CPX #RACKET_MAX_WIDTH
    BCS @done_drawing_racket
    
    @invisible_racket:
        LDA #BLANK_SPRITE_TILE
        STA player_tile, Y
        LDA #RACKET_ATTRIBUTE
        STA player_attribute, Y
        JSR IncrementOffset
        CPX #RACKET_MAX_WIDTH
        BCC @invisible_racket
    @done_drawing_racket:
    RTS
