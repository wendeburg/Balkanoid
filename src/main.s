.include "cpctelera.h.s"
.include "cpct_functions.h.s"
.include "manager/game_manager.h.s"
.include "manager/game_over_screen_manager.h.s"
.include "manager/start_screen_manager.h.s"

.area _DATA
.area _CODE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; IMPORTS
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
.globl _g_palette
.globl man_game_init_game
.globl cpct_waitVSYNC_asm
.globl cpct_akp_stop_asm

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; FUNCTIONS
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;
;; MAIN function. This is the entry point of the application.
;;
_main::
;; Disable firmware to prevent it from interfering with string drawing
   call cpct_disableFirmware_asm

   ;; Establecer el modo de video a 0.
   ld c, #0
   call cpct_setVideoMode_asm

   ;; Establecer la paleta de colores a usar.
   ld hl, #_g_palette
   ld de, #16
   call cpct_setPalette_asm

   ;; Establecer el color del borde la pantalla.
   cpctm_setBorder_asm #0x03

   ;; Establecer colores del texto.
   ld    h, #0x00
   ld    l, #0x0D
   call cpct_setDrawCharM0_asm

new_game:
   ;; Mostrar menu
   call man_start_screen_show

   call cpct_akp_stop_asm

   ;; Preparar juego.
   call man_game_init_game

   ;; Ejecutar juego.
   call man_game_game_loop

   ;; Pantalla fin juego
   call man_game_over_screen_show

   jr new_game