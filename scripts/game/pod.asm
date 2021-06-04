POD.Spawn: 
		
	clr
	lr 0, a

FindLoop:
		
	lr a, 0
	dci RAM.PodStatus
	adc
	lm
	ci 0
	bz Found

	lr a, 0
	inc
	lr 0, a
	ci MAX_PODS
	bz Abort

	jmp FindLoop

Found:
		
	lr a, 0

	dci RAM.PodStatus
	adc
	lr a, 1
	st

	lr a, 0
	dci RAM.PodX
	adc
	Load_Scratch X_Reg
	st

	lr a, 0
	dci RAM.PodY
	adc
	Load_Scratch Y_Reg
	st
	lr 2, a

	ci MAX_SHIP_Y - 1
	bc NotLowPod

	Inc_Ram RAM.PlayerPodCount

NotLowPod:

	;// Store self on grid
	lr a, 2
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
	lr a, 0
	lr 6, a
	st

Abort:

	pop


POD.Random: 

	li FIXED_POD_START
	;li POISON_POD_START
	lr 1, a

TryRandom:

	GetRandom
	;ni %00001111
	ni %00011111
	inc
	inc
	ci GRID_COLUMNS
	bnc TryRandom

	ai 255
	Save_Scratch X_Reg

	jmp POD.Spawn


POD.Destroy:
	
	;//R6= podID


	;// Store self on grid

	lr a, 6
	GetFromArray_A RAM.PodX
	Save_Scratch X_Reg

	lr a, 6
	GetFromArray_A RAM.PodY
	Save_Scratch Y_Reg

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
	li 255
	st

	li 0
	lr 5, a

	jmp DrawCell


POD.InitialPods:
	
	li 3
	Store_Ram RAM.Row
		
MushroomLoop:
	
	Load_Ram RAM.Row
	Save_Scratch Y_Reg

	;// get max pods in this row
	dci PodRowMax
	adc
	lm

	ci 2
	bz MaxIsTwo

MaxIsOne:

	GetRandom
	ni %00000001
	Store_Ram RAM.Column
	jmp PodColumnCheck

MaxIsTwo:

	GetRandom
	ni %00000011
	Store_Ram RAM.Column
	ci 3
	bnz PodColumnLoop
	Dec_Ram RAM.Column

PodColumnCheck:
	
	Load_Ram RAM.Column
	ci 0
	bnz PodColumnLoop

	GetRandom
	ci 250
	bnc PodColumnLoop

	Inc_Ram RAM.Column


PodColumnLoop:

	Dec_Ram RAM.Column
	ci 255
	bz PodRowLoop

	Load_Ram RAM.Row
	Save_Scratch Y_Reg

	pi POD.Random

	Store_Ram RAM.CurrentID
	pi POD.Draw
	pi POD.DrawA

	jmp PodColumnLoop

PodRowLoop:	

	Inc_Ram RAM.Row
	ci GRID_ROWS - 1
	bz NoMoreRows

	jmp MushroomLoop

NoMoreRows:
		
	jmp SCORE.DisplayHigh

DoneHighScore:


	jmp SCORE.Display






POD.Restore:
	
	clr
	Store_Ram RAM.CurrentID

RestoreLoop:

	Load_Ram RAM.CurrentID
	dci RAM.PodStatus
	adc
	lr h, dc
	lm
	ci 0
	bz NextPodRestore

	lr 0, a

	lr dc, h
	ni %10000000
	oi %00000100
	st

	lr a, 0
	ci 4
	bz NoRestoreSound

	pi POD.Draw
	pi POD.DrawA

	dci sfx.pod
	pi playSong

	jmp NextPodRestore

NoRestoreSound:
	
	pi POD.Draw
	pi POD.DrawA


NextPodRestore:

	Inc_Ram RAM.CurrentID
	ci MAX_PODS
	bz DoneRestore

	jmp RestoreLoop

DoneRestore:
	
	jmp DEAD.DoneRestore
	


POD.Draw:


	Load_Ram RAM.CurrentID
	lr 6, a
	GetFromArray_A RAM.PodStatus
	ai POD_CHAR_START
	lr 5, a


	lr a, 6
	GetFromArray_A RAM.PodX
	Save_Scratch X_Reg

	lr a, 6
	GetFromArray_A RAM.PodY
	Save_Scratch Y_Reg

	jmp DrawCell


POD.DrawA:

	;//R6= podID

	Load_Ram RAM.CurrentID
	lr 6, a
	GetFromArray_A RAM.PodStatus
	ai POD_CHAR_A_START
	lr 5, a


	lr a, 6
	GetFromArray_A RAM.PodX
	Save_Scratch X_Reg

	lr a, 6
	GetFromArray_A RAM.PodY
	Save_Scratch Y_Reg

	jmp DrawCell


