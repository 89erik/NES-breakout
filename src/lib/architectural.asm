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

; CMP(sub_routine_arg1, sub_routine_arg2)
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

; If A is positive:
; A <- A+1
; If A is negative:
; A <- A-1
SignedIncrease:
    PHA
    JSR SignedIsNegative
    BEQ @decrease
    @increase:
        PLA
        TAX
        INX
        TXA
        RTS
    @decrease:
        PLA
        TAX
        DEX
        TXA
        RTS

; If A is positive:
; A <- A-1
; If A is negative:
; A <- A+1
SignedDecrease:
    PHA
    JSR SignedIsNegative
    BEQ @increase
    @decrease:
        PLA
        TAX
        DEX
        TXA
        RTS
    @increase:
        PLA
        TAX
        INX
        TXA
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
    
; XY <- XY + A
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


; Sleep for amount of frames given by X
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

; Halt indefinitely (V-blank interrupt routine will still run)
Halt: 
    JMP Halt
