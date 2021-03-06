.macro SET_SQUARE_NOTE frequency, count_index, channel
    ; Low part
    LDA #(((1789773 / (frequency * 16)) - 1) & $FF)
    STA $4002 + (4 * (channel -1))
    ; High part and count index
    LDA #((count_index << 3) & %11111000) | ((((1789773 / (frequency * 16)) - 1) >> 8) & %111)
    STA $4003 + (4 * (channel -1))
.endmacro

.macro case val
    CMP #val
    BNE :+
        JMP .ident(.sprintf("@s%d", val))
    :
.endmacro

.macro SKIP_IF_NOT val
    CMP #val
    BNE :+
.endmacro


    
PlayGuitarProSong:  
    LDA #%00000011  ; Square 1 and 2
    STA APU_CTRL

    ;     DClm vol
    LDA #%10000111  ; duty cycle 50% , deaktivert lengdeteller
                    ; deaktivert envelope - generator , fullt volum (15)
    STA $4000
    STA $4004

    LDX note_index
    BEQ @end_of_note
        DEX
        STX note_index
        RTS
    @end_of_note:
  
    LDA music_index 
        SKIP_IF_NOT 0
        SET_SQUARE_NOTE 294, GUITAR_PRO_TONE_LENGTH, 1   ; D
        LDA #$10
        JMP @end_set_note
    :
        SKIP_IF_NOT 1
        SET_SQUARE_NOTE 440, GUITAR_PRO_TONE_LENGTH, 1   ; A
        LDA #$10
        JMP @end_set_note
    :
        SKIP_IF_NOT 2
        SET_SQUARE_NOTE 587, GUITAR_PRO_TONE_LENGTH, 1   ; D
        LDA #$10
        JMP @end_set_note
    :
        SKIP_IF_NOT 3
        SET_SQUARE_NOTE 659, GUITAR_PRO_TONE_LENGTH, 1   ; E
        LDA #$10
        JMP @end_set_note
    :
        SKIP_IF_NOT 4
        SET_SQUARE_NOTE 440, GUITAR_PRO_TONE_LENGTH, 1   ; A
        LDA #$2
        JMP @end_set_note
    :
        SKIP_IF_NOT 5
        SET_SQUARE_NOTE 587, GUITAR_PRO_TONE_LENGTH, 2   ; D
        LDA #$2
        JMP @end_set_note
    :
        SKIP_IF_NOT 6
        SET_SQUARE_NOTE 740, GUITAR_PRO_TONE_LENGTH, 1   ; F#
        LDA #$C
        JMP @end_set_note
    :
        SKIP_IF_NOT 7
        SET_SQUARE_NOTE 659, GUITAR_PRO_TONE_LENGTH, 1   ; E
        LDA #$10
        JMP @end_set_note
    :
        SKIP_IF_NOT 8
        SET_SQUARE_NOTE 587, GUITAR_PRO_TONE_LENGTH, 1   ; D
        LDA #$10
        JMP @end_set_note
    :
        SKIP_IF_NOT 9
        SET_SQUARE_NOTE 440, GUITAR_PRO_TONE_LENGTH, 1   ; A
        LDA #$10
        JMP @end_set_note
    :
        SKIP_IF_NOT 10
        SET_SQUARE_NOTE 587, 1, 1   ; D
        SET_SQUARE_NOTE 262, 1, 2   ; C
        LDA #$20
        JMP @end_set_note
    :
        SKIP_IF_NOT 11
        SET_SQUARE_NOTE 392, GUITAR_PRO_TONE_LENGTH, 1   ; G
        LDA #$10
        JMP @end_set_note
    :
        SKIP_IF_NOT 12
        SET_SQUARE_NOTE 587, 1, 1   ; D
        SET_SQUARE_NOTE 247, 1, 2   ; B
        LDA #$20
        JMP @end_set_note
    :
        SKIP_IF_NOT 13
        SET_SQUARE_NOTE 233, 1, 1   ; A#3
        LDA #$2
        JMP @end_set_note
    :
        SKIP_IF_NOT 14
        SET_SQUARE_NOTE 392, 1, 2   ; G
        LDA #$2
        JMP @end_set_note
    :
        SKIP_IF_NOT 15
        SET_SQUARE_NOTE 587, 1, 2   ; D
        LDA #$7C
        JMP @end_set_note
    :
        SKIP_IF_NOT 16
        SET_SQUARE_NOTE 220, GUITAR_PRO_TONE_LENGTH, 1   ; A3
        LDA #$10
        JMP @end_set_note
    :
        SKIP_IF_NOT 17
        SET_SQUARE_NOTE 440, GUITAR_PRO_TONE_LENGTH, 1   ; A4
        LDA #$10
        JMP @end_set_note
    :
        SKIP_IF_NOT 18
        SET_SQUARE_NOTE 330, GUITAR_PRO_TONE_LENGTH, 1   ; E4
        LDA #$10
        JMP @end_set_note
    :
        SKIP_IF_NOT 19
        SET_SQUARE_NOTE 494, GUITAR_PRO_TONE_LENGTH, 1   ; B4
        LDA #$10
        JMP @end_set_note
    :
        SKIP_IF_NOT 20
        SET_SQUARE_NOTE 554, GUITAR_PRO_TONE_LENGTH, 1   ; C#5
        LDA #$10
        JMP @end_set_note
    :
        SKIP_IF_NOT 21
        SET_SQUARE_NOTE 587, GUITAR_PRO_TONE_LENGTH, 1   ; D5
        LDA #$10
        JMP @end_set_note
    :
        SKIP_IF_NOT 22
        SET_SQUARE_NOTE 659, GUITAR_PRO_TONE_LENGTH, 1   ; E
        LDA #$20
        JMP @end_set_note
    :
        SKIP_IF_NOT 23
        SET_SQUARE_NOTE 294, 1, 1   ; D
        LDA #$5
        JMP @end_set_note
    :
        SKIP_IF_NOT 24
        SET_SQUARE_NOTE 440, 1, 2   ; A
        LDA #$6
        JMP @end_set_note
    :
        SKIP_IF_NOT 25
        SET_SQUARE_NOTE 554, 1, 1   ; C#5
        LDA #$7
        JMP @end_set_note
    :
        SKIP_IF_NOT 26
        SET_SQUARE_NOTE 740, 1, 2   ; F#5
        LDA #$70
        JMP @end_set_note
    :
        LDA #0
        STA music_index
        RTS
      
    @end_set_note:
        STA note_index
        LDX music_index
        INX
        STX music_index
    RTS

