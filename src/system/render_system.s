.include "render_system.h.s"
.include "../manager/scoreboard_manager.h.s"
.include "../manager/game_manager.h.s"
.include "../manager/entity_manager.h.s"
.include "../manager/stage_manager.h.s"
.include "../cpct_functions.h.s"

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; IMPORTS
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
.globl _sprite_border_top
.globl _border_side_motif
.globl _sprite_bar
.globl _sprite_ball
.globl _sprite_ball2
.globl _sprite_block_common_0
.globl _sprite_block_common_1
.globl _sprite_block_common_2
.globl _sprite_block_common_3
.globl _sprite_block_common_4
.globl _sprite_block_silver
.globl _sprite_block_gold
.globl _sprite_string_digits_00
.globl _sprite_string_digits_01
.globl _sprite_string_digits_02
.globl _sprite_string_digits_03
.globl _sprite_string_digits_04
.globl _sprite_string_digits_05
.globl _sprite_string_digits_06
.globl _sprite_string_digits_07
.globl _sprite_string_digits_08
.globl _sprite_string_digits_09
.globl _sprite_icon_life
.globl _sprite_powerup_catch
.globl _sprite_cover

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; VARIABLES
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
iteration_counter:
    .db 0x00


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; PUBLIC FUNCTIONS
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Cleans the screen and draws the current stage.
;; INPUT:
;;      VOID
;; OUTPUT:
;;      VOID
sys_render_change_stage::
    call clean_stage_screen

    ld hl, #man_entity_stage_block_array
    call sys_render_draw_stage

    call man_scoreboard_draw_stage_number
    
    ret

;; Initializes the game screen.
;; INPUT:
;;      VOID
;; OUTPUT:
;;      VOID
sys_render_init_game_screen::
    ;; Draw menu background. Black screen.
    ld de, #VIDEO_MEMORY_START
    ld a, #0x00
    ld c, #SCREEN_W
    ld b, #SCREEN_H
    call cpct_drawSolidBox_asm

    call sys_render_draw_left_side_border
    call sys_render_draw_right_side_border
    call sys_render_draw_top_border

    call man_scoreboard_init

    ld hl, #man_entity_stage_block_array
    call sys_render_draw_stage

    call sys_reder_draw_bar

    call sys_reder_draw_ball

    ret

;; Draws the sprite of the bar at it's current position.
;; INPUT:
;;      VOID
;; OUTPUT:
;;      VOID
sys_reder_draw_bar::
    ;; Draw sprite.
    ld hl, #man_entity_bar_position
    ld c, (hl)                                  ;; x
    ld b, #BAR_Y_POSITION                       ;; y
    ld hl, #_sprite_bar                         ;; sprite to draw
    ld d, #BAR_W                                ;; sprite width
    ld e, #BAR_H                                ;; sprite height
    call sys_render_draw_sprite

    ret

;; Draws the sprite of the ball at it's current position.
;; INPUT:
;;      VOID
;; OUTPUT:
;;      VOID
sys_reder_draw_ball::
    ;; Draw sprite.
    ld hl, #man_entity_ball_position
    ld e, (hl)
    inc hl
    ld c, (hl)                                      ;; x
    inc hl                                          ;; x and y are words with the first byte being the integer part, so we need to increment hl twice.
    inc hl
    ld b, (hl)                                      ;; y
    ;and #0xFE
    ;ld b, a
    ld a, #0x7F
    cp e
    ;; If c is greater than 127, then draw the sprite_ball2, else draw sprite_ball.
    jr c, _draw_ball2
    ld hl, #_sprite_ball                            ;; sprite to draw
    jr _continue_draw_ball

    _draw_ball2:
    ld hl, #_sprite_ball2                           ;; sprite to draw

    _continue_draw_ball:
    ld d, #BALL_W                                   ;; sprite width
    ld e, #BALL_H                                   ;; sprite height
    call sys_render_draw_sprite

    ret

;; Draws the life sprite at the given position.
;; INPUT:
;;      C = x coordinate of sprite.
;;      B = y coordinate of sprite.
;; OUTPUT:
;;      VOID
sys_render_draw_life_icon::
    ;; Draw sprite.
    ld hl, #_sprite_icon_life                           ;; sprite to draw
    ld d, #LIFE_ICON_W                                  ;; sprite width
    ld e, #LIFE_ICON_H                                  ;; sprite height
    call sys_render_draw_sprite

    ret


;; Draws a solid block with background color in a specified position with a 
;; specified size.
;; INPUT:
;;      C = x coordinate of sprite.
;;      B = y coordinate of sprite.
;;      D = width of sprite (in bytes).
;;      E = height of sprite (in bytes).
;; OUTPUT:
;;      VOID
sys_reder_remove_sprite::
    ;; Get pointer to video memory.
    push de
    ld de, #VIDEO_MEMORY_START
    call cpct_getScreenPtr_asm                  ;; Result in HL

    ;; Get saved width and height of box.
    pop de
    ex de, hl

    ;; Draw solid box.
    ;; de = pointer to video memory
    ld a, #0x00                                 ;; Background color.
    ld c, h                                     ;; width
    ld b, l                                     ;; height

    call cpct_drawSolidBox_asm

    ret

