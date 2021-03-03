;================================================================================
; Capacity Logic
!MAGIC_UPGRADES = "$7EF37B"
;================================================================================
IncrementMagic: 
	; Only continue magic refill if we can actually use magic (variable != 0)
	LDA $7EF373 : BEQ +
		LDA !MAGIC_UPGRADES : !ADD.b FuturoMagic : BNE +
		LDA.b #$00 : STA $7EF36E : STA $7EF373 : BEQ +
	+
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