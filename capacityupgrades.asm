;================================================================================
; Capacity Logic
;================================================================================
!MAGIC_UPGRADES = "$7EF37B"
IncrementMagic: 
	; Only continue magic refill if we can actually use magic
	LDA $7EF373	: BNE +
		RTL
	+
	LDA.l Futuro : BNE +
		LDA.b #$01 : RTL
	+
	LDA !MAGIC_UPGRADES : BEQ +
		RTL
	+
	LDA.b #$00 : STA $7EF36E : STA $7EF373
RTL
;--------------------------------------------------------------------------------
BossMagicRefill:
	; Only continue magic refill if we can actually use magic
	LDA.l Futuro : BEQ .canUseMagic
		LDA !MAGIC_UPGRADES : BNE .canUseMagic
			LDA.b #$80
			RTL
	.canUseMagic
	LDA $7EF36E
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