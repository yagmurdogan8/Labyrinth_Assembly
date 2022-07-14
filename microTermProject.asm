org 100h

.data

init db 0001000b, 0000000b, 0000000b, 0000000b, 0000000b, 1110111b, 1000001b, 1111001b, 1111011b, 1000001b, 1011111b, 1011111b, 1010001b, 1010101b, 1000101b, 1111101b, 1000101b, 1010001b, 1010101b, 1010101b, 1100011b, 1000001b, 1011101b,1011101b, 1011101b, 1001001b, 1000101b, 1011101b, 1100001b, 1101111b, 1000001b, 1010101b, 1010101b, 1010101b, 1111101b, 0000000b, 0000000b, 0000000b, 0000000b, 0000000b
PosOfX dw 2000h
PosOfY db 0001000b

.code

	mov dx, 2000h	
	
MainLoop:
	mov si, 0
	mov cx, 40
	
Next:
	
	mov al, init[si] 
	out dx, al 
	             
	mov bx, dx 
	mov ah, 0
	mov [bx], ax
	
	inc si
	inc dx

	loopne Next
	jl MainLoop
   
       
Begin: 
    
    mov ah, 00h 
    int 16h 
    
    
    cmp ax, 4D00h
    je Right
    cmp ax, 4B00h
    je Left  
    cmp ax, 4800h
    je Up
    cmp ax, 5000h
    je Down
    loop Begin
    

Right:
    mov bx, PosOfX
    cmp bx, 2027h 
    je Begin
	mov ah, 0

    mov bx, PosOfX
    inc bx   
    call checkIfMoveIsOKOnXCoordinate

	mov bx, PosOfX
    mov dx, PosOfX
    call RemovePrevious

    inc PosOfX
    mov dx, PosOfX           
      
    call SetMemoryAndDisplayOnXCoordinate


Left:
    mov bx, PosOfX
    cmp bx, 2000h
    je Begin
	mov ah, 0
	
    mov bx, PosOfX
    dec bx   
    call checkIfMoveIsOKOnXCoordinate
	
	mov bx, PosOfX
    mov dx, PosOfX
    call RemovePrevious

    dec PosOfX
    mov dx, PosOfX               
      
    call SetMemoryAndDisplayOnXCoordinate

Up:

    mov ah, 0
    mov al, PosOfY 
    cmp al, 01H
    je Begin 

    mov bl, 2        
    div bl              
    
    call checkIfMoveIsOKOnYCoordinate
    
    call RemovePrevious

    mov ah, 0
    mov al, PosOfY 
    mov bl, 2
    div bl
    
    call SetMemoryAndDisplayOnYCoordinate

Down:
    mov ah, 0
    mov al, PosOfY 
    cmp al, 40h 
    je Begin

    mov bl, 2       
    mul bl             
    
    call checkIfMoveIsOKOnYCoordinate

    call RemovePrevious

    mov ah, 0
    mov al, PosOfY
    mov bx, 2
    mul bx          
    
    call SetMemoryAndDisplayOnYCoordinate 
 
RemovePrevious:
    mov cx, [bx]
    mov ch, 0
    sub cl, PosOfY
    mov [bx], cl
    
    mov dx, PosOfX
    call SendByte
ret

SetMemoryAndDisplayOnYCoordinate:
    mov bx, PosOfX 
    mov cx, [bx] 
    mov ch, 0      
    mov PosOfY, al 
    add cl, PosOfY         

    mov [bx], cl
    mov dx, PosOfX
    call SendByte
    jmp Begin 
ret 
 
SetMemoryAndDisplayOnXCoordinate:
    mov bx, PosOfX
    mov cx, [bx]
    mov ch, 0
    add cl, PosOfY
    mov [bx], cl
	 
	mov dx, PosOfX
	call SendByte
	jmp Begin
ret

checkIfMoveIsOKOnYCoordinate: 

    mov bx, PosOfX 
    test [bx], ax
    jnz Begin
ret

checkIfMoveIsOKOnXCoordinate:
	
    mov cx, [bx]
    mov ch, 0
    mov al, PosOfY
    test [bx], al
    jnz Begin
    
ret
  
SendByte:
	mov al, cl
	out dx, al      
ret