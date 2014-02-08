LoadLevel1:
    LDX #0
    
    LDA #10
    STA brick_x, X
    STA brick_y, X
    LDA #A_CHARACTER
    STA brick_tile, X
    LDA #TRUE
    STA brick_present, X
    
    INX
    
    LDA #12
    STA brick_x, X
    STA brick_y, X
    LDA #B_CHARACTER
    STA brick_tile, X
    LDA #TRUE
    STA brick_present, X
    
    INX
    
    LDA #13
    STA brick_x, X
    STA brick_y, X
    LDA #B_CHARACTER
    STA brick_tile, X
    LDA #TRUE
    STA brick_present, X
    
    INX
    STX n_bricks
    RTS