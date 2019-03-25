; ********************************************************
; ********************************************************
; *****				  PIANO TILES       		    *****
; *****							  	                *****
; *****            Anujin, Jacob, Utsal              *****
; *****							  	                *****
; ********************************************************
; ********************************************************

INCLUDE Irvine32.inc

.data
welcomeString	BYTE "************** WELCOME TO PIANO TILES *************", 0; Heading
scoreString		BYTE "SCORE: ", 0; Score text
overString		BYTE "GAME OVER!", 0; Game Over text
speedString		BYTE "SPEED: ", 0; Game Speed text
lifeString		BYTE "LIFE: ", 0; Game Life text
wall1			BYTE "???????????????????????????????????????????????????", 0; Wall characters
wall2			BYTE "?						 	?", 0; Wall characters
score			DWORD 0; Stores the score
speed			DWORD 50; Stores the speed of the tiles
life			DWORD 5; Stores the count of lives left
eraseTile		BYTE 48 DUP(" "), 0
tiles1			BYTE 12 DUP(" "), 0
tiles2			BYTE " ", 10 DUP(219), " ", 0
tileStore		DWORD 0
errorText		BYTE "ERROR!", 0

prompt byte 'Choose level of difficulty', 0; text for levelScreen
op1 byte "   1. Easy", 0
op2 byte "   2. Medium", 0
op3 byte "   3. Hard", 0
UserInput DWORD ?


overPrompt1 BYTE "   _____                         ____                 ", 0Dh, 0Ah
overPrompt2 BYTE "  / ____|                       / __ \                ", 0Dh, 0Ah
overPrompt3 BYTE " | |  __  __ _ _ __ ___   ___  | |  | |_   _____ _ __ ", 0Dh, 0Ah
overPrompt4 BYTE " | | |_ |/ _` | '_ ` _ \ / _ \ | |  | \ \ / / _ \ '__|", 0Dh, 0Ah
overPrompt5 BYTE " | |__| | (_| | | | | | |  __/ | |__| |\ V /  __/ |   ", 0Dh, 0Ah
overPrompt6 BYTE "  \_____|\__,_|_| |_| |_|\___|  \____/  \_/ \___|_|   ", 0
overOp1 BYTE "1. Play again", 0
overOp2 BYTE "2. Exit", 0
overInput DWORD ?

showScore BYTE "Your score: "

.code
main PROC

call levelScreen
main ENDP
gameEnd::; label to go to the game over screen
call overScreen
byebye::

call Crlf
call Crlf
call Crlf
exit

levelScreen PROC
mov eax, (black * 16); color settings for the welcome text
call SetTextColor
call Clrscr

mov eax, green + (white * 16); output the prompt
call SetTextColor
mov edx, offset prompt
call WriteString
call crlf

mov eax, white + (green * 16); output the option Easy
call SetTextColor
mov edx, offset op1
call WriteString
call crlf

mov eax, black + (yellow * 16); output the option Medium
call SetTextColor
mov edx, offset op2
call WriteString
call crlf

mov eax, white + (red * 16); output the option Hard
call SetTextColor
mov edx, offset op3
call WriteString

call Crlf

mov eax, white + (black * 16); take the input
call SetTextColor
call ReadInt
mov[UserInput], eax; UserInput = eax

mov ebx, 150
mov edx, 150
cmp eax, 1
cmove ebx, edx
mov edx, 110
cmp eax, 2
cmove ebx, edx
mov edx, 80
cmp eax, 3
cmove ebx, edx

mov speed, ebx

call gameScreen
ret
levelScreen ENDP

overScreen PROC
mov eax, (white * 16); color settings for the screen
call SetTextColor
call Clrscr
mov edx, OFFSET overPrompt1
mov eax, red + (white * 16); color settings for the welcome text
call SetTextColor
call WriteString
call Crlf

mov edx, OFFSET showScore; Show the score
call WriteString
mov eax, score
call WriteInt


