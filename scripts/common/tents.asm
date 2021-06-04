


	processor f8


	org	$800

	db	$55	;	// cartridge id
	db	$2b	;	// unknown

		
RAM_X	= $2800

		include "scripts/macros.asm"

CreateGrid:


	;// start at grid size 3
	dci RAM.GridSize
	li StartGridSize
	st

	dci RAM.GridSizeNeg
	li StartGridSizeNeg
	st

	dci RAM.Level
	li 1
	st
	ai 255
	st
	inc 
	st


	dci sfx.ghostEat
	pi playSong

	;// Title Screen
	dci	gfx.bitmap.bmp.parameters	; address of parameters
	pi	blitGraphic


	pi WaitForInput

	dci sfx.move
	pi playSong

	;// Seed our 'random' list
	lr A, 0
	dci RAM.Seed
	st

PlayAgain:

	li	%11000000	;// 3-colour, green background
	lr	3, A		;// store A to R3
	pi 	clrscrn 	;// call BIOS clear screen

RedoLevel:

	Load_Ram RAM.Level
	ai 255

	ci 20
	bp NotGrid8

	li 8
	Store_Ram RAM.GridSize

	li 248
	Store_Ram RAM.GridSizeNeg

	jmp SetStartScore

NotGrid8:

	dci Levels
	lr 0, a
	adc
	lm

	Store_Ram RAM.GridSize

	lr a, 0
	dci Levels2
	adc
	lm

	Store_Ram RAM.GridSizeNeg

SetStartScore:

;// set score to 99
	dci RAM.ScoreThisRound
	li MaxScorePerRound
	st

	;// set current row and column to 0
	dci RAM.CurrentRow
	clr
	st
	st

	Store_Ram RAM.ScoreCounter

	
	;//pi 	clrscrn 



CreateTheLevel:

	;// start at 0
	clr
	Save_Scratch X_Reg
	Save_Scratch Y_Reg

	;// reset selection box data
	dci RAM.SelectedCell
	clr
	st
	st
	st
	
	li GridStartX
	ai 255
	Store_Ram RAM.PointerPositionX
	Store_Ram RAM.PreviousPointerX

	li GridStartY
	ai 255
	Store_Ram RAM.PointerPositionY
	Store_Ram RAM.PreviousPointerY

	;// get address of start of grid data
	dci RAM.Grid

ClearLoop:
		
		;// set DC0 address to zero
		clr
		st

		;// get X and increment
		Load_Scratch X_Reg
		inc
		Save_Scratch X_Reg

		;// check if 64 yet
		ci 88
		bz Create

		jmp ClearLoop


Create:	
		clr
		Save_Scratch Y_Reg
		Store_Ram RAM.LevelValid



CreateLoop:
		
		;// load acc from Y_Reg
		lr A, S

		;// load grid start address, add index
		dci RAM.Grid
		adc

		lm
		ci 0
		bz IsBlank

		jmp NextCell


IsBlank:
		
		GetRandom
		ci ChanceOfATree
		bnc PlaceTree

		jmp NextCell

	
PlaceTree:
	
		;// Store Attempts in R1
		clr
		Store_R R1_ATTEMPTS

FindTentPos:

		Load_R R1_ATTEMPTS
		ci MaxAttempts
		bnz OkayError

		jmp NextCell

OkayError:
		
		Inc_R R1_ATTEMPTS

		GetRandom
		ni %00000011
		bnz NotLeft

		jmp TryLeft

NotLeft:		

		ci 1
	 	bnz NotRight

		jmp TryRight

NotRight:

		ci 2
		bnz TryDown

		jmp TryUp

