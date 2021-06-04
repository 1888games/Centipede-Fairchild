



SCORE.Display:

	clr
	Store_Ram RAM.XReg

	li 74
	Store_Ram RAM.X

ScoreLoop:

	;// Score Number
		
	Load_Ram RAM.XReg
	GetFromArray_A RAM.ScoreHundredThousands
	lr 5, a

	li Transparent
	lr 1, a	

	li Blue
	lr 2, a

	li 30
	lr 4, a

	Load_Ram RAM.X
	lr 3, a

	pi DrawTile


NoChar:

	Load_Ram RAM.X
	ai 4
	Store_Ram RAM.X

	Inc_Ram RAM.XReg
	ci 6
	bz ScoreDone

	jmp ScoreLoop

ScoreDone:

	jmp FRAME.Loop



SCORE.DisplayHigh:

	clr
	Store_Ram RAM.XReg

	li 74
	Store_Ram RAM.X

ScoreLoop2:

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
	bz ScoreDone2

	jmp ScoreLoop2

ScoreDone2:

	jmp DoneHighScore



SCORE.Head:
	
	Inc_Ram RAM.ScoreAddHundreds
	pop
	

SCORE.Tail:
	
	Inc_Ram RAM.ScoreAddTens
	pop


SCORE.Pod:
		
	Inc_Ram RAM.ScoreAddDigits	
	pop

SCORE.Flea:

	Load_Ram RAM.ScoreAddHundreds
	ai 2
	Store_Ram RAM.ScoreAddHundreds

	pop


SCORE.Scorpion:
	Inc_RAM RAM.ScoreAddThousands

	pop

SCORE.Poison:
	Inc_Ram RAM.ScoreAddTens
	
	pop


SCORE.Spider:

	clr
	Store_Ram RAM.Amount

	Load_Ram RAM.ShipY
	lr 0, a

GapLoop:
	
	lr a, 0
	ai 255
	lr 0, a
	dci RAM.SpiderY
	cm
	bz FoundSpiderGap

	Inc_Ram RAM.Amount

	jmp GapLoop

FoundSpiderGap:

	Load_Ram RAM.Amount
	dci SpiderScore
	adc
	lm
	dci RAM.ScoreAddHundreds
	am
	dci RAM.ScoreAddHundreds
	st

	Reset_Ram RAM.ScoreCooldown

	pop



AddToScore: 

	;// loop back from digit 6 to digit 1
	li 6
	lr 1, a

;// 0 = temp
;// 1 = digit loop
;// 2 = carry loop

DigitLoop:
		
	;// Get the amount to add to this digit, store in 0
	lr a, 1
	GetFromArray_A RAM.ScoreToAdd
	ci 0
	bz NextDigit
	lr 0, a

	;// add the amount to the current digit value and save
	lr a, 1
	GetFromArray_A RAM.Score
	as 0
	lr 0, a
	lr a, 1
	SaveR0ToArray_A RAM.Score

	ai 246				;//subtract 10
	bm NextDigit		;// test if still positive - need to carry

	;// Save the digit with -10
	lr 0, a
	lr a, 1
	SaveR0ToArray_A RAM.Score
	lr a, 1
	ai 255
	lr 2, a


CarryLoop:
		
	;//Digit index for carry
	lr a, 2
	;//add one to digit and check if carry cascades
	Increment_Indexed_Ram RAM.Score
	ci 10
	bnz NextDigit

	;// set this digit to zero
	lr a, 2
	Reset_Indexed_RAM RAM.Score

	;// add one to next digit
	lr a, 2
	ai 255
	Increment_Indexed_Ram RAM.Score


	;// check if finished carrying
	lr a, 2
	ai 255
	ci 0
	bz NextDigit
	lr 2, a

	jmp CarryLoop

NextDigit:

	lr a, 1
	ai 255
	ci 0
	bz DoneAdding
	lr 1, a

	jmp DigitLoop


DoneAdding:

	dci RAM.ScoreToAdd
	clr
	st
	st
	st
	st
	st
	st
	st

	Load_Ram RAM.Lives
	ci 6
	bz NoExtraLife

	Load_Ram RAM.ScoreTenThousands
	dci RAM.TenThousandPrevious
	cm
	bz NoExtraLife

	Store_Ram RAM.TenThousandPrevious

	Inc_RAM RAM.Lives
	Inc_RAM RAM.DrawLives

NoExtraLife:

	pop




CheckHighScore:

	Load_Ram RAM.ScoreHundredThousands
	dci RAM.HighHundredThousands
	cm
	bz CheckTenThousands
	bp NoHighScore
	

	jmp HighScore

CheckTenThousands:

	Load_Ram RAM.ScoreTenThousands
	dci RAM.HighTenThousands
	cm
	bz CheckThousands
	bp NoHighScore
	
	jmp HighScore

CheckThousands:

	Load_Ram RAM.ScoreThousands
	dci RAM.HighThousands
	cm
	bz CheckHundreds
	bp NoHighScore
	
	jmp HighScore

CheckHundreds:

	Load_Ram RAM.ScoreHundreds
	dci RAM.HighHundreds
	cm
	bz CheckTens
	bp NoHighScore

	jmp HighScore

CheckTens:

	Load_Ram RAM.ScoreTens
	dci RAM.HighTens
	cm
	bz CheckDigits
	bp NoHighScore

	jmp HighScore

CheckDigits:

	Load_Ram RAM.ScoreDigits
	dci RAM.HighDigits
	cm
	bp NoHighScore

HighScore:

	Load_Ram RAM.ScoreHundredThousands
	Store_Ram RAM.HighHundredThousands

	Load_Ram RAM.ScoreTenThousands
	Store_Ram RAM.HighTenThousands

	Load_Ram RAM.ScoreThousands
	Store_Ram RAM.HighThousands

	Load_Ram RAM.ScoreHundreds
	Store_Ram RAM.HighHundreds

	Load_Ram RAM.ScoreTens
	Store_Ram RAM.HighTens

	Load_Ram RAM.ScoreDigits
	Store_Ram RAM.HighDigits

NoHighScore:


	pop


SCORE.FrameUpdate:

	Load_Ram RAM.ScoreCooldown
	ci 0
	bz ReadyScore

	ai 255
	Store_Ram RAM.ScoreCooldown

	jmp FRAME.ScoreDone

ReadyScore:

	li SCORE_TIME
	Store_Ram RAM.ScoreCooldown

	;jmp FRAME.ScoreDone

	pi AddToScore
	jmp SCORE.Display