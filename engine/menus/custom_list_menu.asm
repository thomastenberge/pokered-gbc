CustomListMenuTextMethods:
	dw GetMonNameListMenu

CustomListMenuGetEntryText::
	push hl
	ld a, [wListMenuCustomType]
	ld hl, CustomListMenuTextMethods
	call GetAddressFromPointerArray
	call hl_caller
	pop hl
	ret

GetMonNameListMenu:
	jp GetMonName

GetListEntryID:
	ld a, [wListCount]
	and a
	jr z, .noText ;if the list is 0 entries, we only have CANCEL in the list, so don't load any TM info
	ld a, [wCurrentMenuItem]
	ld c, a
	ld a, [wListScrollOffset]
	add c
	ld c, a
	ld a, [wListCount]
	dec a
	cp c ; did the player select Cancel?
	jr c, .noText ; if so, don't display anything
	ld a, [wCurrentMenuItem]
	ld c, a
	ld a, [wListScrollOffset]
	add c
	ld c, a
	ld a, [wListMenuID]
	cp ITEMLISTMENU
	jr nz, .skipmulti 
	sla c ; item entries are 2 bytes long, so multiply by 2
.skipmulti
	ld a, [wListPointer]
	ld l, a
	ld a, [wListPointer + 1]
	ld h, a
	inc hl ; hl = beginning of list entries
	ld b, 0
	add hl, bc
	ld a, [hl] ; a = which item id it is now
	and a ; clear carry
	ret
.noText
	scf
	ret
