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
        LDX #0
        LDY #0
        @move_more:
            JSR @ApproachX
            JSR @ApproachY
            JSR CheckHitBrick
            BEQ @end_approach_routines
            CPY y_velocity
            BNE @move_more
            CPX x_velocity
            BNE @move_more        
        JMP @end_approach_routines
        
            @ApproachX:
                CPX x_velocity
                BEQ @end_approach_x
                
                LDA x_velocity
                JSR SignedIsNegative
                BEQ @x_negative
                @x_positive:
                    TXA
                    LDX ball_x
                    INX
                    STX ball_x
                    TAX
                    INX
                    JMP @end_approach_x
                @x_negative:
                    TXA
                    LDX ball_x
                    DEX
                    STX ball_x
                    TAX
                    DEX
                @end_approach_x:
                    RTS
                    
            @ApproachY:
                CPY y_velocity
                BEQ @end_approach_y
                
                LDA y_velocity
                JSR SignedIsNegative
                BEQ @y_negative
                @y_positive:
                    TYA
                    LDY ball_y
                    INY
                    STY ball_y
                    TAY
                    INY
                    JMP @end_approach_y
                @y_negative:
                    TYA
                    LDY ball_y
                    DEY
                    STY ball_y
                    TAY
                    DEY
                @end_approach_y:
                    RTS
                    
        @stop:  LDA #$fa
                LDY #$fa
                LDX #$fa
                JMP @stop
        @end_approach_routines:   
    
    ; ---[ HIT ONE OF THE WALLS? ]---
    @check_x_edge:
        LDA ball_x
        CMP #LEFT_WALL
        BCC @wall_hit
        CMP #RIGHT_WALL
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
			BCC @overhit
            CMP #FLOOR+1         ; Past roof, underflow
            BCS @overhit
            JMP @end_of_task     ; No hit
			@overhit:
				LDA #ROOF
				STA ball_y
				JMP @invert_y_velocity
				
    
        @check_racket:
            CMP #RACKET_Y-SPRITE_SIZE + 1 + RACKET_MISS_TOLERANCE_Y
            BCS @past_racket

            JSR RacketTolerance
            PHA                 ; tolerance -> stack

            LDA ball_x
            JSR CheckHitRacket  ; A <- diff(ball, racket)
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
            JSR RacketMiss   ; No hit
            JMP @end_of_task
            
        @invert_y_velocity:
            ; Bounce ball
            LDA #0
            SEC
            SBC y_velocity
            STA y_velocity
            JMP @end_of_task

    @end_of_task:
