;joenote - This fixes an issue with exp all where exp gets divided twice	
UndoDivision4ExpAll:
	ld hl, wEnemyMonBaseStats	;get first stat
	ld b, $7
.exp_stat_loop
	ld a, [wUnusedD155]	
	ld c, a		;get number of participating pkmn into c
	xor a	;clear a to zero
	
.exp_adder_loop
	add [hl]	; add the value of the current exp stat to 'a'
	dec c		; decrement participating pkmn
	jr nz, .exp_adder_loop
	
	ld [hl], a	;stick the exp values, now multiplied by the number of participating pkmn, back into the stat address
	
	inc hl	;get next stat 
	dec b
	
	jr nz, .exp_stat_loop
	xor a
	ld [wUnusedD155], a		;clear backup location for how many pkmn recieve exp	
	ret

;joenote - fixes issues where exp all counts fainted pkmn for dividing exp
SetExpAllFlags:
	ld a, $1
	ld [wBoostExpByExpAll], a
	ld a, [wPartyCount]
	ld c, a
	ld b, 0
	ld hl, wPartyMon1HP
.gainExpFlagsLoop	
;wisp92 found that bits need to be rotated in from the left and shifted to the right. 
;Bit 0 of the flags represents the first mon in the party
;Bit 5 of the flags represents the sixth mon in the party
	ld a, [hli]
	or [hl] ; is mon's HP 0?
	jp z, .setnextexpflag	;the carry bit is cleared from the last OR, so 0 will be rotated in next
	scf	;the carry bit is is set, so 1 will be rotated in next
.setnextexpflag 
	jp .do_rotations	
.nextmonforexpall
	dec c
	jr z, .return
	ld a, [wPartyCount]
	sub c
	push bc
	ld bc, wPartyMon2HP - wPartyMon1HP
	ld hl, wPartyMon1HP
	call AddNTimes
	pop bc
	jr .gainExpFlagsLoop
.return
	ld a, b
	ld [wPartyGainExpFlags], a
	ret
.do_rotations
;need to rotate the carry value into the proper flag bit position
;a and hl are free to use
;c is the counter that tells the party position
;b holds the current flag values
	push af	;save carry value
	;the number of rotations needed to move the carry value to the proper flag place is 8 - [wPartyCount] + c
	ld a, $08
	ld hl, wPartyCount 
	sub [hl] ;subtract 1 to 6
	add c	; add the current count
	ld h, a
	pop af	;get the carry value back
	ld a, h
	;a now has the rotation count (8 to 3)
	push bc
	ld c, a	;make c hold the rotation count
	ld a, $00
.loop
	rr a	;rotate the carry value 1 bit to the right per loop
	dec c
	jr nz, .loop
	pop bc
	or b	;append current flag values to a
	ld b, a	; and save them back to b
	jp .nextmonforexpall


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
