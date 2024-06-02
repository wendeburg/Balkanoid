.include "game_manager.h.s"
.include "entity_manager.h.s"
.include "stage_manager.h.s"
.include "../system/render_system.h.s"

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; MACROS (they need to be defined here due to the use of constants)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Defines a row of 10 silver blocks.
.macro DefineSilverBlocksRow _y, _durability
    DefineSilverBlock BLOCK_COL_1, _y, _durability
    DefineSilverBlock BLOCK_COL_2, _y, _durability
    DefineSilverBlock BLOCK_COL_3, _y, _durability
    DefineSilverBlock BLOCK_COL_4, _y, _durability
    DefineSilverBlock BLOCK_COL_5, _y, _durability
    DefineSilverBlock BLOCK_COL_6, _y, _durability
    DefineSilverBlock BLOCK_COL_7, _y, _durability
    DefineSilverBlock BLOCK_COL_8, _y, _durability
    DefineSilverBlock BLOCK_COL_9, _y, _durability
    DefineSilverBlock BLOCK_COL_10, _y, _durability
.endm

;; Defines a row of 10 commong blocks of the same color.
.macro DefineCommonBlocksRow _y, _color
    DefineCommonBlock BLOCK_COL_1, _y, _color
    DefineCommonBlock BLOCK_COL_2, _y, _color
    DefineCommonBlock BLOCK_COL_3, _y, _color
    DefineCommonBlock BLOCK_COL_4, _y, _color
    DefineCommonBlock BLOCK_COL_5, _y, _color
    DefineCommonBlock BLOCK_COL_6, _y, _color
    DefineCommonBlock BLOCK_COL_7, _y, _color
    DefineCommonBlock BLOCK_COL_8, _y, _color
    DefineCommonBlock BLOCK_COL_9, _y, _color
    DefineCommonBlock BLOCK_COL_10, _y, _color
.endm

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; STAGES
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; A pointer array to the stages.
man_stage_stages_array::
    .dw stage_one
    .dw stage_two
    .dw stage_three
    .dw stage_four
    .dw stage_five
    .dw stage_six
    .dw stage_seven

;; The number of stages in the array.
man_stage_number_of_stages::
    .db 7

;; STAGE 1
stage_one_block_array:
    DefineCommonBlock BLOCK_COL_4, BLOCK_ROW_6, BLOCK_COLOR_PINK
    DefineCommonBlock BLOCK_COL_5, BLOCK_ROW_6, BLOCK_COLOR_PASTEL_CYAN
    DefineCommonBlock BLOCK_COL_6, BLOCK_ROW_6, BLOCK_COLOR_PASTEL_CYAN
    DefineCommonBlock BLOCK_COL_7, BLOCK_ROW_6, BLOCK_COLOR_PINK
    DefineCommonBlock BLOCK_COL_4, BLOCK_ROW_7, BLOCK_COLOR_PASTEL_CYAN
    DefineSilverBlock BLOCK_COL_5, BLOCK_ROW_7, 2
    DefineSilverBlock BLOCK_COL_6, BLOCK_ROW_7, 2
    DefineCommonBlock BLOCK_COL_7, BLOCK_ROW_7, BLOCK_COLOR_PASTEL_CYAN
    DefineCommonBlock BLOCK_COL_4, BLOCK_ROW_8, BLOCK_COLOR_PINK
    DefineCommonBlock BLOCK_COL_5, BLOCK_ROW_8, BLOCK_COLOR_PASTEL_CYAN
    DefineCommonBlock BLOCK_COL_6, BLOCK_ROW_8, BLOCK_COLOR_PASTEL_CYAN
    DefineCommonBlock BLOCK_COL_7, BLOCK_ROW_8, BLOCK_COLOR_PINK
    .db END_OF_BLOCKS_ARRAY_BYTE

stage_one_powerups_probabilities:
    DefinePowerPowerupsProbabilities 0, 0, 0

stage_one:
    DefineStage 0, 1, 12, stage_one_block_array, 61, stage_one_powerups_probabilities