;; Draws all the blocks of the stage.
;; specified size.
;; INPUT:
;;      HL = pointer to the stage's block array.
;; OUTPUT:
;;      VOID
sys_render_draw_stage::
sys_render_draw_stage_loop_start:
    ld a, (hl)                                  ;; block type
    
    cp #END_OF_BLOCKS_ARRAY_BYTE
    jp z, sys_render_draw_stage_return          ;; if zero falg is active is because we have reached end of the array, return.

    inc hl
    ld c, (hl)                                  ;; C = x coordinate of sprite.

    inc hl
    ld b, (hl)                                  ;; B = y coordinate of sprite.

    inc hl                                      ;; ignore durability
    inc hl

    ;; Save color in D.
    ld d, (hl)

    inc hl                                      ;; Go to next block

    push hl

    cp #BLOCK_COMMON
    jp z, sys_render_draw_stage_draw_common_block

    cp #BLOCK_SILVER
    jp z, sys_render_draw_stage_draw_silver_block
    
    cp #BLOCK_GOLD
    jp z, sys_render_draw_stage_draw_gold_block

sys_render_draw_stage_draw_common_block:
    call sys_render_draw_common_block

    pop hl
    jr sys_render_draw_stage_loop_start

sys_render_draw_stage_draw_silver_block:
    call sys_render_draw_silver_block

    pop hl
    jr sys_render_draw_stage_loop_start

sys_render_draw_stage_draw_gold_block:
    call sys_render_draw_gold_block

    pop hl
    jr sys_render_draw_stage_loop_start

sys_render_draw_stage_return:
    ret

;; Removes the bar sprite from the screen.
;; INPUT:
;;      VOID
;; OUTPUT:
;;      VOID
sys_render_remove_bar::
    ld hl, #man_entity_bar_position
    ld c, (hl)
    ld b, #BAR_Y_POSITION
    ld d, #BAR_W
    ld e, #BAR_H

    call sys_reder_remove_sprite

    ret

sys_render_remove_ball::
    ld hl, #man_entity_ball_position + 1
    ld c, (hl)
    inc hl
    inc hl
    ld b, (hl)
    ld d, #BALL_W
    ld e, #BALL_H
    call sys_reder_remove_sprite

    ret
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; PRIVATE FUNCTIONS
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Draws a sprite.
;; INPUT:
;;      HL = adress of sprite to paint.
;;      C = x coordinate of sprite.
;;      B = y coordinate of sprite.
;;      D = width of sprite (in bytes).
;;      E = height of sprite (in bytes).
;; OUTPUT:
;;      VOID
sys_render_draw_sprite::
    ;; Get pointer to start of screen.
    push hl
    push de
    ld de, #VIDEO_MEMORY_START
    call cpct_getScreenPtr_asm                  ;; Result in HL

    ;; Draw left corner of border.
    pop de
    ld c, d                                     ;; Sprite width
    ld b, e                                     ;; Sprite height
    ex de, hl                                   ;; DE = pointer to video memory
    pop hl                                      ;; HL = dirección donde se encuentra el sprite
    call cpct_drawSprite_asm

    ret

;; Draws a digit in a certain coordiante.
;; INPUT:
;;      A = Digit to draw.
;;      C = x coordinate of sprite.
;;      B = y coordinate of sprite.
;; OUTPUT:
;;      VOID
sys_render_draw_digit::
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
    ld hl, #_sprite_string_digits_00
    jr sys_render_draw_digit_draw
sys_render_draw_digit_one:
    ld hl, #_sprite_string_digits_01
    jr sys_render_draw_digit_draw
sys_render_draw_digit_two:
    ld hl, #_sprite_string_digits_02
    jr sys_render_draw_digit_draw
sys_render_draw_digit_three:
    ld hl, #_sprite_string_digits_03
    jr sys_render_draw_digit_draw
sys_render_draw_digit_four:
    ld hl, #_sprite_string_digits_04
    jr sys_render_draw_digit_draw
sys_render_draw_digit_five:
    ld hl, #_sprite_string_digits_05
    jr sys_render_draw_digit_draw
sys_render_draw_digit_six:
    ld hl, #_sprite_string_digits_06
    jr sys_render_draw_digit_draw
sys_render_draw_digit_seven:
    ld hl, #_sprite_string_digits_07
    jr sys_render_draw_digit_draw
sys_render_draw_digit_eight:
    ld hl, #_sprite_string_digits_08
    jr sys_render_draw_digit_draw
sys_render_draw_digit_nine:
    ld hl, #_sprite_string_digits_09
    jr sys_render_draw_digit_draw

sys_render_draw_digit_draw:
    ld d, #DIGIT_W
    ld e, #DIGIT_H
    call sys_render_draw_sprite

    ret
.globl _sprite_powerup_catch

