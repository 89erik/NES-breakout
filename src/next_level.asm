NextLevel:
    LDX level
    INX
    CPX levels_n
    BCS @end_if_level_overflow ; TODO this doesn't work as it should
        STX level
    @end_if_level_overflow:
    JSR SetAndLoadLevel
    LDA #TRUE
    JSR DrawLevel


    LDA scroll
    CMP #$FF
    BNE @scroll
    @reset_scroll:
        LDA ppu_ctrl_1
        EOR #%00000001
        STA ppu_ctrl_1
        LDA #0
        STA scroll
        LDX #1
        JSR Sleep
    @scroll:
        LDA scroll
        CMP #$FF
        BEQ @end_of_sub_routine
        CLC
        ADC #SCROLL_SPEED
        BCC @no_overflow
            LDA #$FF
        @no_overflow:
        STA scroll
        LDX #1
        JSR Sleep
        JMP @scroll
    @end_of_sub_routine:
    RTS
