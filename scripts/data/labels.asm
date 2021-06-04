;------------------------
; BIOS Calls
;------------------------
clrscrn         =       $00d0                                   ;uses r31
delay           =       $008f
pushk           =       $0107                                   ;used to allow more subroutine stack space
popk            =       $011e
drawchar        =       $0679
IncP1Score      =       $02AC

;------------------------
; Colors
;------------------------
Red             =       $40
Blue            =       $80
Green           =       $00
Transparent     =       $C0
Back_green 		=      	$C0
Back_grey		= 		$C6
Clear = 				$FF



X_Reg = 45
Y_Reg = 44


START_HEADS = 1
START_CENTS = 12
START_PODS = 12
MAX_PODS = 100
MAX_CENTS = 16
CENT_TIME = 30
START_LIVES = 3

SHIP_START_X = 11
SHIP_START_Y = 18
MAX_SHIP_Y = GRID_ROWS - 5

GRID_ROWS = 19
GRID_COLUMNS = 23

SHIP_CHAR = 2
BULLET_CHAR  = 3
POD_CHAR_START = 3
CENT_CHAR_START = 11
POD_CHAR_A_START = 15
SCORPION_CHAR_LEFT = 29
SCORPION_CHAR_RIGHT = 30
FLEA_CHAR_LEFT = 27
FLEA_CHAR_RIGHT = 28
SPIDER_CHAR_LEFT = 24
SPIDER_CHAR_RIGHT = 25
SHIP_DEAD_CHAR = 26
FIXED_POD_START = 4
POISON_POD_START = 8
POD_INACTIVE = 0

SCORPION_TIME = 18
SPIDER_TIME = 14
FLEA_TIME = 13
SCORE_TIME = 120
SHIP_TIME = 7
BULLET_TIME = 1
POD_TIME = MAX_PODS

CENT_SPAWN_COL = 4
CENT_HEAD_LEFT = 1
CENT_HEAD_RIGHT = 2
CENT_TAIL_LEFT = 3
CENT_TAIL_RIGHT = 4
CENT_WRAP_ROW = 12

