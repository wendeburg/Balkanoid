.include "manager/entity_manager.h.s"
.include "cpctelera.h.s"
.include "render_system.h.s"
.include "manager/scoreboard_manager.h.s"
.include "physics_system.h.s"
.include "../cpct_functions.h.s"
.include "collision_system.h.s"
.include "utils.h.s"

.globl cpct_akp_SFXPlay_asm
.globl cpct_akp_SFXStop_asm
.globl cpct_akp_SFXStopAll_asm
.globl cpct_akp_musicPlay_asm
.globl cpct_akp_stop_asm

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; CONSTANTS
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
screen_width = SCOREBOARD_X_START - BORDER_SIDE_W
screen_height = SCREEN_H

.macro saveSetBorder _color
    push hl
    cpctm_setBorder_asm _color
    pop hl
.endm

.macro LD_REAL REG, ENT1, DEC
    ld  REG, #(ENT1*256 + DEC*256)
.endm

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; variables
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
sys_bar_side_bounce:
    .db 00 ;; 0 = no bounce, 1 = bounce

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; PUBLIC FUNCTIONS
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Updates the position of the ball.
;; INPUT:
;;      VOID
;; OUTPUT:
;;      A = 1 if ball is out of bounds (player loses a life), 0 otherwise.
sys_physics_update::

    ld c, #screen_width - 2     ;; Screen width + 1 - ball width
    push bc
    ;; Update X
    ld hl, #man_entity_ball_position ;; HL = X
    ld e, (hl)              ;; DE = X(*256)
    inc hl
    ld d, (hl)

    ld hl, #man_entity_ball_speed ;; BC = VX
    ld c, (hl)
    inc hl
    ld b, (hl)

    ex de, hl                ;; hl = x + vx
    add hl, bc

    ld a, h                 ;; A = integer part of x

    pop bc
    cp c
    jr nc, invalid_x        ;; If A > screen_width - 2, jump to invalid_x (bounce)

    ld c, #BORDER_SIDE_W
    cp c
    jr c, invalid_x           ;; If A < BORDER_SIDE_W, jump to invalid_y (bounce)

    valid_x:                ;; IF
        ex de, hl
        ld hl, #man_entity_ball_position ;; HL = X address
        ld (hl), e          ;; d = integer part of X
        inc hl
        ld (hl), d          ;; e = floating part of X
        jr _check_collisions_x

    invalid_x:              ;; ELSE
        call sys_physics_bounce_x
        ;; Play sound effect
        ld l, #2    ;; Instrument number
        ld h, #10    ;; Volume 0-15
        ld e, #40  ;; Note 0-143
        ld d, #0    ;; Speed (0 = As original, [1-255] = new Speed (1 is fastest))
        ld bc, #0x0000  ;; Inverted Pitch (-0xFFFF -> 0xFFFF).  0 is no pitch.  The higher the pitch, the lower the sound.
        ;; Bitmask representing channels to use for reproducing the sound (Ch.A = 001 (1), Ch.B = 010 (2), Ch.C = 100 (4))
        ld a, #2
        call cpct_akp_SFXPlay_asm       
        jr endif_x


_check_collisions_x:
    ;; Check collisions after updating X
    ;; If the ball is higher than the bar, check collisions with blocks.
    ld hl, #man_entity_ball_position + 3
    ld a, (hl)              ;; A = y
    ld b, #BAR_Y_POSITION - 10   ;; B = y
    cp b
    jr c, _check_collisions_x_blocks
    ;; Else check collisions with bar.
