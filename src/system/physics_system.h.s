;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; EXPORTS
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
.globl sys_physics_update
.globl sys_physics_check_bar_movement
.globl sys_physics_bounce_x
.globl sys_physics_bounce_y
.globl sys_physics_get_bar_direction
.globl sys_physics_check_ball_detach
.globl sys_physics_is_spacebar_pressed
 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; CONSTANTS
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
BAR_MOVEMENT_SIZE = 0x01            ;; Size of movement in bytes.

MAX_BALL_Y = 190                    ;; If the ball reaches this height, player loses a life.