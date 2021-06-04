FRAME.Start:
	
	jmp LIVES.Display

FRAME.Loop:
	
	jmp INPUT.FrameUpdate

FRAME.InputDone:

	jmp BULLET.FrameUpdate

FRAME.BulletDone:

	jmp SHIP.FrameUpdate

FRAME.ShipDone:

	jmp CENT.CheckSpawn

FRAME.CentMoveDone:

	jmp CENT.CheckCollision

FRAME.CollisionDone:

	jmp SPIDER.FrameUpdate

FRAME.SpiderDone:

	jmp SPIDER.CheckCollision

FRAME.SpiderCollisionDone:

	jmp FLEA.FrameUpdate

FRAME.FleaDone:

	jmp FLEA.CheckCollision

FRAME.FleaCollisionDone

	jmp SCORE.FrameUpdate

FRAME.ScoreDone:

	jmp LIVES.FrameUpdate

FRAME.LivesDone:

	jmp SCORPION.FrameUpdate

FRAME.ScorpionDone:

	jmp SCORPION.CheckCollision

FRAME.ScorpionCollisionDone

	


	jmp FRAME.Loop