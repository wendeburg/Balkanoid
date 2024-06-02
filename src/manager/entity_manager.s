.include "entity_manager.h.s"
.include "../system/render_system.h.s"
.include "../cpct_functions.h.s"

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; VARIABLES
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Position of the bar in bytes.
man_entity_bar_position::
    .db STARTING_BAR_X
;; X and Y coordinates of the ball.
man_entity_ball_position::
    .dw STARTING_BALL_X
    .dw STARTING_BALL_Y
;; X and Y speed of the ball.
man_entity_ball_speed::
    .dw BALL_VX
    .dw BALL_VY
;; Is ball attached to bar.
man_entity_ball_attached_to_bar::
    .db BALL_ATTACHED_TO_BAR
;; Current stage's block array.
man_entity_stage_block_array::
    .ds MAX_BLOCK_ARRAY_SIZE

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; PUBLIC FUNCTIONS
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Handles how the block should change with the collision with the ball.
;; INPUT:
;;      HL = Adress to block which the ball collided with.
;; OUTPUT:
;;      A = 1 if the block was destroyed, 0 otherwise.
;;      B = Adress of destroyed block.
man_entity_handle_block_collision::
    ;; Copy block adress in DE.
    ld e, l
    ld d, h

    ;; Check the block type.
    ld a, (hl)

    inc hl                      ;; Go to block position.

    cp #BLOCK_COMMON
    jr z, remove_block

    cp #BLOCK_SILVER
    jr z, decrease_silver_block_durability

    cp #BLOCK_GOLD
    jr z, block_not_destroyed

decrease_silver_block_durability:
    inc hl                      ;; Go to durability.
    inc hl
    ld a, (hl)
    
    ;; If block has 1 hit remaining remove it.
    cp #1
    jr z, remove_block

    ;; Otherwise decrease durability.
    dec a
    ld (hl), a

block_not_destroyed:
    ld a, #0

    jr handle_block_collision_return

remove_block:
    ld a, (de)
    push af

    ld a, #BLOCK_DESTROYED
    ld (de), a
    
    ex de, hl
    inc hl

    ;; Remove the block.
    ld c, (hl)
    inc hl
    ld b, (hl)
    ld d, #BLOCK_W
    ld e, #BLOCK_H
    call sys_reder_remove_sprite

    pop af
    ld b, a

    ld a, #1
handle_block_collision_return:
    ret