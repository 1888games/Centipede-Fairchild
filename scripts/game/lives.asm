LIVES.Display:

	Reset_Ram RAM.DrawLives

	li 1
	Store_Ram RAM.X

	li 20
	Save_Scratch Y_Reg

	li 75
	Save_Scratch X_Reg

LivesLoop:

	Load_Ram RAM.X
	dci RAM.Lives
	cm
	bp DrawLifeShip

	li 1
	lr 5, a
	jmp DrawTheLife

DrawLifeShip:
	
	li SHIP_CHAR
	lr 5, a

DrawTheLife:

	li Transparent
	lr 1, a	

	li Blue
	lr 2, a

	li 75
	lr 4, a

	Load_Scratch X_Reg
	lr 3, a

	pi DrawChar


EndLiveLoop:

	Load_Scratch X_Reg
	ai 4
	Save_Scratch X_Reg
	
	Inc_Ram RAM.X
	ci 7
	bz DoneLives

	jmp LivesLoop

DoneLives:

	
	jmp FRAME.LivesDone


LIVES.FrameUpdate: 

	Load_Ram RAM.DrawLives
	ci 0
	bz NoDisplayLives

	jmp LIVES.Display

NoDisplayLives:
	
	jmp FRAME.LivesDone