_check_collisions_x_bar:
    call sys_collision_update_bar
    ;; If c flag is set, the ball has not collided with the bar.
    ;; If c flag is not set, the ball has collided with the bar.
    jr c, _not_collided

    ;call cpct_akp_musicPlay_asm
    ;; Play sound effect
    ld l, #1    ;; Instrument number
    ld h, #10    ;; Volume 0-15
    ld e, #70  ;; Note 0-143
    ld d, #0    ;; Speed (0 = As original, [1-255] = new Speed (1 is fastest))
    ld bc, #0x0000  ;; Inverted Pitch (-0xFFFF -> 0xFFFF).  0 is no pitch.  The higher the pitch, the lower the sound.
    ;; Bitmask representing channels to use for reproducing the sound (Ch.A = 001 (1), Ch.B = 010 (2), Ch.C = 100 (4))
    ld a, #2
    call cpct_akp_SFXPlay_asm

    ;; If the ball has collided with the bar due to the X movement, reverse the X speed.
    ;saveSetBorder HW_RED
    call sys_physics_bounce_x
    jr endif_x

_check_collisions_x_blocks:
    call sys_collision_update_blocks
    ;; If c flag is set, the ball has not collided with any block.
    ;; If c flag is not set, the ball has collided with a block.
    jr c, _not_collided

    ;; Play sound effect
    ld l, #3    ;; Instrument number
    ld h, #10    ;; Volume 0-15
    ld e, #70  ;; Note 0-143
    ld d, #0    ;; Speed (0 = As original, [1-255] = new Speed (1 is fastest))
    ld bc, #0x0000  ;; Inverted Pitch (-0xFFFF -> 0xFFFF).  0 is no pitch.  The higher the pitch, the lower the sound.
    ;; Bitmask representing channels to use for reproducing the sound (Ch.A = 001 (1), Ch.B = 010 (2), Ch.C = 100 (4))
    ld a, #2
    call cpct_akp_SFXPlay_asm

    ;; If the ball has collided with a block due to the X movement, reverse the X speed.
    ;saveSetBorder HW_RED
    call sys_physics_bounce_x
    jr endif_x

_not_collided:
    ;;saveSetBorder HW_GREEN
    

endif_x:                ;; ENDIF  

    ;; Update Y
    ;ld c, #screen_height - 2    ;; Screen height + 1 - ball height
    ;;push bc

    ld hl, #man_entity_ball_position + 2
    ld e, (hl)              ;; DE = Y(*256)
    inc hl
    ld d, (hl)
    
    ld hl, #man_entity_ball_speed + 2;; BC = VY
    ld c, (hl)
    inc hl
    ld b, (hl)

    ex de, hl                ;; hl = y + vy
    add hl, bc

    ld a, h                 ;; A = integer part of y
    
    ;; Check if ball is out of bounds.
    cp #MAX_BALL_Y
    jp nc, #_ball_out_of_bounds
    jp z, #_ball_out_of_bounds

    ld c, #BORDER_TOP_H
    cp c
    jr c, invalid_y           ;; If A < BORDER_SIDE_W, jump to invalid_y (bounce)

    valid_y:                ;; IF
        ex de, hl
        ld hl, #man_entity_ball_position + 2
        ld (hl), e          ;; d = integer part of Y
        inc hl
        ld (hl), d          ;; y = floating part of X
        jr _check_collisions_y

    invalid_y:              ;; ELSE
        call sys_physics_bounce_y
        ;; Play sound effect
        ld l, #2    ;; Instrument number
        ld h, #10    ;; Volume 0-15
        ld e, #40  ;; Note 0-143
        ld d, #0    ;; Speed (0 = As original, [1-255] = new Speed (1 is fastest))
        ld bc, #0x0000  ;; Inverted Pitch (-0xFFFF -> 0xFFFF).  0 is no pitch.  The higher the pitch, the lower the sound.
        ;; Bitmask representing channels to use for reproducing the sound (Ch.A = 001 (1), Ch.B = 010 (2), Ch.C = 100 (4))
        ld a, #2
        call cpct_akp_SFXPlay_asm
        jr _not_collided_y

