;================================================================================
; Capacity Logic
!MAGIC_UPGRADES = "$7EF37B"
;================================================================================
IncrementMagic:
	; Refill magic if we can actually use magic
	LDA !MAGIC_UPGRADES : !ADD.b FuturoMagic : BNE .hasMagic
	LDA.b #$00 : STA $7EF36E : STA $7EF373
	RTL

	; Check if current magic power is full
	.hasMagic
	LDA $7EF36E : CMP.b #$80 : BCC .magicNotFull 	

	; If it is full, stop refilling 
	LDA.b #$80 : STA $7EF36E
	LDA.b #$00 : STA $7EF373
	RTL

	.magicNotFull
	LDA $7EF373 : DEC A : STA $7EF373
	LDA $7EF36E : INC A : STA $7EF36E
	LDA $1A : AND.b #$03 : BNE .doneWithMagicRefill ; if((frame_counter % 4) != 0) don't refill this frame
	LDA $012E : BNE .doneWithMagicRefill ; Is this sound channel in use?
	LDA.b #$2D : STA $012E; Play the magic refill sound effect

	.doneWithMagicRefill
RTL
;--------------------------------------------------------------------------------
!BOMB_UPGRADES = "$7EF370"
!BOMB_CURRENT = "$7EF343"
;--------------------------------------------------------------------------------
IncrementBombs:
    LDA !BOMB_UPGRADES : !ADD.l StartingMaxBombs : BEQ + ; skip if we can't have bombs
		DEC

		CMP !BOMB_CURRENT
		
		!BLT +
			LDA !BOMB_CURRENT
			CMP.b #99 : !BGE +
			INC : STA !BOMB_CURRENT
		+
	+
RTL
;--------------------------------------------------------------------------------
!ARROW_UPGRADES = "$7EF371"
!ARROW_CURRENT = "$7EF377"
;--------------------------------------------------------------------------------
IncrementArrows:
    LDA !ARROW_UPGRADES ; get arrow upgrades
	!ADD.l StartingMaxArrows : DEC

    CMP !ARROW_CURRENT
	
	!BLT +    
    	LDA !ARROW_CURRENT
		CMP.b #99 : !BGE +
		INC : STA !ARROW_CURRENT
	+
RTL
;--------------------------------------------------------------------------------
CompareBombsToMax:
    LDA !BOMB_UPGRADES ; get bomb upgrades
	!ADD.l StartingMaxBombs

    CMP !BOMB_CURRENT
RTL
;--------------------------------------------------------------------------------