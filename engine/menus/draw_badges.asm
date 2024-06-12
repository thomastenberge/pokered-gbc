DrawBadges:
; Draw 4x2 gym leader faces, with the faces replaced by
; badges if they are owned. Used in the player status screen.

; In Japanese versions, names are displayed above faces.
; Instead of removing relevant code, the name graphics were erased.

; Tile ids for face/badge graphics.
	ld de, wBadgeOrFaceTiles
	ld hl, .FaceBadgeTiles
	ld bc, NUM_BADGES
	call CopyData

; Booleans for each badge.
	ld hl, wTempObtainedBadgesBooleans
	ld bc, NUM_BADGES
	xor a
	call FillMemory

; Alter these based on owned badges.
	ld de, wTempObtainedBadgesBooleans
	ld hl, wBadgeOrFaceTiles
	ld a, [wObtainedBadges]
	ld b, a
	ld c, NUM_BADGES
.CheckBadge
	srl b
	jr nc, .NextBadge
	ld a, [hl]
	add 4 ; Badge graphics are after each face
	ld [hl], a
	ld a, 1
	ld [de], a
.NextBadge
	inc hl
	inc de
	dec c
	jr nz, .CheckBadge

; Draw two rows of badges.
	ld hl, wBadgeNumberTile
	ld a, $d8 ; [1]
	ld [hli], a		;increments to cd3e which is wBadgeNameTile
	ld [hl], $00

	hlcoord 2, 11
	ld de, wTempObtainedBadgesBooleans
	call .DrawBadgeRow

	hlcoord 2, 14
	ld de, wTempObtainedBadgesBooleans + 4
	; fallthrough

.DrawBadgeRow
; Draw 4 badges.

	ld c, 4
.DrawBadge
	push de
	push hl

; Badge no.
	ld a, [wBadgeNumberTile]
	ld [hli], a
	inc a
	ld [wBadgeNumberTile], a

; Names aren't printed if the badge is owned.
;joenote - restoring leader names, 
;so shuffled updating badge names around a bit since it now tracks badge number 
	ld a, [de]
	and a
	jr nz, .SkipName
	call .PlaceTilesName
	jr .PlaceBadge

.SkipName
	ld a, [wBadgeNameTile]
	inc a
	ld [wBadgeNameTile], a
	inc hl

.PlaceBadge
	ld de, SCREEN_WIDTH - 1
	add hl, de
	ld a, [wBadgeOrFaceTiles]
	call .PlaceTiles
	add hl, de
	call .PlaceTiles

; Shift badge array back one byte.
	push bc
	ld hl, wBadgeOrFaceTiles + 1
	ld de, wBadgeOrFaceTiles
	ld bc, NUM_BADGES
	call CopyData
	pop bc

	pop hl
	ld de, 4
	add hl, de

	pop de
	inc de
	dec c
	jr nz, .DrawBadge
	ret

.PlaceTilesName	;joenote - restoring leader names
	push bc
	push hl
	
	;get the correct tile list for the current leader
	ld hl, LeaderNameList
	ld bc, $0000
	ld a, [wBadgeNameTile]
	ld c, a
	inc a	;increment the badge number while we're at it
	ld [wBadgeNameTile], a
	add hl, bc
	add hl, bc
	ld a, [hli]
	push af
	ld a, [hl]
	ld b, a
	pop af
	ld c, a
	
	;BC now points to leader name tile list
	;so let's push & pop HL real quick for printing to the screen
	pop hl
	push hl
.nameloop
	ld a, [bc]
	and a
	jr z, .nameloop_end
	ld [hli], a
	inc bc
	jr .nameloop
.nameloop_end
	
	pop hl
	pop bc
	inc hl
	ret

.PlaceTiles
	ld [hli], a
	inc a
	ld [hl], a
	inc a
	ret

.FaceBadgeTiles
	db $20, $28, $30, $38, $40, $48, $50, $58

LeaderNameList:	;joenote - for restoring leader names
	dw .brock
	dw .misty
	dw .surge
	dw .erika
	dw .koga
	dw .sabrina
	dw .blaine
	dw .giovanni
.brock
	db $60,$61,$62,$00
.misty
	db $63,$64,$65,$00
.surge
	db $66,$67,$68,$00
.erika
	db $69,$6A,$00
.koga
	db $6B,$6C,$00
.sabrina
	db $6D,$6E,$6F,$00
.blaine
	db $70,$71,$72,$00
.giovanni
	db $73,$74,$00

GymLeaderFaceAndBadgeTileGraphics:
IF GEN_2_GRAPHICS
	INCBIN "gfx/gs/badges.2bpp"
ELSE
	INCBIN "gfx/trainer_card/badges.2bpp"
ENDC
