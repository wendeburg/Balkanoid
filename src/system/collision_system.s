.include "manager/game_manager.h.s"
.include "manager/stage_manager.h.s"
.include "render_system.h.s"
.include "manager/entity_manager.h.s"
.include "cpctelera.h.s"
.include "cpct_functions.h.s"
.include "physics_system.h.s"

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; sys_collision_update_blocks
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Calculates collisions between ball and blocks.
;; INPUT:
;;      VOID
;; OUTPUT:
;;      VOID
sys_collision_update_blocks::
    ld hl, #man_entity_stage_block_array
_block_loop:
    ld a, (hl)            ;; A = type of block.
    
    cp #END_OF_BLOCKS_ARRAY_BYTE
    ;ld a, #0x00
    ;ld b, #0x00
    scf
    ret z          ;; if zero falg is active is because we have reached end of the array, return.

    ;; Check if block has been destroyed.
    cp #BLOCK_DESTROYED

    inc hl
    ld c, (hl)                                  ;; C = x coordinate of sprite.

    inc hl
    ld b, (hl)                                  ;; B = y coordinate of sprite.

    inc hl                                      ;; ignore durability and color.
    inc hl
    inc hl

    push hl

    ld d, #BLOCK_W                               ;; D = width of sprite.
    ld e, #BLOCK_H                               ;; E = height of sprite.

    ;; Go to next block
    jr z, _no_collsion

    ;; Check collision between ball and entity.
    call sys_check_collision
    jr nc, _collision

    
_no_collsion:
    
    pop hl
    jr _block_loop

_collision:
    pop hl

    ;; Go start of collided block.
    ld a, #BLOCK_BYTE_SIZE
    sub_hl_a
    call man_game_block_collision
    
    scf
    ccf

    ret


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; sys_collision_update_bar
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Calculates collisions between ball and blocks.
;; INPUT:
;;      VOID
;; OUTPUT:
;;      VOID
sys_collision_update_bar::
    ld hl, #man_entity_bar_position
    ld c, (hl)              ;; C = X position of bar.
    ld b, #BAR_Y_POSITION             ;; B = Y position of bar.
    ld d, #BAR_W             ;; D = width of bar.
    ld e, #BAR_H             ;; E = height of bar.
    ;; Check collision between ball and bar.
    call sys_check_collision
    ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; sys_check_collision
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Checks collision between ball and entity.
;; INPUT:
;;      C = x coordinate of entity.
;;      B = y coordinate of entity.
;;      D = width of entity.
;;      E = height of entity.
;; OUTPUT:
;;      Carry: 1 - no collision, 0 - collision.
;;      HL = normal vector of the collision surface.
sys_check_collision::
    ld hl, #man_entity_ball_position + 1
    ld a, (hl)              ;; A = X position of ball.
    ;; if a < c, then ball is to the left of the entity, so no collision.
    add #BALL_W             ;; A = X position of ball + ball width.
    sub c                   ;; A = A - C to compare with 0.
    ;; normal vector = (-1, 0)
    ret c    ;; if carry flag is active, then no collision.

    ;; if a > (c + entity_width), then ball is to the right of the entity, so no collision.
    ld a, c                 ;; A = X position of entity.
    add d           ;; A = A + entity width.
    ld c, (hl)              ;; C = X position of ball.
    sub c                   ;; A = A - C to compare with 0.
    ;; normal vector = (1, 0)
    ret c   ;; if carry flag is not active, then no collision.

    ld hl, #man_entity_ball_position + 3
    ld a, (hl)              ;; A = Y position of ball.
    ;; if a < b, then ball is below the entity, so no collision.
    add #BALL_H             ;; A = Y position of ball + ball height.
    sub b                   ;; A = A - b to compare with 0.
    ;; normal vector = (0, -1)
    ret c    ;; if carry flag is active, then no collision.

    ;; if a > (c + entity_width), then ball is to the right of the entity, so no collision.
    ld a, b                 ;; A = Y position of entity.
    add e           ;; A = A + entity height.
    ld b, (hl)              ;; B = Y position of ball.
    sub b                   ;; A = A - B to compare with 0.
    ;; normal vector = (0, 1)
    ret   ;; if carry flag is not active, then collision.