;; STAGE 2
stage_two_block_array:
    DefineCommonBlock BLOCK_COL_1, BLOCK_ROW_10, BLOCK_COLOR_PASTEL_GREEN
    DefineSilverBlock BLOCK_COL_2, BLOCK_ROW_10, 2
    DefineCommonBlock BLOCK_COL_1, BLOCK_ROW_11, BLOCK_COLOR_PASTEL_GREEN
    DefineCommonBlock BLOCK_COL_2, BLOCK_ROW_11, BLOCK_COLOR_PASTEL_GREEN
    DefineCommonBlock BLOCK_COL_1, BLOCK_ROW_1, BLOCK_COLOR_PASTEL_GREEN
    DefineSilverBlock BLOCK_COL_2, BLOCK_ROW_2, 2
    DefineCommonBlock BLOCK_COL_1, BLOCK_ROW_2, BLOCK_COLOR_PASTEL_GREEN
    DefineCommonBlock BLOCK_COL_2, BLOCK_ROW_1, BLOCK_COLOR_PASTEL_GREEN
    DefineCommonBlock BLOCK_COL_9, BLOCK_ROW_1, BLOCK_COLOR_PASTEL_GREEN
    DefineSilverBlock BLOCK_COL_9, BLOCK_ROW_2, 2
    DefineCommonBlock BLOCK_COL_10, BLOCK_ROW_2, BLOCK_COLOR_PASTEL_GREEN
    DefineCommonBlock BLOCK_COL_10, BLOCK_ROW_1, BLOCK_COLOR_PASTEL_GREEN
    DefineCommonBlock BLOCK_COL_9, BLOCK_ROW_11, BLOCK_COLOR_PASTEL_GREEN
    DefineSilverBlock BLOCK_COL_9, BLOCK_ROW_10, 2
    DefineCommonBlock BLOCK_COL_10, BLOCK_ROW_11, BLOCK_COLOR_PASTEL_GREEN
    DefineCommonBlock BLOCK_COL_10, BLOCK_ROW_10, BLOCK_COLOR_PASTEL_GREEN
    DefineCommonBlock BLOCK_COL_6, BLOCK_ROW_5, BLOCK_COLOR_PASTEL_CYAN
    DefineCommonBlock BLOCK_COL_6, BLOCK_ROW_6, BLOCK_COLOR_PASTEL_BLUE
    DefineCommonBlock BLOCK_COL_5, BLOCK_ROW_5, BLOCK_COLOR_PASTEL_CYAN
    DefineCommonBlock BLOCK_COL_5, BLOCK_ROW_6, BLOCK_COLOR_PASTEL_BLUE
    DefineCommonBlock BLOCK_COL_6, BLOCK_ROW_7, BLOCK_COLOR_PASTEL_CYAN
    DefineCommonBlock BLOCK_COL_5, BLOCK_ROW_7, BLOCK_COLOR_PASTEL_CYAN
    .db END_OF_BLOCKS_ARRAY_BYTE

stage_two_powerups_probabilities:
    DefinePowerPowerupsProbabilities 0, 0, 0

stage_two:
    DefineStage 0, 2, 22, stage_two_block_array, 111, stage_two_powerups_probabilities

