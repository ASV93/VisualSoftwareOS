; *-------------------------------------------------------*
; |                                                       |
; |   File Name: Power.asm 	                              |
; |   Description: Shutdown/Reboot function               |
; |                                                       |
; |   Visual Software Operating System				      |
; |                                                       |
; *-------------------------------------------------------*


	BITS 16
	%INCLUDE "devapi.inc"
	ORG 32768


start:
	call .draw_background

	mov ax, .command_list			; Draw list of power operations
	mov bx, .help_msg1
	mov cx, .help_msg2
	call os_list_dialog

	jc near .exit				; User pressed Esc?

	cmp ax, 1				; Otherwise respond to choice
	je near .shutdownpc

	cmp ax, 2
	je near .rebootpc

.shutdownpc:
    mov   ax,5304h
    sub   bx,bx
    int   15h
    mov   ax,5302h
    sub   bx,bx
    int   15h
    mov   ax,5308h
    mov   bx,1
    mov   cx,bx
    int   15h
    mov   ax,530Dh
    mov   bx,1
    mov   cx,bx
    int   15h
    mov   ax,530Fh
    mov   bx,1
    mov   cx,bx
    int   15h
    mov   ax,530Eh
    sub   bx,bx
    mov   cx,102h
    int   15h
    mov   ax,5307h
    mov   bx,1
    mov   cx,3
    int   15h
	ret
	
.rebootpc:
	mov ax, 0040h
	mov ds, ax
	mov word [0072h], 0000h ; 0000h = cold boot | 1234h = warm boot
	jmp 0FFFFh:0000h

.exit:
	call os_clear_screen
	ret


.draw_background:
	mov ax, .title_msg
	mov bx, .footer_msg
	mov cx, 01000000b ;00010010b ;00100000b
	call os_draw_background
	ret


	.command_list		db 'Shutdown,Reboot', 0

	.help_msg1		db 'Select a power operation to perform,', 0
	.help_msg2		db 'or press the Esc key to exit...', 0

	.title_msg		db 'VSOS Power Application', 0
	.footer_msg		db 'Shutdown or Reboot your PC', 0

; ------------------------------------------------------------------

