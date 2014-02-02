; ------------------------------------------------- ;
; ---------------------[ RAM ]--------------------- ;
; ------------------------------------------------- ;
; This is a part of the RAM segment and everything  ;
; in this file represents places in the memory,     ;
; and can be refered to by the labels.				;
; ------------------------------------------------- ;
	
	; State variables
	bg_color:					.byte 0
	wait_for_v_blank:			.byte 0
	panic_mode:					.byte 0
	
	; Player state
	racket_pos:					.byte 0	; Position of racket
	racket:						.byte 0 ; (used in check_hit_flipper.asm)
	delta_racket_hit:			.byte 0 ; Where on racket ball hit
	p1_score:					.byte 0
	
	; The ball
	x_vector: 					.byte 0
	y_vector: 					.byte 0
	
	; Physics
;	x_grav:						.byte 0
;	y_grav:						.byte 0
;	x_vel:						.byte 0
;	y_vel:						.byte 0

	; Registers
	ppu_ctrl_1:					.byte 0

	