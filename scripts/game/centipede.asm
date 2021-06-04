CENT.Spawn: 
		
	clr
	lr 0, a

FindLoopCent:
		
	lr a, 0
	dci RAM.CentStatus
	adc
	lm
	ci 0
	bz FoundCent

	lr a, 0
	inc
	lr 0, a
	ci START_CENTS
	bz AbortCent

	jmp FindLoopCent

FoundCent:
		
	;Inc_Ram RAM.CentsAlive
	Reset_Ram RAM.SpawnReady

	lr a, 0
	lr 6, a
	
	inc
	ci START_CENTS
	bz ResetNextDraw

	Store_Ram RAM.CentProcessID
	jmp SaveCentData
	
ResetNextDraw:
	
	Reset_Ram RAM.CentProcessID

SaveCentData:

	lr a, 6
	dci RAM.CentStatus
	adc
	lr a, 1
	st

	lr a, 0
	dci RAM.CentX
	adc
	Load_Scratch X_Reg
	st

	lr a, 0
	dci RAM.CentY
	adc
	Load_Scratch Y_Reg
	st
	
	lr a, 0
	dci RAM.CentPlunge
	adc
	li 0
	st

	Load_Ram RAM.LastSpawned
	lr 7, a

	lr a, 0
	dci RAM.CentInFront
	adc
	lr a, 7
	st



	lr a, 0
	Store_Ram RAM.LastSpawned

AbortCent:

	pop

CENT.DestroyAll:

	clr
	Store_Ram RAM.CurrentID


DestroyLoop:
	
	lr 6, a
	dci RAM.CentStatus
	adc
	lm
	ci 0
	bz NoDestroyNeeded3

	pi CENT.Destroy

NoDestroyNeeded3:

	Inc_Ram RAM.CurrentID
	ci START_CENTS
	bnz DestroyLoop

	jmp DestroyedAllCents


CENT.CheckPodUnderneath:

	Load_Scratch Y_Reg
	sl 1

	dci RowLookup
	adc
	lm
	lr	Qu, A
	lm
	lr	Ql, A
	lr	DC, Q

	Load_Scratch X_Reg
	adc
	lm

	pop

CENT.Destroy:
	
	;//
	;// Store self on grid

	lr a, 6
	GetFromArray_A RAM.CentX
	Save_Scratch X_Reg

	lr a, 6
	GetFromArray_A RAM.CentY
	Save_Scratch Y_Reg

	li 0
	lr 5, a

	jmp DrawCell


CENT.Draw:

	;//R6= podID

	lr a, 6
	GetFromArray_A RAM.CentStatus
	ai CENT_CHAR_START
	lr 5, a


	lr a, 6
	GetFromArray_A RAM.CentX
	Save_Scratch X_Reg

	lr a, 6
	GetFromArray_A RAM.CentY
	Save_Scratch Y_Reg

	jmp DrawCell





GetCentLocation:

	Load_Ram RAM.CentProcessID
	lr 6, a
	dci RAM.CentX
	adc
	lr h, dc
	lm
	lr 8, a
	lr 0, a
	Store_Ram RAM.X

	lr a, 6
	dci RAM.CentY
	adc
	lm
	lr 9, a
	lr 1, a
	Store_Ram RAM.Y

	lr a, 6
	dci RAM.CentPlunge
	adc
	lm
	lr 4, a

	pop


PadTime:
	
	li 60

TimeDelay:

	inc 
	ci 0
	bnz TimeDelay

	pop



CheckOtherCentipedes:
	
	clr
	lr 4, a
	lr 5, a

CheckCentLoop:

	lr a, 4	
	dci RAM.CentProcessID
	cm
	bz NextCentCheck

	lr a, 4
	dci RAM.CentX
	adc
	lr a, 0
	cm 
	bnz NextCentCheck

	lr a, 4
	dci RAM.CentY
	adc
	lr a, 1
	cm
	bnz NextCentCheck

	ds 5
	jmp DoneCentCheck

NextCentCheck:

	lr a, 4
	inc
	lr 4, a
	ci START_CENTS
	bz DoneCentCheck

	jmp CheckCentLoop


DoneCentCheck:

	pop

CENT.Move:
	
	li 0
	Store_Ram RAM.YReg



CentMoveLoop:

	Load_Ram RAM.CentProcessID
	lr 6, a
	dci RAM.CentStatus
	adc
	lm
	ci 0
	bnz IsMovingCent

	pi PadTime

IsMovingCent:
	
	lr 1, a

	Load_Ram RAM.LastSpawned
	dci RAM.CentProcessID
	cm
	bnz NoMatchLastSpawn

	li 1
	Store_Ram RAM.SpawnReady

NoMatchLastSpawn:
;// check hit by bullet

	lr a, 1
	ci CENT_HEAD_LEFT
	bnz NotHeadLeft

	jmp MoveCentLeft

NotHeadLeft:

	lr a, 1
	ci CENT_TAIL_LEFT
	bnz NotTailLeft

	jmp MoveCentLeft

