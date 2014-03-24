; ----------------------------------------------- ;
; -----------------[ MAIN LOOP ]----------------- ;
; ----------------------------------------------- ;
; This part of the code runs once after every     ;
; V-blank and performs the physics of moving the  ;
; racket according to input, and the ball         ;
; according to its vectors. This loops repeats    ;
; with the excact same frequency as the PPU       ;
; framerate.                                      ;
; ----------------------------------------------- ;


MainLoop:
    LDA v_blank_complete
    BNE MainLoop
    
    LDA #FALSE
    STA v_blank_complete

    ; Loop procedures
    .include "src/loop/racket_placement.asm"        ; Places the rackets
    .include "src/loop/ball_placement.asm"          ; Places the ball
    .include "src/loop/move_token.asm"
    JMP MainLoop

    ; Subroutines
    .include "src/loop/racket_miss.asm"            ; Subroutine used by "ball_placement.asm"
    .include "src/loop/check_hit_racket.asm"       ; Subroutine used by "ball_placement.asm"
