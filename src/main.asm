.include "data/constants.inc"

.segment "INES"
	.byte "NES",$1A,1,1,1
	;      012   3  4 5 6
	; http://wiki.nesdev.com/w/index.php/INES
	
.segment "VECTORS"
	.word V_blank	; Non-maskable interrupt (used by V-Blank)
	.word Start		; Initial program counter value
	.word No-op		; IRQ (not used)

.segment "GFX"
	.incbin "data/sprites.chr"		; Graphics for moving things (binary file)
	.incbin "data/background.chr"	; Graphics for background (binary file)
	
.segment "CODE"
		.include "sub_routines.asm"		; General sub-routines
	Start:
		.include "init/init.asm" 		; Initialization procedure
		.include "loop/loop.asm"		; Physics to be performed per framerate
	V_blank:
		.include "v_blank.asm"			; Drawing the screen
	No-op:
		RTI
	
.segment "DATA"	
	.include "data/data.asm"
	
.segment "ZERO_PAGE"
	.include "memory/ram.asm"				; Variables in RAM
	
.segment "OAM"
	.include "memory/oam.asm"				; Sprite memory
	