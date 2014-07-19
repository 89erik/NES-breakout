; ------------------------------------------------- ;
; ---------------------[ RAM ]--------------------- ;
; ------------------------------------------------- ;
; This is a part of the RAM segment and everything  ;
; in this file represents places in the memory,     ;
; and can be referred to by the labels.             ;
; ------------------------------------------------- ;

    ; System state
    bg_color:                   .byte 0
    v_blank_complete:           .byte 0
    scroll:                     .byte 0
    
    ; Registers
    ppu_ctrl_1:                 .byte 0
    
    ; Player state
    racket_pos:                 .byte 0
    racket_width:               .byte 0
    score:                      .byte 0
    holding_ball:               .byte 0
    kill_count:	                .byte 0
    
    ; The ball
    x_velocity:                 .byte 0
    y_velocity:                 .byte 0
    ball_speed:                 .byte 0

    ; Temporary usage
    tmp:                        .byte 0
    sub_routine_tmp:            .byte 0
    sub_routine_arg1:           .byte 0
    sub_routine_arg2:           .byte 0
    
    ; Brick table
    n_bricks:                   .byte 0
    brick_x:                    .byte 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    brick_y:                    .byte 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    brick_tile:                 .byte 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    brick_present:              .byte 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    
    ; Brick update queue
    bricks_to_update:           .byte 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    brick_to_update_high_addrs: .byte 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    brick_to_update_low_addrs:  .byte 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    first_brick_to_update:      .byte 0
    last_brick_to_update:       .byte 0
    
    ; Level table
    level:                      .byte 0
    level_n_data:               .byte 0
    level_data:                 .word 0

    fp:                         .word 0

    ; Music
    music_index:                .word 0
    note_index:                 .word 0
