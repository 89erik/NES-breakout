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
