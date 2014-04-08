StartScreen:
    LDA #0
    STA level
    JSR SetAndLoadLevel

    LDA #FALSE
    JSR @set_bricks_present
    
    LDX #1
    JSR Sleep
    
    LDA #2
    @update_loop_outer:
        PHA
        
        LDA #TRUE
        JSR @set_bricks_present
        JSR @update_screen


        LDA #FALSE
        JSR @set_bricks_present
        JSR @update_screen
        
        @loop_maintenance:
            PLA
            TAX
            DEX
            TXA
            BNE @update_loop_outer

    LDA #TRUE
    JSR @set_bricks_present
    JSR @update_screen

    
    JSR WaitForPlayer
    LDX #1
    JSR Sleep
    LDA #FALSE
    JSR @set_bricks_present
    JSR @update_screen
    RTS

    @update_screen:
        LDX #0
        @update_loop_inner:
            LDY #0
            TXA
            PHA
            LDX #FALSE
            JSR UpdateBackgroundTile
            
            LDX #1
            JSR Sleep
            PLA
            TAX
            INX
            CMP n_bricks
            BCC @update_loop_inner
        RTS

    ; All brick_present <- A
    @set_bricks_present:
        LDX #0
        @loop:
            STA brick_present, X
            INX
            CPX n_bricks
            BCC @loop
        RTS
