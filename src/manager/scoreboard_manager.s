.include "game_manager.h.s"
.include "scoreboard_manager.h.s"
.include "../system/render_system.h.s"
.include "../cpct_functions.h.s"
.include "../utils.h.s"

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; IMPORTS
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
.globl _sprite_string_score
.globl _sprite_string_active
.globl _sprite_string_power
.globl _sprite_string_ups
.globl _sprite_string_lives
.globl _sprite_string_stage
.globl _sprite_string_high

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; PUBLIC FUNCTIONS
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Initializes the scoreboard.
;; INPUT:
;;      VOID
;; OUTPUT:
;;      VOID
man_scoreboard_init::
    call man_scoreboard_clean_scoreboard

    ;; Draw "score" text.
    ld hl, #_sprite_string_score
    ld c, #(SCOREBOARD_X_START + HORIZONTAL_SPACING)
    ld b, #(BORDER_TOP_H)
    ld d, #SCORE_TEXT_W
    ld e, #TEXT_H
    call sys_render_draw_sprite

    ;; Draw score.
    call draw_score

    ;; Draw "lives" text
    ld hl, #_sprite_string_lives
    ld c, #(SCOREBOARD_X_START + HORIZONTAL_SPACING)
    ld b, #(BORDER_TOP_H + TEXT_H + DIGIT_H + 6*VERTICAL_SPACING)
    ld d, #LIVES_TEXT_W
    ld e, #TEXT_H
    call sys_render_draw_sprite    

    ;; Draw lives
    call draw_lives

    ;; Draw "level" text.
    ld hl, #_sprite_string_stage
    ld c, #(SCOREBOARD_X_START + HORIZONTAL_SPACING)
    ld b, #(24*VERTICAL_SPACING)
    ld d, #STAGE_TEXT_W
    ld e, #TEXT_H
    call sys_render_draw_sprite

    ;; Draw stage number
    call man_scoreboard_draw_stage_number

    ;; Draw "high score" text.
    ld hl, #_sprite_string_high
    ld c, #(SCOREBOARD_X_START + HORIZONTAL_SPACING)
    ld b, #(BORDER_TOP_H + 5*TEXT_H + 2*DIGIT_H +  25*VERTICAL_SPACING + 2*LIFE_ICON_H + POWERUP_SPRITE_H)
    ld d, #HIGH_TEXT_W
    ld e, #TEXT_H
    call sys_render_draw_sprite

    ld hl, #_sprite_string_score
    ld c, #(SCOREBOARD_X_START + 2*HORIZONTAL_SPACING)
    ld b, #(BORDER_TOP_H + 6*TEXT_H + 2*DIGIT_H + 25*VERTICAL_SPACING + 2*LIFE_ICON_H + POWERUP_SPRITE_H)
    ld d, #SCORE_TEXT_W
    ld e, #TEXT_H
    call sys_render_draw_sprite

    ;; Draw high score.
    call draw_high_score

    ret

;; Cleans everything from the scoreboard.
;; INPUT:
;;      VOID
;; OUTPUT:
;;      VOID
man_scoreboard_clean_scoreboard::
    ;; Clean scoreboard.
    ld c, #SCOREBOARD_X_START
    ld b, #0
    ld de, #VIDEO_MEMORY_START
    call cpct_getScreenPtr_asm                  ;; Result in HL

    ex de, hl
    ld a, #0x00
    ld c, #(79-SCOREBOARD_X_START+1)
    ld b, #SCREEN_H
    call cpct_drawSolidBox_asm

    ret
    
man_scoreboard_update_score::
    call erase_score
    call draw_score

    ret

man_scoreboard_draw_stage_number::
    call man_game_get_current_stage_number
    push bc

    ld d, #0
    push de

    ld a, b
    cp #0
    jr z, man_scoreboard_draw_stage_number_draw_second_digit

    ld c, #(SCOREBOARD_X_START + 2*HORIZONTAL_SPACING)
    ld b, #(26*VERTICAL_SPACING)
    call sys_render_draw_digit

    pop de
    ld d, #1
    push de

