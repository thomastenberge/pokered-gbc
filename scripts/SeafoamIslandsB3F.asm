SeafoamIslandsB3F_Script:
	call EnableAutoTextBoxDrawing
	ld hl, wFlags_0xcd60
	bit 7, [hl]
	res 7, [hl]
	jr z, .noBoulderWasPushed
	ld hl, Seafoam4HolesCoords
	call CheckBoulderCoords
	ret nc
	EventFlagAddress hl, EVENT_SEAFOAM4_BOULDER1_DOWN_HOLE
	ld a, [wCoordIndex]
	cp $1
	jr nz, .boulder2FellDownHole
	SetEventReuseHL EVENT_SEAFOAM4_BOULDER1_DOWN_HOLE
	ld a, HS_SEAFOAM_ISLANDS_B3F_BOULDER_1
	ld [wObjectToHide], a
	ld a, HS_SEAFOAM_ISLANDS_B4F_BOULDER_1
	ld [wObjectToShow], a
	jr .hideAndShowBoulderObjects
.boulder2FellDownHole
	SetEventAfterBranchReuseHL EVENT_SEAFOAM4_BOULDER2_DOWN_HOLE, EVENT_SEAFOAM4_BOULDER1_DOWN_HOLE
	ld a, HS_SEAFOAM_ISLANDS_B3F_BOULDER_2
	ld [wObjectToHide], a
	ld a, HS_SEAFOAM_ISLANDS_B4F_BOULDER_2
	ld [wObjectToShow], a
.hideAndShowBoulderObjects
	ld a, [wObjectToHide]
	ld [wMissableObjectIndex], a
	predef HideObject
	ld a, [wObjectToShow]
	ld [wMissableObjectIndex], a
	predef ShowObject
	jr .runCurrentMapScript
.noBoulderWasPushed
	ld a, SEAFOAM_ISLANDS_B4F
	ld [wDungeonWarpDestinationMap], a
	ld hl, Seafoam4HolesCoords
	call IsPlayerOnDungeonWarp
	ld a, [wd732]
	bit 4, a
	ret nz
.runCurrentMapScript
	ld hl, SeafoamIslandsB3F_ScriptPointers
	ld a, [wSeafoamIslandsB3FCurScript]
	jp CallFunctionInTable

Seafoam4HolesCoords:
	dbmapcoord  3, 16
	dbmapcoord  6, 16
	db -1 ; end

SeafoamIslandsB3F_ScriptPointers:
	def_script_pointers
	dw_const SeafoamIslandsB3FDefaultScript,       SCRIPT_SEAFOAMISLANDSB3F_DEFAULT
	dw_const SeafoamIslandsB3FObjectMoving1Script, SCRIPT_SEAFOAMISLANDSB3F_OBJECT_MOVING1
	dw_const SeafoamIslandsB3FMoveObjectScript,    SCRIPT_SEAFOAMISLANDSB3F_MOVE_OBJECT
	dw_const SeafoamIslandsB3FObjectMoving2Script, SCRIPT_SEAFOAMISLANDSB3F_OBJECT_MOVING2
	EXPORT SCRIPT_SEAFOAMISLANDSB3F_MOVE_OBJECT ; used by engine/overworld/player_state.asm

; wispnote - Added a check for the righ bank size which executes
; a different JoyPad sequence to simulate the current.
SeafoamIslandsB3FDefaultScript:
	CheckBothEventsSet EVENT_SEAFOAM3_BOULDER1_DOWN_HOLE, EVENT_SEAFOAM3_BOULDER2_DOWN_HOLE
	ret z
	ld a, [wYCoord]
	cp 8
	jr nz, .checkEntryFromRightBank
	ld a, [wXCoord]
	cp 15
	ret nz
	jp .isEntryFromLeftBank
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; wispnote - Right Bank Check
.checkEntryFromRightBank
	cp $a
	ret nz
	ld a, [wXCoord]
	cp $17
	ret nz
	ld de, RLEMovementRightBank
	jp .simJoyPadFromBanksSeafoamIslands4
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
.isEntryFromLeftBank
	ld de, RLEList_ForcedSurfingStrongCurrentNearSteps
