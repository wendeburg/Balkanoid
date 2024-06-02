;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; EXPORTS
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
.globl sys_reder_draw_bar
.globl sys_reder_remove_sprite
.globl sys_render_draw_stage
.globl sys_reder_draw_ball
.globl sys_render_remove_bar
.globl sys_render_remove_ball
.globl sys_render_draw_sprite
.globl sys_render_draw_digit
.globl sys_render_draw_life_icon
.globl sys_render_draw_powerup_catch
.globl sys_render_change_stage
.globl sys_render_init_game_screen


.macro DrawMotif _x, _y, _MOTIF, _size_x, _size_y
    ld de, #VIDEO_MEMORY_START
    ld c, _x
    ld b, _y
    call cpct_getScreenPtr_asm
    ex de, hl
    ld hl, _MOTIF
    ld c, _size_x
    ld b, _size_y
    call cpct_drawSprite_asm
.endm
.macro DrawNMotifs _N, _X, _MOT, _SIZE_X, _SIZE_Y
    ld a, #0
    .rept _N
        push af
        DrawMotif _X, a, _MOT, _SIZE_X, _SIZE_Y
        pop af
        add _SIZE_Y
    .endm
.endm

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; CONSTANTS
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
VIDEO_MEMORY_START = 0xC000
SCREEN_H = 200                  ;; In pixels.
SCREEN_W = 320                  ;; In pixels.

BORDER_SIDE_H = 8               ;; In lines.
BORDER_SIDE_W = 2               ;; In bytes.
BORDER_TOP_H = 8                ;; In lines.
BORDER_TOP_W = 2                ;; In bytes.
BORDER_TOP_ENENY_SPANER_W = 4   ;; In bytes.

BAR_Y_POSITION = 168            ;; In lines.
BAR_H = 8                       ;; In lines.
BAR_W = 8                       ;; In bytes.

BALL_H = 6                      ;; In lines.
BALL_W = 3                      ;; In bytes.

BLOCK_W = 6                     ;; In bytes.
BLOCK_H = 8                     ;; In lines.

DIGIT_W = 2                     ;; In bytes.
DIGIT_H = 6                     ;; In lines.

LIFE_ICON_W = 3                 ;; In bytes.
LIFE_ICON_H = 4                 ;; In lines.

POWERUP_SPRITE_W = 4
POWERUP_SPRITE_H = 10

BLOCK_COLOR_PASTEL_CYAN = 1
BLOCK_COLOR_PASTEL_BLUE = 2
BLOCK_COLOR_PINK = 3
BLOCK_COLOR_PASTEL_GREEN = 4
BLOCK_COLOR_CYAN = 5