man_scoreboard_draw_stage_number_draw_second_digit:
    pop de
    pop bc

    ld b, c
    ld c, #(SCOREBOARD_X_START + 2*HORIZONTAL_SPACING)
    
    ld a, d
    cp #0
    jr z, man_scoreboard_draw_stage_number_draw_dont_add_offset

    ld a, c
    add #DIGIT_W
    ld c, a

man_scoreboard_draw_stage_number_draw_dont_add_offset:
    ld a, b
    ld b, #(26*VERTICAL_SPACING)
    call sys_render_draw_digit

    ret

man_scoreboard_draw_catch_powerup_icon::
    ld c, #(SCOREBOARD_X_START + HORIZONTAL_SPACING)
    ld b, #(BORDER_TOP_H + 4*TEXT_H + DIGIT_H + 14*VERTICAL_SPACING + 2*LIFE_ICON_H)

    call sys_render_draw_powerup_catch

    ret

man_scoreboard_update_high_score::
    call erase_high_score
    call draw_high_score

    ret

man_scoreboard_remove_life::
    ld a, (man_game_lives)

    call get_life_coords

    ld d, #LIFE_ICON_W
    ld e, #LIFE_ICON_H
    call sys_reder_remove_sprite

    ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; PRIVATE FUNCTIONS
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Erases the score from the scoreboard.
;; INPUT:
;;      VOID
;; OUTPUT:
;;      VOID
erase_score:
    ld c, #(SCOREBOARD_X_START + 2*HORIZONTAL_SPACING)
    ld b, #(BORDER_TOP_H + TEXT_H + VERTICAL_SPACING)
    ld d, #(5*DIGIT_W)
    ld e, #DIGIT_H
    call sys_reder_remove_sprite

    ret

;; Erases the high score from the scoreboard.
;; INPUT:
;;      VOID
;; OUTPUT:
;;      VOID
erase_high_score:
    ld c, #(SCOREBOARD_X_START + 3*HORIZONTAL_SPACING)
    ld b, #(BORDER_TOP_H + 6*TEXT_H + 2*DIGIT_H +  27*VERTICAL_SPACING + 2*LIFE_ICON_H + POWERUP_SPRITE_H)
    ld d, #(5*DIGIT_W)
    ld e, #DIGIT_H
    call sys_reder_remove_sprite

    ret