.simJoyPadFromBanksSeafoamIslands4
	ld hl, wSimulatedJoypadStatesEnd	
	call DecodeRLEList
	dec a
	ld [wSimulatedJoypadStatesIndex], a
	call StartSimulatingJoypadStates
	ld hl, wFlags_D733
	set 2, [hl]
	ld a, SCRIPT_SEAFOAMISLANDSB3F_OBJECT_MOVING1
	ld [wSeafoamIslandsB3FCurScript], a
	ret

RLEList_ForcedSurfingStrongCurrentNearSteps:
	db D_DOWN, 6
	db D_RIGHT, 5
	db D_DOWN, 3
	db -1 ; end

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; wispnote - JoyPad Sequence for Entry from the Right Bank Side
RLEMovementRightBank:
	db D_DOWN,6
	db D_LEFT,2
	db D_DOWN,1
	db $ff
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

SeafoamIslandsB3FObjectMoving1Script:
	ld a, [wSimulatedJoypadStatesIndex]
	and a
	ret nz
	ld a, SCRIPT_SEAFOAMISLANDSB3F_DEFAULT
	ld [wSeafoamIslandsB3FCurScript], a
	ret

SeafoamIslandsB3FMoveObjectScript:
	CheckBothEventsSet EVENT_SEAFOAM3_BOULDER1_DOWN_HOLE, EVENT_SEAFOAM3_BOULDER2_DOWN_HOLE
	ret z
	ld a, [wXCoord]
	cp 18
	jr z, .playerFellThroughHoleLeft
	cp 19
	ld a, SCRIPT_SEAFOAMISLANDSB3F_DEFAULT
	jr nz, .playerNotInStrongCurrent
	ld de, .RLEList_StrongCurrentNearRightBoulder
	jr .forceSurfMovement
.playerFellThroughHoleLeft
	ld de, .RLEList_StrongCurrentNearLeftBoulder
.forceSurfMovement
	ld hl, wSimulatedJoypadStatesEnd
	call DecodeRLEList
	dec a
	ld [wSimulatedJoypadStatesIndex], a
	xor a
	ld [wSpritePlayerStateData2MovementByte1], a
	ld hl, wd730
	set 7, [hl]
	ld hl, wFlags_D733
	set 2, [hl]
	ld a, SCRIPT_SEAFOAMISLANDSB3F_OBJECT_MOVING2
.playerNotInStrongCurrent
	ld [wSeafoamIslandsB3FCurScript], a
	ret

; wispnote - Correct strong current's path after falling through 2nd boulder's hole.
.RLEList_StrongCurrentNearRightBoulder:
	db D_DOWN, 6
	db D_RIGHT, 1
	db D_DOWN, 4
	db -1 ; end

.RLEList_StrongCurrentNearLeftBoulder:
	db D_DOWN, 6
	db D_RIGHT, 2
	db D_DOWN, 4
	db -1 ; end

SeafoamIslandsB3FObjectMoving2Script:
	ld a, [wSimulatedJoypadStatesIndex]
	and a
	ret nz
	ld a, SCRIPT_SEAFOAMISLANDSB3F_DEFAULT
	ld [wSeafoamIslandsB3FCurScript], a
	ret

SeafoamIslandsB3F_TextPointers:
	def_text_pointers
	dw_const BoulderText, TEXT_SEAFOAMISLANDSB3F_BOULDER1
	dw_const BoulderText, TEXT_SEAFOAMISLANDSB3F_BOULDER2
	dw_const BoulderText, TEXT_SEAFOAMISLANDSB3F_BOULDER3
	dw_const BoulderText, TEXT_SEAFOAMISLANDSB3F_BOULDER4
	dw_const BoulderText, TEXT_SEAFOAMISLANDSB3F_BOULDER5
	dw_const BoulderText, TEXT_SEAFOAMISLANDSB3F_BOULDER6
