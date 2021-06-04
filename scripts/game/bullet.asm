BULLET.Fire:
	
	Load_Ram RAM.BulletX
	ci 255
	bnz BulletActive

	Load_Ram RAM.ShipY
	ci 0
	bz BulletActive
	Store_Ram RAM.BulletY

	Reset_Ram RAM.BulletMoved

	Load_Ram RAM.ShipX
	Store_Ram RAM.BulletX

	pi BULLET.Draw

	dci sfx.fire
	pi playSong

BulletActive:
	
	jmp BulletFired
	



BULLET.Move:

	Load_Ram RAM.BulletX
	ci 255
	bnz IsBullet

	jmp NoBullet

IsBullet:

	pi BULLET.Delete

	Inc_Ram RAM.BulletMoved	

	Load_Ram RAM.BulletX
	lr 0, a

	Dec_Ram RAM.BulletY
	lr 1, a
	ci 255
	bz BulletDone

	GetCellContents
	lr 6, a
	ci 255
	bz CheckCentipedeHit

	dci RAM.PodStatus
	adc
	lr h, dc
	lm
	ai 255
	lr dc, h
	st
	lr 7, a

	ci 0
	bz PodDestroyed

	ci 4
	bz PodDestroyed

	lr a, 6
	Store_Ram RAM.CurrentID
	pi POD.Draw
	pi POD.DrawA

	lr a, 7
	ai 251
	bp PoisonedPod
	
	pi SCORE.Pod
	jmp NowEndPod

PoisonedPodAlive:
	
	pi SCORE.Poison

NowEndPod:

	jmp EndBullet

PodDestroyed:

	lr a, 6
	dci RAM.PodY
	adc
	lm

	ci MAX_SHIP_Y - 1
	bc NotLowPodHit

	Dec_Ram RAM.PlayerPodCount

NotLowPodHit:
	
	lr a, 7
	ai 251
	bp PoisonedPod

	pi SCORE.Pod
	jmp NowDestroyPod

PoisonedPod:
	
	pi SCORE.Poison

NowDestroyPod:

	pi POD.Destroy
	

	
EndBullet:

	jmp BulletDone

CheckCentipedeHit:
	
	pi BULLET.Draw

	jmp FRAME.BulletDone


BulletDone:

	li 255
	Store_Ram RAM.BulletX

NoBullet:

	jmp FRAME.BulletDone

BULLET.Draw:

	Load_Ram RAM.BulletY
	dci RAM.ShipY
	cm
	bnz OkayToDraw

	pop

OkayToDraw:
	
	li BULLET_CHAR
	lr 5, a

	Load_Ram RAM.BulletX
	ci 255
	bnz OkayToDraw3

	pop

OkayToDraw3:
	
	Load_Ram RAM.BulletX
	Save_Scratch X_Reg

	Load_Ram RAM.BulletY
	Save_Scratch Y_Reg

	jmp DrawCell

BULLET.Delete:

	Load_Ram RAM.BulletY
	dci RAM.ShipY
	cm
	bnz OkayToDraw2

	pop

OkayToDraw2:

	Load_Ram RAM.BulletX
	Save_Scratch X_Reg
	lr 0, a

	Load_Ram RAM.BulletY
	Save_Scratch Y_Reg
	lr 1, a

	li 0
	lr 5, a

	jmp DrawCell


BULLET.FrameUpdate:

	Load_Ram RAM.BulletCooldown
	ci 0
	bz ReadyBullet

	ai 255
	Store_Ram RAM.BulletCooldown

	jmp FRAME.BulletDone

ReadyBullet:

	li BULLET_TIME
	Store_Ram RAM.BulletCooldown

	jmp BULLET.Move
