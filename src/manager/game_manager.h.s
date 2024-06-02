;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; EXPORTS
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
.globl man_game_init_game
.globl man_game_lives
.globl man_game_display_score
.globl man_game_display_high_score
.globl man_game_current_stage
.globl man_game_game_loop
.globl man_game_get_current_stage_number
.globl man_game_block_collision
.globl man_game_number_of_blocks_left
.globl man_game_high_score_changed

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; CONSTANTS
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ZERO = 0

NUM_STARTING_LIVES = 5

STARTING_STAGE = 0

BLOCK_COMMON_DESTRUCTION_POINTS = 1     ;; 10
BLOCK_SILVER_DESTRUCTION_POINTS = 3     ;; 30