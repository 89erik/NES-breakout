; ---[ FLIPPER MISS ]---------------------
; Should be called whenever the ball gets below racket

RacketMiss:
    LDX score
    BEQ @game_over
    DEX
    STX score
    JSR DrawScore
    
    LDX racket_width
    DEX
    CPX #RACKET_MIN_WIDTH
    BCC @end_if
        STX racket_width
        JSR DrawRacket
    @end_if:

    LDA #TRUE
    STA holding_ball
    RTS

    @game_over: 
        LDA #0
        STA x_velocity
        STA y_velocity
        RTS
