	processor f8


	org	$800

	db	$55	;	// cartridge id
	db	$2b	;	// unknown


	include "scripts/common/macros.asm"

Entry:
		
	;jmp TitleSelect

	dci sfx.prizeEat
	pi playSong

	dci RAM.High
	st
	st
	st
	st
	st
	st
	st

PlayAgain:

	li	0	;// 3-colour, green background
	lr	3, A		;// store A to R3
	pi 	clrscrn 	;// call BIOS clear screen

	dci sfx.ghostEat
	pi playSong

	;// Title Screen
	dci	gfx.cent.bmp.parameters	; address of parameters
	pi	blitGraphic


TitleSelect:

	pi WaitForInput

ReadyToPlay:

	lr A, 0
	dci RAM.Seed
	st
	
	dci sfx.move
	;pi playSong

	;// Seed our 'random' list

	li	$d6	;// 3-colour, green background
	lr	3, A		;// store A to R3
	pi 	clrscrn 	;// call BIOS clear screen

InitialiseVariables:

	li SHIP_START_X
	Store_Ram RAM.ShipX

	li SHIP_START_Y
	Store_Ram RAM.ShipY

	pi DrawShip

	li 255
	Store_Ram RAM.BulletX
	Store_Ram RAM.SpiderX
	Store_Ram RAM.FleaX
	Store_Ram RAM.ScorpionX

	li START_CENTS
	Store_Ram RAM.CentSpawners
	Store_Ram RAM.CentsAlive

	li 1
	Store_Ram RAM.SpawnReady
	Store_Ram RAM.DrawLives
	Store_Ram RAM.FleaSFX
	Store_Ram RAM.ScorpionSFX

	li START_LIVES
	Store_Ram RAM.Lives

	li START_HEADS
	Store_Ram RAM.HeadsInLevel
	Store_Ram RAM.HeadsLeft
	
	clr
	Store_Ram RAM.SpawnPod
	Store_RAM RAM.CentProcessID
	Store_Ram RAM.HeadDirection
	Store_Ram RAM.SpawnDelay
	Store_Ram RAM.Level
	Store_Ram RAM.FleaEnd
	Store_Ram RAM.ScorpionEnd
	Store_Ram RAM.PlayerPodCount
	Store_Ram RAM.ScoreToAdd
	st
	st
	st
	st
	st
	st
	Store_Ram RAM.SpiderSoundID
	Store_Ram RAM.Score
	st
	st
	st
	st
	st
	st
	st
	lr 0, a
	

ClearLoop:

	lr a, 0
	dci RAM.PodStatus
	adc
	clr
	st

	lr a, 0
	dci RAM.CentX
	adc
	clr
	st

	lr a, 0
	inc

	ci 250
	bz DoneClear

	lr 0, a
	jmp ClearLoop

DoneClear:
		
	dci RAM.CentX
	li 255
	st
	st
	st
	st
	st
	st
	st
	st
	st
	st
	st
	st
	
	Store_Ram RAM.BulletX
	Store_Ram RAM.SpiderX
	Store_Ram RAM.SpiderCooldown
	Store_Ram RAM.FleaX
	Store_Ram RAM.FleaPodID

	li 0
	dci RAM.CentPlunge
	st
	st
	st
	st
	st
	st
	st
	st
	st
	st
	st
	st

	li 1
	Store_Ram RAM.SpawnReady

	li FLEA_TIME
	Store_Ram RAM.FleaSpeed


ClearGrid:

	clr
	Save_Scratch Y_Reg
	
RowLoop:
	
	;//rowID
	sl 1

	dci RowLookup
	adc
	lm
	lr	Qu, A
	lm
	lr	Ql, A
	lr	DC, Q
	lr  h, dc

	clr
	Save_Scratch X_Reg

ColumnLoop:
	
	lr dc, h
	adc
	li 255
	st

	clr
	lr 5, a
	pi DrawCell

	Inc_Scratch X_Reg
	ci GRID_COLUMNS
	bnz ColumnLoop

	Inc_Scratch Y_Reg
	ci GRID_ROWS
	bnz RowLoop


OtherSetup:

	pi DrawShip

	clr
	Store_Ram RAM.X

TryAgain:
		
	li 73
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

	li Blue
	lr 1, a

	li 2
	lr 2, a

	Load_Ram RAM.Y
	lr 3, a

	pi plot

	li Green
	lr 1, a

	li 99
	lr 2, a

	Load_Ram RAM.Y
	lr 3, a

	pi plot

	lr a, 0
	inc
	inc
	ci 58
	bz DoneLine

	lr 0, a
	Inc_Ram RAM.Y
	Inc_Ram RAM.Y
	jmp LineLoop

DoneLine:
	

SCORE.Title:

	clr
	Store_Ram RAM.XReg

	li 74
	Store_Ram RAM.X

ScoreTitleLoop:

	;// Score Number
		
	Load_Ram RAM.XReg
	ai 10
	lr 5, a

	li Transparent
	lr 1, a	

	li Green
	lr 2, a

	li 23
	lr 4, a

	Load_Ram RAM.X
	lr 3, a

	pi DrawTile

	Load_Ram RAM.XReg
	ai 15
	lr 5, a

	li Transparent
	lr 1, a	

	li Green
	lr 2, a

	li 42
	lr 4, a

	Load_Ram RAM.X
	lr 3, a

	pi DrawTile


	Load_Ram RAM.X
	ai 4
	Store_Ram RAM.X

	Inc_Ram RAM.XReg
	ci 5
	bz ScoreTitleDone

	jmp ScoreTitleLoop

