.include "utils.h.s"

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; PUBLIC FUNCTIONS
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Operation A % B.
;; OUTPUT:
;;      A = A % B
utils_modulo_8b:
modulo_8b_loop:
    cp b
    jr c, modulo_8b_return
    sub b
    jr modulo_8b_loop

modulo_8b_return:
    ret

;; Operation C * B.
;; OUTPUT:
;;      A = C * B
utils_mult_8b:
    ;; If either c or b is 0 return 0.
    ld a, b
    cp #0
    jr z, mult_8b_return_0
    ld a, c
    cp #0
    jr z, mult_8b_return_0

    ld d, c

mult_8b_loop:
    ld a, b
    cp #1
    jr z, mult_8b_return

    dec a
    ld b, a

    ld a, c
    add d
    ld c, a

    jr mult_8b_loop

mult_8b_return_0:
    ld c, #0

mult_8b_return:
    ld a, c

    ret

;; Operation C / B. B can't be 0.
;; OUTPUT:
;;      A = C / B
utils_div_8b::
    ld e, #0        ;; Init quotient.

div_8b_loop:
    ld a, c
    cp b
    jr c, div_8b_return

    sub b
    ld c, a

    ld a, e
    inc a
    ld e, a

    jr div_8b_loop

div_8b_return:
    ld a, e

    ret

;; Negate hl
;; INPUT: hl
;; OUTPUT: hl = -hl
;; DESTROYED: a
utils_neg_HL::
	xor a
	sub l
	ld l,a
	sbc a,a
	sub h
	ld h,a
	ret