_check_collisions_y:
    ;; Check collisions after updating Y
    ;; If the ball is higher than the bar, check collisions with blocks.
    ld hl, #man_entity_ball_position + 3
    ld a, (hl)              ;; A = y
    ld b, #BAR_Y_POSITION - 10              ;; B = y
    cp b
    jr c, _check_collisions_y_blocks
    ;; Else check collisions with bar.
    call sys_collision_update_bar
    ;; If c flag is set, the ball has not collided with the bar.
    ;; If c flag is not set, the ball has collided with the bar.
    jr c, _not_collided_y

    ;call cpct_akp_musicPlay_asm
    ;; Play sound effect
    ld l, #1    ;; Instrument number
    ld h, #10    ;; Volume 0-15
    ld e, #70  ;; Note 0-143
    ld d, #0    ;; Speed (0 = As original, [1-255] = new Speed (1 is fastest))
    ld bc, #0x0000  ;; Inverted Pitch (-0xFFFF -> 0xFFFF).  0 is no pitch.  The higher the pitch, the lower the sound.
    ;; Bitmask representing channels to use for reproducing the sound (Ch.A = 001 (1), Ch.B = 010 (2), Ch.C = 100 (4))
    ld a, #2
    call cpct_akp_SFXPlay_asm

    ;; If the ball has collided with the bar due to the Y movement, change the Y and X speed depending on the bar segment.
    ;saveSetBorder HW_RED
    ;; The bar is divided in 5 segments.
    ;; Left segment makes the ball go left fast.
    ;; Left-middle segment makes the ball go left.
    ;; Middle segment makes the ball not change X speed.
    ;; Right-middle segment makes the ball go right.
    ;; Right segment makes the ball go right fast.
    ;; Get bar segment.
    ld hl, #man_entity_bar_position
    ld a, (hl)
    ;; Add left segment size.
    add #1
    ld hl, #man_entity_ball_position + 1
    ld b, (hl)
    ;inc b   ; Increment to acount for ball width.
    inc b
    inc b
    cp b
    ;; If the ball bounced on the left side of the bar, goes left fast.
    jr nc, _bounce_left_fast
    add #2
    cp b
    ;; If the ball bounced on the middle-left segment, goes left.
    jr nc, _bounce_left
    add #2
    cp b
    ;; If the ball bounced on the middle segment, goes straight.
    jr nc, _end_bar_bounce
    add #2
    cp b
    ;; If the ball bounced on the right-middle segment, goes right.
    jr nc, _bounce_right
    ;; If the ball bounced on the right side of the bar, goes right.
    jr _bounce_right_fast





_end_bar_bounce:
    call sys_physics_bounce_y
    jr endif_y

_check_collisions_y_blocks:
    call sys_collision_update_blocks
    ;; If c flag is set, the ball has not collided with any block.
    ;; If c flag is not set, the ball has collided with a block.
    jr c, _not_collided_y

    ;; Play sound effect
    ld l, #3    ;; Instrument number
    ld h, #10    ;; Volume 0-15
    ld e, #70  ;; Note 0-143
    ld d, #0    ;; Speed (0 = As original, [1-255] = new Speed (1 is fastest))
    ld bc, #0x0000  ;; Inverted Pitch (-0xFFFF -> 0xFFFF).  0 is no pitch.  The higher the pitch, the lower the sound.
    ;; Bitmask representing channels to use for reproducing the sound (Ch.A = 001 (1), Ch.B = 010 (2), Ch.C = 100 (4))
    ld a, #2
    call cpct_akp_SFXPlay_asm

    ;; If the ball has collided with a block due to the Y movement, reverse the Y speed.
    ;;saveSetBorder HW_RED
    call sys_physics_bounce_y
    jr endif_y

_ball_out_of_bounds:
    ld a, #1
    ret

_not_collided_y:
    ;saveSetBorder HW_GREEN
    ;call cpct_akp_SFXStopAll_asm

    endif_y:

    ld a, #0
    ret

_bounce_left_fast:
    ld hl, #man_entity_ball_speed
    ;LD_REAL de, -1, 0            ;; DE = -0.5
    ld  de, #(-(1*256)/2 - (1*256)/4)
    ld (hl), e          ;; vx = DE
    inc hl
    ld (hl), d

    ld hl, #man_entity_ball_position
    call sys_physics_change_ball_position

    jr _end_bar_bounce