NotTailLeft:

	lr a, 1
	ci CENT_HEAD_RIGHT
	bnz NotHeadRight

	jmp MoveCentRight

NotHeadRight:

	lr a, 1
	ci CENT_TAIL_RIGHT
	bnz NotTailRight

	jmp MoveCentRight

NotTailRight:

	jmp NextCentProcess



MoveCentLeft:

	pi CENT.Destroy
	pi CENT.CheckPodUnderneath

	ci 255
	bz NoPodUnderLeft

	pi POD.Draw
	pi POD.DrawA

NoPodUnderLeft:

NoDestroyNeeded2:

	pi GetCentLocation

	lr a, 0
	ci 255
	bnz CentStillAliveLeft

	jmp NextCentProcess

CentStillAliveLeft:

	lr a, 4
	ci 0
	bz PodNotLeft

	jmp NoPoisonedRight

PodNotLeft:

	lr a, 8
	ci 0
	bnz NotCol0Left

	jmp NoPoisonedRight

NotCol0Left:

	lr a, 0
	ai 255
	lr 0, a

	GetCellContents
	ci 255
	bnz TurnCentRight

	pi CheckOtherCentipedes

	lr a, 5
	ci 255
	bz NoPoisonedRight

	lr a, 0
	Store_Ram RAM.X
	lr dc, h
	st

	pi CENT.Draw

	jmp NextCentProcess


TurnCentRight:
	
	dci RAM.PodStatus
	adc
	lm
	ai 251
	bm NoPoisonedRight

	Load_Ram RAM.CentProcessID
	SaveToArray_A RAM.CentPlunge, 1

NoPoisonedRight:
	
	Load_Ram RAM.CentProcessID
	Increment_Indexed_Ram RAM.CentY
	Store_Ram RAM.Y
	ci GRID_ROWS
	bnz NoCentBottom2


CentipedeReachedBottomRight:

	Load_Ram RAM.CentProcessID
	SaveToArray_A RAM.CentY, CENT_WRAP_ROW

	Load_Ram RAM.CentsAlive
	ci 12
	bz NoCentBottom2

	GetRandom
	ni %00001111
	ci 6
	bnz NoCentBottom2

	Inc_Ram RAM.CentSpawners
	Inc_Ram RAM.HeadsLeft

NoCentBottom2:

	ci GRID_ROWS - 1
	bnz NotActualBottomLeft

	Load_Ram RAM.CentProcessID
	SaveToArray_A RAM.CentPlunge, 0

NotActualBottomLeft:

	Load_Ram RAM.CentProcessID
	Increment_Indexed_Ram RAM.CentStatus

	pi CENT.Draw

	jmp NextCentProcess

MoveCentRight:


	pi CENT.Destroy
	pi CENT.CheckPodUnderneath


	ci 255
	bz NoPodUnderRight

	pi POD.Draw
	pi POD.DrawA

NoPodUnderRight:

NoDestroyNeeded:

	pi GetCentLocation

	lr a, 0
	ci 255
	bnz CentStillAliveRight

	jmp NextCentProcess

CentStillAliveRight:

	lr a, 4
	ci 0
	bz PodNotRight

	jmp NoPoisonedLeft

PodNotRight:

	lr a, 8
	inc
	ci GRID_COLUMNS
	bnz NotRightCol

	jmp NoPoisonedLeft

NotRightCol:

	lr a, 0	
	inc
	lr 0, a
	
	
	GetCellContents
	ci 255
	bnz TurnCentLeft

	pi CheckOtherCentipedes

	lr a, 5
	ci 255
	bz NoPoisonedLeft

	lr a, 0
	Store_Ram RAM.X
	lr dc, h
	st

	pi CENT.Draw

	jmp NextCentProcess


TurnCentLeft:

	dci RAM.PodStatus
	adc
	lm
	ai 251
	bm NoPoisonedLeft

	Load_Ram RAM.CentProcessID
	SaveToArray_A RAM.CentPlunge, 1

NoPoisonedLeft:

	Load_Ram RAM.CentProcessID
	Increment_Indexed_Ram RAM.CentY
	Store_Ram RAM.Y
	ci GRID_ROWS
	bnz NoCentBottom

CentipedeReachedBottomLeft:

	Load_Ram RAM.CentProcessID
	SaveToArray_A RAM.CentY, CENT_WRAP_ROW

	Load_Ram RAM.CentsAlive
	ci 12
	bz NoSpaceLeftMore

	GetRandom
	ni %00001111
	ci 3
	bnz NoSpaceLeftMore

	Inc_Ram RAM.CentSpawners
	Inc_Ram RAM.HeadsLeft

NoSpaceLeftMore:

NoCentBottom:
	
	ci GRID_ROWS - 1
	bnz NotActualBottomRight

	Load_Ram RAM.CentProcessID
	SaveToArray_A RAM.CentPlunge, 0

