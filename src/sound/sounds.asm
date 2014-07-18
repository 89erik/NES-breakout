.macro SET_SQUARE_NOTE frequency, count_index, channel
    ; Low part
    LDA #(((1789773 / (frequency * 16)) - 1) & $FF)
    STA $4002 + (4 * (channel -1))
    ; High part and count index
    LDA #((count_index << 3) & %11111000) | ((((1789773 / (frequency * 16)) - 1) >> 8) & %111)
    STA $4003 + (4 * (channel -1))
.endmacro


PlayBounceSound:
    LDA #%00000011  ; Square 1 and 2
    STA APU_CTRL

    ;     DClm vol
    LDA #%10000111  ; duty cycle 50% , deaktivert lengdeteller
                    ; deaktivert envelope - generator , fullt volum (15)
    STA $4000
    STA $4004

    SET_SQUARE_NOTE 440, 0, 1
    SET_SQUARE_NOTE 220, 0, 2
    
    RTS

PlayKillBrickSound:
    LDA #%00000011  ; Square 1 and 2
    STA APU_CTRL

    ;     DClm vol
    LDA #%10000111  ; duty cycle 50% , deaktivert lengdeteller
                    ; deaktivert envelope - generator , fullt volum (15)
    STA $4000
    STA $4004

    SET_SQUARE_NOTE 200, 0, 1
    SET_SQUARE_NOTE 220, 0, 2
    
    RTS

PlayCatchTokenSound:
    LDA #%00000011  ; Square 1 and 2
    STA APU_CTRL

    ;     DClm vol
    LDA #%10000111  ; duty cycle 50% , deaktivert lengdeteller
                    ; deaktivert envelope - generator , fullt volum (15)
    STA $4000
    STA $4004

    SET_SQUARE_NOTE 440, 0, 1
    SET_SQUARE_NOTE 400, 0, 2
    
    RTS

PlayDeathSound:
    RTS
    LDA #%00000100 ; aktiver triangle
    STA $4015
    
    LDA #%10000001 ; deaktiver tellerne , sett lineærtelleren
                    ; til noe annet enn 0
    STA $4008
    LDA #235 ; t = 235 gir f = ca. 220 Hz (PAL )
    STA $400A ; lagre lav del av perioden
    
    LDA #0 ; vi har ingen høy del
    STA $400B  
    
    RTS