_bounce_left:
    ld hl, #man_entity_ball_speed
    ;LD_REAL de, 0, -1/2           ;; A = -0.25
    ld  de, #(- (1*256)/2)
    ld (hl), e          ;; vx = DE
    inc hl
    ld (hl), d

    ld hl, #man_entity_ball_position
    call sys_physics_change_ball_position

    jr _end_bar_bounce

_bounce_right:
    ld hl, #man_entity_ball_speed
    ;LD_REAL de, 0, 1/2            ;; A = 0.25
    ld  de, #((1*256)/2)
    ld (hl), e          ;; vx = DE
    inc hl
    ld (hl), d

    ld hl, #man_entity_ball_position
    call sys_physics_change_ball_position

    jr _end_bar_bounce
    
    

_bounce_right_fast:
    ld hl, #man_entity_ball_speed
    ;LD_REAL de, 1, 0            ;; A = 0.5
    ld  de, #((1*256)/2 + (1*256)/4)
    ld (hl), e          ;; vx = DE
    inc hl
    ld (hl), d 

    ld hl, #man_entity_ball_position
    call sys_physics_change_ball_position

    jr _end_bar_bounce

;; Cambia la posición de la pelota.
;; INPUT:
;;      DE = speed component.
;; OUTPUT:
;;      HL = position component address.
sys_physics_change_ball_position::
    ld c, (hl)
    inc hl
    ld b, (hl)
    ex de, hl
    add hl, bc
    ex de, hl
    ld (hl), d
    dec hl
    ld (hl), e

    ret

sys_physics_bounce_x::
    
    ld hl, #man_entity_ball_speed
    ld e, (hl)          ;; DE = vx
    inc hl
    ld d, (hl)
    ex de, hl
    call utils_neg_HL                 ;; A = -A
    ex de, hl
    ld (hl), d          ;; vx = -A
    dec hl
    ld (hl), e

    ld hl, #man_entity_ball_position
    call sys_physics_change_ball_position

    ;ld hl, #man_entity_ball_position ;; HL = X
    ;ld a, (hl)              ;; A = X
    ;ld hl, #man_entity_ball_speed ;; HL = VX
    ;add (hl)                ;; A = x + vx
    ;ld hl, #man_entity_ball_position ;; HL = X
    ;ld (hl), a          ;; x = A
    ret


sys_physics_bounce_y::
    
    ld hl, #man_entity_ball_speed + 2
    ld e, (hl)          ;; DE = vy
    inc hl
    ld d, (hl)
    ex de, hl
    call utils_neg_HL                 ;; A = -A
    ex de, hl
    ld (hl), d          ;; vy = -A
    dec hl
    ld (hl), e

    ld hl, #man_entity_ball_position + 2
    call sys_physics_change_ball_position    
    
    ;ld hl, #man_entity_ball_position + 1
    ;ld a, (hl)              ;; A = y
    ;ld hl, #man_entity_ball_speed + 1
    ;add (hl)                ;; A = y + vy
    ;ld hl, #man_entity_ball_position + 1
    ;ld (hl), a          ;; y = A
    ret

;; Calcula la reflexión de la pelota.
;; INPUT:
;;      H = X del vector normal a la superficie de rebote
;;      L = Y del vector normal a la superficie de rebote
;;      A = X de la velocidad de la pelota
;;      B = Y de la velocidad de la pelota
;; OUTPUT:
;;      VOID
sys_physics_reflect_ball::
    ;; Calcular dot product entre el vector de velocidad de la bola y el vector normal a la superficie de rebote.
    ;; El vector normal a la superficie de rebote puede ser (0, 1), (0, -1), (1, 0) o (-1, 0).
    push hl
    ld d, l
    ld e, b
    ld b, h
    ld c, a
    call sys_physics_dot_product
    ;; Multiplicar el resultado del dot product por 2.
    add hl, hl
    ;; Multiplicar el resultado del dot product por el vector normal a la superficie de rebote.



