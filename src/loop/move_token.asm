MoveToken:
    LDA token_tile
    BEQ @end_of_sub_routine
        LDA token_y
        CLC
        ADC #TOKEN_SPEED
        STA token_y
        
        CMP #RACKET_Y-SPRITE_SIZE
        BCS @check_racket
            JMP @end_of_sub_routine

    @check_racket:
        CMP #RACKET_Y-SPRITE_SIZE + 1 + RACKET_MISS_TOLERANCE_Y
        BCS @past_racket
            JSR RacketTolerance
            PHA                 ; tolerance -> stack

            LDA token_x
            JSR CheckHitRacket  ; A <- diff(ball, racket)
            PHA                 ; diff -> stack (stack = diff, tolerance, ...)
            JSR AbsoluteValue   ; A <- abs(diff)
            TAX                 ; X <- abs(diff)
            PLA                 ; A <- diff (stack = tolerance, ...)
            TAY                 ; Y <- diff
            PLA                 ; A <- tolerance
            STA tmp             ; tmp <- tolerance
            CPX tmp             ; cmp(abs(diff), tolerance)
            BCS @end_of_sub_routine ; diff > tolerance -> No hit (ignores for now)
                JSR IncreaseRacketWidth
                JMP @destroy_token
    @past_racket:
        ; Token is below racket limit, reached floor yet?
        CMP #FLOOR+SPRITE_SIZE
        BCC @end_of_sub_routine ; Ignore
        @destroy_token:
            LDA #0
            STA token_tile
@end_of_sub_routine:
