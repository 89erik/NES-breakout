; ---[ FLIPPER MISS ]---------------------
; Should be called whenever the ball gets below racket

FlipperNoHit:
    LDX score
    BEQ GameOver
    DEX
    STX score
    JSR DrawScore
    LDA #TRUE
    STA holding_ball
    RTS

GameOver: 
    LDA #0
    STA x_vector
    STA y_vector
    RTS