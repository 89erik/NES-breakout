CheckHitBrick:
    TXA
    PHA ; Preserve X
    LDX #0
    CPX n_bricks
    BEQ @no_hits
    @iterate_bricks:
        LDA brick_present, X
        BNE @no_hit
        @brick_is_present:
            JSR @InBoundsHorizontal
            BNE @no_hit
            JSR @InBoundsVertical
            BNE @no_hit
            @hit:
                PLA
                TAX ; Retrieve X
                LDA #TRUE
                RTS ; Return        
            @no_hit:
                INX
                CPX n_bricks
                BCC @iterate_bricks
        @no_hits:
            PLA
            TAX ; Retrieve X
            LDA #FALSE
            RTS ; Return
       
        
    @InBoundsHorizontal:
        @calculate_brick_coordinate_x:
            TXA
            PHA     ; Preserve X
            LDA brick_x, X
            LDX #SPRITE_SIZE
            JSR Multiply
        @in_bounds_left:
            CLC
            ADC #SPRITE_SIZE-1
            CMP ball_x
            BCC @off_right
        @in_bounds_right:
            SEC
            SBC #SPRITE_SIZE*2
            BCC @off_left
            CMP ball_x
            BCS @off_left
        PLA
        TAX     ; Retrieve X
        LDA #TRUE
        RTS
        
        @off_left:
        @off_right:
            PLA
            TAX     ; Retrieve X
            LDA #FALSE
            RTS
            
    @InBoundsVertical:
        @calculate_brick_coordinate_y:
            TXA
            PHA     ; Preserve X
            LDA brick_y, X
            LDX #SPRITE_SIZE
            JSR Multiply
        @in_bounds_top:
            CLC
            ADC #SPRITE_SIZE-1
            CMP ball_y
            BCC @ball_below
        @in_bounds_below:
            SEC
            SBC #SPRITE_SIZE*2
            BCC @ball_above
            CMP ball_y
            BCS @ball_above
        PLA
        TAX     ; Retrieve X
        LDA #TRUE
        RTS
        
        @ball_below:
        @ball_above:
            PLA
            TAX     ; Retrieve X
            LDA #FALSE
            RTS