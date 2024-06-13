
;returns z flag if on the first attack
;returns z flag cleared if not on the first or not applicable
TestMultiAttackMoveUse_firstAttack:
	call TestMultiAttackMoveUse
	ret nz
	ld a, l
	and a
	ret
;returns z flag set if on the last attack
;returns z flag cleared if not on the last attack or not applicable
TestMultiAttackMoveUse_lastAttack:
	call TestMultiAttackMoveUse
	ret nz
	ld a, l
	cp 1
	ret
;returns with z flag set if using a multi-attack move 
;returns with L = attacks left
TestMultiAttackMoveUse:
	ld a, [hWhoseTurn]
	and a
	push bc
	ld a, [wPlayerMoveNum]
	ld b, a
	ld a, [wPlayerMoveEffect]
	ld h, a
	ld a, [wPlayerNumAttacksLeft]
	ld l, a
	jr z, .next1
	ld a, [wEnemyMoveNum]
	ld b, a
	ld a, [wEnemyMoveEffect]
	ld h, a
	ld a, [wEnemyNumAttacksLeft]
	ld l, a
.next1
	ld a, b
	pop bc
	cp TWINEEDLE
	jr z, .multi_attack
	ld a, h
	cp ATTACK_TWICE_EFFECT
	jr z, .multi_attack
	cp TWO_TO_FIVE_ATTACKS_EFFECT
	jr nz, .done_multi
.multi_attack
	;at this line, we are dealing with a multi-attack or two-attack move
	xor a
	ret
.done_multi
	ld a, 1
	and a
	ret
