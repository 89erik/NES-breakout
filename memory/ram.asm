; ------------------------------------------------- ;
; ---------------------[ RAM ]--------------------- ;
; ------------------------------------------------- ;
; This is a part of the RAM segment and everything  ;
; in this file represents places in the memory,     ;
; and can be refered to by the labels.				;
; ------------------------------------------------- ;
	 
	; System state
	bg_color:					.byte 0
	wait_for_v_blank:			.byte 0
	panic_mode:					.byte 0
	
	; Player state
	racket_pos:					.byte 0
	racket_width:				.byte 0
	p1_score:					.byte 0
	holding_ball:				.byte 0
	
	; The ball
	x_vector: 					.byte 0
	y_vector: 					.byte 0
	
	; Registers
	ppu_ctrl_1:					.byte 0

	; Temporary usage
	tmp:                        .byte 0
	sub_routine_tmp:			.byte 0
    sub_routine_arg1:			.byte 0
    sub_routine_arg2:			.byte 0
    
    n_bricks:                   .byte 0
    brick_x:                    .byte 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    brick_y:                    .byte 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    brick_tile:                 .byte 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    brick_present:              .byte 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    
    level:                      .byte 0
    level_n_data:               .byte 0
    level_data:                 .byte 0,0
    