;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; EXPORTS
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
.globl man_scoreboard_init
.globl man_scoreboard_draw_stage_number
.globl man_scoreboard_draw_catch_powerup_icon
.globl man_scoreboard_update_score
.globl man_scoreboard_update_high_score
.globl man_scoreboard_remove_life
.globl man_scoreboard_clean_scoreboard

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; CONSTANTS
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
SCOREBOARD_X_START = 0x40                   ;; The column (x coordinate) where the scoreboard starts in pixels.
HORIZONTAL_SPACING = 0x01                   ;; The size of the spacing in number of lines.
VERTICAL_SPACING = 0x04                     ;; The size of the spacing in bytes.
SCOREBOARD_LIFE_ICON_MARGIN = 0x02

TEXT_H = 6
SCORE_TEXT_W = 10
LIVES_TEXT_W = 10
ACTIVE_TEXT_W = 11
POWER_TEXT_W = 11
UPS_TEXT_W = 10
STAGE_TEXT_W = 10
HIGH_TEXT_W = 8