PlayNoRemorse:
    LDA #%00000011  ; Square 1 and 2
    STA APU_CTRL

    ;     DClm vol
    LDA #%10000111  ; duty cycle 50% , deaktivert lengdeteller
                    ; deaktivert envelope - generator , fullt volum (15)
    STA $4000
    STA $4004

    LDX note_index
    BEQ @end_of_note
        DEX
        STX note_index
        RTS
    @end_of_note:
  
    LDA music_index 
        SKIP_IF_NOT 0
        SET_SQUARE_NOTE E3, GUITAR_PRO_TONE_LENGTH, 1
        LDA #10
        JMP @end_set_note
    :
        SKIP_IF_NOT 1
        SET_SQUARE_NOTE E3, GUITAR_PRO_TONE_LENGTH, 1
        LDA #10
        JMP @end_set_note
    :
        SKIP_IF_NOT 2
        SET_SQUARE_NOTE G4, GUITAR_PRO_TONE_LENGTH, 1
        LDA #10
        JMP @end_set_note
    :
        SKIP_IF_NOT 3
        SET_SQUARE_NOTE E3, GUITAR_PRO_TONE_LENGTH, 1
        LDA #10
        JMP @end_set_note
    :
        SKIP_IF_NOT 4
        SET_SQUARE_NOTE E3, GUITAR_PRO_TONE_LENGTH, 1
        LDA #10
        JMP @end_set_note
    :
        SKIP_IF_NOT 5
        SET_SQUARE_NOTE Fs4, GUITAR_PRO_TONE_LENGTH, 1
        LDA #10
        JMP @end_set_note
    :
        SKIP_IF_NOT 6
        SET_SQUARE_NOTE E3, GUITAR_PRO_TONE_LENGTH, 1 
        LDA #10
        JMP @end_set_note
    :
        SKIP_IF_NOT 7
        SET_SQUARE_NOTE E3, GUITAR_PRO_TONE_LENGTH, 1 
        LDA #10
        JMP @end_set_note
    :
        SKIP_IF_NOT 8
        SET_SQUARE_NOTE E4, GUITAR_PRO_TONE_LENGTH, 1 
        LDA #10
        JMP @end_set_note
    :
        SKIP_IF_NOT 9
        SET_SQUARE_NOTE E3, GUITAR_PRO_TONE_LENGTH, 1
        LDA #10
        JMP @end_set_note
    :
        SKIP_IF_NOT 10
        SET_SQUARE_NOTE E3, GUITAR_PRO_TONE_LENGTH, 1
        LDA #10
        JMP @end_set_note
    :
        SKIP_IF_NOT 11
        SET_SQUARE_NOTE D4, GUITAR_PRO_TONE_LENGTH, 1
        LDA #10
        JMP @end_set_note
    :
        SKIP_IF_NOT 12
        SET_SQUARE_NOTE E3, GUITAR_PRO_TONE_LENGTH, 1
        LDA #10
        JMP @end_set_note
    :
        SKIP_IF_NOT 13
        SET_SQUARE_NOTE E3, GUITAR_PRO_TONE_LENGTH, 1
        LDA #10
        JMP @end_set_note
    :
        SKIP_IF_NOT 14
        SET_SQUARE_NOTE D4, GUITAR_PRO_TONE_LENGTH, 1
        LDA #10
        JMP @end_set_note
    :
        SKIP_IF_NOT 15
        SET_SQUARE_NOTE E4, GUITAR_PRO_TONE_LENGTH, 1 
        LDA #10
        JMP @end_set_note
    :
        LDA #0
        STA music_index
        RTS
      
    @end_set_note:
        STA note_index
        LDX music_index
        INX
        STX music_index
    RTS

    
PlayBounceSound:
    LDA #%00000011  ; Square 1 and 2
    STA APU_CTRL

    ;     DClm vol
    LDA #%10000111  ; duty cycle 50% , deaktivert lengdeteller
                    ; deaktivert envelope - generator , fullt volum (15)
    STA $4000
    STA $4004

    ;SET_SQUARE_NOTE 440, 0, 1
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

    ;SET_SQUARE_NOTE 200, 0, 1
    SET_SQUARE_NOTE 440, 0, 2
    
    RTS

PlayCatchTokenSound:
    LDA #%00000011  ; Square 1 and 2
    STA APU_CTRL

    ;     DClm vol
    LDA #%10000111  ; duty cycle 50% , deaktivert lengdeteller
                    ; deaktivert envelope - generator , fullt volum (15)
    STA $4000
    STA $4004

    ;SET_SQUARE_NOTE 440, 0, 1
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