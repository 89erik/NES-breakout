; ------------------------------------------------ ;
; ---------------[ INITIALIZATION ]--------------- ;
; ------------------------------------------------ ;
; The CPU starts here at boot. This part of the    ;
; code will set up the memory and PPU.             ;
; ------------------------------------------------ ;

; -[WAIT 2 FRAMES FOR PPU BOOT]-
:   LDA $2002
    BPL :-
:   LDA $2002
    BPL :-

; -[TURN OFF RENDERING]-
    JSR DisablePpuRendering

; -[LOAD PALETTE]-
    LDA #$3F
    STA PPU_ADDRESS  ; PPU address = start of palette
    LDA #$00
    STA PPU_ADDRESS      
    
    LDX #0
    @load_palette:
        LDA palette, X
        STA PPU_VALUE
        INX
        CPX #32
        BNE @load_palette
    
; -[INIT STACK]-
    LDX #$FF
    TXS
    LDA #STACK_PAGE
    LDX #1
    STA fp, X

;--------------------------------------------------------
; Test area
JMP @done

@done:
;--------------------------------------------------------

; -[INIT STATE VARIABLES]-
    LDA #0
    STA bg_color
    LDA #0
    STA x_velocity
    LDA #BALL_DEFAULT_SPEED_Y
    STA ball_speed
    STA y_velocity
    LDA #RACKET_START_WIDTH
    STA racket_width
    LDA #(RIGHT_WALL/2) - (RACKET_START_WIDTH/2)
    STA racket_pos
    LDA #TRUE
    STA holding_ball
    LDA #INITIAL_SCORE
    STA score
    LDA #0
    STA first_brick_to_update
    STA last_brick_to_update
    
    
; -[INIT GAME-INDEPENDENT OAM DATA]-
    ; BALL
        LDA #BALL_TILE
        STA ball_tile
        LDA #%00000001; (Palette 1)
        STA ball_attribute
    
    ; RACKET
        LDA #RACKET_START_WIDTH
        STA racket_width
        JSR DrawRacket
    
    ; PLAYER 1 AND 2 SCORES 
        LDX #4 ; offset for high digit
        
        ; y pos
        LDA #32
        STA score_y          ; p1 low digit
        STA score_y, X       ; p1 high digit

        ; x pos
        LDA #32 
        STA score_x, X       ; p1 high digit
        LDA #40
        STA score_x          ; p1 low digit
        
        LDA #0 ; attribute byte
        STA score_attribute          ; p1 low digit
        STA score_attribute, X       ; p1 high digit

        ; Score initially invisible
        LDA #0
        STA score_tile    ; low digit
        STA score_tile, X ; high digit
    
    JSR FillBackground
    
; -[INIT PPU (ENABLES RENDERING)]-
    JSR EnablePpuRendering
    
; -[LAUNCH START SCREEN]-    
    JSR StartScreen
    
; -[LOAD LEVEL 1]-
    LDA #1
    STA level
    JSR SetAndLoadLevel
    JSR DrawLevel
    JSR DrawScore

; -[TOKEN DEMO (CAN BE REMOVED)]-
    LDA #INCREASE_SPEED_TOKEN
    STA token_tile
    LDA #0
    STA token_y
    STA token_attribute
    LDA #100
    STA token_x