;; Draws the high score.
;; INPUT:
;;      VOID
;; OUTPUT:
;;      VOID
draw_high_score:
    ld hl, #man_game_display_high_score
    ld a, (hl)
    inc hl
    push hl

    ;; Draw 1s digit.
    ld c, #(SCOREBOARD_X_START + 3*HORIZONTAL_SPACING + 4*DIGIT_W)
    ld b, #(BORDER_TOP_H + 6*TEXT_H + 2*DIGIT_H +  27*VERTICAL_SPACING + 2*LIFE_ICON_H + POWERUP_SPRITE_H)

    call sys_render_draw_digit

    pop hl
    ld a, (hl)
    inc hl
    push hl

    ;; Draw 10s digit.
    ld c, #(SCOREBOARD_X_START + 3*HORIZONTAL_SPACING + 3*DIGIT_W)
    ld b, #(BORDER_TOP_H + 6*TEXT_H + 2*DIGIT_H +  27*VERTICAL_SPACING + 2*LIFE_ICON_H + POWERUP_SPRITE_H)

    call sys_render_draw_digit

    pop hl
    ld a, (hl)
    inc hl
    push hl

    ;; Draw 100s digit.
    ld c, #(SCOREBOARD_X_START + 3*HORIZONTAL_SPACING + 2*DIGIT_W)
    ld b, #(BORDER_TOP_H + 6*TEXT_H + 2*DIGIT_H +  27*VERTICAL_SPACING + 2*LIFE_ICON_H + POWERUP_SPRITE_H)

    call sys_render_draw_digit

    pop hl
    ld a, (hl)
    inc hl
    push hl

    ;; Draw 1.000s digit.
    ld c, #(SCOREBOARD_X_START + 3*HORIZONTAL_SPACING + DIGIT_W)
    ld b, #(BORDER_TOP_H + 6*TEXT_H + 2*DIGIT_H +  27*VERTICAL_SPACING + 2*LIFE_ICON_H + POWERUP_SPRITE_H)

    call sys_render_draw_digit

    pop hl
    ld a, (hl)

    ;; Draw 10.000s digit.
    ld c, #(SCOREBOARD_X_START + 3*HORIZONTAL_SPACING)
    ld b, #(BORDER_TOP_H + 6*TEXT_H + 2*DIGIT_H +  27*VERTICAL_SPACING + 2*LIFE_ICON_H + POWERUP_SPRITE_H)

    call sys_render_draw_digit

    ret    

    ret

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
    ld c, #(SCOREBOARD_X_START + 2*HORIZONTAL_SPACING + 4*DIGIT_W)
    ld b, #(BORDER_TOP_H + TEXT_H + VERTICAL_SPACING)

    call sys_render_draw_digit

    pop hl
    ld a, (hl)
    inc hl
    push hl

    ;; Draw 10s digit.
    ld c, #(SCOREBOARD_X_START + 2*HORIZONTAL_SPACING + 3*DIGIT_W)
    ld b, #(BORDER_TOP_H + TEXT_H + VERTICAL_SPACING)

    call sys_render_draw_digit

    pop hl
    ld a, (hl)
    inc hl
    push hl

    ;; Draw 100s digit.
    ld c, #(SCOREBOARD_X_START + 2*HORIZONTAL_SPACING + 2*DIGIT_W)
    ld b, #(BORDER_TOP_H + TEXT_H + VERTICAL_SPACING)

    call sys_render_draw_digit

    pop hl
    ld a, (hl)
    inc hl
    push hl

    ;; Draw 1.000s digit.
    ld c, #(SCOREBOARD_X_START + 2*HORIZONTAL_SPACING + DIGIT_W)
    ld b, #(BORDER_TOP_H + TEXT_H + VERTICAL_SPACING)

    call sys_render_draw_digit

    pop hl
    ld a, (hl)

    ;; Draw 10.000s digit.
    ld c, #(SCOREBOARD_X_START + 2*HORIZONTAL_SPACING)
    ld b, #(BORDER_TOP_H + TEXT_H + VERTICAL_SPACING)

    call sys_render_draw_digit

    ret

;; Returns the x and y coords where a life icon should be drawn.
;; INPUT:
;;      A = Number of lives.
;; OUTPUT:
;;      C = x coordinate of sprite.
;;      B = y coordinate of sprite.
get_life_coords:
    push af

    ;; Get y coordinate.
    ld c, a
    ld b, #3                               ;; Number of lives in a line.
    call utils_div_8b

    ;; Add margin between lines.
    ld b, #(2*VERTICAL_SPACING + LIFE_ICON_H)
    ld c, a
    call utils_mult_8b

    ;; Add constant part.
    add #(BORDER_TOP_H + 2*TEXT_H + DIGIT_H + 8*VERTICAL_SPACING)
    ld d, a

    ;; Get x coordinate.
    pop af

    ;; Save y coordinate.
    push de

    ld b, #3                                ;; Number of lives in a line.
    call utils_modulo_8b

    ;; Add margin between icons.
    ld b, #(SCOREBOARD_LIFE_ICON_MARGIN + LIFE_ICON_W)
    ld c, a
    call utils_mult_8b

    ;; Add constant part.
    add #(SCOREBOARD_X_START + HORIZONTAL_SPACING)
    ld c, a

    pop de
    ld b, d

    ret

;; Draws the life icons.
;; INPUT:
;;      VOID
;; OUTPUT:
;;      VOID
draw_lives:
    ld hl, #man_game_lives
    ld a, (hl)

    ld b, a                     ;; Iteration limit.
    ld a, #0                    ;; Current number of iteraitons.

draw_lives_loop:
    ;; If loop limit has been reached return.
    cp b
    jr z, draw_lives_return

    push bc
    push af

    call get_life_coords
    call sys_render_draw_life_icon

    pop af
    pop bc
    inc a

    jr draw_lives_loop


draw_lives_return:
    ret
