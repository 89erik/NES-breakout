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
    
; Halts until player pushes either of these bottons:
; start, up, down, left, right
WaitForPlayer:
    ; Signal controller for read
    LDA #1
    STA PLAYER1_CTRL
    LDA #0
    STA PLAYER1_CTRL
    
    ; Read controller, sequence is as follows:
    ; A, B, Select, Start, Up, Down, Left, Right
    LDA PLAYER1_CTRL ; A
    LDA PLAYER1_CTRL ; B
    LDA PLAYER1_CTRL ; Select
    LDA PLAYER1_CTRL ; Start
    AND #1
    BNE @stop_waiting
    LDA PLAYER1_CTRL ; Up
    AND #1
    BNE @stop_waiting
    LDA PLAYER1_CTRL ; Down
    AND #1
    BNE @stop_waiting
    LDA PLAYER1_CTRL ; Left
    AND #1
    BNE @stop_waiting
    LDA PLAYER1_CTRL ; Right
    AND #1
    BNE @stop_waiting
    JMP WaitForPlayer
    
    @stop_waiting:
    RTS
