.include "cpctelera.h.s"
.include "game_over_screen_manager.h.s"
.include "scoreboard_manager.h.s"
.include "game_manager.h.s"
.include "../cpct_functions.h.s"
.include "../system/render_system.h.s"

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; IMPORTS
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
.globl _balkan_motif_left
.globl _balkan_motif_right
.globl _kavalsviri
.globl _sprite_game_over
.globl _sprite_game_win

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; PUBLIC FUNCTIONS
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Manages the game over menu.
;; INPUT:
;;      VOID
;; OUTPUT:
;;      VOID
man_game_over_screen_show::

    

    call draw_game_over_screen

    ld de, #_kavalsviri
    call cpct_akp_musicInit_asm
    
_check_keyboard_over:
    call cpct_waitVSYNC_asm
    call cpct_akp_musicPlay_asm

    ;; Wait for the user to press enter.
    ;; Escanear teclado.
    call cpct_scanKeyboard_asm
    
    ;; Comprobar si se ha pulsado enter.
    ld hl, #Key_Return
    call cpct_isKeyPressed_asm
    cp #0x00
    ret nz
    jr _check_keyboard_over

;; Renders game over screen.
;; INPUT:
;;      A = 1 if player won 0 if player lost.
;; OUTPUT:
;;      VOID
_game_over_title: .asciz "GAME OVER"
_you_win_text: .asciz "YOU WIN!"
_your_score: .asciz "YOUR SCORE"
_high_score: .asciz "HIGH SCORE"
_start_title: .asciz "PRESS ENTER"
_start_title_2: .asciz "TO CONTINUE"
_new_high_score: .asciz "NEW!"
draw_game_over_screen:
    push af
    call man_scoreboard_clean_scoreboard

    ;; Draw menu background. Black screen.
    ld de, #VIDEO_MEMORY_START
    ld a, #0xC0
    ld c, #SCREEN_W
    ld b, #SCREEN_H
    call cpct_drawSolidBox_asm

    ld de, #VIDEO_MEMORY_START
    ld c, #22
    ld b, #0
    call cpct_getScreenPtr_asm
    ex de, hl
    ld a, #0xC0
    ld c, #SCREEN_W
    ld b, #SCREEN_H
    call cpct_drawSolidBox_asm

    DrawNMotifs 13, #0, #_balkan_motif_left, #4, #16
    DrawNMotifs 13, #76, #_balkan_motif_right, #4, #16

    pop af
    cp #1
    jr z, sys_render_show_game_over_win_text

    ;; Set red character color.
    ld l, #0x0F
    ld h, #0x01
    call cpct_setDrawCharM0_asm

    ;; Draw start title.
    ;; Calculate video memory position X = 10, Y = 30
    ; ld de, #VIDEO_MEMORY_START
    ; ld c, #22
    ; ld b, #25
    ; call cpct_getScreenPtr_asm                  ;; Result in HL
    ; ld iy, #_game_over_title
    ; call cpct_drawStringM0_asm

    ld de, #VIDEO_MEMORY_START
    ld c, #8
    ld b, #0
    call cpct_getScreenPtr_asm                  ;; Result in HL
    ;ld iy, #_game_title
    ;call cpct_drawStringM0_asm
    ex de, hl
    ld hl, #_sprite_game_over
    ld c, #63
    ld b, #147
    call cpct_drawSprite_asm

    jr sys_render_show_game_over_draw_score

sys_render_show_game_over_win_text:
    ;; Set green character color.
    ; ld l, #0x09
    ; ld h, #0x01
    ; call cpct_setDrawCharM0_asm

    ; ;; Draw start title.
    ; ;; Calculate video memory position X = 10, Y = 30
    ; ld de, #VIDEO_MEMORY_START
    ; ld c, #25
    ; ld b, #25
    ; call cpct_getScreenPtr_asm                  ;; Result in HL
    ; ld iy, #_you_win_text
    ; call cpct_drawStringM0_asm

    ld de, #VIDEO_MEMORY_START
    ld c, #8
    ld b, #0
    call cpct_getScreenPtr_asm                  ;; Result in HL
    ex de, hl
    ld hl, #_sprite_game_win
    ld c, #63
    ld b, #130
    call cpct_drawSprite_asm

sys_render_show_game_over_draw_score:
    

    ;; Draw score
    ld de, #VIDEO_MEMORY_START
    ld c, #10
    ld b, #150
    call cpct_getScreenPtr_asm                  ;; Result in HL
    ld iy, #_your_score
    call cpct_drawStringM0_asm

    call draw_score

    ;; Draw high score
    ld de, #VIDEO_MEMORY_START
    ld c, #10
    ld b, #160
    call cpct_getScreenPtr_asm                  ;; Result in HL
    ld iy, #_high_score
    call cpct_drawStringM0_asm

    call draw_high_score

    ;; Check if there was a new high score this game.
    ld hl, #man_game_high_score_changed
    ld a, (hl)
    cp #1
    jr nz, continue_drawing_game_over_screen

    ld de, #VIDEO_MEMORY_START
    ld c, #60
    ld b, #170
    call cpct_getScreenPtr_asm                  ;; Result in HL
    ld iy, #_new_high_score
    call cpct_drawStringM0_asm

