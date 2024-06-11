; Syntactic sugar macros

MACRO lb ; r, hi, lo
	ld \1, ((\2) & $ff) << 8 + ((\3) & $ff)
ENDM

MACRO ldpal
	ld \1, \2 << 6 | \3 << 4 | \4 << 2 | \5
ENDM

; Design patterns

MACRO dict
	IF \1 == 0
		and a
	ELSE
		cp \1
	ENDC
	jp z, \2
ENDM

; dereference the pointer argument into hl, if no argument just pull reference from hl
MACRO hl_deref
	IF _NARG > 0
		ld hl, \1
	ENDC
	ld a, [hli]
	ld h, [hl]
	ld l, a
ENDM