TryDown:
		
		;// check dow

		Load_Ram RAM.CurrentRow
		inc
		Store_Ram RAM.TargetRow
		
		Load_Ram RAM.GridSize
		dci RAM.TargetRow
		cm

		bz FindTentPos


		;// Get cell ID below
		Load_Scratch Y_Reg
		Store_Ram RAM.CurrentID

		Load_Ram RAM.GridSize
		dci RAM.CurrentID
		am
		Store_Ram RAM.CurrentID

		;// use index to access grid, check if 0
		GetFromArray_A RAM.Grid
		
		ci BLANK_CELL
		bnz FindTentPos


		;// save new Cell ID
		Load_Ram RAM.CurrentID
		dci RAM.Grid
		adc

		li WILL_BE_TENT
		st

		;// Get Target Row ID
		Load_Ram RAM.TargetRow
		
		;// Increase tent in row count
		Increment_Indexed_Ram RAM.RowCounts

		;// Get Current Column ID
		Load_Ram RAM.CurrentColumn
		
		;// Increase tent in column count
		Increment_Indexed_Ram RAM.ColumnCounts

		jmp Confirm



TryUp:	

		;// $08F5
		;// check not row 0
		Load_Ram RAM.CurrentRow
		ci 0
		bnz Skip1

		jmp FindTentPos

Skip1:
	
		;// subtract 1
		ai 255
		Store_Ram RAM.TargetRow
		

		;// Get cell ID below
		Load_Scratch Y_Reg
		Store_Ram RAM.CurrentID

		Load_Ram RAM.GridSizeNeg
		dci RAM.CurrentID
		am
		Store_Ram RAM.CurrentID

		;// use index to access grid, check if 0
		GetFromArray_A RAM.Grid
		
		ci BLANK_CELL
		bz PlaceTentAbove

		jmp FindTentPos

PlaceTentAbove:
	
		;// save new Cell ID
		Load_Ram RAM.CurrentID
		dci RAM.Grid
		adc

		li WILL_BE_TENT
		st

		;// Get Target Row ID
		Load_Ram RAM.TargetRow
		
		;// Increase tent in row count
		Increment_Indexed_Ram RAM.RowCounts

		;// Get Current Column ID
		Load_Ram RAM.CurrentColumn
		
		;// Increase tent in column count
		Increment_Indexed_Ram RAM.ColumnCounts

		jmp Confirm


TryRight:

		Load_Ram RAM.CurrentColumn
		inc
		Store_Ram RAM.TargetColumn
		
		Load_Ram RAM.GridSize
		dci RAM.TargetColumn
		cm

		bnz NotFarRight

		jmp FindTentPos

NotFarRight:


		;// Get cell ID below
		Load_Scratch Y_Reg
		inc
		Store_Ram RAM.CurrentID

		;// use index to access grid, check if 0
		GetFromArray_A RAM.Grid
		
		ci BLANK_CELL
		bz PlaceTentRight

		jmp FindTentPos

PlaceTentRight:

		;// save new Cell ID
		Load_Ram RAM.CurrentID
		dci RAM.Grid
		adc

		li WILL_BE_TENT
		st

		;// Get Target Row ID
		Load_Ram RAM.CurrentRow
		
		;// Increase tent in row count
		Increment_Indexed_Ram RAM.RowCounts

		;// Get Current Column ID
		Load_Ram RAM.TargetColumn
		
		;// Increase tent in column count
		Increment_Indexed_Ram RAM.ColumnCounts

		jmp Confirm

TryLeft:

	;// $08F5
		;// check not row 0
		Load_Ram RAM.CurrentColumn
		ci 0
		bnz NotFarLeft

		jmp FindTentPos

NotFarLeft:
	
		;// subtract 1
		ai 255
		Store_Ram RAM.TargetColumn
		

		;// Get cell ID below
		Load_Scratch Y_Reg
		ai 255
		Store_Ram RAM.CurrentID

		;// use index to access grid, check if 0
		GetFromArray_A RAM.Grid
		
		ci BLANK_CELL
		bz PlaceTentLeft

		jmp FindTentPos

