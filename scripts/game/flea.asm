

FLEA.Move:
	
	
	Load_Ram RAM.SpiderX
	ci 255
	bnz NoSound

	Load_Ram RAM.FleaNote
	ai 245
	Store_Ram RAM.FleaNote

	dci RAM.FleaSFX
	pi playSong

NoSound:

	pi FLEA.DeleteUnder

	Load_Ram RAM.FleaY
	lr 1, a

	Load_Ram RAM.FleaX
	lr 0, a

	GetCellContents
	
	ci 255
	bz NoPodUnderFlea

	Store_Ram RAM.CurrentID
	pi POD.Draw
	pi POD.DrawA

	jmp NoNewPod

NoPodUnderFlea:
	
	Load_Ram RAM.FleaY
	ci GRID_ROWS - 1
	bz NoNewPod
	
	GetRandom
	ni %00000111
	ci 4
	bnz NoNewPod

	li FIXED_POD_START
	lr 1, a

	Load_Ram RAM.FleaY
	Save_Scratch Y_Reg

	Load_Ram RAM.FleaX
	Save_Scratch X_Reg

	pi POD.Spawn

	Store_Ram RAM.CurrentID
	pi POD.Draw
	pi POD.DrawA

NoNewPod:


	Inc_Ram RAM.FleaY
	ci GRID_ROWS
	bnz FleaNotAtBottom

	Load_Ram RAM.PlayerPodCount
	ai 250
	bp FleaDone


FleaWrap:

	Reset_Ram RAM.FleaY

	GetRandom
	ni %00001111
	inc
	Store_Ram RAM.FleaX

	jmp FleaNotAtBottom


FleaDone:
	
	li 255
	Store_Ram RAM.FleaX
	Store_Ram RAM.FleaCooldown
	jmp FRAME.FleaDone

FleaNotAtBottom:
	
	pi FLEA.DrawUnder
	pi FLEA.DrawOver

	jmp FRAME.FleaDone

FLEA.FrameUpdate:

	Load_Ram RAM.FleaCooldown
	ci 0
	bz ReadyFlea

	ai 255
	Store_Ram RAM.FleaCooldown

	jmp CheckCollisionFlea

ReadyFlea:

	Load_Ram RAM.FleaSpeed
	Store_Ram RAM.FleaCooldown

	Load_Ram RAM.FleaX
	ci 255
	bz FleaInactive

	jmp FLEA.Move

FLEA.DrawUnder:

	li FLEA_CHAR_LEFT
	lr 5, a

	Load_Ram RAM.FleaX
	Save_Scratch X_Reg

	Load_Ram RAM.FleaY
	Save_Scratch Y_Reg


	jmp DrawCell

FLEA.DrawOver:

	li FLEA_CHAR_RIGHT
	lr 5, a

	jmp DrawCell


FLEA.DeleteUnder:

	li 0
	lr 5, a

	Load_Ram RAM.FleaX
	Save_Scratch X_Reg

	Load_Ram RAM.FleaY
	Save_Scratch Y_Reg

	jmp DrawCell




FleaInactive:

	Load_Ram RAM.HeadsInLevel
	ci 1
	bz NoNewFlea

	Load_Ram RAM.PlayerPodCount
	ai 250
	bp NoNewFlea

	GetRandom
	ci 3
	bnc NoNewFlea

	GetRandom
	ni %00001111
	inc
	Store_Ram RAM.FleaX

	li 0
	Store_Ram RAM.FleaY

	li 200
	Store_Ram RAM.FleaNote

	pi FLEA.DrawUnder
	pi FLEA.DrawOver

CheckCollisionFlea:

	Load_Ram RAM.FleaX
	ci 255
	bz NoCollisionFlea

	lr 4, a

	Load_RAM RAM.FleaY
	lr 5, a
	
	pi DEAD.Check 

NoNewFlea:
NoCollisionFlea:

	jmp FRAME.FleaDone


FLEA.CheckCollision:

	Load_Ram RAM.FleaX
	lr 0, a
	ci 255
	bz FleaCollisionDone

	dci RAM.BulletX
	cm 
	bnz FleaCollisionDone

	Load_Ram RAM.FleaY
	lr 1, a
	dci RAM.BulletY
	cm
	bnz FleaCollisionDone

FleaHit:

	pi FLEA.DeleteUnder

	GetCellContents
	
	ci 255
	bz NoPodUnderDeadFlea

	Store_Ram RAM.CurrentID
	pi POD.Draw
	pi POD.DrawA

NoPodUnderDeadFlea:

	li 255
	Store_Ram RAM.FleaX
	Store_Ram RAM.FleaCooldown

	dci sfx.fleaHit
	pi playSong

	pi SCORE.Flea

FleaCollisionDone:

	jmp FRAME.FleaCollisionDone