;; STAGE 3
stage_three_block_array:
    DefineCommonBlock BLOCK_COL_1, BLOCK_ROW_11, BLOCK_COLOR_PASTEL_BLUE
    DefineCommonBlock BLOCK_COL_2, BLOCK_ROW_10, BLOCK_COLOR_PASTEL_GREEN
    DefineCommonBlock BLOCK_COL_3, BLOCK_ROW_9, BLOCK_COLOR_PINK
    DefineCommonBlock BLOCK_COL_4, BLOCK_ROW_8, BLOCK_COLOR_PASTEL_GREEN
    DefineGoldBlock BLOCK_COL_5, BLOCK_ROW_7
    DefineGoldBlock BLOCK_COL_6, BLOCK_ROW_6
    DefineCommonBlock BLOCK_COL_7, BLOCK_ROW_5, BLOCK_COLOR_PASTEL_GREEN
    DefineCommonBlock BLOCK_COL_8, BLOCK_ROW_4, BLOCK_COLOR_PINK
    DefineCommonBlock BLOCK_COL_9, BLOCK_ROW_3, BLOCK_COLOR_PASTEL_GREEN
    DefineCommonBlock BLOCK_COL_10, BLOCK_ROW_2, BLOCK_COLOR_PASTEL_BLUE
    DefineCommonBlock BLOCK_COL_1, BLOCK_ROW_2, BLOCK_COLOR_PASTEL_BLUE
    DefineCommonBlock BLOCK_COL_2, BLOCK_ROW_3, BLOCK_COLOR_PASTEL_GREEN
    DefineCommonBlock BLOCK_COL_3, BLOCK_ROW_4, BLOCK_COLOR_PINK
    DefineCommonBlock BLOCK_COL_4, BLOCK_ROW_5, BLOCK_COLOR_PASTEL_GREEN
    DefineSilverBlock BLOCK_COL_5, BLOCK_ROW_6, 2
    DefineSilverBlock BLOCK_COL_6, BLOCK_ROW_7, 2
    DefineCommonBlock BLOCK_COL_7, BLOCK_ROW_8, BLOCK_COLOR_PASTEL_GREEN
    DefineCommonBlock BLOCK_COL_8, BLOCK_ROW_9, BLOCK_COLOR_PINK
    DefineCommonBlock BLOCK_COL_9, BLOCK_ROW_10, BLOCK_COLOR_PASTEL_GREEN
    DefineCommonBlock BLOCK_COL_10, BLOCK_ROW_11, BLOCK_COLOR_PASTEL_BLUE

    .db END_OF_BLOCKS_ARRAY_BYTE

stage_three_powerups_probabilities:
    DefinePowerPowerupsProbabilities 0, 0, 0

stage_three:
    DefineStage 0, 3, 18, stage_three_block_array, 101, stage_three_powerups_probabilities

;; STAGE 4
stage_four_block_array:
    DefineCommonBlock BLOCK_COL_3, BLOCK_ROW_7, BLOCK_COLOR_PASTEL_GREEN
    DefineCommonBlock BLOCK_COL_8, BLOCK_ROW_7, BLOCK_COLOR_PASTEL_GREEN
    DefineCommonBlock BLOCK_COL_4, BLOCK_ROW_6, BLOCK_COLOR_PASTEL_BLUE
    DefineCommonBlock BLOCK_COL_5, BLOCK_ROW_5, BLOCK_COLOR_PASTEL_BLUE
    DefineCommonBlock BLOCK_COL_6, BLOCK_ROW_5, BLOCK_COLOR_PASTEL_BLUE
    DefineCommonBlock BLOCK_COL_7, BLOCK_ROW_6, BLOCK_COLOR_PASTEL_BLUE
    DefineCommonBlock BLOCK_COL_4, BLOCK_ROW_8, BLOCK_COLOR_PASTEL_BLUE
    DefineCommonBlock BLOCK_COL_5, BLOCK_ROW_9, BLOCK_COLOR_PASTEL_BLUE
    DefineCommonBlock BLOCK_COL_6, BLOCK_ROW_9, BLOCK_COLOR_PASTEL_BLUE
    DefineCommonBlock BLOCK_COL_7, BLOCK_ROW_8, BLOCK_COLOR_PASTEL_BLUE
    DefineGoldBlock BLOCK_COL_4, BLOCK_ROW_7
    DefineGoldBlock BLOCK_COL_7, BLOCK_ROW_7
    DefineGoldBlock BLOCK_COL_5, BLOCK_ROW_8
    DefineGoldBlock BLOCK_COL_6, BLOCK_ROW_8
    DefineSilverBlock BLOCK_COL_5, BLOCK_ROW_7, 2
    DefineSilverBlock BLOCK_COL_6, BLOCK_ROW_7, 2
    .db END_OF_BLOCKS_ARRAY_BYTE

