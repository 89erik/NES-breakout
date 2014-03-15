; ------------------------------------------------- ;
; -----------[ GENERAL SUB-ROUTINES ]-------------- ;
; ------------------------------------------------- ;
; This file contains some general sub-routines      ;
; used at several parts of the system               ;
; ------------------------------------------------- ;

; Is A negative?
; Yes: A <- 0
; No:  A <- 1
SignedIsNegative:
    CMP #LOWEST_SIGNED
    BCC @positive
    @negative:
        LDA #TRUE
        RTS
    @positive:
        LDA #FALSE
        RTS

; A <- abs(A)
AbsoluteValue:
    STA sub_routine_tmp
    JSR SignedIsNegative
    BNE @not_negative
        LDA #0
        SEC
        SBC sub_routine_tmp
        RTS
    @not_negative:
        LDA sub_routine_tmp
        RTS

SignedComparison:
    LDA sub_routine_arg2
    JSR SignedIsNegative
    BNE @second_positive
    @second_negative:
        LDA sub_routine_arg1
        JSR SignedIsNegative
        BNE @second_negative_first_positive
        @both_negative:
            LDA sub_routine_arg1
            JSR AbsoluteValue
            STA sub_routine_arg1
            LDA sub_routine_arg2
            JSR AbsoluteValue
            CMP sub_routine_arg1
            RTS
    @second_positive:
        LDA sub_routine_arg1
        JSR SignedIsNegative
        BNE @both_positive
        @second_positive_first_negative:
            CLC ; <
            RTS
    @second_negative_first_positive:
        SEC ; >=
        RTS
    
    @both_positive:
        LDA sub_routine_arg1
        CMP sub_routine_arg2
        RTS
    
; A <- A/2  
; Arithmetic Shift Right
ASR:
    PHA
    JSR SignedIsNegative
    BNE @positive
    @negative:
        PLA
        TAX
        CMP #-1
        BEQ @minus_one
        AND #%10000000
        BEQ @no_s_bit_preservation
        @s_bit_preservation:
            TXA
            LSR A
            ORA #%10000000
            RTS
        @minus_one:
            LDA #0
            RTS
        @no_s_bit_preservation:
            TXA
            LSR A
            RTS
    @positive:
        PLA
        LSR A
        RTS

; A <- A * X
Multiply:
    CMP #0
    BEQ @zero
    CPX #0
    BEQ @zero
    
    STA sub_routine_tmp
    DEX
    @loop:
        CLC
        ADC sub_routine_tmp
        DEX
        BNE @loop
    
    @end_of_sub_routine:
        RTS
    @zero:
        LDA #0
        RTS

; A <- A / X
; X <- A mod X
; Will stall on division by zero!
Divide:
    STX sub_routine_tmp
    LDX #0
    @loop:
        INX
        SEC
        SBC sub_routine_tmp
        BEQ @end
        BCS @loop
        @underflow:
            ADC sub_routine_tmp            
            DEX
    @end:
    ; swap(A, X):
    STX sub_routine_tmp
    TAX
    LDA sub_routine_tmp
    RTS
    
; XY <- A + XY
AccumulateLong:
    STY sub_routine_tmp
    CLC
    ADC sub_routine_tmp
    BCC @no_carry
        INX
    @no_carry:
    TAY
    RTS

; XY <- XY + sub_routine_arg1 sub_routine_arg2
AddLong:
    STX sub_routine_tmp
    LDA sub_routine_arg1
    CLC
    ADC sub_routine_tmp
    TAX
    LDA sub_routine_arg2
    JSR AccumulateLong  
    RTS

    
; XY <- sub_routine_arg1 * sub_routine_arg2
MultiplyLong:
    LDA fp
    PHA ; preserve fp
    @init_frame:
        LDA sub_routine_arg2
        PHA
        LDA #0
        PHA
        PHA
    @init_frame_pointer:
        TSX
        STX fp
    @detect_zero:
        LDA sub_routine_arg1
        BEQ @zero
        LDA sub_routine_arg2
        BEQ @zero
    @loop:
        @load_regs_before_call:
            LDY @x
            LDA (<fp), Y
            TAX                  ; Retrieves X accumulator
            LDY @y
            LDA (<fp), Y
            TAY                  ; Retrieves Y accumulator
            LDA sub_routine_arg1 ; Retrieves add value
        @call_add_long:    
            JSR AccumulateLong
        @store_regs_after_call:    
            TYA
            LDY @y
            STA (<fp), Y          ; Preserves Y accumulator
            TXA
            LDY @x
            STA (<fp), Y          ; Preserves X accumulator
        @loop_maintenance:
            LDY @counter
            LDA (<fp), Y
            TAX
            DEX
            TXA
            STA (<fp), Y
            CPX #0
            BNE @loop
        
    @end_of_sub_routine:
        PLA
        TAY ; pop Y
        PLA
        TAX ; pop X
        PLA ; pop counter
        PLA ; retrieve fp
        STA fp
        RTS
    @zero:
        LDY @y
        LDA #0
        STA (<fp), Y
        JMP @end_of_sub_routine

    ; Local variables
    @counter: .byte 3
    @x:       .byte 2
    @y:       .byte 1

    
; A <- racket_width * sprite_size
RacketWidth:
    LDA racket_width
    LDX #SPRITE_SIZE
    JSR Multiply
    RTS
    
; X <- X+1
; Y <- X*4
IncrementOffset:
    INX
    TXA
    ASL
    ASL
    TAY
    RTS 

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

WaitForPlayer:
    ; Signal controller for read
    LDA #1
    STA PLAYER1_CTRL
    LDA #0
    STA PLAYER1_CTRL
    
    ; Read controller, sequence is as follows:
    ; A, B, Select, Start, Up, Down, Left, Right
    LDA PLAYER1_CTRL ; A
    LDA PLAYER1_CTRL ; B
    LDA PLAYER1_CTRL ; Select
    LDA PLAYER1_CTRL ; Start
    AND #1
    BNE @stop_waiting
    LDA PLAYER1_CTRL ; Up
    AND #1
    BNE @stop_waiting
    LDA PLAYER1_CTRL ; Down
    AND #1
    BNE @stop_waiting
    LDA PLAYER1_CTRL ; Left
    AND #1
    BNE @stop_waiting
    LDA PLAYER1_CTRL ; Right
    AND #1
    BNE @stop_waiting
    JMP WaitForPlayer
    
    @stop_waiting:
    RTS

; Sleep for amount of frames
; given by X
Sleep:
    @wait:
        LDA v_blank_complete
        BNE @wait
    @reset_variable:
        LDA #FALSE
        STA v_blank_complete
    @loop_maintenance:
        DEX
        BNE @wait
    RTS

Halt: 
    JMP Halt

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
