;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; EXPORTS
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
.globl man_stage_stages_array
.globl man_stage_number_of_stages

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; MACROS
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Creates a stage. A stage is defined by it's number, a pointer to the array of blocks and a pointer
;; to an array of probabolities for the powerups.
.macro DefineStage _numberTens, _numberUnits, _numberOfBlocks, _blockArrayAdress, _blockArraySize, _powerupsProbabiltyArray
    .db _numberTens
    .db _numberUnits
    .db _numberOfBlocks
    .dw _blockArrayAdress
    .dw _blockArraySize
    .dw _powerupsProbabiltyArray
.endm

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; CONSTANTS
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
END_OF_BLOCKS_ARRAY_BYTE = 0x00

SIZE_OF_STAGE = 9                   ;; bytes.
OFFSET_TO_BLOCK_ARRAY_IN_STAGE = 3  ;; bytes.

BLOCK_ROW_1 = 23
BLOCK_ROW_2 = 31
BLOCK_ROW_3 = 39
BLOCK_ROW_4 = 47
BLOCK_ROW_5 = 55
BLOCK_ROW_6 = 63
BLOCK_ROW_7 = 71
BLOCK_ROW_8 = 79
BLOCK_ROW_9 = 87
BLOCK_ROW_10 = 95
BLOCK_ROW_11 = 103

BLOCK_COL_1 = 0x02
BLOCK_COL_2 = 0x08
BLOCK_COL_3 = 0x0E
BLOCK_COL_4 = 0x14
BLOCK_COL_5 = 0x1A
BLOCK_COL_6 = 0x20
BLOCK_COL_7 = 0x26
BLOCK_COL_8 = 0x2C
BLOCK_COL_9 = 0x32
BLOCK_COL_10 = 0x38