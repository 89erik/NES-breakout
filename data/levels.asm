start_screen_n_data: 
    .byte 7
start_screen_data:
    .byte $0C, $0E, N_CHARACTER
    .byte $0D, $0E, E_CHARACTER
    .byte $0E, $0E, S_CHARACTER
    
    .byte $10, $0E, P_CHARACTER
    .byte $11, $0E, O_CHARACTER
    .byte $12, $0E, N_CHARACTER
    .byte $13, $0E, G_CHARACTER

level_1_n_data: 
    .byte 15
level_1_data:
    .byte 10, 10, A_CHARACTER
    .byte 10, 11, A_CHARACTER
    .byte 10, 12, A_CHARACTER
    .byte 10, 13, A_CHARACTER
    .byte 10, 14, A_CHARACTER
    .byte 11, 10, B_CHARACTER
    .byte 11, 11, B_CHARACTER
    .byte 11, 12, B_CHARACTER
    .byte 11, 13, B_CHARACTER
    .byte 11, 14, B_CHARACTER
    .byte 12, 10, C_CHARACTER
    .byte 12, 11, C_CHARACTER
    .byte 12, 12, C_CHARACTER
    .byte 12, 13, C_CHARACTER
    .byte 12, 14, C_CHARACTER