stage_four_powerups_probabilities:
    DefinePowerPowerupsProbabilities 0, 0, 0

stage_four:
    DefineStage 0, 4, 12, stage_four_block_array, 81, stage_four_powerups_probabilities

;; STAGE 5
stage_five_block_array:
    DefineCommonBlocksRow BLOCK_ROW_2, BLOCK_COLOR_PASTEL_GREEN
    DefineCommonBlock BLOCK_COL_1, BLOCK_ROW_4, BLOCK_COLOR_PASTEL_BLUE
    DefineCommonBlock BLOCK_COL_2, BLOCK_ROW_4, BLOCK_COLOR_PASTEL_BLUE
    DefineCommonBlock BLOCK_COL_3, BLOCK_ROW_4, BLOCK_COLOR_PASTEL_BLUE
    DefineGoldBlock BLOCK_COL_4, BLOCK_ROW_4
    DefineGoldBlock BLOCK_COL_5, BLOCK_ROW_4
    DefineGoldBlock BLOCK_COL_6, BLOCK_ROW_4
    DefineGoldBlock BLOCK_COL_7, BLOCK_ROW_4
    DefineGoldBlock BLOCK_COL_8, BLOCK_ROW_4
    DefineGoldBlock BLOCK_COL_9, BLOCK_ROW_4
    DefineGoldBlock BLOCK_COL_10, BLOCK_ROW_4
    DefineCommonBlocksRow BLOCK_ROW_6, BLOCK_COLOR_PINK
    DefineCommonBlock BLOCK_COL_10, BLOCK_ROW_8, BLOCK_COLOR_PASTEL_BLUE
    DefineCommonBlock BLOCK_COL_9, BLOCK_ROW_8, BLOCK_COLOR_PASTEL_BLUE
    DefineCommonBlock BLOCK_COL_8, BLOCK_ROW_8, BLOCK_COLOR_PASTEL_BLUE
    DefineGoldBlock BLOCK_COL_4, BLOCK_ROW_8
    DefineGoldBlock BLOCK_COL_5, BLOCK_ROW_8
    DefineGoldBlock BLOCK_COL_6, BLOCK_ROW_8
    DefineGoldBlock BLOCK_COL_7, BLOCK_ROW_8
    DefineGoldBlock BLOCK_COL_3, BLOCK_ROW_8
    DefineGoldBlock BLOCK_COL_2, BLOCK_ROW_8
    DefineGoldBlock BLOCK_COL_1, BLOCK_ROW_8
    DefineCommonBlocksRow BLOCK_ROW_10, BLOCK_COLOR_PASTEL_CYAN
    .db END_OF_BLOCKS_ARRAY_BYTE

stage_five_powerups_probabilities:
    DefinePowerPowerupsProbabilities 0, 0, 0

stage_five:
    DefineStage 0, 5, 36, stage_five_block_array, 251, stage_five_powerups_probabilities

