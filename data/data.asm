; ---------------------------------------- ;
; ----------------[ DATA ]---------------- ;
; ---------------------------------------- ;
; This section contains the data to be     ;
; placed on the PRG ROM (game cartridge).  ;
; ---------------------------------------- ;

Palette:
	; Background
	.byte 0, $12, $3C, $09
	.byte 0, $15, $3C, $09
	.byte 0, $15, $3C, $09
	.byte 0, $15, $3C, $09
	
	; Sprites
	.byte $11, $2A, $28, $15
	.byte $11, $15, $3C, $09
	.byte $11, $3F, $37, $00
	.byte $11, 0, 0, 0