;; Draws the catch powerup's sprite in a given position.
;; INPUT:
;;      C = x coordinate of sprite.
;;      B = y coordinate of sprite.        
;; OUTPUT:
;;      VOID
sys_render_draw_powerup_catch::
    ld hl, #_sprite_powerup_catch
    ld d, #POWERUP_SPRITE_W
    ld e, #POWERUP_SPRITE_H
    
    call sys_render_draw_sprite    

    ret


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; PRIVATE FUNCTIONS
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Removes everything from the game screen, doesn't clean the scoreboard.
;; INPUT:
;;      VOID
;; OUTPUT:
;;      VOID
clean_stage_screen:
    ld de, #VIDEO_MEMORY_START
    ld c, #BORDER_SIDE_W
    ld b, #BLOCK_ROW_1
    call cpct_getScreenPtr_asm

    ex de, hl
    ld a, #0x00
    ld c, #(BLOCK_COL_10 + BLOCK_W - BORDER_SIDE_W)
    ld b, #BLOCK_ROW_11
    call cpct_drawSolidBox_asm

    ret

;; Draws the left side border of the game screen.
;; INPUT:
;;      VOID
;; OUTPUT:
;;      VOID
sys_render_draw_left_side_border:
    DrawNMotifs 20, #0, #_border_side_motif, #2, #10

    ret

;; Draws the right side border of the game screen.
;; INPUT:
;;      VOID
;; OUTPUT:
;;      VOID
sys_render_draw_right_side_border:
    DrawNMotifs 20, #62, #_border_side_motif, #2, #10

    ret

;; Draws the top side border of the game screen.
;; INPUT:
;;      VOID
;; OUTPUT:
;;      VOID
sys_render_draw_top_border:
    ;; Save starting position of iteration counter.
    ld hl, #iteration_counter
    ld (hl), #BORDER_SIDE_W
    ld c, #BORDER_SIDE_W

draw_top_border_loop_start_1:    
    ;; Draw sprite.
    ld hl, #_sprite_border_top                  ;; sprite to draw
    ;; c = x
    ld b, #0x00                                 ;; y
    ld d, #BORDER_TOP_W                         ;; sprite width
    ld e, #BORDER_TOP_H                         ;; sprite height
    call sys_render_draw_sprite

    ;; Add BORDER_TOP_W to iteration_counter.
    ld a, (iteration_counter)
    add #BORDER_TOP_W
    ld (iteration_counter), a
    ld c, a

    cp #(SCOREBOARD_X_START - BORDER_SIDE_W)
    jr nz, draw_top_border_loop_start_1

    ret

;; Draws a common block with the given coordiantes.
;; INPUT:
;;      C = x coordinate of sprite.
;;      B = y coordinate of sprite.
;;      D = Color of the block.
;; OUTPUT:
;;      VOID
sys_render_draw_common_block:
    ld a, d
    cp #BLOCK_COLOR_PASTEL_CYAN
    jr z, sys_render_draw_common_block_pastel_cyan
    cp #BLOCK_COLOR_PASTEL_BLUE
    jr z, sys_render_draw_common_block_pastel_blue
    cp #BLOCK_COLOR_PINK
    jR z, sys_render_draw_common_block_pink
    cp #BLOCK_COLOR_PASTEL_GREEN
    jr z, sys_render_draw_common_block_pastel_green
    cp #BLOCK_COLOR_CYAN
    jr z, sys_render_draw_common_block_cyan

sys_render_draw_common_block_pastel_cyan:
    ld hl, #_sprite_block_common_0
    jr sys_render_draw_common_block_set_w_h
sys_render_draw_common_block_pastel_blue:
    ld hl, #_sprite_block_common_1
    jr sys_render_draw_common_block_set_w_h
sys_render_draw_common_block_pink:
    ld hl, #_sprite_block_common_2
    jr sys_render_draw_common_block_set_w_h
sys_render_draw_common_block_pastel_green:
    ld hl, #_sprite_block_common_3
    jr sys_render_draw_common_block_set_w_h
sys_render_draw_common_block_cyan:
    ld hl, #_sprite_block_common_4

sys_render_draw_common_block_set_w_h:
    ld d, #BLOCK_W
    ld e, #BLOCK_H

    call sys_render_draw_sprite
    
    ret

;; Draws a silver block with the given coordiantes.
;; INPUT:
;;      C = x coordinate of sprite.
;;      B = y coordinate of sprite.
;; OUTPUT:
;;      VOID
sys_render_draw_silver_block:
    ld hl, #_sprite_block_silver
    ld d, #BLOCK_W
    ld e, #BLOCK_H

    call sys_render_draw_sprite
    
    ret

;; Draws a gold block with the given coordiantes.
;; INPUT:
;;      C = x coordinate of sprite.
;;      B = y coordinate of sprite.
;; OUTPUT:
;;      VOID
sys_render_draw_gold_block:
    ld hl, #_sprite_block_gold
    ld d, #BLOCK_W
    ld e, #BLOCK_H

    call sys_render_draw_sprite
    
    ret