continue_drawing_game_over_screen:
    ;; Draw start new game title.
    ld de, #VIDEO_MEMORY_START
    ld c, #10
    ld b, #180
    call cpct_getScreenPtr_asm                  ;; Result in HL
    ld iy, #_start_title
    call cpct_drawStringM0_asm
    ld de, #VIDEO_MEMORY_START
    ld c, #30
    ld b, #190
    call cpct_getScreenPtr_asm                  ;; Result in HL
    ld iy, #_start_title_2
    call cpct_drawStringM0_asm
    
    ret


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; PRIVATE FUNCTIONS
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Draws the score.
;; INPUT:
;;      VOID
;; OUTPUT:
;;      VOID
draw_score:
    ld hl, #man_game_display_score
    ld a, (hl)
    inc hl
    push hl

    ;; Draw 1s digit.
    ld c, #68
    ld b, #150

    call draw_digit

    pop hl
    ld a, (hl)
    inc hl
    push hl

    ;; Draw 10s digit.
    ld c, #64
    ld b, #150

    call draw_digit

    pop hl
    ld a, (hl)
    inc hl
    push hl

    ;; Draw 100s digit.
    ld c, #60
    ld b, #150

    call draw_digit

    pop hl
    ld a, (hl)
    inc hl
    push hl

    ;; Draw 1.000s digit.
    ld c, #56
    ld b, #150

    call draw_digit

    pop hl
    ld a, (hl)

    ;; Draw 10.000s digit.
    ld c, #52
    ld b, #150

    call draw_digit

    ret

;; Draws the high score.
;; INPUT:
;;      A = Digit to draw.
;;      C = x coordinate of sprite.
;;      B = y coordinate of sprite.
;; OUTPUT:
;;      VOID
draw_high_score:
    ld hl, #man_game_display_high_score
    ld a, (hl)
    inc hl
    push hl

    ;; Draw 1s digit.
    ld c, #68
    ld b, #160

    call draw_digit

    pop hl
    ld a, (hl)
    inc hl
    push hl

    ;; Draw 10s digit.
    ld c, #64
    ld b, #160

    call draw_digit

    pop hl
    ld a, (hl)
    inc hl
    push hl

    ;; Draw 100s digit.
    ld c, #60
    ld b, #160

    call draw_digit

    pop hl
    ld a, (hl)
    inc hl
    push hl

    ;; Draw 1.000s digit.
    ld c, #56
    ld b, #160

    call draw_digit

    pop hl
    ld a, (hl)

    ;; Draw 10.000s digit.
    ld c, #52
    ld b, #160

    call draw_digit

    ret

;; Draws a digit in a certain coordiante.
;; INPUT:
;;      A = Digit to draw.
;;      C = x coordinate of sprite.
;;      B = y coordinate of sprite.
;; OUTPUT:
;;      VOID
_0: .asciz "0"
_1: .asciz "1"
_2: .asciz "2"
_3: .asciz "3"
_4: .asciz "4"
_5: .asciz "5"
_6: .asciz "6"
_7: .asciz "7"
_8: .asciz "8"
_9: .asciz "9"
draw_digit:
    cp #0
    jr z, sys_render_draw_digit_zero
    cp #1
    jr z, sys_render_draw_digit_one
    cp #2
    jr z, sys_render_draw_digit_two
    cp #3
    jr z, sys_render_draw_digit_three
    cp #4
    jr z, sys_render_draw_digit_four
    cp #5
    jr z, sys_render_draw_digit_five
    cp #6
    jr z, sys_render_draw_digit_six
    cp #7
    jr z, sys_render_draw_digit_seven
    cp #8
    jr z, sys_render_draw_digit_eight
    cp #9
    jr z, sys_render_draw_digit_nine

sys_render_draw_digit_zero:
    ld iy, #_0
    jr sys_render_draw_digit_draw
sys_render_draw_digit_one:
    ld iy, #_1
    jr sys_render_draw_digit_draw
sys_render_draw_digit_two:
    ld iy, #_2
    jr sys_render_draw_digit_draw
sys_render_draw_digit_three:
    ld iy, #_3
    jr sys_render_draw_digit_draw
sys_render_draw_digit_four:
    ld iy, #_4
    jr sys_render_draw_digit_draw
sys_render_draw_digit_five:
    ld iy, #_5
    jr sys_render_draw_digit_draw
sys_render_draw_digit_six:
    ld iy, #_6
    jr sys_render_draw_digit_draw
sys_render_draw_digit_seven:
    ld iy, #_7
    jr sys_render_draw_digit_draw
sys_render_draw_digit_eight:
    ld iy, #_8
    jr sys_render_draw_digit_draw
sys_render_draw_digit_nine:
    ld iy, #_9
    jr sys_render_draw_digit_draw

sys_render_draw_digit_draw:
    push af

    ld de, #VIDEO_MEMORY_START
    call cpct_getScreenPtr_asm

    pop af
    ld b, a
    call cpct_drawStringM0_asm

    ret