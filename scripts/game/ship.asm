

SHIP.Controls:

	Load_Ram RAM.JoyRightNow
	ci 0
	bz NotRight

	jmp MoveRight

NotRight:

	Load_Ram RAM.JoyLeftNow
	ci 0
	bz NotLeft

	jmp MoveLeft

NotLeft:

	Load_Ram RAM.JoyDownNow
	ci 0
	bz NotDown
	jmp MoveDown

NotDown:
	
	Load_Ram RAM.JoyUpNow
	ci 0
	bz NotUp

	jmp MoveUp

NotUp:

	Load_Ram RAM.JoyFireNow
	ci 0
	bz NotFire

	jmp BULLET.Fire

BulletFired:


NotFire:

	jmp FinishControls


MoveLeft:	
	
	Load_Ram RAM.ShipX
	ci 0
	bnz SpaceLeft

	jmp NotLeft

SpaceLeft:
	
	ai 255
	lr 0, a

	Load_Ram RAM.ShipY
	lr 1, a

	GetCellContents
	ci 255
	bnz FinishLeft

	pi DeleteShip

	Dec_Ram RAM.ShipX
	;pi DrawShip

FinishLeft:

	jmp NotLeft

MoveRight:

	Load_Ram RAM.ShipX
	inc
	ci GRID_COLUMNS
	bnz SpaceRight

	jmp NotLeft

SpaceRight:

	lr 0, a

	Load_Ram RAM.ShipY
	lr 1, a

	GetCellContents
	ci 255
	bnz FinishRight
	
	pi DeleteShip

	Inc_Ram RAM.ShipX
	;pi DrawShip

FinishRight:

	jmp NotLeft

MoveUp:
	
	Load_Ram RAM.ShipY
	ci MAX_SHIP_Y
	bnc SpaceUp

	jmp FinishControls

SpaceUp:
	
	ai 255
	lr 1, a

	Load_Ram RAM.ShipX
	lr 0, a

	GetCellContents
	ci 255
	bnz FinishUp

	pi DeleteShip

	Dec_Ram RAM.ShipY
	;pi DrawShip

FinishUp:

	jmp NotUp

MoveDown:

	pi DrawShip


	Load_Ram RAM.ShipY
	inc
	ci GRID_ROWS
	bnz SpaceDown

	jmp NotUp

SpaceDown:
		
	lr 1, a

	Load_Ram RAM.ShipX
	lr 0, a

	GetCellContents
	ci 255
	bnz FinishDown

	pi DeleteShip

	Inc_Ram RAM.ShipY
	;pi DrawShip

FinishDown:

	jmp NotUp
	

FinishControls:
	
	pi DrawShip

	li 0
	lr 0, a


	jmp FRAME.ShipDone


DrawShip:
	
	li SHIP_CHAR
	lr 5, a

	Load_Ram RAM.ShipX
	Save_Scratch X_Reg

	Load_Ram RAM.ShipY
	Save_Scratch Y_Reg


	jmp DrawCell


DeleteShip:

	Load_Ram RAM.ShipX
	Save_Scratch X_Reg
	;lr 0, a

	Load_Ram RAM.ShipY
	Save_Scratch Y_Reg
;	lr 1, a

	li 0
	lr 5, a

	jmp DrawCell



SHIP.FrameUpdate:

	Load_Ram RAM.ShipCooldown
	ci 0
	bz ReadyShip

	ai 255
	Store_Ram RAM.ShipCooldown

	jmp FRAME.ShipDone

ReadyShip:

	li SHIP_TIME
	Store_Ram RAM.ShipCooldown

	jmp SHIP.Controls