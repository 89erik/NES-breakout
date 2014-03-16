BallPlacement:
    LDA holding_ball
    BNE @move_ball
    @hold_ball:
        ; STOP BALL MOVEMENT
        LDA #0
        STA x_velocity
        STA y_velocity
        
        ; SET BALL X POSITION AFTER RACKET
        JSR RacketWidth     ; A <- len(racket_width)
        LSR                 ; A <- len(racket_width)/2
        CLC
        ADC racket_pos
        SEC
        SBC #SPRITE_SIZE/2
        STA ball_x
        
        ; SET BALL Y POSITION
        LDA #RACKET_Y - SPRITE_SIZE
        STA ball_y
        
        JMP @end_of_task

    @move_ball:
        ; -[UPDATE X]-
        LDA ball_x      ; Load x position
        CLC             ; Clear carry bit
        ADC x_velocity    ; Add velocity to position
        TAX             ; Copy A to X
        STA ball_x      ; Update OAM
        
        ; -[UPDATE Y]-
        LDA ball_y      ; Load y position
        CLC             ; Clear carry bit
        ADC y_velocity    ; Add velocity to position
        TAY             ; Copy A to X
        STA ball_y      ; Update OAM    
    
    
    ; ---[ HIT ONE OF THE WALLS? ]---
    @check_x_edge:
        CPX #LEFT_WALL
        BCC @wall_hit
        CPX #RIGHT_WALL
        BCS @wall_hit
        JMP @check_y_edge

        @wall_hit:
            LDA #0
            SEC
            SBC x_velocity
            STA x_velocity ; Inverts x_velocity
            JMP @end_of_task ; JMP to @check_y_edge?

        
        ; -[HIT ROOF OR FLOOR?]-
    @check_y_edge:
        LDA y_velocity
        JSR SignedIsNegative    ; Check if y-velocity is negative
        BEQ @ball_moves_upward

        @ball_moves_downward:
            LDA ball_y
            CMP #RACKET_Y-SPRITE_SIZE
            BCS @check_racket ; greater or equal
            JMP @end_of_task  ; No hit
        
        @ball_moves_upward:
            LDA ball_y
            CMP #ROOF            ; Hit roof
            BEQ @invert_y_velocity
            CMP #FLOOR+1         ; Past roof, underflow
            BCS @invert_y_velocity
            JMP @end_of_task     ; No hit
    
        @check_racket:
            CMP #RACKET_Y-SPRITE_SIZE + 1 + RACKET_MISS_TOLERANCE_Y
            BCS @past_racket
            
            JSR RacketWidth     ; A <- len(racket_width)
            LSR                 ; A <- len(racket_width)/2
            CLC
            ADC #1+RACKET_MISS_TOLERANCE_X ; A <- (len(racket_width)/2) + 1 + general_tolerance
            PHA                 ; tolerance -> stack
            
            JSR CheckHitFlipper ; A <- diff(ball, racket)
            PHA                 ; diff -> stack (stack = diff, tolerance, ...)
            JSR AbsoluteValue   ; A <- abs(diff)
            TAX                 ; X <- abs(diff)
            PLA                 ; A <- diff (stack = tolerance, ...)
            TAY                 ; Y <- diff
            PLA                 ; A <- tolerance
            STA tmp             ; tmp <- tolerance
            CPX tmp             ; cmp(abs(diff), tolerance)
            BCS @end_of_task    ; diff > tolerance -> No hit (ignores for now)
            
            TYA                 ; A <- diff
            JSR ASR             ; Reduce diff
            JSR ASR             ; Reduce diff
            JSR ASR             ; Reduce diff
            
            CLC
            ADC x_velocity        ; Add diff to x_velocity
            STA x_velocity
            JMP @invert_y_velocity ; Bounce ball upwards

        
        @past_racket:
            ; Ball is below racket limit, reached floor yet?
            CMP #FLOOR+SPRITE_SIZE
            BCC @end_of_task ; Hit
            JSR FlipperNoHit ; No hit
            JMP @end_of_task
            
        @invert_y_velocity:
            ; Bounce ball
            LDA #0
            SEC
            SBC y_velocity
            STA y_velocity
            JMP @end_of_task

    
@end_of_task:
