;================================================================================
; RNG Fixes
;--------------------------------------------------------------------------------
RigDigRNG:
	LDA $7FFE01 : CMP.l DiggingGameRNG : !BGE .forceHeart
	.normalItem
	JSL $0DBA71 ; GetRandomInt
RTL
	.forceHeart
	LDA $7FFE00 : BNE .normalItem
	LDA #$04
RTL
;--------------------------------------------------------------------------------
RigChestRNG:
	JSL.l DecrementChestCounter
	LDA $04C4 : CMP.l ChestGameRNG : BEQ .forceHeart
	.normalItem
	JSL $0DBA71 ; GetRandomInt
	AND.b #$07 ; restrict values to 0-7
	CMP #$07 : BEQ .notHeart
	JSL.l DecrementItemCounter
RTL
	.forceHeart
	LDA $0403 : AND.b #$40 : BNE .notHeart
	LDA #$07 ; give prize item
RTL
	.notHeart
	JSL.l DecrementItemCounter
	;LDA #$00 ; bullshit rupee farming in chest game
	
	JSL $0DBA71 ; GetRandomInt ; spam RNG until we stop getting the prize item
	AND.b #$07 ; restrict values to 0-7
	CMP #$07 : BNE + ; player got prize item AGAIN
		LDA.b #$00 ; give them money instead
	+
RTL
;--------------------------------------------------------------------------------
RNG_Lanmolas1:
	LDA.b #$00 : BRA _rng_done
RNG_Moldorm1:
	LDA.b #$01 : BRA _rng_done
RNG_Agahnim1:
	LDA.b #$02 : BRA _rng_done
RNG_Helmasaur:
	LDA.b #$03 : BRA _rng_done
RNG_Arrghus:
	LDA.b #$04 : BRA _rng_done
RNG_Mothula:
	LDA.b #$05 : BRA _rng_done
RNG_Kholdstare:
	LDA.b #$06 : BRA _rng_done
RNG_Vitreous:
	LDA.b #$07 : BRA _rng_done
RNG_Trinexx:
	LDA.b #$08 : BRA _rng_done
RNG_Lanmolas2:
	LDA.b #$09 : BRA _rng_done
RNG_Moldorm2:
	LDA.b #$0A : BRA _rng_done
RNG_Agahnim2:
	LDA.b #$0B : BRA _rng_done
RNG_Agahnim2Phantoms:
	LDA.b #$0C : BRA _rng_done
RNG_Ganon:
	LDA.b #$0D
	_rng_done:
	JSL.l GetStaticRNG
RTL
;--------------------------------------------------------------------------------
; In: A = RNG Index
; Out: A = RNG Result
;--------------------------------------------------------------------------------
!RNG_POINTERS = "$7F5200"
GetStaticRNG:
	PHX : PHP
	REP #$20 ; set 16-bit accumulator and index registers
	AND.w #$007F
	ASL : TAX : LDA !RNG_POINTERS, X : INC : STA !RNG_POINTERS, X : TAX : ASL ; increment pointer and move value to X
	LDA Static_RNG, X ; load RNG value
	PLP : PLX
RTL
;--------------------------------------------------------------------------------
InitRNGPointerTable:
	PHX : PHP
	REP #$30 ; set 16-bit accumulator & index registers
	LDX.w #$0000
	-
		LDA .rngDefaults, X : STA !RNG_POINTERS, X : INX #2
		LDA .rngDefaults, X : STA !RNG_POINTERS, X : INX #2
		LDA .rngDefaults, X : STA !RNG_POINTERS, X : INX #2
		LDA .rngDefaults, X : STA !RNG_POINTERS, X : INX #2
	CPX.w #$007F : !BLT -
	PLP : PLX
RTL
.rngDefaults
dw #$0000 ; 00 = Lanmolas 1
dw #$0040 ; 01 = Moldorm 1
dw #$0080 ; 02 = Agahnim 1
dw #$00C0 ; 03 = Helmasaur
dw #$0100 ; 04 = Arrghus
dw #$0140 ; 05 = Mothula
dw #$0180 ; 06 = Kholdstare
dw #$01C0 ; 07 = Vitreous
dw #$0200 ; 08 = Trinexx
dw #$0240 ; 09 = Lanmolas 2
dw #$0280 ; 10 = Moldorm 2
dw #$02C0 ; 11 = Agahnim 2
dw #$0300 ; 12 = Agahnim 2 Phantoms
dw #$0340 ; 13 = Ganon
dw #$0380 ; 14 = Unused
dw #$03C0 ; 15 = Unused
;--------------------------------------------------------------------------------