PlaceTentLeft:
	
		;// save new Cell ID
		Load_Ram RAM.CurrentID
		dci RAM.Grid
		adc

		li WILL_BE_TENT
		st

		;// Get Target Row ID
		Load_Ram RAM.CurrentRow
		
		;// Increase tent in row count
		Increment_Indexed_Ram RAM.RowCounts

		;// Get Current Column ID
		Load_Ram RAM.TargetColumn
		
		;// Increase tent in column count
		Increment_Indexed_Ram RAM.ColumnCounts

		jmp Confirm


Confirm:

		Inc_Ram RAM.LevelValid

		Load_Scratch Y_Reg
		dci RAM.Grid
		adc
		li TREE
		st



NextCell:
			
		
			;// Check if final column of row

			Inc_Ram RAM.CurrentColumn

			dci RAM.GridSize
			cm
			bnz Okay

			;// next row, reset column to 0
			Reset_Ram RAM.CurrentColumn
			
			;// check if final row of grid
			Inc_Ram RAM.CurrentRow

			dci RAM.GridSize
			cm
			bnz Okay

			jmp DisplayScore


Okay:
				

			;// Y = Y + 1

			Inc_Scratch Y_Reg	
			jmp CreateLoop

DisplayScore:

	clr
	Save_Scratch X_Reg


	li 70
	Store_Ram RAM.X

	li 0
	Store_Ram RAM.Y
	lr 0, a

LineLoop:

	li Red
	lr 1, a

	Load_Ram RAM.X
	lr 2, a

	Load_Ram RAM.Y
	lr 3, a

	pi plot

	lr a, 0
	inc
	ci 58
	bz DoneLine

	lr 0, a
	Inc_Ram RAM.Y
	jmp LineLoop

DoneLine:

	li 74
	Store_Ram RAM.X

ScoreLoop:

	;// Number
		
	lr A, S
	GetFromArray_A RAM.Score
	ai 4
	lr 5, a

	li Green
	lr 1, a	

	li Blue
	lr 2, a

	li 25
	lr 4, a

	Load_Ram RAM.X
	lr 3, a

	pi DrawTile

	;// Char

	lr A, S
	ai 15
	lr 5, a

	li Red
	lr 2, a

	li Transparent
	lr 1, a

	li 13
	lr 4, a


	Load_Ram RAM.X
	lr 3, a

	pi DrawTile


	Load_Ram RAM.X
	ai 5
	Store_Ram RAM.X

	Inc_Scratch X_Reg
	ci 5
	bz ScoreDone

	jmp ScoreLoop

ScoreDone:

	li Green
	lr 1, a

	li Red
	lr 2, a

	li 40
	lr 4, a

	Load_Ram RAM.LevelTens
	ai 4
	lr 5, a

	li LevelX
	lr 3, a

	pi DrawTile


	li Transparent
	lr 1, a

	li Blue
	lr 2, a

	li 33
	lr 4, a

	li 20
	lr 5, a

	li LevelX
	lr 3, a

	pi DrawTile


	li Transparent
	lr 1, a

	li Blue
	lr 2, a

	li 33
	lr 4, a

	li 21
	lr 5, a

	li LevelX
	ai 5
	lr 3, a

	pi DrawTile





	li Green
	lr 1, a

	li Red
	lr 2, a

	li 40
	lr 4, a

	Load_Ram RAM.LevelDigits
	ai 4
	lr 5, a

	li LevelX
	ai 5
	lr 3, a

	pi DrawTile



DrawGrid:

	Load_Ram RAM.LevelValid
	ci 0
	bnz LevelOkay

	jmp RedoLevel


LevelOkay:
	
	;// Start screen position top left
	li GridStartX
	Store_Ram RAM.X

	li GridStartY
	Store_Ram RAM.Y

	clr
	Store_Ram RAM.CurrentColumn
	Store_Ram RAM.CurrentRow
	Store_Ram RAM.LevelNotComplete
	Save_Scratch Y_Reg

	Clear16Bytes RAM.YourRowCounts


