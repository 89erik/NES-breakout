; A <- diff(ball, racket)
CheckHitFlipper:
        ; Center position of racket
        JSR RacketWidth     ; A <- len(racket_width)
        LSR                 ; A <- len(racket_width)/2
        CLC 
        ADC racket_pos      ; A <- racket_pos + len(racket_width)/2
        STA tmp             ; tmp <- A == center of racket
        
        ; Position of ball
        LDA ball_x
        CLC
        ADC #SPRITE_SIZE/2
        
        ; Find diff(racket, ball)
        TAX                 ; X <- ball
        SEC
        SBC tmp             ; A <- diff(ball, racket)
        
        
        ; Is ball to the right of racket?
        ; If so, a negative diff means overflow
        CPX tmp              ; cmp(ball, racket)
        BCC @racket_is_right ; ball < racket
        @racket_is_left:     ; negative is not OK
            ;@loop: JMP @loop
            STA tmp          ; tmp <- diff
            JSR SignedIsNegative
            BEQ @large_diff  ; negative diff AND (racket < ball) -> overflow -> large diff
            LDA tmp          ; A <- diff
        
        @racket_is_right:
        RTS
                
        @large_diff:
            LDA #HIGHEST_SIGNED
            RTS
            
