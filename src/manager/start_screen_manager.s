.include "start_screen_manager.h.s"
.include "scoreboard_manager.h.s"
.include "../cpct_functions.h.s"
.include "cpctelera.h.s"
.include "../system/render_system.h.s"

.globl cpct_waitVSYNC_asm
.globl cpct_akp_musicInit_asm
.globl cpct_akp_musicPlay_asm
.globl _balkan_motif_left
.globl _balkan_motif_right
.globl _sprite_cover
.globl _balkan_motif_left_hs
.globl _balkan_motif_right_hs

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; PUBLIC FUNCTIONS
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Manages the game menu.
;; INPUT:
;;      VOID
;; OUTPUT:
;;      VOID
.globl _mercadona
man_start_screen_show::
    ;; Limpiar el area del scoreboard, que puede quedar con cosas dibujadas.
    call man_scoreboard_clean_scoreboard

    call draw_start_screen

    ld de, #_mercadona
    call cpct_akp_musicInit_asm
    
_check_keyboard_menu:

    call cpct_waitVSYNC_asm
    call cpct_akp_musicPlay_asm

    ;; Wait for the user to press space.
    ;; Escanear teclado.
    call cpct_scanKeyboard_asm
    
    ;; Comprobar si se ha pulsado espacio.
    ld hl, #Key_Return
    call cpct_isKeyPressed_asm
    cp #0x00
    ret nz
    jr _check_keyboard_menu

;; Renders game start menu.
;; INPUT:
;;      VOID
;; OUTPUT:
;;      VOID
_game_title: .asciz "BALKANOID"
_how_to_play_title: .asciz "HOW TO PLAY"
_how_to_play_1: .asciz "- O to move left"
_how_to_play_2: .asciz "- P to move right"
_how_to_play_3: .asciz "- Space to launch"
_how_to_play_4: .asciz "  the ball"
_start_title: .asciz "PRESS ENTER"
_start_title_2: .asciz "TO START"
draw_start_screen:
    ;; Draw menu background. Black screen.
    ld de, #VIDEO_MEMORY_START
    ld a, #0x00
    ld c, #SCREEN_W
    ld b, #SCREEN_H
    call cpct_drawSolidBox_asm

    ;; Draw border motifs.
    DrawNMotifs 12, #0, #_balkan_motif_left, #4, #16

    ld de, #VIDEO_MEMORY_START
    ld c, #0
    ld b, #191
    call cpct_getScreenPtr_asm                  ;; Result in HL
    ex de, hl
    ld hl, #_balkan_motif_left_hs
    ld c, #4
    ld b, #8
    call cpct_drawSprite_asm

    DrawNMotifs 12, #76, #_balkan_motif_right, #4, #16

    ld de, #VIDEO_MEMORY_START
    ld c, #76
    ld b, #191
    call cpct_getScreenPtr_asm                  ;; Result in HL
    ex de, hl
    ld hl, #_balkan_motif_right_hs
    ld c, #4
    ld b, #8
    call cpct_drawSprite_asm

    ld l, #0x04
    ld h, #0x00
    call cpct_setDrawCharM0_asm
    
    ;; Draw game title.
    ;; Calculate video memory position X = 20, Y = 25
    ld de, #VIDEO_MEMORY_START
    ld c, #15
    ld b, #25
    call cpct_getScreenPtr_asm                  ;; Result in HL
    ;ld iy, #_game_title
    ;call cpct_drawStringM0_asm
    ex de, hl
    ld hl, #_sprite_cover
    ld c, #52
    ld b, #24
    call cpct_drawSprite_asm


    ld l, #0x0E
    ld h, #0x00
    call cpct_setDrawCharM0_asm

    ;; Draw start title.
    ;; Calculate video memory position X = 10, Y = 30
    ld de, #VIDEO_MEMORY_START
    ld c, #5
    ld b, #63
    call cpct_getScreenPtr_asm                  ;; Result in HL
    ld iy, #_how_to_play_title
    call cpct_drawStringM0_asm
    ld de, #VIDEO_MEMORY_START
    ld c, #7
    ld b, #78
    call cpct_getScreenPtr_asm                  ;; Result in HL
    ld iy, #_how_to_play_1
    call cpct_drawStringM0_asm
    ld de, #VIDEO_MEMORY_START
    ld c, #7
    ld b, #93
    call cpct_getScreenPtr_asm                  ;; Result in HL
    ld iy, #_how_to_play_2
    call cpct_drawStringM0_asm
    ld de, #VIDEO_MEMORY_START
    ld c, #7
    ld b, #108
    call cpct_getScreenPtr_asm                  ;; Result in HL
    ld iy, #_how_to_play_3
    call cpct_drawStringM0_asm
    ld de, #VIDEO_MEMORY_START
    ld c, #7
    ld b, #123
    call cpct_getScreenPtr_asm                  ;; Result in HL
    ld iy, #_how_to_play_4
    call cpct_drawStringM0_asm

    ld l, #0x04
    ld h, #0x00
    call cpct_setDrawCharM0_asm

    ;; Draw start title.
    ;; Calculate video memory position X = 10, Y = 30
    ld de, #VIDEO_MEMORY_START
    ld c, #10
    ld b, #160
    call cpct_getScreenPtr_asm                  ;; Result in HL
    ld iy, #_start_title
    call cpct_drawStringM0_asm
    ld de, #VIDEO_MEMORY_START
    ld c, #40
    ld b, #170
    call cpct_getScreenPtr_asm                  ;; Result in HL
    ld iy, #_start_title_2
    call cpct_drawStringM0_asm

    ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; PRIVATE FUNCTIONS
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;