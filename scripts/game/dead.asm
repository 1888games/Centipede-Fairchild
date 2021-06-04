

DEAD.Check:

	lr a, 4
	dci RAM.ShipX
	cm
	bnz NotDeadDave

	lr a, 5
	dci RAM.ShipY
	cm
	bnz NotDeadDave

	li 18
	Store_Ram RAM.DeathTimer

	jmp DeadLoop

NotDeadDave:

	pop



DeadLoop:
	
	Load_Ram RAM.DeathTimer
	ci 0
	bz PostDeath

	Dec_Ram RAM.DeathTimer

	GetRandom
	Store_Ram RAM.ShipDeadChar

	pi DrawShipDead

NoDrawShip:
	

	li 2
	Store_Ram RAM.DeathSFX

	li 0
	Store_Ram RAM.DeathSFX3

	GetRandom
	ni %00001111
	Store_Ram RAM.DeathSFX2

	dci RAM.DeathSFX
	pi playSong

	jmp DeadLoop



DrawShipDead:

	li SHIP_DEAD_CHAR
	lr 5, a

	Load_Ram RAM.ShipX
	Save_Scratch X_Reg

	Load_Ram RAM.ShipY
	Save_Scratch Y_Reg

	jmp DrawCell


PostDeath:

	Dec_Ram RAM.Lives
	ci 0
	bnz ContinueGame

	jmp GameOver

ContinueGame:
	
	jmp POD.Restore

DEAD.DoneRestore:
	
	pi BULLET.Delete

	Load_Ram RAM.SpiderX
	ci 255
	bz NoDeleteSpider

	pi SPIDER.DeleteLeft
	pi SPIDER.DeleteRight

	

NoDeleteSpider:


	Load_Ram RAM.ScorpionX
	ci 255
	bz NoDeleteScorpion


	pi SCORPION.DeleteLeft
	pi SCORPION.DeleteRight

NoDeleteScorpion:
	

	Load_Ram RAM.FleaX
	ci 255
	bz NoDeleteFlea

	pi FLEA.DeleteUnder

NoDeleteFlea:
	

	pi DeleteShip

	li SHIP_START_X
	Store_Ram RAM.ShipX

	li SHIP_START_Y
	Store_Ram RAM.ShipY

	jmp CENT.DestroyAll

DestroyedAllCents:

	jmp NoHeadReset


GameOver:
	
	
	pi CheckHighScore

DeleteLastLife:
	
	li 1
	lr 5, a

	li Transparent
	lr 1, a	

	li Blue
	lr 2, a

	li 75
	lr 4, a
	lr 3, a

	pi DrawChar

	dci sfx.gameOver
	pi playSong


	clr
	Store_Ram RAM.XReg

	li 74
	Store_Ram RAM.X

ScoreLoop3:

	;// Score Number
		
	Load_Ram RAM.XReg
	GetFromArray_A RAM.HighHundredThousands
	lr 5, a

	li Transparent
	lr 1, a	

	li Red
	lr 2, a

	li 48
	lr 4, a

	Load_Ram RAM.X
	lr 3, a

	pi DrawTile

	Load_Ram RAM.X
	ai 4
	Store_Ram RAM.X

	Inc_Ram RAM.XReg
	ci 6
	bz ScoreDone3

	jmp ScoreLoop3

ScoreDone3:

WaitLoop:
	
	inc
	nop
	nop
	bnz WaitLoop

	pi WaitForInput
	jmp PlayAgain



Reset: