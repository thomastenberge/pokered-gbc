TradeMons:
; entries correspond to TRADE_FOR_* constants
	table_width 3 + NAME_LENGTH, TradeMons
	; give mon, get mon, dialog id, nickname
	; The two instances of TRADE_DIALOGSET_EVOLUTION are a leftover
	; from the Japanese Blue trades, which used species that evolve.
	; Japanese Red and Green used TRADE_DIALOGSET_CASUAL, and had
	; the same species as English Red and Blue.
	db NIDORINO,   KADABRA,   TRADE_DIALOGSET_CASUAL,    "SNOOPS@@@@@"
	db ABRA,       MR_MIME,   TRADE_DIALOGSET_CASUAL,    "MARCEL@@@@@"
	db BUTTERFREE, BEEDRILL,  TRADE_DIALOGSET_HAPPY,     "CHIKUCHIKU@" ; unused
	db PONYTA,     SEEL,      TRADE_DIALOGSET_CASUAL,    "SAILOR@@@@@"
	db CUBONE,     MACHOKE,   TRADE_DIALOGSET_HAPPY,     "HUNKS@@@@@@"
	db SLOWPOKE,   HAUNTER,   TRADE_DIALOGSET_CASUAL,    "SPOOKS@@@@@"
	db POLIWHIRL,  JYNX,      TRADE_DIALOGSET_EVOLUTION, "LOLA@@@@@@@"
	db RAICHU,     LICKITUNG, TRADE_DIALOGSET_EVOLUTION, "MARC@@@@@@@"
	db VENONAT,    FARFETCHD, TRADE_DIALOGSET_HAPPY,     "DUX@@@@@@@@"
	db NIDORINA,   GRAVELER,  TRADE_DIALOGSET_HAPPY,     "ROCROL@@@@@"
	assert_table_length NUM_NPC_TRADES
