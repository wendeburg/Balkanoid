;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; EXPORTS
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
.globl man_entity_bar_position
.globl man_entity_ball_position
.globl man_entity_ball_speed
.globl man_entity_ball_attached_to_bar
.globl man_entity_stage_block_array
.globl man_entity_handle_block_collision

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; MACROS
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Creates a block with the given type, x and y coordiantes and durability.
;; Only silver blocks have durability. Gold blocks are indestructible and normal blocks break after one hit.
;; Only common blocks have a color.
.macro DefineBlock _type, _x, _y, _durability, _color 
    .db _type
    .db _x
    .db _y
    .db _durability
    .db _color                           
.endm

;; Defines a common block.
.macro DefineCommonBlock _x, _y, _color
    DefineBlock BLOCK_COMMON, _x, _y, 0, _color
.endm

;; Defines a silver block.
.macro DefineSilverBlock _x, _y, _durability
    DefineBlock BLOCK_SILVER, _x, _y, _durability, 0
.endm

;; Defines a gold block.
.macro DefineGoldBlock _x, _y
    DefineBlock BLOCK_GOLD, _x, _y, 0, 0
.endm

;; Defines the probability for the different powerups.
.macro DefinePowerPowerupsProbabilities _probExtend, _probCatch, _probLife
    .db _probExtend
    .db _probCatch
    .db _probLife
.endm

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; CONSTANTS
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

BLOCK_BYTE_SIZE = 5

MAX_NUM_BLOCKS = 11 * 10                    ;; 11 rows, 10 blocks each.

MAX_BLOCK_ARRAY_SIZE = (MAX_NUM_BLOCKS * BLOCK_BYTE_SIZE) + 1 ;; Max number of blocks + end of block array byte.

;; Block types
BLOCK_COMMON = 1
BLOCK_SILVER = 2
BLOCK_GOLD = 3
BLOCK_DESTROYED = 4

;; Bar
STARTING_BAR_X = 0x1B

;; Ball
STARTING_BALL_X = 0x1D00
STARTING_BALL_Y = (160*256)
BALL_VX = #0x0000
BALL_VY = #0x0000

BALL_ATTACHED_TO_BAR = 1
BALL_NOT_ATTACHED_TO_BAR = 0