NotActualBottomRight:

	Load_Ram RAM.CentProcessID
	Decrement_Indexed_Ram RAM.CentStatus

	pi CENT.Draw


NextCentProcess:


	
	Inc_Ram RAM.CentProcessID
	ci START_CENTS
	bnz KeepGoingCents

	Reset_Ram RAM.CentProcessID

KeepGoingCents:
	
	Inc_Ram RAM.YReg
	
AllCentsDone:

	Load_Ram RAM.X
	lr 4, a

	Load_Ram RAM.Y
	lr 5, a

	pi DEAD.Check

NoShipCentHit:

	jmp FRAME.CentMoveDone






CENT.CheckSpawn:

	Load_Ram RAM.SpawnReady
	ci 0 
	bnz SpawnEnabled

	jmp CENT.Move

SpawnEnabled:

	Load_Ram RAM.SpawnDelay
	ci 0
	bz ReadyToSpawn

	Dec_Ram RAM.SpawnDelay

	jmp CENT.Move

ReadyToSpawn:
		
	Load_Ram RAM.CentSpawners
	lr 0, a
	ci 0
	bz DoneCheckSpawn

	ai 255
	Store_Ram RAM.CentSpawners

	Load_Ram RAM.HeadsLeft
	ci 0
	bnz Head

SpawnMovingCent:

	li CENT_TAIL_LEFT
	lr 1, a
	lr 7, a

	jmp SpawnPosition

Head:

	Dec_Ram RAM.HeadsLeft

	ci 0
	bz NoSpawnDelay

	li 125
	Store_Ram RAM.SpawnDelay

NoSpawnDelay:

	li CENT_HEAD_LEFT
	lr 1, a
	lr 7, a

	li 255
	Store_Ram RAM.LastSpawned

SpawnPosition:
	
	li CENT_SPAWN_COL
	Save_Scratch X_Reg

	clr
	Save_Scratch Y_Reg

	pi CENT.Spawn
	pi CENT.Draw

DoneCheckSpawn:
	
	jmp CENT.Move
	
ExitTheCollision:

	jmp ExitCollision



CENT.CheckCollision:

	Load_Ram RAM.BulletX
	ci 255
	bz ExitTheCollision

	Load_Ram RAM.BulletCooldown
	ci 0
	bnz ExitTheCollision

	Load_Ram RAM.BulletMoved
	ci 0
	bz ExitTheCollision

	clr
	lr 6, a

CentHitLoop:

	lr a, 6
	dci RAM.CentX
	adc
	lm
	dci RAM.BulletX
	cm
	bz XMatches

	jmp NotHitCent

XMatches:

	lr a, 6
	dci RAM.CentY
	adc
	lm
	dci RAM.BulletY
	cm
	bz HitCentipede

	jmp NotHitCent

HitCentipede:

	Dec_Ram RAM.CentsAlive


	lr a, 6
	Store_Ram RAM.Direction
	dci RAM.CentStatus
	adc
	lr q, dc
	lm
	ci 2
	bnc HitTail

	pi SCORE.Head
	jmp ClearStatus


HitTail:

	pi SCORE.Tail

ClearStatus:


	lr dc, q
	clr
	st

	lr a, 6
	dci RAM.CentX
	adc
	li 255
	st

	pi CENT.Destroy
	pi CENT.CheckPodUnderneath


	ci 255
	bz NoPodUnderShot

	pi POD.Draw
	pi POD.DrawA

NoPodUnderShot:

	li FIXED_POD_START
	lr 1, a

	Load_Ram RAM.BulletY
	Save_Scratch Y_Reg

	Load_Ram RAM.BulletX
	Save_Scratch X_Reg

	pi POD.Spawn

	Store_Ram RAM.CurrentID
	pi POD.Draw
	pi POD.DrawA

	dci RAM.BulletX
	li 255
	st

	;// Turn next segment into a head


	dci sfx.hit
	pi playSong
	

	clr
	lr 0, a

FindNextTail:

	lr a, 0
	dci RAM.CentInFront
	adc
	lm
	dci RAM.Direction
	cm
	bnz NextSegment


TurnIntoHead:

	lr a, 0
	dci RAM.CentStatus
	adc
	lr h, dc
	lm
	ai 254
	bp NotNeg

	li 0
NotNeg:

	lr dc, h
	st

	lr a, 0
	dci RAM.CentInFront
	adc
	li 255
	st

	jmp AllSegments


NextSegment:

	lr a, 0
	inc
	lr 0, a
	ci START_CENTS
	bz AllSegments

	jmp FindNextTail

AllSegments:

	jmp DoneHitCheck

NotHitCent:
	
	lr a, 6
	inc 
	lr 6, a
	ci START_CENTS
	bz DoneHitCheck

	jmp CentHitLoop

DoneHitCheck:

	Load_Ram RAM.CentsAlive
	ci 0
	bnz ExitCollision

	jmp IncrementLevel
	
ExitCollision:
		

	jmp FRAME.CollisionDone