ScoreTitleDone:

	
	jmp POD.InitialPods

	
DrawCell:
	
	lr a, 5
	dci Colours
	adc
	lm
	lr 2, a

	lr a, 5
	dci Background
	adc
	lm 
	lr 1, a

	Load_Scratch X_Reg
	dci ColumnPosLookup
	adc
	lm
	lr 3, a
	
	Load_Scratch Y_Reg
	dci RowPosLookup
	adc
	lm
	lr 4, a

	jmp DrawChar


IncrementLevel:
	
	pi BULLET.Delete

	Load_Ram RAM.SpiderX
	ci 255
	bz NoDeleteSpider2

	pi SPIDER.DeleteLeft
	pi SPIDER.DeleteRight


NoDeleteSpider2:


	Load_Ram RAM.ScorpionX
	ci 255
	bz NoDeleteScorpion2


	pi SCORPION.DeleteLeft
	pi SCORPION.DeleteRight

NoDeleteScorpion2:
	
	Load_Ram RAM.FleaX
	ci 255
	bz NoDeleteFlea2

	pi FLEA.DeleteUnder

NoDeleteFlea2:

	Inc_Ram RAM.Level
	Reset_Ram RAM.CentProcessID

	Load_Ram RAM.HeadDirection
	ci 0
	bz HeadsIncrease

HeadDecrease:
	
	Dec_Ram RAM.HeadsInLevel
	ci 1
	bnz NoHeadReset

	Reset_Ram RAM.HeadDirection

	jmp NoHeadReset

HeadsIncrease:
	
	Inc_Ram RAM.HeadsInLevel
	ci START_CENTS + 1
	bnz NoHeadReset

	li 1
	Store_Ram RAM.HeadDirection
	Dec_Ram RAM.HeadsInLevel


NoHeadReset:

	Load_Ram RAM.HeadsInLevel
	Store_Ram RAM.HeadsLeft

	li START_CENTS
	Store_Ram RAM.CentSpawners
	Store_Ram RAM.CentsAlive

	clr
	dci RAM.CentX
	li 255
	st
	st
	st
	st
	st
	st
	st
	st
	st
	st
	st
	st
	Store_Ram RAM.BulletX
	Store_Ram RAM.SpiderX
	Store_Ram RAM.SpiderCooldown
	Store_Ram RAM.FleaX
	Store_Ram RAM.ScorpionX

	dci RAM.CentStatus
	li 0
	st
	st
	st
	st
	st
	st
	st
	st
	st
	st
	st
	st

	dci RAM.CentPlunge
	st
	st
	st
	st
	st
	st
	st
	st
	st
	st
	st
	st

	li 1
	Store_Ram RAM.SpawnReady
	Store_Ram RAM.DrawLives

	jmp FRAME.Loop





	;org $1000

	
	include "scripts/common/draw.asm"
	include "scripts/data/labels.asm"
	include "scripts/data/bitmaps.asm"
	include "scripts/data/chars.asm"
	include "scripts/common/drawing.inc"
	include "scripts/data/ram.asm"
	include "scripts/common/input.asm"
	include "scripts/common/sound.asm"
	include "scripts/game/bullet.asm"
	include "scripts/game/ship.asm"
	include "scripts/game/pod.asm"
	include "scripts/game/frame.asm"
	include "scripts/game/centipede.asm"
	include "scripts/game/score.asm"
	include "scripts/game/spider.asm"
	include "scripts/game/lives.asm"
	include "scripts/game/dead.asm"
	include "scripts/game/flea.asm"
	include "scripts/game/scorpion.asm"

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
    .byte 86,93,70,244,152,75,22,119,108,154,79,250,239,9,2083,191
    .byte 35,16,249,72,193,122,236,64,244,160,3,235,60,143
    .byte 8,58,208,155,53,97,206,193,232,183,28,179,121,21
    .byte 33,59,173,224,249,8,141,215,250,87,204,240,137
    .byte 143,182


RowLookup:
		
	.word RAM.Grid, RAM.Grid_Row1, RAM.Grid_Row2, RAM.Grid_Row3, RAM.Grid_Row4, RAM.Grid_Row5, RAM.Grid_Row6
	.word RAM.Grid_Row7, RAM.Grid_Row8, RAM.Grid_Row9, RAM.Grid_Row10, RAM.Grid_Row11, RAM.Grid_Row12, RAM.Grid_Row13
	.word RAM.Grid_Row14, RAM.Grid_Row15, RAM.Grid_Row16, RAM.Grid_Row17, RAM.Grid_Row18


RowPosLookup:	.byte 1, 4, 7, 10, 13, 16, 19, 22, 25, 28, 31, 34, 37, 40, 43, 46, 49, 52, 55, 57
ColumnPosLookup:	.byte 4, 7, 10, 13, 16, 19, 22, 25, 28, 31, 34, 37, 40, 43, 46, 49, 52, 55, 57, 60, 63, 66, 69, 72, 75, 78, 81, 84, 87, 90


PodRowMax:		.byte 0, 0, 0, 1, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 1, 1, 1, 0



SpiderStartY:		.byte GRID_ROWS - 1, GRID_ROWS - 1, GRID_ROWS - 6, GRID_ROWS - 6
SpiderStartX:		.byte 0, GRID_COLUMNS - 2, 0, GRID_COLUMNS - 2
SpiderDirection:	.byte 1, 0, 1, 0
SpiderSpeedX:		.byte 1, 255, 1, 255
SpiderSpeedY:		.byte 255, 255, 1, 1

SpiderScore:		.byte 9, 9, 6, 6, 3, 3, 3, 3