GridLoop:

	lr A, S

	;// Check if a dummy solution tent
	GetFromArray_A RAM.Grid
	lr R5_CharID, A
	ci WILL_BE_TENT
	bnz NotTempTent

	;// Set temp tent to zero
	lr A, S
	dci RAM.Grid
	adc
	clr
	st
	lr R5_CharID, A

	jmp NotTent

NotTempTent:

	ci TENT
	bnz NotTent

	;// Is a placed tent
	Load_Ram RAM.CurrentRow
	Increment_Indexed_Ram RAM.YourRowCounts
	Load_Ram RAM.CurrentColumn
	Increment_Indexed_Ram RAM.YourColumnCounts


NotTent:

	lr A, R5_CharID
	ci 0
	bz EndLoop2

	dci Colours
	adc
	lm
	lr 2, A

	li Transparent
	lr 1, A

	Load_Ram RAM.X
	lr R3_XPos, A

	Load_Ram RAM.Y
	lr R4_YPos, A

	pi	DrawTile


EndLoop2:


	;// add 6 to X
	dci RAM.X
	lr q, dc
	lm
	ai GridCellSize
	lr dc, q
	st

	Inc_Ram RAM.CurrentColumn
	dci RAM.GridSize
	cm
	bnz NoWrap

	;// next row, reset column to 0
	Reset_Ram RAM.CurrentColumn
	
	li GridStartX
	Store_Ram RAM.X
	
	;// check if final row of grid
	

	;// add 6 to Y
	dci RAM.Y
	lr q, dc
	lm
	ai GridCellSize
	lr dc, q
	st

	Inc_Ram RAM.CurrentRow
	dci RAM.GridSize
	cm
	bz DrawEdges


NoWrap:
		

	;// Y = Y + 1

	Inc_Scratch Y_Reg	
	jmp GridLoop



DrawEdges:
	
	li EdgeX
	Store_Ram RAM.X

	li GridStartY
	Store_Ram RAM.Y

	clr
	Store_Ram RAM.LevelNotComplete
	Save_Scratch Y_Reg

EdgeLoop:
	
	lr A, S

	GetFromArray_A RAM.RowCounts
	Store_Ram RAM.CurrentRow

	ai 4
	lr R5_CharID, A

	lr A, S
	GetFromArray_A RAM.YourRowCounts
	dci RAM.CurrentRow
	cm
	bnz Match

	li Green
	lr 2, a

	jmp SkipColour

Match:
	
	Inc_Ram RAM.LevelNotComplete

	li Blue
	lr 2, A

SkipColour:

	li Transparent
	lr 1, A

	Load_Ram RAM.X
	lr R3_XPos, A

	Load_Ram RAM.Y
	lr R4_YPos, A

	pi DrawTile
	
	;// add 6 to Y
	dci RAM.Y
	lr q, dc
	lm
	ai GridCellSize
	lr dc, q
	st

	Inc_Scratch Y_Reg
	dci RAM.GridSize
	cm
	bz TopEdge

	jmp EdgeLoop


TopEdge:


	li GridStartX
	Store_Ram RAM.X

	li EdgeTopY
	Store_Ram RAM.Y

	clr
	Save_Scratch Y_Reg

TopLoop:

	lr A, S

	GetFromArray_A RAM.ColumnCounts
	Store_Ram RAM.CurrentColumn

	lr A, S
	GetFromArray_A RAM.ColumnCounts
	ai 4
	lr R5_CharID, A

	lr A, S
	GetFromArray_A RAM.YourColumnCounts
	dci RAM.CurrentColumn
	cm
	bnz Match2

	li Green
	lr 2, a

	jmp SkipColour2

Match2:
	
	Inc_Ram RAM.LevelNotComplete

	li Red
	lr 2, A