call Crlf
mov edx, offset overOp1; output the option : Play again
call WriteString
call Crlf
mov edx, offset overOp2; output the option : Exit
call WriteString
call Crlf
call ReadInt; take the input
mov[overInput], eax; overInput = eax

cmp eax, 1
je menuCaller
jmp byebye
menuCaller :
call levelScreen
ret
overScreen ENDP


gameScreen PROC USES eax ebx ecx edx
call Clrscr
mov life, 5
mov score, 0
mov dl, 14; set x for left bound of the area
mov dh, 2; set y for right bound of the zone
call Gotoxy
mov eax, green + (white * 16); color settings for the welcome text
call SetTextColor
mov edx, OFFSET welcomeString
call WriteString; display welcome text on the screen
mov dl, 1; location for Speed text
mov dh, 8
call Gotoxy

mov dl, 14; location of the area wall
mov dh, 4
call Gotoxy
mov eax, yellow + (green * 16); color settings for the wall
call SetTextColor
mov edx, OFFSET wall1
call WriteString
mov ah, 20
Wall:; display the wall
	mov dl, 14
	mov dh, ah
	call Gotoxy
	dec ah
	mov edx, OFFSET wall2
	call WriteString
	cmp ah, 4
	jg Wall
	mov dl, 14
	mov dh, 21
	call Gotoxy
	mov edx, OFFSET wall1
	call WriteString

	call fallTiles
	ret
	gameScreen ENDP

	fallTiles PROC USES eax ebx ecx edx
	call Randomize
	Start :
mov ecx, 4; Randomly generate tiles
mov ebx, 0
genTile:
mov eax, 2
call RandomRange
shl ebx, 1
add ebx, eax
loop genTile
mov tileStore, ebx

mov ecx, 15; loop counters
mov ebx, 5
mov eax, white + (green * 16); color settings for the tiles
call SetTextColor

downTile :
mov dl, 15
mov dh, bl
call Gotoxy
mov eax, speed; set delay settings
call Delay
mov edx, OFFSET eraseTile
call WriteString

inc bl
mov dl, 15
mov dh, bl
dec bl
call Gotoxy

pushad
mov ebx, tileStore
mov ecx, 4
printTile:; print out the tiles
	shr ebx, 1
	jc filledOne
	mov edx, OFFSET tiles1
	call WriteString
	jmp doneFill
	filledOne :
mov edx, OFFSET tiles2
call WriteString
doneFill :
loop printTile
popad

inc ebx
loop downTile

; KEYBOARD CODE START
pushad
mov ecx, 1
xor eax, eax
call ReadKey
mov ebx, 0
cmp eax, 1E61h
cmove ebx, ecx
mov edx, 2
cmp eax, 1F73h
cmove ebx, edx
mov ecx, 4
mov edx, 8
cmp eax, 2064h
cmove ebx, ecx
cmp eax, 2166h
cmove ebx, edx

; CODE TO INCREMENT / DECREMENT SCORE
mov eax, tileStore
and eax, ebx
mov ecx, eax
and ebx, eax
cmp ebx, 0
jle scoreNotAdd
add score, 10
add life, 1
cmp speed, 30
jle speedNotReduce
sub speed, 2
speedNotReduce:
scoreNotAdd:
sub life, 1

popad
; KEYBOARD CODE END

mov dl, 1
mov dh, 8
call Gotoxy
mov edx, OFFSET speedString
call WriteString; display speed text on the screen
mov eax, 100
sub eax, speed
call WriteInt

mov dl, 1
mov dh, 10
call Gotoxy
mov edx, OFFSET scoreString; display Score
call WriteString
mov eax, score
call WriteInt

mov dl, 1
mov dh, 12
call Gotoxy
mov edx, OFFSET lifeString; display Life
call WriteString
mov eax, life
call WriteInt

mov dl, 15
mov dh, 20
call Gotoxy
mov eax, speed; set delay settings
call Delay
mov edx, OFFSET eraseTile
call WriteString

mov eax, life
cmp life, 0
je gameEnd

jmp Start
ret
fallTiles ENDP

END main