;; STAGE 6
stage_six_block_array:
    DefineCommonBlock BLOCK_COL_1, BLOCK_ROW_2, BLOCK_COLOR_PASTEL_BLUE
    DefineCommonBlock BLOCK_COL_1, BLOCK_ROW_3, BLOCK_COLOR_PASTEL_BLUE
    DefineCommonBlock BLOCK_COL_1, BLOCK_ROW_4, BLOCK_COLOR_PASTEL_BLUE
    DefineCommonBlock BLOCK_COL_1, BLOCK_ROW_5, BLOCK_COLOR_PASTEL_BLUE
    DefineCommonBlock BLOCK_COL_1, BLOCK_ROW_6, BLOCK_COLOR_PASTEL_BLUE
    DefineCommonBlock BLOCK_COL_1, BLOCK_ROW_7, BLOCK_COLOR_PASTEL_BLUE
    DefineCommonBlock BLOCK_COL_1, BLOCK_ROW_8, BLOCK_COLOR_PASTEL_BLUE
    DefineGoldBlock BLOCK_COL_1, BLOCK_ROW_9
    DefineCommonBlock BLOCK_COL_1, BLOCK_ROW_10, BLOCK_COLOR_PASTEL_BLUE

    DefineCommonBlock BLOCK_COL_3, BLOCK_ROW_2, BLOCK_COLOR_PINK
    DefineCommonBlock BLOCK_COL_3, BLOCK_ROW_3, BLOCK_COLOR_PINK
    DefineCommonBlock BLOCK_COL_3, BLOCK_ROW_4, BLOCK_COLOR_PINK
    DefineGoldBlock BLOCK_COL_3, BLOCK_ROW_5
    DefineCommonBlock BLOCK_COL_3, BLOCK_ROW_6, BLOCK_COLOR_PINK
    DefineCommonBlock BLOCK_COL_3, BLOCK_ROW_7, BLOCK_COLOR_PINK
    DefineCommonBlock BLOCK_COL_3, BLOCK_ROW_8, BLOCK_COLOR_PINK
    DefineGoldBlock BLOCK_COL_3, BLOCK_ROW_9
    DefineCommonBlock BLOCK_COL_3, BLOCK_ROW_10, BLOCK_COLOR_PINK

    DefineGoldBlock BLOCK_COL_5, BLOCK_ROW_3
    DefineGoldBlock BLOCK_COL_6, BLOCK_ROW_3
    DefineSilverBlock BLOCK_COL_5, BLOCK_ROW_4, 2
    DefineSilverBlock BLOCK_COL_6, BLOCK_ROW_4, 2

    DefineSilverBlock BLOCK_COL_5, BLOCK_ROW_6, 2
    DefineSilverBlock BLOCK_COL_6, BLOCK_ROW_6, 2
    DefineGoldBlock BLOCK_COL_5, BLOCK_ROW_7
    DefineGoldBlock BLOCK_COL_6, BLOCK_ROW_7

    DefineCommonBlock BLOCK_COL_8, BLOCK_ROW_2, BLOCK_COLOR_PINK
    DefineCommonBlock BLOCK_COL_8, BLOCK_ROW_3, BLOCK_COLOR_PINK
    DefineCommonBlock BLOCK_COL_8, BLOCK_ROW_4, BLOCK_COLOR_PINK
    DefineGoldBlock BLOCK_COL_8, BLOCK_ROW_5
    DefineCommonBlock BLOCK_COL_8, BLOCK_ROW_6, BLOCK_COLOR_PINK
    DefineCommonBlock BLOCK_COL_8, BLOCK_ROW_7, BLOCK_COLOR_PINK
    DefineCommonBlock BLOCK_COL_8, BLOCK_ROW_8, BLOCK_COLOR_PINK
    DefineGoldBlock BLOCK_COL_8, BLOCK_ROW_9
    DefineCommonBlock BLOCK_COL_8, BLOCK_ROW_10, BLOCK_COLOR_PINK

    DefineCommonBlock BLOCK_COL_10, BLOCK_ROW_2, BLOCK_COLOR_PASTEL_BLUE
    DefineCommonBlock BLOCK_COL_10, BLOCK_ROW_3, BLOCK_COLOR_PASTEL_BLUE
    DefineCommonBlock BLOCK_COL_10, BLOCK_ROW_4, BLOCK_COLOR_PASTEL_BLUE
    DefineCommonBlock BLOCK_COL_10, BLOCK_ROW_5, BLOCK_COLOR_PASTEL_BLUE
    DefineCommonBlock BLOCK_COL_10, BLOCK_ROW_6, BLOCK_COLOR_PASTEL_BLUE
    DefineCommonBlock BLOCK_COL_10, BLOCK_ROW_7, BLOCK_COLOR_PASTEL_BLUE
    DefineCommonBlock BLOCK_COL_10, BLOCK_ROW_8, BLOCK_COLOR_PASTEL_BLUE
    DefineGoldBlock BLOCK_COL_10, BLOCK_ROW_9
    DefineCommonBlock BLOCK_COL_10, BLOCK_ROW_10, BLOCK_COLOR_PASTEL_BLUE
    .db END_OF_BLOCKS_ARRAY_BYTE

