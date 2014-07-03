; A <- racket_width * sprite_size
RacketWidth:
    LDA racket_width
    LDX #SPRITE_SIZE
    JSR Multiply
    RTS

RacketTolerance:
    JSR RacketWidth     ; A <- len(racket_width)
    LSR                 ; A <- len(racket_width)/2
    CLC
    ADC #1+RACKET_MISS_TOLERANCE_X ; A <- (len(racket_width)/2) + 1 + general_tolerance
    RTS

IncreaseRacketWidth:
    LDX racket_width
    INX
    CPX #RACKET_MAX_WIDTH+1
    BCS @end_if
        STX racket_width
        JSR DrawRacket
    @end_if:
    RTS

DecreaseRacketWidth:
    LDX racket_width
    DEX
    CPX #RACKET_MIN_WIDTH
    BCC @end_if
        STX racket_width
        JSR DrawRacket
    @end_if:
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

; Dispenses a token from the brick given by X
; X = brick index
DispenseToken:
	TYA
	PHA ; Preserve Y
	
	TXA
	TAY ; Y <- X
	
	LDA brick_x, Y
	LDX #SPRITE_SIZE
	JSR Multiply
	STA token_x
	LDA brick_y, Y
	LDX #SPRITE_SIZE
	JSR Multiply
	STA token_y
	LDA #INCREASE_RACKET_TOKEN
	STA token_tile
	
	PLA
	TAY ; Retrieve Y
	RTS