SkipColour2:

	li Transparent
	lr 1, A

	Load_Ram RAM.X
	lr R3_XPos, A

	Load_Ram RAM.Y
	lr R4_YPos, A

	pi DrawTile
	
	;// add 6 to Y
	dci RAM.X
	lr q, dc
	lm
	ai GridCellSize
	lr dc,q
	st

	Inc_Scratch Y_Reg
	dci RAM.GridSize
	cm
	bz Done

	jmp TopLoop


Done:

	Load_Ram RAM.LevelNotComplete
	ci 0
	bnz NoNoise

LevelComplete:
	
	Load_Ram RAM.ScoreThisRound
	lr 0, a

	pi Scoring

	dci sfx.extraPacman
	pi playSong

	Inc_Ram RAM.Level

	Inc_Ram RAM.LevelDigits
	ci 10
	bnz NoLevelWrap

	Reset_Ram RAM.LevelDigits
	Inc_Ram RAM.LevelTens


NoLevelWrap:

	jmp PlayAgain


Moved:


ClearSelection:
	
	dci sfx.move
	pi playSong

NoNoise:

	

	Load_Ram RAM.PreviousPointerX
	lr 2, A

	Load_Ram RAM.PreviousPointerY
	lr 3, A

	li Transparent
	lr 1, A

	pi plot

	Load_Ram RAM.PreviousPointerX
	ai GridCellSize
	lr 2, A

	Load_Ram RAM.PreviousPointerY
	lr 3, A

	pi plot

	Load_Ram RAM.PreviousPointerX
	ai GridCellSize
	lr 2, A

	Load_Ram RAM.PreviousPointerY
	ai GridCellSize
	lr 3, A

	pi plot

	Load_Ram RAM.PreviousPointerX
	lr 2, A

	Load_Ram RAM.PreviousPointerY
	ai GridCellSize
	lr 3, A

	pi plot


DrawSelection:
		
	Load_Ram RAM.PointerPositionX
	Store_Ram RAM.PreviousPointerX
	lr 2, A

	Load_Ram RAM.PointerPositionY
	Store_Ram RAM.PreviousPointerY
	lr 3, A

	li Blue
	lr 1, A

	pi plot

	Load_Ram RAM.PointerPositionX
	ai GridCellSize
	lr 2, A

	Load_Ram RAM.PointerPositionY
	lr 3, A

	pi plot

	Load_Ram RAM.PointerPositionX
	ai GridCellSize
	lr 2, A

	Load_Ram RAM.PointerPositionY
	ai GridCellSize
	lr 3, A

	pi plot

	Load_Ram RAM.PointerPositionX
	lr 2, A

	Load_Ram RAM.PointerPositionY
	ai GridCellSize
	lr 3, A

	pi plot


TryAgain:
	
	pi WaitForInput
	lr 0, a
	
	ni %00000001
	bnz MoveRight

	lr a, 0
	ni %00000010

	bnz MoveLeft

	lr a, 0
	ni %00000100

	bnz MoveDown

	lr a, 0
	ni %00001000

	bz NotUp

	jmp MoveUp

NotUp:

	lr a, 0
	ni %10000000

	bz TryAgain

	jmp Fire

MoveRight:
	
	Load_Ram RAM.SelectedColumn
	inc
	Store_Ram RAM.CurrentColumn

	Load_Ram RAM.GridSize
	dci RAM.CurrentColumn
	cm
	bz AlreadyRight

	Inc_Ram RAM.SelectedColumn
	Inc_Ram RAM.SelectedCell

	Load_Ram RAM.PointerPositionX
	ai GridCellSize
	Store_Ram RAM.PointerPositionX

	jmp ClearSelection


AlreadyRight:

	jmp TryAgain

MoveLeft:
	
	Load_Ram RAM.SelectedColumn
	ci 0
	bz TryAgain

	ai 255
	Store_Ram RAM.SelectedColumn

	Load_Ram RAM.SelectedCell
	ai 255
	Store_Ram RAM.SelectedCell

	Load_Ram RAM.PointerPositionX
	ai GridCellSizeNeg
	Store_Ram RAM.PointerPositionX

	jmp ClearSelection


