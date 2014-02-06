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
	p1_score:					.byte 0
	
	; The ball
	x_vector: 					.byte 0
	y_vector: 					.byte 0
	
	; Registers
	ppu_ctrl_1:					.byte 0

	; Temporary usage
	tmp:						.byte 0
	sub_routine_tmp:			.byte 0