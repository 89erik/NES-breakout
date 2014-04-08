levels_n:     .byte 3

start_screen_n_data: 
    .byte 11
start_screen_data:
    .byte $0A, $0E, N_CHARACTER
    .byte $0B, $0E, E_CHARACTER
    .byte $0C, $0E, S_CHARACTER
    
    .byte $0E, $0E, B_CHARACTER
    .byte $0F, $0E, R_CHARACTER
    .byte $10, $0E, E_CHARACTER
    .byte $11, $0E, A_CHARACTER
    .byte $12, $0E, K_CHARACTER
    .byte $13, $0E, O_CHARACTER
    .byte $14, $0E, U_CHARACTER
    .byte $15, $0E, T_CHARACTER

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
    
level_2_n_data: 
    .byte 12
level_2_data:
    .byte $0C, $0C, E_CHARACTER
    .byte $0D, $0C, R_CHARACTER
    .byte $0E, $0C, I_CHARACTER
    .byte $0F, $0C, K_CHARACTER
    
    .byte $0C, $0D, E_CHARACTER
    .byte $0D, $0D, R_CHARACTER
    .byte $0E, $0D, I_CHARACTER
    .byte $0F, $0D, K_CHARACTER

    .byte $0C, $0E, E_CHARACTER
    .byte $0D, $0E, R_CHARACTER
    .byte $0E, $0E, I_CHARACTER
    .byte $0F, $0E, K_CHARACTER