MoveDown:

	Load_Ram RAM.SelectedRow
	inc
	Store_Ram RAM.CurrentRow

	Load_Ram RAM.GridSize
	dci RAM.CurrentRow
	cm
	bz AlreadyDown

	Inc_Ram RAM.SelectedRow

	Load_Ram RAM.SelectedCell
	dci RAM.GridSize
	am
	Store_Ram RAM.SelectedCell

	Load_Ram RAM.PointerPositionY
	ai GridCellSize
	Store_Ram RAM.PointerPositionY

	jmp ClearSelection

AlreadyDown:
	
	jmp TryAgain


MoveUp:

	Load_Ram RAM.SelectedRow
	ci 0
	bnz CanMoveUp

	jmp TryAgain

CanMoveUp:
	
	ai 255
	Store_Ram RAM.SelectedRow

	Load_Ram RAM.SelectedCell
	dci RAM.GridSizeNeg
	am
	Store_Ram RAM.SelectedCell

	Load_Ram RAM.PointerPositionY
	ai GridCellSizeNeg
	Store_Ram RAM.PointerPositionY

	jmp ClearSelection


Fire:

	li 250
	lr 0, a
Debounce: 
	ds 0
	bnz Debounce

	
	Load_Ram RAM.SelectedCell
	dci RAM.Grid
	adc
	lr h, dc0
	lm	

	ci BLANK_CELL
	bz DrawTent

	ci TENT
	bz DeleteTentJmp

	jmp TryAgain

DeleteTentJmp:

	jmp DeleteTent

DrawTent: 
	
	;//Check next to tree

CheckTreeRight:

	Load_Ram RAM.SelectedColumn
	inc
	dci RAM.GridSize
	cm 
	bz CheckTreeLeft

	;//Check tree to right

	Load_Ram RAM.SelectedCell
	inc
	dci RAM.Grid
	adc
	lm
	ci TREE
	bnz CheckTreeLeft

	jmp CanPlaceTent

CheckTreeLeft:

	Load_Ram RAM.SelectedColumn
	ci 0
	bz CheckTreeDown
	Load_Ram RAM.SelectedCell
	ai 255
	dci RAM.Grid
	adc
	lm
	ci TREE
	bnz CheckTreeDown

	jmp CanPlaceTent

CheckTreeDown:

	Load_Ram RAM.SelectedRow
	inc
	dci RAM.GridSize
	cm 
	bz CheckTreeUp

	;//Check tree down

	Load_Ram RAM.SelectedCell
	dci RAM.GridSize
	am
	dci RAM.Grid
	adc
	lm
	ci TREE
	bnz CheckTreeUp

	jmp CanPlaceTent

CheckTreeUp:

	Load_Ram RAM.SelectedRow
	ci 0
	bz CantPlaceTent

	Load_Ram RAM.SelectedCell
	dci RAM.GridSizeNeg
	am
	dci RAM.Grid
	adc
	lm
	ci TREE
	bnz CantPlaceTent

	jmp CanPlaceTent

CantPlaceTent:

	jmp TryAgain

CanPlaceTent:
	
	lr dc0, h
	li TENT
	st

	Load_Ram RAM.SelectedRow
	Increment_Indexed_Ram RAM.YourRowCounts

	Load_Ram RAM.SelectedColumn
	Increment_Indexed_Ram RAM.YourColumnCounts
	
		
	Load_Ram RAM.PointerPositionX
	inc
	lr 3, A

	Load_Ram RAM.PointerPositionY
	inc
	lr 4, A

	li TENT
	lr 5, A

	li Transparent
	lr 1, A

	li Red
	lr 2, A

	pi DrawTile

	dci sfx.place
	pi playSong

	jmp DrawEdges