;; Calcula el producto escalar entre dos vectores.
;; INPUT:
;;      D = Y del primer vector
;;      B = X del primer vector
;;      C = X del segundo vector
;;      E = Y del segundo vector
;; OUTPUT:
;;      HL = Producto escalar
sys_physics_dot_product::
    ld hl, #0x0000
    ;; Multiplicar X1 * X2 (B * C)
    call sys_physics_multiply
    ld b, d
    ld c, e
    ex de, hl
    ;; Multiplicar Y1 * Y2 (E * D)
    call sys_physics_multiply
    ;; Sumar los dos resultados (B * C) + (E * D)
    add hl, de

    ret

;; Multiplica dos números.
;; INPUT: 
;;        B = Primer número
;;        C = Segundo número
;; OUTPUT: 
;;        HL = B * C
sys_physics_multiply::
	ld hl, #0
	ld a, b
	or a
	ret z
	ld d, #0
	ld e, c
mul_loop:	
    add hl, de
	djnz mul_loop
	ret

;; Verifica si se ha presionado la tecla para despegar la pelota de la barra.
;; INPUT:
;;      VOID
;; OUTPUT:
;;      VOID
sys_physics_check_ball_detach::
    
    call sys_physics_is_spacebar_pressed
    cp #0
    jr z, sys_physics_check_ball_detach_return

    call sys_physics_get_bar_direction
    ld a, b
    cp #0
    jr z, sys_physics_check_ball_detach_move_up
    cp #1
    jr z, sys_physics_check_ball_detach_move_up_right
    cp #-1
    jr z, sys_physics_check_ball_detach_move_up_left


sys_physics_check_ball_detach_move_up:
    ld bc, #0
    ;ld de, #(-1*256 -1/2*256)
    ;LD_REAL de, -2, -1/2
    ld de, #(-(2*256) - (2*256)/4)

    jr sys_physics_check_ball_detach_modify_ball_velocity
sys_physics_check_ball_detach_move_up_right:
    ld bc, #((0*256) + (1*256)/2)
    ;LD_REAL de, -2, -1/2
    ld de, #(-(2*256) - (2*256)/4)

    jr sys_physics_check_ball_detach_modify_ball_velocity
sys_physics_check_ball_detach_move_up_left:
    ld bc, #(-(0*256) - (1*256)/2)
    ;LD_REAL de, -2, -1/2
    ld de, #(-(2*256) - (2*256)/4)

sys_physics_check_ball_detach_modify_ball_velocity:
    ld hl, #man_entity_ball_speed
    ld (hl), c
    inc hl
    ld (hl), b
    inc hl
    ld (hl), e
    inc hl
    ld (hl), d

    ld hl, #man_entity_ball_attached_to_bar
    ld (hl), #BALL_NOT_ATTACHED_TO_BAR

sys_physics_check_ball_detach_return:
    ret

;; Verifica si se ha presionado la tecla espacio.
;; INPUT:
;;      VOID
;; OUTPUT:
;;      A = 1 if Space is pressed 0 if not.
sys_physics_is_spacebar_pressed::
    ;; Escanear teclado.
    call cpct_scanKeyboard_asm

    ;; Ver si se ha presionado la tecla espacio.
    ld hl, #Key_Space
    call cpct_isKeyPressed_asm
    cp #0x00
    jr nz, sys_physics_is_spacebar_pressed_is_pressed

    ;; No se ha presionado.
    ld a, #0
    jr sys_physics_is_spacebar_pressed_return

    ;; Se ha presionado.
sys_physics_is_spacebar_pressed_is_pressed:
    ld a, #1

sys_physics_is_spacebar_pressed_return:
    ret

;; Verifica si se ha presionado alguna tecla para mover la barra y mueve la barra si es así.
;; INPUT:
;;      VOID
;; OUTPUT:
;;      VOID
sys_physics_check_bar_movement::
    call sys_physics_get_bar_direction
    ld a, b

    ;; Ver si se ha preisonado alguna tecla. Si no se ha presionado ninguna tecla return.
    cp #0
    jr z, sys_physics_check_bar_movement_return

    ;; Ver si se ha presionado la tecla O y si se ha presionado mover barra a la izquierda.
    cp #-1
    jr z, sys_physics_check_bar_movement_move_bar_left

    ;; Si no se ha presionado la tecla Q ver si la tecla P se ha presionado y si ha sido así mover
    ;; a la derecha.
    cp #1
    jr z, sys_physics_check_bar_movement_move_bar_right

