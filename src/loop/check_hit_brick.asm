CheckHitBrick:
    TYA
    PHA ; Preserve Y
    LDY #0
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
            TAY ; Retrieve Y
            LDA #TRUE
            RTS ; Return
        
        @no_hit:
            INY
            CPY n_bricks
            BCC @iterate_bricks
            PLA
            TAY ; Retrieve Y
            LDA #FALSE
            RTS ; Return
       
        
        
    @InBoundsHorizontal:
        @in_bounds_left:
            LDA brick_x, X
            CLC
            ADC #SPRITE_SIZE
            CMP ball_x
            BCC @off_left
        @in_bounds_right:
            LDA brick_x, X
            SEC
            SBC #SPRITE_SIZE
            BCS @off_right
            CMP ball_x
            BCS @off_right
        LDA #TRUE
        RTS
        
        @off_left:
        @off_right:
            LDA #FALSE
            RTS
            
    @InBoundsVertical:
        @in_bounds_top:
            LDA brick_y, X
            CLC
            ADC #SPRITE_SIZE
            CMP ball_y
            BCC @ball_below
        @in_bounds_below:
            LDA brick_y, X
            SEC
            SBC #SPRITE_SIZE
            BCS @ball_above
            CMP ball_y
            BCS @ball_above
        LDA #TRUE
        RTS
        
        @ball_below:
        @ball_above:
            LDA #FALSE
            RTS