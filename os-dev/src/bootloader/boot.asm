org 0x7C00
bits 16

; macro for endl hex
%define ENDL 0x0D, 0x0A

;
; FAT12 Required Header (from here : https://wiki.osdev.org/FAT)
;
jmp short start
nop

bdb_oem:					db 'MSWIN4.1'			; 8 bytes
bdb_bytes_per_sector:		dw 512
bdb_sector_per_cluster:		db 1
bdb_reserved_sector:		dw 1
bdb_fat_count:				db 2
bdb_dir_entries_count:		dw 0E0h
bdb_total_sectors:			dw 2880					; 2880 * 512 sector = 1.44MB
bdb_media_descriptor_type:	db 0F0h					; F0 indicates 3.5" floppy disk
bdb_sectors_per_fat:		dw 9					; 9 sectors/fat
bdb_sectors_per_track:		dw 18		
bdb_heads:					dw 2
bdb_hidden_sectors:			dd 0
bdb_large_sector_count:		dd 0

; Extended boot record
ebr_drive_number:			db 0					; 0x00 floppy, 0x80 hdd, 
							db 0					; reserved byte set to 0
ebr_signature:				db 29h
ebr_volume_id:				db 12h, 34h, 56h, 78h 	; any 4 bytes number (serial number)
ebr_volume_label:			db 'ERYZ OS    '		; any 11 bytes string
ebr_system_id				db 'FAT12   '			; 8 bytes padded with spaces



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
	mov sp, 0x7C00						; stack grows downward from here

	; read something from the floppy disk!
	; BIOS should set DL to drive number
	mov [ebr_drive_number], dl
	mov ax, 1							; LBA=1 -> read second sector
	mov cl, 1							; 1 sector to read
	mov bx, 0x7E00						; data should be here after the bootloader
	call disk_read

	; print message
	mov si, msg_hello
	call puts

	cli 						; disable interrupts, so CPU cant get out of halt state
	hlt

;
; Error handlers
;
floppy_error:
	mov si, msg_read_failed
	call puts
	jmp wait_and_key_reboot

wait_and_key_reboot:
	mov ah, 0
	int 16h						; wait for keypress
	jmp 0FFFFh:0				; jump to beginning of BIOS, should reboot
	hlt

.halt:
	cli 						; disable interrupts, so CPU cant get out of halt state
	hlt

; 
; Disk Routines
;

;
; Since our filesystem needs CHS (cylinder, head, sector), we need to convert LBA (logical base addressing)
; Converts LBA address to CHS address
; Parameters :
;	- ax : LBA address
; Returns :
; 	- cx [bits 0-5] : sector number
; 	- cx [bits 6-15] : cylinder number
;	- dh : head
;
lba_to_chs:
	
	push ax
	push dx

	xor dx, dx								; dx = 0
	div word [bdb_sectors_per_track]		; ax = LBA / sectors_per_track
											; dx = LBA % sectors_per_track
	inc dx									; dx = (LBA % sectors_per_track + 1) = sector
	mov cx, dx								; cx = sector

	xor dx, dx								; dx = 0
	div word [bdb_heads]					; ax = (LBA / sectors_per_track) / heads = cylinder
											; dx = (LBA / sectors_per_track) % heads = head
	; dl is lower 8 bit of dx
	mov dh, dl								; dh = head
	mov ch, al								; ch = cylinder (lower 8 bits)
	shl al, 6
	or cl, ah								; upper 2 bits of cylinder to CL

	pop ax
	mov dl, al								; restore dl
	pop ax

	ret


;
; Reads sectors from a disk
; Parameters:
;	- ax: LBA address
;	- cl: number of sectors to read (up to 128)
;	- dl: drive number
;	- es:bx: memory location to store data
;
disk_read:
	push ax									; save registers that will be used
	push bx
	push cx
	push dx
	push di

	push cx 								; temporarily save cx (number of sectors to read)
	call lba_to_chs							; compute our CHS address
	pop ax									; al = number of sectors to read

	mov ah, 02h								;
	mov di, 3								; since floppy disk might be unreliable, retry 3x
	int 13h									; call interrupt 13h

.retry:
	pusha									; save all register, dont know which BIOS used
	stc 									; set carry flag, some BIOS dont set it
	int 13h									; if carry flag cleared -> success
	jnc .done								; jump if carry not set (cleared)

	; read failed
	popa
	call disk_reset

	dec di									; retry until di = 0 
	test di, di
	jnz .retry

.fail:
	; all attempts exhausted, still fail
	; jump to error message
	jmp floppy_error

.done:
	popa

	pop di
	pop dx
	pop cx
	pop bx
	pop ax									; restore modified registers
	ret

;
;	Reset disk controller
;	Parameters:
;		- dl: drive number
;
disk_reset:
	pusha
	mov ah, 0								; reset disk
	stc
	int 13h
	jc floppy_error
	popa
	ret

msg_hello: 							db "Hello world!", ENDL, 0
msg_read_failed:					db "Read from disk failed!", ENDL, 0
times 510-($-$$) db 0
dw 0AA55h
