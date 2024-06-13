DisplayEffectiveness:
;joenote - if a multi-attack move, only display effectiveness on the last attack 
	callba TestMultiAttackMoveUse
	jr nz, .next
	callba TestMultiAttackMoveUse_lastAttack
	ret nz
.next

	ld a, [wDamageMultipliers]
	and $7F
	cp EFFECTIVE
	ret z
	ld hl, SuperEffectiveText
	jr nc, .done
	ld hl, NotVeryEffectiveText
.done
	jp PrintText

SuperEffectiveText:
	text_far _SuperEffectiveText
	text_end

NotVeryEffectiveText:
	text_far _NotVeryEffectiveText
	text_end
