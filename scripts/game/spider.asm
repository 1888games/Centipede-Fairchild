


SPIDER.CheckCollision:

	Load_Ram RAM.SpiderX
	ci 255
	bz SpiderCollisionDone

	dci RAM.BulletX
	cm 
	bz CheckY

	ai 1
	dci RAM.BulletX
	cm
	bnz SpiderCollisionDone

CheckY:

	Load_Ram RAM.SpiderY
	dci RAM.BulletY
	cm
	bnz SpiderCollisionDone

SpiderHit:

	pi SPIDER.DeleteLeft
	pi SPIDER.DeleteRight

	li 255
	Store_Ram RAM.SpiderX
	Store_Ram RAM.SpiderCooldown

	dci sfx.hitSpider
	pi playSong

	pi SCORE.Spider

SpiderCollisionDone:

	jmp FRAME.SpiderCollisionDone



SPIDER.Move:

	Load_Ram RAM.SpiderSoundID
	ci 0
	bz HighSound

	ci 1
	bz MedSound

LowSound:
	
	dci sfx.spider1
	jmp GotSound
MedSound:
	
	dci sfx.hitSpider
	jmp GotSound

HighSound:
	
	dci sfx.spider2

GotSound:

	pi playSong

	Inc_Ram RAM.SpiderSoundID
	ci 3
	bnz NoResetSound

	Reset_Ram RAM.SpiderSoundID

NoResetSound:


	pi SPIDER.DeleteLeft
	pi SPIDER.DeleteRight

	Load_Ram RAM.SpiderX
	dci RAM.SpiderXSpeed
	am
	Store_Ram RAM.SpiderX

	ci 255
	bz ReachedEdge

	ci GRID_COLUMNS - 1
	bz ReachedEdge


	Load_Ram RAM.SpiderY
	dci RAM.SpiderYSpeed
	am
	Store_Ram RAM.SpiderY

	ci GRID_ROWS - 1
	bz ReachedBottom

	ci GRID_ROWS - 6
	bz ReachedTop

	GetRandom
	ci 240
	bnc ReachedBottom

	ci 20
	bc ReachedTop

	jmp FinishSpider


ReachedEdge:

	li 255
	Store_Ram RAM.SpiderX
	Store_Ram RAM.SpiderCooldown

	jmp FRAME.SpiderDone


ReachedBottom:

	li 255
	Store_Ram RAM.SpiderYSpeed
	jmp RandomDirection

ReachedTop:

	li 1
	Store_Ram RAM.SpiderYSpeed

RandomDirection:

	Load_Ram RAM.SpiderSideAim
	ci 0
	bz GoingLeft


GoingRight:

	GetRandom
	ni %00000001
	Store_Ram RAM.SpiderXSpeed
	jmp FinishSpider

GoingLeft:

	GetRandom
	ni %00000001
	ai 255
	Store_Ram RAM.SpiderXSpeed

FinishSpider:
	
	Load_Ram RAM.SpiderX
	lr 0, a

	Load_Ram RAM.SpiderY
	lr 1, a

	GetCellContents
	ci 255 
	bnz HitAPod

	lr a, 0
	inc
	lr 0, a

	GetCellContents
	ci 255
	bz NoPod

HitAPod:

	lr 6, a
	dci RAM.PodStatus
	adc
	clr
	st

	lr a, 6
	dci RAM.PodY
	adc
	lm

	ci MAX_SHIP_Y - 1
	bc NotLowPodSpider

	Dec_Ram RAM.PlayerPodCount

NotLowPodSpider:

	pi POD.Destroy

NoPod:

	pi SPIDER.DrawLeft
	pi SPIDER.DrawRight

	Load_Ram RAM.SpiderX
	lr 4, a

	Load_RAM RAM.SpiderY
	lr 5, a
	
	pi DEAD.Check 

	lr a, 4
	inc
	lr 4, a

	pi DEAD.Check

	jmp FRAME.SpiderDone



SPIDER.DrawLeft:

	li SPIDER_CHAR_LEFT
	lr 5, a

	Load_Ram RAM.SpiderX
	Save_Scratch X_Reg

	Load_Ram RAM.SpiderY
	Save_Scratch Y_Reg


	jmp DrawCell

SPIDER.DrawRight:

	li SPIDER_CHAR_RIGHT
	lr 5, a

	Inc_Scratch X_Reg

	jmp DrawCell


SPIDER.DeleteLeft:

	li 0
	lr 5, a

	Load_Ram RAM.SpiderX
	Save_Scratch X_Reg

	Load_Ram RAM.SpiderY
	Save_Scratch Y_Reg


	jmp DrawCell


SPIDER.DeleteRight:

	li 0
	lr 5, a

	Inc_Scratch X_Reg

	jmp DrawCell



SPIDER.FrameUpdate:

	Load_Ram RAM.SpiderCooldown
	ci 0
	bz ReadySpider

	ai 255
	Store_Ram RAM.SpiderCooldown


	jmp CheckCollision

ReadySpider:

	li SPIDER_TIME
	Store_Ram RAM.SpiderCooldown

	Load_Ram RAM.SpiderX
	ci 255
	bz SpiderInactive

	jmp SPIDER.Move


SpiderInactive:

	GetRandom
	ci 3
	bnc NoNewSpider
	
	lr 0, a
	dci SpiderStartY
	adc
	lm
	Store_Ram RAM.SpiderY

	lr a, 0
	dci SpiderStartX
	adc
	lm
	Store_Ram RAM.SpiderX

	lr a, 0
	dci SpiderSpeedX
	adc
	lm
	Store_Ram RAM.SpiderXSpeed

	lr a, 0
	dci SpiderSpeedY
	adc
	lm
	Store_Ram RAM.SpiderYSpeed

	lr a, 0
	dci SpiderDirection
	adc
	lm
	Store_Ram RAM.SpiderSideAim

	pi SPIDER.DrawLeft
	pi SPIDER.DrawRight


CheckCollision:

	Load_Ram RAM.SpiderX
	ci 255
	bz NoCollisionSpider

	lr 4, a

	Load_RAM RAM.SpiderY
	lr 5, a
	
	pi DEAD.Check 

	lr a, 4
	inc
	lr 4, a

	pi DEAD.Check

NoNewSpider:
NoCollisionSpider:

	jmp FRAME.SpiderDone