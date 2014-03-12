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
    STA PPU_ADRESS  ; PPU adress = start of palette
    LDA #$00
    STA PPU_ADRESS      
    
    LDX #0
    @load_palette:
        LDA Palette, X
        STA PPU_VALUE
        INX
        CPX #32
        BNE @load_palette

; -[FILL BACKGROUND]-
    LDA #1
    STA level
    JSR SetAndLoadLevel
    JSR FillBackground
    
; -[SET SCROLL]-
    LDA #0
    STA PPU_SCROLL
    STA PPU_SCROLL
    
; -[INIT STACK]-
    LDX #$FF
    TXS

;--------------------------------------------------------
; Test area
JMP @done

    
    
 ;   LDA #<level
 ;   STA pointer
 ;   LDA #>level
 ;   LDX #1
 ;   STA pointer, X
    
    
 ;   LDA #$ab
 ;   STA level
    
    
  ;  LDY #0
  ;  LDA (<pointer), Y


    @derp: JMP @derp
    
@done:
;--------------------------------------------------------

; -[INIT STATE VARIABLES]-
    LDA #0
    STA bg_color
    LDA #0
    STA x_vector
    LDA #BALL_SPEED_Y
    STA y_vector
    LDA #RACKET_START_WIDTH
    STA racket_width
    LDA #(RIGHT_WALL/2) - (RACKET_START_WIDTH/2)
    STA racket_pos
    LDA #TRUE
    STA holding_ball
    LDA #10
    STA p1_score

    
; -[INIT GAME-INDEPENDENT OAM DATA]-
    ; BALL
        LDA #BALL_TILE
        STA ball_tile
        LDA #%00000001; (Palette 1)
        STA ball_attribute
        
    ; PLAYER RACKET
        LDX #0 ; offset
        LDY #0 ; offset x4
        @left_edge_of_racket:
            LDA #RACKET_LEFT_TILE
            STA player_tile, Y
            LDA #RACKET_ATTRIBUTE
            STA player_attribute, Y
            JSR IncrementOffset

        CPX #RACKET_START_WIDTH-1
        BCS @right_edge_of_racket
        
        @center_racket:
            LDA #RACKET_CENTER_TILE
            STA player_tile, Y
            LDA #RACKET_ATTRIBUTE
            STA player_attribute, Y
            JSR IncrementOffset
            CPX #RACKET_START_WIDTH-1
            BCC @center_racket
        
        @right_edge_of_racket:
            LDA #RACKET_RIGHT_TILE
            STA player_tile, Y
            LDA #RACKET_ATTRIBUTE
            STA player_attribute, Y
            JSR IncrementOffset
        
        CPX #RACKET_MAX_WIDTH
        BCS @done_init_racket
        
        @invisible_racket:
            LDA #BLANK_SPRITE_TILE
            STA player_tile, Y
            LDA #RACKET_ATTRIBUTE
            STA player_attribute, Y
            JSR IncrementOffset
            CPX #RACKET_MAX_WIDTH
            BCC @invisible_racket
        
        JMP @done_init_racket
        

            
    @done_init_racket:
    
    ; PLAYER 1 AND 2 SCORES 
        LDX #4 ; offset for high digit
        
        LDA #32 ; y pos
        STA p1_score_y          ; p1 low digit
        STA p1_score_y, X       ; p1 high digit
        
        LDA #$10 ; tile number
        STA p1_score_tile           ; p1 low digit
        STA p1_score_tile, X        ; p1 high digit
        
        LDA #0 ; attribute byte
        STA p1_score_attribute          ; p1 low digit
        STA p1_score_attribute, X       ; p1 high digit
        
        ; x pos player 1
        LDA #32 
        STA p1_score_x, X       ; p1 high digit
        LDA #40
        STA p1_score_x          ; p1 low digit
        
    
; -[INIT PPU (ENABLES RENDERING)]-
    JSR EnablePpuRendering
