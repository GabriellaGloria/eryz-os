org 0x7C00
bits 16

; macro for endl hex
%define ENDL 0x0D, 0x0A

start: ; so main is still entry point
	jmp main 

; we want to print a string
; Params : ds:si points to a string

puts:
	; save registers that is modified later
	push si
	push ax

.loop:
	; lodsb loads result in al
	lodsb			; load a byte from ds:si and increment the si by 1 byte	
	or al, al		; verify if null or not (if 0, zero-flag next -> null terminating char)
	jz .done

	; prints a character stored by al	
	mov ah, 0x0e 	; interrupt number
	mov bh, 0 		; set page number 0 since not graphic
	int 0x10  		; for video interrups (here for only printing char in tty)

	jmp .loop
	
.done:
	pop ax
	pop si
	ret

main:

	; setup data segments
	mov ax, 0
	; cant directly write a const to ds/es
	mov ds, ax
	mov es, ax

	; setup stack
	mov ss, ax
	mov sp, 0x7C00	; stack grows downward from here

	; print message
	mov si, msg_hello
	call puts

	hlt

.halt:
	jmp .halt

msg_hello: db "Hello world!", ENDL, 0

times 510-($-$$) db 0
dw 0AA55h
