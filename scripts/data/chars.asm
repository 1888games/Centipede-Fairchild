chars:		.word grid, blank, ship, bullet, pod1, pod2, pod3, pod4  ;// 0-7
			.word pod1, pod2, pod3, pod4 ;// 8-11
			.word pod_head_left, pod_head_right, pod_tail_left, pod_tail_right ;// 12-15
			.word pod_1A, pod_2A, pod_3A, pod_4A, pod_1A, pod_2A, pod_3A, pod_4A ;// 16 -23
			.word spider_1, spider_2, RAM.ShipDeadChar, flea_1, flea_2 ;// 24-28
			.word scorpion_1, scorpion_2

Colours:	.byte Transparent, Transparent, Blue, Blue,Red,Red,Red,Red
			.byte Blue, Blue, Blue, Blue
			.byte Red,Red,Green, Green
			.byte Green, Green, Green, Green,Green, Green, Green, Green
			.byte Blue, Red, Blue, Red, Blue
			.byte Red, Red

Background:	.byte Clear, Transparent, Clear, Clear,Transparent, Transparent, Transparent, Transparent
			.byte Transparent, Transparent, Transparent, Transparent
			.byte Transparent,Transparent, Transparent, Transparent
			.byte Clear,Clear, Clear, Clear,Clear,Clear, Clear, Clear
			.byte Transparent, Transparent, Transparent, Transparent, Clear
			.byte Transparent, Transparent

grid:
		.byte %11111111
		.byte %11111111

blank
		.byte %00000000
		.byte %00000000

ship:

		.byte %01011111
		.byte %10000000

bullet:

		.byte %01001000
		.byte %00000000
pod1:

		.byte %11100000
		.byte %00000001


pod2:
		.byte %11101000
	.byte %00000001




pod3:

		.byte %11111100
		.byte %00000001



pod4:
	.byte %11111101
	.byte %00000001



pod_head_left:

	.byte %01110101
	.byte %10000001

pod_head_right:

	.byte %11010111
	.byte %00000001

pod_tail_left:

	.byte %00101100
	.byte %10000010

pod_tail_right:

	.byte %10011010
	.byte %00000010




pod_1A:
	.byte %10100000
	.byte %00000001

pod_2A:
	.byte %10100000
	.byte %00000001


pod_3A:
	.byte %10100000
	.byte %00000001

pod_4A:
	.byte %10100001
	.byte %00000001


spider_1:
	.byte %10001110
	.byte %10000010

spider_2:
	.byte %10111000
	.byte %10000010


flea_1:
		.byte %00111101
		.byte %10000010

flea_2:
		
		.byte %01000000
		.byte %00000010

scorpion_1:

	.byte %10111101
	.byte %00000010

scorpion_2:

	.byte %01000111	
	.byte %10000010	





numLetters:

	.word tile_0, tile_1, tile_2, tile_3, tile_4, tile_5, tile_6, tile_7, tile_8, tile_9
	.word tile_s, tile_c, tile_o, tile_r, tile_e, tile_h, tile_i, tile_g, tile_h


tile_0:
	.byte %01110010
	.byte %10010100
	.byte %10100111
	.byte %00000000



tile_1:
	.byte %00100011
	.byte %00001000
	.byte %01000111
	.byte %00000000


tile_2:
	.byte %01110000
	.byte %10011100
	.byte %10000111
	.byte %00000000



tile_3:
	.byte %01110000
	.byte %10011100
	.byte %00100111
	.byte %00000000



tile_4:
		.byte %01000010
	.byte %10011100
	.byte %00100001
	.byte %00000000


tile_5:
		.byte %01110010
		.byte %00011100
		.byte %00100111
		.byte %00000000



tile_6:
	.byte %01110010
	.byte %00011100
	.byte %10100111
	.byte %00000000



tile_7:
		.byte %01110000
		.byte %10000100
		.byte %00100001
		.byte %00000000


tile_8:
		.byte %01110010
		.byte %10011100
		.byte %10100111
		.byte %00000000

tile_9:
	.byte %01110010
	.byte %10011100
	.byte %00100001
	.byte %00000000


tile_s:

	.byte %01110010
	.byte %00011100
	.byte %00100111
	.byte %00000000

tile_c:
	.byte %01110010
	.byte %00010000
	.byte %10000111
	.byte %00000000

tile_o:

	.byte %01110010
	.byte %10010100
	.byte %10100111
	.byte %00000000

tile_r:

	.byte %01100010
	.byte %10011000
	.byte %10100101
	.byte %00000000

tile_e:

	.byte %01110010
	.byte %00011100
	.byte %10000111
	.byte %00000000

tile_h:

	.byte %01010010
	.byte %10011100
	.byte %10100101
	.byte %00000000

tile_i:

	.byte %01110001
	.byte %00001000
	.byte %01000111
	.byte %00000000


tile_g:

	.byte %01110010
	.byte %00010100
	.byte %10100111
	.byte %00000000


