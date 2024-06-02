.include "game_manager.h.s"
.include "stage_manager.h.s"
.include "../system/render_system.h.s"
.include "../system/physics_system.h.s"
.include "entity_manager.h.s"
.include "../cpct_functions.h.s"
.include "system/collision_system.h.s"
.include "cpctelera.h.s"
.include "../utils.h.s"
.include "scoreboard_manager.h.s"

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; IMPORTS
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
.globl _sfx

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; VARIABLES
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Player high score.
man_game_display_high_score::
    .db ZERO        ;; Number of 10000s
    .db ZERO        ;; Number of 1000s
    .db ZERO        ;; Number of 100s
    .db ZERO        ;; Number of 10s
    .db ZERO        ;; Number of 1s

man_game_high_score:
    .dw ZERO

;; Player score.
man_game_display_score::
    .db ZERO        ;; Number of 10000s
    .db ZERO        ;; Number of 1000s
    .db ZERO        ;; Number of 100s
    .db ZERO        ;; Number of 10s
    .db ZERO        ;; Number of 1s

man_game_score::
    .dw ZERO

;; Player lives.
man_game_lives::
    .db NUM_STARTING_LIVES

;; Current stage.
man_game_current_stage::
    .db STARTING_STAGE

;; Number of blocks left to be destroyed in the level.
man_game_number_of_blocks_left::
    .db ZERO

;; 1 if high score changed, other wise 0.
man_game_high_score_changed::
    .db ZERO

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; PUBLIC FUNCTIONS
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Prepares everything for a new game.
;; INPUT:
;;      VOID
;; OUTPUT:
;;      VOID
man_game_init_game::
    call sys_render_remove_ball 
    call sys_render_remove_bar

    call reset_ball_state
    call reset_bar_state

    call sys_reder_draw_bar

    ld hl, #man_game_current_stage
    ld (hl), #STARTING_STAGE

    call man_game_copy_block_array_from_stage
    call man_set_number_of_blocks_in_stage

    ld hl, #man_game_lives
    ld (hl), #NUM_STARTING_LIVES

    ld hl, #man_game_high_score_changed
    ld (hl), #ZERO

    call restart_score


    ;; Init systems
    call sys_render_init_game_screen
    
    ;; Init sound FX
    ld de, #_sfx        ;; DE = SFX Music (only instruments, no music pattern)
    call cpct_akp_SFXInit_asm     ;; Initialize sound FX
    ld de, #_sfx        ;; DE = SFX Music again
    call cpct_akp_musicInit_asm   ;; Initialize music player with the SFX music
    ret

;; Game loop.
;; INPUT:
;;      VOID
;; OUTPUT:
;;      A = 1 if player won, 0 otherwise.
man_game_game_loop::
    call sys_render_remove_ball

    call man_game_check_ball_detach

    call sys_physics_check_bar_movement
    
    call sys_physics_update
    cp #1
    jr nz, continue_game_loop

    call decrease_player_lifes
    cp #1
    jr nz, reset_game

    ld a, #0
    ret

reset_game:
    call sys_render_remove_ball 
    call sys_render_remove_bar

    call reset_ball_state
    call reset_bar_state

    call sys_reder_draw_bar

    call man_scoreboard_remove_life

continue_game_loop:
    call check_if_any_blocks_left
    cp #0
    jr z, change_to_next_stage

    call sys_reder_draw_ball

    call cpct_waitVSYNC_asm
    call cpct_akp_musicPlay_asm
    call cpct_waitVSYNC_asm

    jr man_game_game_loop

change_to_next_stage:
    call increase_current_stage_number

    ;; Check if there are no more stages.
    call check_if_no_more_stages
    cp #1
    jr z, game_over_win

    call sys_render_remove_bar

    call reset_ball_state
    call reset_bar_state

    call sys_reder_draw_bar
    call sys_reder_draw_ball

    call man_set_number_of_blocks_in_stage
    call man_game_copy_block_array_from_stage

    call sys_render_change_stage

    jr man_game_game_loop

game_over_win:
    ld a, #1
    ret

;; Orchestrates what should happen when the ball collides with a block.
;; INPUT:
;;      HL = Adress to block which the ball collided with.
;; OUTPUT:
;;      VOID
man_game_block_collision::
    call man_entity_handle_block_collision      ;; A = 1 if block was destroyed.
                                                ;; B = Type of block destroyed.
    cp #1
    jr nz, man_game_block_collision_return

    push bc
    ld a, b
    call update_display_score
    call man_scoreboard_update_score

    pop bc
    ld a, b
    call update_score

    call update_high_score

    call decrease_number_of_blocks

