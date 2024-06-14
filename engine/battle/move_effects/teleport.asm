; returns nz if the player/opponent can switch
CheckCanForceSwitch::
	ldh a, [hWhoseTurn]
	and a
	ld a, [wPartyCount]
	ld hl, wPartyMon1HP
	ld bc, wPartyMon2 - wPartyMon1 - 1
	jr z, CheckCanForceSwitchEnemy.playerTurn
CheckCanForceSwitchEnemy::
	ld a, [wEnemyPartyCount]
	ld hl, wEnemyMon1HP
	ld bc, wEnemyMon2 - wEnemyMon1 - 1
.playerTurn
	ld e, a
	ld d, a
.partyMonsLoop
	xor a
	or [hl]
	inc hl
	or [hl]
	jr nz, .skipDec
	dec d
.skipDec
	add hl, bc
	dec e
	jr nz, .partyMonsLoop
	ld a, d
	dec a ; don't count current pokemon
	ret