sys_physics_check_bar_movement_move_bar_left:
    call sys_physics_move_bar_left
    jr sys_physics_check_bar_movement_return

sys_physics_check_bar_movement_move_bar_right:
    call sys_physics_move_bar_right

sys_physics_check_bar_movement_return:
    ret

;; Devuelve la dirección en la que se mueve la barra.
;; INPUT:
;;      VOID
;; OUTPUT:
;;      B = -1 si se mueve a la izquierda, 1 si se mueve a la derecha, 0 si no se mueve.
sys_physics_get_bar_direction::
    ;; Escanear teclado.
    call cpct_scanKeyboard_asm
    
    ;; Ver si se ha preisonado alguna tecla. Si no se ha presionado ninguna tecla return.
    call cpct_isAnyKeyPressed_asm
    cp #0x00
    ld b, #0
    ret z

    ;; Ver si se ha presionado la tecla Q.
    ld hl, #Key_O
    call cpct_isKeyPressed_asm
    cp #0x00
    jr nz, _get_left

    ;; Si no se ha presionado la tecla Q ver si la tecla P.
    ld hl, #Key_P
    call cpct_isKeyPressed_asm
    cp #0x00
    jr nz, _get_right

    ld b, #0
    ret

    _get_left:
        ld b, #-1
        ret
    _get_right:
        ld b, #1
        ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; PRIVATE FUNCTIONS
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Mueve la barra a la derecha si no está ya en el borde derecho de la pantalla del juego.
;; INPUT:
;;      VOID
;; OUTPUT:
;;      VOID
sys_physics_move_bar_right:
    ;; Get current position.
    ld hl, #man_entity_bar_position
    ld a, (hl)

    ;; Check it's not already touching the screen border.
    add #BAR_W

    cp #(SCOREBOARD_X_START - BORDER_SIDE_W)

    ;; If the bar already touches the border don't move it.
    jr z, sys_physics_move_bar_right_return

    ;; Check if ball is attached, and if it is move it with the bar.
    ld hl, #man_entity_ball_attached_to_bar
    ld a, (hl)
    cp #BALL_ATTACHED_TO_BAR
    jr nz, sys_physics_move_bar_right_continue

    ld hl, #man_entity_ball_position + 1
    ld a, (hl)
    inc a
    ld (hl), a

sys_physics_move_bar_right_continue:
    ;; Otherwise move position.
    call sys_render_remove_bar

    ld hl, #man_entity_bar_position
    ld a, (hl)
    add #BAR_MOVEMENT_SIZE

    ld (hl), a

    call sys_reder_draw_bar

sys_physics_move_bar_right_return:
    ret

;; Mueve la barra a la izquierda si no está ya en el borde izquierdo de la pantalla del juego.
;; INPUT:
;;      VOID
;; OUTPUT:
;;      VOID
sys_physics_move_bar_left:
    ;; Get current position.
    ld hl, #man_entity_bar_position
    ld a, (hl)

    ;; Check if bar is touching the left border.
    cp #BORDER_SIDE_W

    ;; If the bar already touches the border don't move it.
    jr z, sys_physics_move_bar_left_return

    ;; Check if ball is attached, and if it is move it with the bar.
    ld hl, #man_entity_ball_attached_to_bar
    ld a, (hl)
    cp #BALL_ATTACHED_TO_BAR
    jr nz, sys_physics_move_bar_left_continue

    ld hl, #man_entity_ball_position + 1
    ld a, (hl)
    dec a
    ld (hl), a

sys_physics_move_bar_left_continue:
    ;; Otherwise move position.
    call sys_render_remove_bar

    ld hl, #man_entity_bar_position
    ld a, (hl)
    dec a

    ld (hl), a

    call sys_reder_draw_bar

sys_physics_move_bar_left_return:
    ret