man_game_block_collision_return:
    ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; PRIVATE FUNCTIONS
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Checks if the current stage is one past the last stage.
;; INPUT:
;;      VOID
;; OUTPUT:
;;      A = 1 there no more stages, 0 otherwise.
check_if_no_more_stages:
    ld a, (man_game_current_stage)
    ld hl, #man_stage_number_of_stages
    ld b, (hl)
    cp b

    jr z, check_if_last_stage_true

    ld a, #0

    jr check_if_last_stage_return

check_if_last_stage_true:
    ld a, #1

check_if_last_stage_return:
    ret

increase_current_stage_number:
    ld hl, #man_game_current_stage
    ld a, (hl)
    inc a
    ld (hl), a

    ret

;; Checks if there are any blocks left in the stage.
;; INPUT:
;;      VOID
;; OUTPUT:
;;      A = 1 if there are blocks left, 0 otherwise.
check_if_any_blocks_left:
    ld hl, #man_game_number_of_blocks_left
    ld a, (hl)
    cp #0
    jr z, return_no_blocks_left

    ld a, #1
    jr check_if_any_blocks_left_return

return_no_blocks_left:
    ld a, #0

check_if_any_blocks_left_return:
    ret

decrease_number_of_blocks:
    ld hl, #man_game_number_of_blocks_left
    ld a, (hl)
    dec a
    ld (hl), a

    ret

restart_score:
    ld hl, #man_game_score
    ld (hl), #ZERO
    inc hl
    ld (hl), #ZERO

    ld hl, #man_game_display_score
    ld (hl), #ZERO
    inc hl
    ld (hl), #ZERO
    inc hl
    ld (hl), #ZERO
    inc hl
    ld (hl), #ZERO    
    inc hl
    ld (hl), #ZERO

    ret

reset_bar_state:
    ld hl, #man_entity_bar_position
    ld (hl), #STARTING_BAR_X

    ret

reset_ball_state:
    ld hl, #man_entity_ball_attached_to_bar
    ld (hl), #BALL_ATTACHED_TO_BAR
    
    ld hl, #man_entity_ball_speed
    ld (hl), #0
    inc hl
    ld (hl), #0
    inc hl
    ld (hl), #0
    inc hl
    ld (hl), #0

    ld hl, #man_entity_ball_position + 1
    ld (hl), #0x1D
    inc hl
    inc hl
    ld (hl), #0xA0

    ret

