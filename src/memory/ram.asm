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
	
	; Physics
	x_grav						.byte 0
	y_grav						.byte 0
	x_vel						.byte 0
	y_vel						.byte 0
	
	; Scrolling
	x_scroll:					.byte 0
	y_scroll:					.byte 0
	scroll_direction:			.byte 0
		
	; Registers
	ppu_ctrl_1:					.byte 0