stage_six_powerups_probabilities:
    DefinePowerPowerupsProbabilities 0, 0, 0

stage_six:
    DefineStage 0, 6, 34, stage_six_block_array, 221, stage_six_powerups_probabilities

;; STAGE 7
stage_seven_block_array:
    ;; Primera columna
    DefineCommonBlock BLOCK_COL_1, BLOCK_ROW_1, BLOCK_COLOR_PINK 
    DefineCommonBlock BLOCK_COL_1, BLOCK_ROW_2, BLOCK_COLOR_PINK 
    DefineCommonBlock BLOCK_COL_1, BLOCK_ROW_3, BLOCK_COLOR_PINK 
    DefineCommonBlock BLOCK_COL_1, BLOCK_ROW_4, BLOCK_COLOR_PINK 
    DefineCommonBlock BLOCK_COL_1, BLOCK_ROW_5, BLOCK_COLOR_PINK 
    DefineCommonBlock BLOCK_COL_1, BLOCK_ROW_6, BLOCK_COLOR_PINK 
    DefineCommonBlock BLOCK_COL_1, BLOCK_ROW_7, BLOCK_COLOR_PINK 
    DefineCommonBlock BLOCK_COL_1, BLOCK_ROW_8, BLOCK_COLOR_PINK
    DefineCommonBlock BLOCK_COL_1, BLOCK_ROW_9, BLOCK_COLOR_PINK
    DefineSilverBlock BLOCK_COL_1, BLOCK_ROW_10, 2
    ;; Segunda columna
    DefineCommonBlock BLOCK_COL_2, BLOCK_ROW_2, BLOCK_COLOR_PASTEL_CYAN
    DefineCommonBlock BLOCK_COL_2, BLOCK_ROW_3, BLOCK_COLOR_PASTEL_CYAN
    DefineCommonBlock BLOCK_COL_2, BLOCK_ROW_4, BLOCK_COLOR_PASTEL_CYAN
    DefineCommonBlock BLOCK_COL_2, BLOCK_ROW_5, BLOCK_COLOR_PASTEL_CYAN
    DefineCommonBlock BLOCK_COL_2, BLOCK_ROW_6, BLOCK_COLOR_PASTEL_CYAN 
    DefineCommonBlock BLOCK_COL_2, BLOCK_ROW_7, BLOCK_COLOR_PASTEL_CYAN 
    DefineCommonBlock BLOCK_COL_2, BLOCK_ROW_8, BLOCK_COLOR_PASTEL_CYAN
    DefineCommonBlock BLOCK_COL_2, BLOCK_ROW_9, BLOCK_COLOR_PASTEL_CYAN
    DefineSilverBlock BLOCK_COL_2, BLOCK_ROW_10, 2
    ;; Tercera columna
    DefineCommonBlock BLOCK_COL_3, BLOCK_ROW_3, BLOCK_COLOR_PASTEL_GREEN
    DefineCommonBlock BLOCK_COL_3, BLOCK_ROW_4, BLOCK_COLOR_PASTEL_GREEN
    DefineCommonBlock BLOCK_COL_3, BLOCK_ROW_5, BLOCK_COLOR_PASTEL_GREEN
    DefineCommonBlock BLOCK_COL_3, BLOCK_ROW_6, BLOCK_COLOR_PASTEL_GREEN 
    DefineCommonBlock BLOCK_COL_3, BLOCK_ROW_7, BLOCK_COLOR_PASTEL_GREEN 
    DefineCommonBlock BLOCK_COL_3, BLOCK_ROW_8, BLOCK_COLOR_PASTEL_GREEN
    DefineCommonBlock BLOCK_COL_3, BLOCK_ROW_9, BLOCK_COLOR_PASTEL_GREEN
    DefineSilverBlock BLOCK_COL_3, BLOCK_ROW_10, 2
    ;; Cuarta columna
    DefineCommonBlock BLOCK_COL_4, BLOCK_ROW_4, BLOCK_COLOR_PASTEL_BLUE
    DefineCommonBlock BLOCK_COL_4, BLOCK_ROW_5, BLOCK_COLOR_PASTEL_BLUE
    DefineCommonBlock BLOCK_COL_4, BLOCK_ROW_6, BLOCK_COLOR_PASTEL_BLUE 
    DefineCommonBlock BLOCK_COL_4, BLOCK_ROW_7, BLOCK_COLOR_PASTEL_BLUE 
    DefineCommonBlock BLOCK_COL_4, BLOCK_ROW_8, BLOCK_COLOR_PASTEL_BLUE
    DefineCommonBlock BLOCK_COL_4, BLOCK_ROW_9, BLOCK_COLOR_PASTEL_BLUE
    DefineSilverBlock BLOCK_COL_4, BLOCK_ROW_10, 2
    ;; Quinta columna
    DefineCommonBlock BLOCK_COL_5, BLOCK_ROW_5, BLOCK_COLOR_CYAN
    DefineCommonBlock BLOCK_COL_5, BLOCK_ROW_6, BLOCK_COLOR_CYAN 
    DefineCommonBlock BLOCK_COL_5, BLOCK_ROW_7, BLOCK_COLOR_CYAN 
    DefineCommonBlock BLOCK_COL_5, BLOCK_ROW_8, BLOCK_COLOR_CYAN
    DefineCommonBlock BLOCK_COL_5, BLOCK_ROW_9, BLOCK_COLOR_CYAN
    DefineSilverBlock BLOCK_COL_5, BLOCK_ROW_10, 2
    ;; Sexta Columna
    DefineCommonBlock BLOCK_COL_6, BLOCK_ROW_6, BLOCK_COLOR_PINK 
    DefineCommonBlock BLOCK_COL_6, BLOCK_ROW_7, BLOCK_COLOR_PINK 
    DefineCommonBlock BLOCK_COL_6, BLOCK_ROW_8, BLOCK_COLOR_PINK
    DefineCommonBlock BLOCK_COL_6, BLOCK_ROW_9, BLOCK_COLOR_PINK
    DefineSilverBlock BLOCK_COL_6, BLOCK_ROW_10, 2
    ;; Septima Columna
    DefineCommonBlock BLOCK_COL_7, BLOCK_ROW_7, BLOCK_COLOR_PASTEL_CYAN 
    DefineCommonBlock BLOCK_COL_7, BLOCK_ROW_8, BLOCK_COLOR_PASTEL_CYAN
    DefineCommonBlock BLOCK_COL_7, BLOCK_ROW_9, BLOCK_COLOR_PASTEL_CYAN
    DefineSilverBlock BLOCK_COL_7, BLOCK_ROW_10, 2
    ;; Octava Columna
    DefineCommonBlock BLOCK_COL_8, BLOCK_ROW_8, BLOCK_COLOR_PASTEL_GREEN
    DefineCommonBlock BLOCK_COL_8, BLOCK_ROW_9, BLOCK_COLOR_PASTEL_GREEN
    DefineSilverBlock BLOCK_COL_8, BLOCK_ROW_10, 2
    ;; Novena Columna
    DefineCommonBlock BLOCK_COL_9, BLOCK_ROW_9, BLOCK_COLOR_PASTEL_BLUE
    DefineSilverBlock BLOCK_COL_9, BLOCK_ROW_10, 2
    ;; Decima Columna
    DefineCommonBlock BLOCK_COL_10, BLOCK_ROW_10, BLOCK_COLOR_CYAN
    .db END_OF_BLOCKS_ARRAY_BYTE

stage_seven_powerups_probabilities:
    DefinePowerPowerupsProbabilities 0, 0, 0

stage_seven:
    DefineStage 0, 7, 55, stage_seven_block_array, 276, stage_seven_powerups_probabilities