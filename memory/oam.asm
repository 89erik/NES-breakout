; ------------------------------------------------- ;
; ----------[ OBJECT ATTRIBUTE MEMORY ]------------ ;
; ------------------------------------------------- ;
; Contains the memory locations of the OAM, which 	;
; keep tracks of the sprites.						;
; ------------------------------------------------- ;	
	player_y:					.byte 0			; flipper 0
	player_tile:				.byte 0			; flipper 0
	player_attribute:			.byte 0			; flipper 0
	player_x:					.byte 0			; flipper 0
								.byte 0,0,0,0	; flipper 1
								.byte 0,0,0,0	; flipper 2
								.byte 0,0,0,0	; flipper 3
								.byte 0,0,0,0	; flipper 4
								.byte 0,0,0,0	; flipper 5
								.byte 0,0,0,0	; flipper 6
	
	ball_y:					.byte 0
	ball_tile:				.byte 0
	ball_attribute:			.byte 0
	ball_x:					.byte 0

	p1_score_y:					.byte 0
	p1_score_tile:				.byte 0
	p1_score_attribute:			.byte 0
	p1_score_x:					.byte 0
								.byte 0,0,0,0	; high digit
								