;; Decreases 1 live from the player.
;; INPUT:
;;      VOID
;; OUTPUT:
;;      A = 1 if player has no lives left, 0 otherwise.
decrease_player_lifes:
    ld a, (#man_game_lives)
    dec a
    ld (#man_game_lives), a

    cp #0
    jr z, player_has_zero_lives

    ld a, #0
    ret

player_has_zero_lives:
    ld a, #1
    ret

;; Updates the high score if the nwe score is bigger than the current high score.
;; INPUT:
;;      VOID
;; OUTPUT:
;;      VOID
update_high_score:
    ld hl, #man_game_score
    ld b, (hl)
    inc hl
    ld c, (hl)

    ld hl, #man_game_high_score
    ld d, (hl)
    inc hl
    ld e, (hl)

    ;; Ver si BC < DE
    ;; Bytes altos
    ld a, b
    cp d
    jr c, update_high_score_return
    jr z, compare_lower_byte_score
    jr nc, set_new_high_score

compare_lower_byte_score:
    ;; Si B = D comparar byte menos significativo
    ld a, c
    cp e
    jr c, update_high_score_return
    jr z, update_high_score_return
    jr nc, set_new_high_score


set_new_high_score:
    ld hl, #man_game_score
    ld b, (hl)
    inc hl
    ld c, (hl)

    ld hl, #man_game_high_score
    ld (hl), b
    inc hl
    ld (hl), c

    call set_new_digits_highscore
    call man_scoreboard_update_high_score

    ld hl, #man_game_high_score_changed
    ld (hl), #1

update_high_score_return:
    ret

;; Copies the display score into the display high score.
;; INPUT:
;;      VOID
;; OUTPUT:
;;      VOID
set_new_digits_highscore:
    ld hl, #man_game_display_score
    ld de, #man_game_display_high_score
    ld bc, #0x0005
    call cpct_memcpy_asm

    ret

;; Updates the score depending on the type of block destroyed.
;; INPUT:
;;      A = Type of destroyed block.
;; OUTPUT:
;;      VOID
update_score:
    cp #BLOCK_COMMON
    jr z, update_score_add_common_block_to_score
    cp #BLOCK_SILVER
    jr z, update_score_add_silver_block_to_score

update_score_add_common_block_to_score:
    ld b, #BLOCK_COMMON_DESTRUCTION_POINTS 

    jr update_score_continue_addition

update_score_add_silver_block_to_score:
    ld b, #BLOCK_SILVER_DESTRUCTION_POINTS

update_score_continue_addition:
    ld hl, #man_game_score
    ld d, (hl)
    inc hl
    ld e, (hl)

    ld a, b

    add_de_a

    ld (hl), e
    dec hl
    ld (hl), d

    ret

;; Updates the display score depending on the type of block destroyed.
;; Only updates the 10s, 100s and 1000s digits as no block destruction gives less than 10 points and
;; no game will reach 10000 points due to lack of maps.
;; INPUT:
;;      A = Type of destroyed block.
;; OUTPUT:
;;      VOID
update_display_score:
    cp #BLOCK_COMMON
    jr z, add_common_block_to_score
    cp #BLOCK_SILVER
    jr z, add_silver_block_to_score

add_common_block_to_score:
    ld b, #BLOCK_COMMON_DESTRUCTION_POINTS 

    jr continue_addition

add_silver_block_to_score:
    ld b, #BLOCK_SILVER_DESTRUCTION_POINTS

continue_addition:
    ld hl, #man_game_display_score
    inc hl                      ;; Ignore 1s digit.

    ;; Update 10s digit.
    ld a, (hl)
    add b

    cp #9
    jr c, save_score_and_return

    ld c, a
    push bc

    ld b, #10
    call utils_modulo_8b

    ld (hl), a
    inc hl

    ;; Update 100s digit.
    pop bc
    ld b, #10
    call utils_div_8b

    ld b, a
    ld a, (hl)
    add b

    cp #9
    jr c, save_score_and_return

    ld c, a
    push bc

    ld b, #100
    call utils_modulo_8b

    ld (hl), a
    inc hl

    ;; Update 1000s digit.
    pop bc
    ld b, #100
    call utils_div_8b

    ld b, a
    ld a, (hl)
    add b

save_score_and_return:
    ld (hl), a

    ret

;; Checks if the user pressed they key to detach the ball from the bar.
;; INPUT:
;;      VOID
;; OUTPUT:
;;      VOID
man_game_check_ball_detach:
    ld hl, #man_entity_ball_attached_to_bar
    ld a, (hl)
    cp #BALL_ATTACHED_TO_BAR
    jr nz, man_game_check_ball_detach_return

    call sys_physics_check_ball_detach

man_game_check_ball_detach_return:
    ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; PRIVATE FUNCTIONS
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Gets the adress of the block array for the current stage.
;; INPUT:
;;      VOID
;; OUTPUT:
;;      HL = adress to block array.
;;      BC = block array size in bytes.
man_game_get_current_stage_blocks_array_data::
    call man_game_get_current_stage_adress

    ;; Add OFFSET_TO_BLOCK_ARRAY_IN_STAGE to go to the block array pointer.
    ld a, l
    add #OFFSET_TO_BLOCK_ARRAY_IN_STAGE
    ld l, a

    ld a, #0x00
    adc h
    ld h, a

    ;; Load the block array pointer into hl.
    ld e, (hl)
    inc hl
    ld d, (hl)

    ;; Load the block array size into bc.
    inc hl
    ld c, (hl)
    inc hl
    ld b, (hl)

    ex de, hl

    ret

;; Gets the adress of the block array for the current stage.
;; INPUT:
;;      VOID
;; OUTPUT:
;;      B = First digit.
;;      C = Second digit.
man_game_get_current_stage_number::
    call man_game_get_current_stage_adress

    ld b, (hl)
    inc hl
    ld c, (hl)
    
    ret

;; Saves the number of blocks in the current stage to the corresponding variable.
;; INPUT:
;;      VOID
;; OUTPUT:
;;      VOID
man_set_number_of_blocks_in_stage:
    call man_game_get_current_stage_adress
    inc hl
    inc hl

    ld de, #man_game_number_of_blocks_left
    ld a, (hl)

    ex de, hl
    ld (hl), a

    ret

;; Gets the adress of the current stage.
;; INPUT:
;;      VOID
;; OUTPUT:
;;      VOID
man_game_copy_block_array_from_stage::
    call man_game_get_current_stage_blocks_array_data
    ld de, #man_entity_stage_block_array

    call cpct_memcpy_asm

    ret

;; Gets the adress of the current stage.
;; INPUT:
;;      VOID
;; OUTPUT:
;;      HL = adress to the current stage.
man_game_get_current_stage_adress:
    ld a, (man_game_current_stage)
    ld hl, #man_stage_stages_array

    ;; Get current stage's pointer.
man_game_get_current_stage_adress_loop_start:
    cp #0x00
    jr z, man_game_get_current_stage_adress_loop_end

    ld b, a

    ;; Add size of word to the current adress (to go to the next stage pointer).
    ld a, l
    add #2
    ld l, a

    ld a, #0x00
    adc h
    ld h, a

    ;; Decrement one from the iteration counter.
    ld a, b
    dec a

    jr man_game_get_current_stage_adress_loop_start


man_game_get_current_stage_adress_loop_end:
    ;; Load the current stage's adress into hl.
    ld e, (hl)
    inc hl
    ld d, (hl)
    ex de, hl

    ret