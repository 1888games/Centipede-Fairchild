

SCORPION.Move:
	
	Load_Ram RAM.ScorpionX
	ci 255
	bnz NoSound2

	Load_Ram RAM.FleaX
	ci 255
	bnz NoSound2

	Load_Ram RAM.ScorpionNote
	ai 5
	Store_Ram RAM.ScorpionNote

	dci RAM.ScorpionSFX
	pi playSong

NoSound2:

	pi SCORPION.DeleteLeft
	pi SCORPION.DeleteRight

	Load_Ram RAM.ScorpionY
	lr 1, a

	Load_Ram RAM.ScorpionX
	lr 0, a

	GetCellContents
	
	ci 255
	bz NoPodUnderScorpionLeft

	Store_Ram RAM.CurrentID

	dci RAM.PodStatus
	adc
	lr h, dc
	lm 
	ai 251
	bp PodAlreadyPoisonLeft2

	ai 9
	lr dc, h
	st

PodAlreadyPoisonLeft2:

	pi POD.Draw
	pi POD.DrawA

NoPodUnderScorpionLeft:

	Load_Ram RAM.ScorpionY
	lr 1, a

	Load_Ram RAM.ScorpionX
	inc
	lr 0, a

	GetCellContents
	
	ci 255
	bz NoPodUnderScorpionRight

	Store_Ram RAM.CurrentID

	dci RAM.PodStatus
	adc
	lr h, dc
	lm 
	ai 251
	bp PodAlreadyPoisonRight2

	ai 9
	lr dc, h
	st

PodAlreadyPoisonRight2:

	pi POD.Draw
	pi POD.DrawA

NoPodUnderScorpionRight:

	Load_Ram RAM.ScorpionDirection
	ci 255
	bz ScorpionGoingLeft


ScorpionGoingRight:

	Inc_Ram RAM.ScorpionX
	ci GRID_COLUMNS - 2
	bz ScorpionReachedEdge

	jmp ScorpionNotAtEdge

ScorpionGoingLeft:

	Dec_Ram RAM.ScorpionX
	ci 0
	bz ScorpionReachedEdge

	jmp ScorpionNotAtEdge

ScorpionReachedEdge:

	li 255
	Store_Ram RAM.ScorpionX
	Store_Ram RAM.ScorpionCooldown

	jmp FRAME.ScorpionDone

ScorpionNotAtEdge:
	
	pi SCORPION.DrawLeft
	pi SCORPION.DrawRight

	jmp FRAME.ScorpionDone


SCORPION.DrawLeft:

	li SCORPION_CHAR_LEFT
	lr 5, a

	Load_Ram RAM.ScorpionX
	Save_Scratch X_Reg

	Load_Ram RAM.ScorpionY
	Save_Scratch Y_Reg


	jmp DrawCell


SCORPION.DrawRight:

	li SCORPION_CHAR_RIGHT
	lr 5, a

	Inc_Scratch X_Reg

	jmp DrawCell


SCORPION.DeleteLeft:

	li 0
	lr 5, a

	Load_Ram RAM.ScorpionX
	Save_Scratch X_Reg

	Load_Ram RAM.ScorpionY
	Save_Scratch Y_Reg

	jmp DrawCell


SCORPION.DeleteRight:

	li 0
	lr 5, a

	Inc_Scratch X_Reg

	jmp DrawCell




SCORPION.FrameUpdate:

	Load_Ram RAM.ScorpionCooldown
	ci 0
	bz ReadyScorpion

	ai 255
	Store_Ram RAM.ScorpionCooldown

	jmp CheckCollisionScorpion

ReadyScorpion:

	li SCORPION_TIME
	Store_Ram RAM.ScorpionCooldown

	Load_Ram RAM.ScorpionX
	ci 255
	bz ScorpionInactive

	jmp SCORPION.Move



ScorpionInactive:

	Load_Ram RAM.HeadsInLevel
	ai 253
	bm NoNewScorpion

	GetRandom
	ci 5
	bnc NoNewScorpion

	GetRandom
	lr 0, a
	ni %00001111
	Store_Ram RAM.ScorpionY

	lr a, 0
	ci 127
	bc RightScorpion

LeftScorpion:
	
	li 0
	Store_Ram RAM.ScorpionX

	li 1
	Store_Ram RAM.ScorpionDirection

	jmp DrawTheNewScorpion

RightScorpion:

	li GRID_COLUMNS - 2
	Store_Ram RAM.ScorpionX

	li 255
	Store_Ram RAM.ScorpionDirection

DrawTheNewScorpion:

	li 20
	Store_Ram RAM.ScorpionNote

	pi SCORPION.DrawLeft
	pi SCORPION.DrawRight

CheckCollisionScorpion:

	Load_Ram RAM.ScorpionX
	ci 255
	bz NoCollisionScorpion

	lr 4, a

	Load_RAM RAM.ScorpionY
	lr 5, a
	
	pi DEAD.Check 

NoNewScorpion:
NoCollisionScorpion:

	jmp FRAME.ScorpionDone



SCORPION.CheckCollision:

	Load_Ram RAM.ScorpionX
	ci 255
	bz ScorpionCollisionDone

	dci RAM.BulletX
	cm 
	bz CheckYScorpion

	ai 1
	dci RAM.BulletX
	cm
	bnz ScorpionCollisionDone

CheckYScorpion:

	Load_Ram RAM.ScorpionY
	dci RAM.BulletY
	cm
	bnz ScorpionCollisionDone

ScorpionHit:

	pi SCORPION.DeleteLeft
	pi SCORPION.DeleteRight

	Load_Ram RAM.ScorpionY
	lr 1, a

	Load_Ram RAM.ScorpionX
	lr 0, a

	GetCellContents

	ci 255
	bz NoPodUnderScorpionHead2

	Store_Ram RAM.CurrentID
	pi POD.Draw
	pi POD.DrawA

NoPodUnderScorpionHead2:

	Load_Ram RAM.ScorpionY
	lr 1, a

	Load_Ram RAM.ScorpionX
	inc
	lr 0, a

	GetCellContents

	ci 255
	bz NoPodUnderScorpionTail2

	Store_Ram RAM.CurrentID
	pi POD.Draw
	pi POD.DrawA

NoPodUnderScorpionTail2:

	li 255
	Store_Ram RAM.ScorpionX
	Store_Ram RAM.ScorpionCooldown

	dci sfx.hitScorpion
	pi playSong

	pi SCORE.Scorpion

ScorpionCollisionDone:

	jmp FRAME.ScorpionCollisionDone

