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
				JSR KillBrick
				BEQ @end_check_hit_bricks
                @bounce_direction:
                    JSR @XDiff
                    JSR AbsoluteValue
                    STA sub_routine_tmp
                    JSR @YDiff
                    JSR AbsoluteValue
                    CMP sub_routine_tmp
                    BCC @horizontal_bounce
                    BEQ @bounce_both
                    @vertical_bounce:
                       LDA #0
                        SEC
                        SBC x_velocity
                        STA x_velocity
                        JMP @end_bounce_direction
                    @horizontal_bounce:
                        LDA #0
                        SEC
                        SBC y_velocity
                        STA y_velocity
                        JMP @end_bounce_direction
                    @bounce_both:
                        LDA #0
                        SEC
                        SBC y_velocity
                        STA y_velocity
                        LDA #0
                        SEC
                        SBC x_velocity
                        STA x_velocity
                @end_bounce_direction:
                
                PLA
                TAX ; Retrieve X
                LDA #TRUE
                RTS ; Return        
            @no_hit:
                INX
                CPX n_bricks
                BCC @iterate_bricks
        @no_hits:
		@end_check_hit_bricks:
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
            
    @XDiff:
        ;@calculate_brick_coordinate_x:
            TXA
            PHA     ; Preserve X
            LDA brick_x, X
            LDX #SPRITE_SIZE
            JSR Multiply
        @calculate_x_diff:
            SEC
            SBC ball_x
            TAY
            PLA
            TAX     ; Retrieve X
            TYA
            RTS
            
    @YDiff:
        ;@calculate_brick_coordinate_y:
            TXA
            PHA     ; Preserve X
            LDA brick_y, X
            LDX #SPRITE_SIZE
            JSR Multiply
        @calculate_y_diff:
            SEC
            SBC ball_y
            TAY
            PLA
            TAX     ; Retrieve X
            TYA
            RTS
			
; Kills brick and goes to next level if no more bricks.
; If next level:
; 	A <- TRUE
; else
;	A <- FALSE
KillBrick:
	LDA #FALSE
	STA brick_present, X
	TXA
	LDX #FALSE
	JSR UpdateBackgroundTile
	
	LDX #0
	@check_bricks:
		LDA brick_present, X
		BNE @continue_check_bricks
			LDA #FALSE
			RTS
		@continue_check_bricks:
			INX
			CPX n_bricks
			BCC @check_bricks
	JSR NextLevel
	LDA #TRUE
	RTS
		