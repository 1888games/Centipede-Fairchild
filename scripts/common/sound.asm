 
BadSound:                               ;make a bad sound
				li		$3f		; r1 loaded with $3f
				lr		1,a		
sndloop:
				li		$80		; $80 loaded into A
				outs	5			; send data to port
				lis		1		; A=1
				lr		5,a		; load r5 with 1

				li 50
				lr 		0, a
DelayLp:
				ds 0
				bnz DelayLp

			
				lis		0		; same as clr
				outs	5			; send 0 on port
				ds		1		; r1 decreased
				bf		4,sndloop	; run the loop again until r1 is 0

				pop


-----------;
; Play Song ;
;-----------;

; plays a song from memory
; song address stored in DC0
; uses r3, r4, r5, r7

playSong:                       				; taken from Pro Football
	lis	3						; A = 3
	lr	4, A						; A -> r4, r4 = 3

.playSongDelay1:      
	inc							; increase A
	bnz	.playSongDelay1					; [Branch if not zero] back to .psdly1
	am							; Memory adressed by DC0 is added to A, flags set  - get duration data
	lr	7, A						; A -> r7
	bz	.playSongEnd					; Go to end if zero
	lm							; Load memory into A (adressed by DC0) - get frequency data
	lr	5, A						; A -> r5

	; check to see if we should pause
	inc
	bnc  .playSongLoop					; it didn't roll over, play a note instead

.playSongPause:
	li	$ff
	lr	6, A
.playSongPauseLoop:
	ds	6						; pause counter
	bnz	.playSongPauseLoop
	ds	7						; duration of the pause
	bnz	.playSongPause

	; play the next note
	br	playSong

.playSongLoop:
	li	$80						; A= $80 
	outs	5						; Send  A -> port 5
	lr	A, 5						; r5 -> A

.playSongDelay2:
	inc							; increase A
	bnz	.playSongDelay2						; [Branch if not zero] back to .psdly2
	outs	5						; A -> port 5
	lr	A, 5						; r5 -> A

.playSongDelay3:
	inc							; increase A
	bnz	.playSongDelay3					; [Branch if not zero] back to .psdly3
	ds	4						; decrease r4
	bnz	.playSongLoop					; [Branch if not zero] back to .psloop
	lis	3						; A = 3
	lr	4, A						; A -> r4
	ds	7						; decrease r7
	bnz	.playSongLoop						; [Branch if not zero] back to .psloop
	br	playSong					; start over - branch to beginning

.playSongEnd:
	pop		


;---------------------------------------------------------------------------
; Ghost Eat Sound
;---------------------------------------------------------------------------

sfx.ghostEat:
	.byte 5,10,2,61,2,63,3,93,3,94,3,95,3,95,3,95
	.byte 3,103,3, 104,3,111,3,112,3,112,3,112,3,108,3,108
	.byte 2,110,2,111,2,112,2,112,2,112

	.byte 0

sfx.move:
	.byte 4, 250
	.byte 0

sfx.delete:

	.byte 5, 100, 5, 50
	.byte 0

sfx.fire:
	.byte 2, 200
	;.byte 1, 160
	.byte 0

sfx.hit:
	.byte 1, 50
	.byte 0

sfx.hitSpider:

	.byte 1, 50, 1, 180, 0

sfx.fleaHit:
	.byte 2, 70, 2, 150, 0

sfx.hitScorpion:
	.byte 2, 170, 2, 90, 0

sfx.spider1:

	.byte 1, 230
	.byte 0

sfx.spider2:

	.byte 1, 100
	.byte 0

sfx.pod:

	.byte 4, 25

sfx.dead:

	.byte 1, 100, 1, 90, 1, 80, 1, 70, 1, 60, 1, 50, 1, 40, 1, 30, 5, 20, 0

sfx.gameOver:

	.byte 5, 100, 5, 95, 5, 90, 4, 85, 4, 80, 4, 75, 3, 70, 3, 65, 3, 60, 3, 55, 3, 50, 3, 45, 3, 40, 3, 35, 3, 30, 3, 25, 25, 20, 0

;---------------------------------------------------------------------------
; Prize Eat Sound
;---------------------------------------------------------------------------

sfx.prizeEat:
	.byte 2,75,2,72,2,65,1,59,1,47,1,12,4,1,1,5,1,32
	.byte	1,49,2,66,2,7,2,1,3,166,3,173
	.byte 0