DeleteTent:

	lr dc0, h
	li BLANK_CELL
	st

	Load_Ram RAM.SelectedRow
	Decrement_Indexed_Ram RAM.YourRowCounts

	Load_Ram RAM.SelectedColumn
	Decrement_Indexed_Ram RAM.YourColumnCounts
		
	Load_Ram RAM.PointerPositionX
	inc
	lr 3, A

	Load_Ram RAM.PointerPositionY
	inc
	lr 4, A

	li BLANK_CELL
	lr 5, A

	li Transparent
	lr 1, A

	li Red
	lr 2, A

	pi DrawTile

	dci sfx.delete
	pi playSong

	jmp DrawEdges


Scoring:

ScoringLoop:

	Inc_Ram RAM.ScoreDigits
	ci 10
	bnz EndScoreLoop

	Reset_Ram RAM.ScoreDigits
	Inc_Ram RAM.ScoreTens
	ci 10
	bnz EndScoreLoop

	Reset_Ram RAM.ScoreTens
	Inc_Ram RAM.ScoreHundreds
	ci 10
	bnz EndScoreLoop

	Reset_Ram RAM.ScoreHundreds
	Inc_Ram RAM.ScoreThousands
	ci 10
	bnz EndScoreLoop

	Reset_Ram RAM.ScoreThousands
	Inc_Ram RAM.Score

EndScoreLoop:

	lr a, 0
	ai 255
	bz DoneScoring
	ds 0
	jmp ScoringLoop

DoneScoring:

	pop






	;org $1600

	
	include "scripts/draw.asm"
	include "scripts/labels.asm"
	include "scripts/chars.asm"
	include "scripts/drawing.inc"
	include "scripts/ram.asm"
	include "scripts/input.asm"
	include "scripts/sound.asm"



RandomLookup:

  .byte 29,61,10,138,52,207,52,178,0
  .byte 168,192,236,42,44,36,42,224,37
  .byte 39,68,183,60,168,188,246,67,24,18
  .byte 159,56,24,238,172,103,212,17,24,170,202,50,118
  .byte 95,33,219,36,169,99,26,242,79,85,138,61,118,50
  .byte 210,128,110,61,53,44,70,183,212, 101,45,118,124
  .byte 5,34,212,173,193,83,57,153,200,102,68,40,157,118
  .byte 59,231,7,237,98,205,14,247,121,19,133,40,20,97,121,
  .byte 33,76,210,247,136,112,54,252,122,253,25,58,148,46,39,
   .byte 8,186,125,173,250,229,251,93,85,39,74,89,104,215
   .byte 180,173,126,245,197,53,139,110,160,38,242,78,116
   .byte 189,233,27,37,109,163,11,125,33,114,128,179,129,51,11,
   .byte 67,54,145,7,119,225,186,140,19,169,134,139,227,211
   .byte 74,254,76,7,206,218,17,224,186,186,137,198,85,103
   .byte 192,169,142,75,68,194,181,16,66,234,105,193,106,137
    .byte 86,93,70,244,152,75,22,119,108,154,79,250,239,9,203,191
    .byte 35,16,249,72,193,122,236,64,244,160,3,235,60,143
    .byte 8,58,208,155,53,97,206,193,232,183,28,179,121,21
    .byte 33,59,173,224,249,8,141,215,250,87,204,240,137,119
    .byte 143,182

Colours:	.byte Transparent, Green, Red, Red

Levels:	.byte 3, 4, 4, 5, 5, 5, 5, 6, 6, 6, 6, 6, 6, 7, 7, 7, 7, 7, 7, 7, 7
Levels2: .byte 253, 252, 252, 251, 251, 251, 251, 250, 250, 250, 250, 250, 250, 249, 249, 249, 249, 249, 249, 249, 249


	;//org $0fff                ;	// added only to set a useable rom-size in MESS
    ;//    .byte   $10


