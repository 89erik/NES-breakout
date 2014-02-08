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
    ;@negative:
        LDA #0
        RTS
    @positive:
        LDA #1
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
