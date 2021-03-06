; ---[ RACKET PLACEMENT ]---
; Writes the racket placement to OAM
    LDX #0 ; offset
    LDY #0 ; offset x4
RacketPlacement:
    ; -[X-COORDINATE]-
    TXA
    PHA             ; X -> stack
    LDA #SPRITE_SIZE
    JSR Multiply    ; A <- X*SPRITE_SIZE
    CLC
    ADC racket_pos  ; A <- racket_pos + (X*SPRITE_SIZE)
    STA player_x, Y

    ; -[Y-COORDINATE]-
    LDA #RACKET_Y
    STA player_y, Y

    PLA
    TAX             ; X <- stack
    JSR IncrementOffset
    CPX racket_width
    BCC RacketPlacement

; ---[ RACKET INPUT ]---
; Updates racket position according to input from player

@racket_input:
    ; Signal controller for read
    LDA #1
    STA PLAYER1_CTRL
    LDA #0
    STA PLAYER1_CTRL

    ; Read controller, sequence is as follows:
    ; A, B, Select, Start, Up, Down, Left, Right
    LDA PLAYER1_CTRL ; A

    LDX holding_ball
    BNE @ignore_A_button
        AND #1
        BEQ @ignore_A_button ; not pushed
            JSR PlayBounceSound
            LDA #FALSE
            STA holding_ball
            LDA #0
            SEC
            SBC ball_speed
            STA y_velocity

    @ignore_A_button:
        LDX #FALSE
        LDA PLAYER1_CTRL ; B
        AND #1
        BEQ @end_check_b
            LDX #TRUE
        @end_check_b:
        TXA
        PHA
        LDA PLAYER1_CTRL ; Select
        LDA PLAYER1_CTRL ; Start
        LDA PLAYER1_CTRL ; Up
        LDA PLAYER1_CTRL ; Down

    ; -[CHECK LEFT BUTTON]-
        LDA PLAYER1_CTRL ; Left
        AND #1
        BEQ @right_button
        PLA
        BEQ @fast_l
        @slow_l:
            LDA racket_pos
            SEC
            SBC #RACKET_SPEED/2
            JMP @end_speed_check_l
        @fast_l:
            LDA racket_pos
            SEC
            SBC #RACKET_SPEED
        @end_speed_check_l:
        CMP #LEFT_WALL
        BCS @left_move_in_bounds
        LDA #LEFT_WALL
    @left_move_in_bounds:
        STA racket_pos

        JMP @end_of_task

    ; -[CHECK RIGHT BUTTON]-
    @right_button:
        LDA PLAYER1_CTRL ; Right
        AND #1
        BEQ @end_of_task

        JSR RacketWidth
        STA tmp
        LDA #RIGHT_WALL + SPRITE_SIZE
        CLC
        SBC tmp
        STA tmp

        PLA
        BEQ @fast_r
        @slow_r:
            LDA racket_pos
            CLC
            ADC #RACKET_SPEED/2
            JMP @end_speed_check_r
        @fast_r:
            LDA racket_pos
            CLC
            ADC #RACKET_SPEED
        @end_speed_check_r:

        CMP tmp ;#RIGHT_WALL - RACKET_WIDTH + SPRITE_SIZE
        BCC @right_move_in_bounds
        LDA tmp ;#RIGHT_WALL - RACKET_WIDTH + SPRITE_SIZE
    @right_move_in_bounds:
        STA racket_pos

    @end_of_task:
