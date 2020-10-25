
CODE = 0fffah 

STACK_SIZE = 01000h

I_RECORDSIZE = 0eh
I_RELATIVERECORD = 21h
I_READ = 0
I_WRITE = 1
I_RW = 2
I_BEG = 0
I_CUR = 1
I_END = 2

@ENDCODE	MACRO	code
	mov	al,code
	mov	ah,4ch
	int	21h
	endm

@CHANGESEGM	macro	segreg,seg
		assume	segreg:seg
		push	ax
		mov	ax,seg
		mov	segreg,ax
		pop	ax
		endm

@KEYBRR	MACRO	delay,rate
	push	bx
	push	ax
	mov	ah,03h
	mov	al,05h
	mov	bh,delay
	mov	bl,rate
	int	16h
	pop	ax
	pop	bx
	endm

XORDATA	MACRO	string,xxor
	IRPC	x,<string>
	db	"&x" XOR xxor
	endm
	endm

@DOSPRINT	macro	char
	push	ax
	push	dx
	mov	dl,char
	mov	ah,02h
	int	21h
	pop	dx
	pop	ax
	endm

@DOSLPRINT	macro	char
	push	dx
	push	ax
	mov	dl,char
	mov	ah,05h
	int	21h
	pop	ax
	pop	dx
	endm
	
@PUSH	macro
	push	ds
	push	es
	push	ax
	push	bx
	push	dx
	push	cx
	push	si
	push	di
	endm

@POP	macro
	pop	di
	pop	si
	pop	cx
	pop	dx
	pop	bx
	pop	ax
	pop	es
	pop	ds
	endm

@PUSHAX	macro
	push	ds
	push	es
	push	bx
	push	dx
	push	cx
	push	si
	push	di
	endm

@POPAX	macro
	pop	di
	pop	si
	pop	cx
	pop	dx
	pop	bx
	pop	es
	pop	ds
	endm

@SETBLOCKOFMEMORY	macro	startparagraph,numberofparagraphs
			push	es
			push	bx
			mov	es,startparagraph
			mov	bx,numberofparagraphs
			mov	ah,4ah
			int	21h
			pop	bx
			pop	es
			endm

@ALLOCATEMEMORY	macro	bytes		;AX
		push	bx
		push	cx
		mov	bx,bytes
		mov	cl,4
		shr	bx,cl
		inc	bx
		mov	ah,48h
		int	21h
		pop	cx
		pop	bx
		endm

@FREEMEMORY	macro	seg_adr
		push	ax
		push	es
		mov	ax,seg_adr
		mov	es,ax
		mov	ah,49h
		int	21h
		pop	es
		pop	ax
		endm

@INITWIND	macro	x,y,x1,y1,attr
		push	ax
		push	cx
		push	dx
		push	bx
		mov	cl,x
		mov	ch,y
		mov	dl,x1
		mov	dh,y1
		mov	bh,attr
		mov	al,0
		mov	ah,06h
		int	10h
		pop	bx
		pop	dx
		pop	cx
		pop	ax
		endm

@FINDFIRSTFILE	macro	filenameoffset,attrib		;DTA
		push	dx
		push	cx
		push	ax
		mov	dx,filenameoffset
		mov	cx,attrib
		mov	ah,4eh
		int	21h
		pop	ax
		pop	cx
		pop	dx
		endm

@FINDNEXTFILE	macro		;DTA
		push	ax
		mov	ah,4fh
		int	21h
		pop	ax
		endm

@RENAME_FILE	macro
	push	ax
	push	es
	push	ds
	pop	es
	mov	ah,56h
	int	21h
	pop	es
	pop	ax
	endm

@DELETE_FILE    macro
        mov     ah,41h
        int     21h
        endm

@SELECT_DRIVE	macro	drive
		push	dx
		push	ax
		mov	dl,drive
		sub	dl,"A"
                mov     ah,0eh
                int     21h
		pop	ax
		pop	dx
                endm

@GETDTA		macro		;ES:BX
		push	ax
		mov	ah,2fh
		int	21h
		pop	ax
		endm

@GETPSP		macro		;BX
		push	ax
		mov	ah,62h
		int	21h
		pop	ax
		endm

@GETINT		macro	intcode	;es:bx
		push	ax
		mov	ah,35h
		mov	al,intcode
		int	21h
		pop	ax
		endm

@DOINT		macro	intcode	;ds:dx
		push	ax
		mov	ah,25h
		mov	al,intcode
		int	21h
		pop	ax
		endm

@GETDISKSPACE	macro	drive		;ax=sector,bx=clusters
		mov	dl,drive	;cx=bytes per sector
		mov	ah,36h		;dx=total clusters
		int	21h
		endm
	
@CREATEFCB      macro   fcb
                mov     dx,offset fcb
                mov     ah,16h
                int     21h
                endm

@OPENFCB        macro   fcb
                mov     dx,offset fcb
                mov     ah,0fh
                int     21h
                endm

@CLOSEFCB       macro   fcb
                mov     dx,offset fcb
                mov     ah,10h
                int     21h
                endm

@RANDOMREAD     macro   fcb
                mov     dx,offset fcb
                mov     ah,21h
                int     21h
                endm

@RANDOMWRITE    macro   fcb
                mov     dx,offset fcb
                mov     ah,22h
                int     21h
                endm

@SETDTA         macro   buffer
                mov     dx,offset buffer
                mov     ah,1ah
                int     21h
                endm

@CREATEHANDLE   macro   path,attrib
                mov     dx,offset path
                mov     cx,attrib
                mov     ah,3ch
                int     21h
                endm

@OPENHANDLE     macro   path,access
                mov     dx,offset path
                mov     al,access
                mov     ah,3dh
                int     21h
                endm

@CLOSEHANDLE    macro   handle
                mov     bx,handle
                mov     ah,3eh
                int     21h
                endm

@READHANDLE     macro   handle,buffer,bytes
                mov     bx,handle
                mov     dx,offset buffer
                mov     cx,bytes
                mov     ah,3fh
                int     21h
                endm

@WRITEHANDLE    macro   handle,buffer,bytes
                mov     bx,handle
                mov     dx,offset buffer
                mov     cx,bytes
                mov     ah,40h
                int     21h
                endm

@MOVEFP         macro   handle,high,low,method
                mov     bx,handle
                mov     cx,high
                mov     dx,low
                mov     al,method
                mov     ah,42h
                int     21h
                endm


@CREATE_HANDLE  macro   path,attr
		push	dx
		push	cx
                mov     dx,offset path
                mov     cx,attr
                mov     ah,3ch
                int     21h
		pop	cx
		pop	dx
                endm

@OPEN_HANDLE    macro	path,access
		push	dx
                mov     dx,offset path
                mov     al,access
                mov     ah,3dh
                int     21h
		pop	dx
                endm

@CLOSE_HANDLE   macro   handle
		push	ax
		push	bx
                mov     bx,handle
                mov     ah,3eh
                int     21h
		pop	bx
		pop	ax
                endm

@READ_HANDLE    macro   handle,buffer,bytes
		LOCAL	readerr
		push	ax
		push	cx
		push	bx
		push	dx
                mov     cx,bytes
                mov     bx,handle
                mov     dx,offset buffer 
                mov     ah,3fh
                int     21h
		cmp	ax,cx
		je	readerr
		stc
readerr:	pop	dx
		pop	bx
		pop	cx
		pop	ax
                endm

@WRITE_HANDLE   macro   handle,buffer,bytes
		LOCAL	writerr
		push	cx
		push	ax
		push	dx
		push	bx
                mov     cx,bytes
                mov     bx,handle
                mov     dx,offset buffer
                mov     ah,40h
                int     21h
		cmp	ax,cx
		je	writerr
		stc
writerr:	pop	bx
		pop	dx
		pop	ax
		pop	cx
                endm

@READ_MEM	macro   handle,buffer,bytes
		LOCAL	mreaderr
		push	ax
		push	cx
		push	bx
		push	dx
                mov     cx,bytes
                mov     bx,handle
                mov     dx,buffer
                mov     ah,3fh
                int     21h
		cmp	ax,cx
		je	mreaderr
		stc
mreaderr:	pop	dx
		pop	bx
		pop	cx
		pop	ax
                endm

@WRITE_MEM	macro   handle,buffer,bytes
		LOCAL	mwriterr
		push	cx
		push	ax
		push	dx
		push	bx
                mov     cx,bytes
                mov     bx,handle
                mov     dx,buffer
                mov     ah,40h
                int     21h
		cmp	ax,cx
		je	mwriterr
		stc
mwriterr:	pop	bx
		pop	dx
		pop	ax
		pop	cx
                endm


@READ_MEM_AX	macro   handle,buffer,bytes
		LOCAL	mreaderrax
		push	cx
		push	bx
		push	dx
                mov     cx,bytes
                mov     bx,handle
                mov     dx,buffer
                mov     ah,3fh
                int     21h
		cmp	ax,cx
		je	mreaderrax
		stc
mreaderrax:	pop	dx
		pop	bx
		pop	cx
                endm

@READS  macro   STARTSEC,NUMBSEC,TRACK,HEAD,DRIVE,BUFFER
        push    es
        push    ds
        pop     es
        mov     al,NUMBSEC
        mov     cl,STARTSEC
        mov     ch,TRACK
        mov     dh,HEAD
        mov     dl,DRIVE
        mov     bx,offset BUFFER
        mov     ah,02h
        int     13h
        pop     es
        endm

@WRITES macro   STARTSEC,NUMBSEC,TRACK,HEAD,DRIVE,BUFFER
        push    es
        push    ds
        pop     es
        mov     al,NUMBSEC
        mov     cl,STARTSEC
        mov     ch,TRACK
        mov     dh,HEAD
        mov     dl,DRIVE
        mov     bx,offset BUFFER
        mov     ah,03h
        int     13h
        pop     es
        endm

@VERIFY macro   STARTSEC,NUMBSEC,TRACK,HEAD,DRIVE,BUFFER
        push    es
        push    ds
        pop     es
        mov     al,NUMBSEC
        mov     cl,STARTSEC
        mov     ch,TRACK
        mov     dh,HEAD
        mov     dl,DRIVE
        mov     bx,offset BUFFER
        mov     ah,04h
        int     13h
        pop     es
        endm

@RESET  macro   DRIVE
        LOCAL   gro
gro:    mov     dl,DRIVE
        mov     ah,0
        int     13h
        jc      gro
        endm
	
@RESETHRD	macro
	mov	ah,13
	int	13h
	endm

@READDS  macro   DISK,STARTSEC,NUMBSEC,BUFFER
        mov     cx,NUMBSEC
        mov     dx,STARTSEC
        mov     al,DISK
        mov     bx,offset BUFFER
        int     25h
	pop	ax
        endm

MAXREC = 32769
BRIGHT = 00001000b
FLASH = 10000000b
FLASHBRIGHT = 10001000b
NULL = 0

@INITSCREEN	macro
		call	initscreen
		endm

@INITWIND	macro	buffer
		push	bx
		mov	bx,offset buffer
		mov	word ptr [bx],0
		add	bx,4
		call	initwind
		pop	bx
		endm

@DELWIND        macro
                call    winddel
                endm

@WDELALL	macro
                call    winddelall
                endm

@SETWIND        macro   window
                mov     bx,offset window
                call    windmake
                endm

@SETBOX		macro	x,y,x1,y1,atr,boxtype
		mov	dl,x
		mov	dh,y
		mov	bl,x1
		mov	bh,y1
		mov	di,boxtype
		mov	ah,atr
		call	setbox
		endm

@SETPOPUP       macro   window
                mov     bx,offset window
                call    popmake
                endm

@WPRINT         macro   x,y,string,attr
                mov     dl,x
                mov     dh,y
                mov     bx,offset string
		mov	ax,attr
                call    windprint
                endm
                
@WPRINTCH       macro   x,y,char
                mov     dl,x
                mov     dh,y
                mov     al,char
                call    winddisp
                endm

@WINPUT         macro   x,y,buf
                mov     dl,x
                mov     dh,y
                mov     bx,offset buf
		mov	ax,0
                call    windinput
                endm

@WINPUTNUM      macro   x,y,buf
                mov     dl,x
                mov     dh,y
                mov     bx,offset buf
                call    windinputnum
                endm

@QPRINT         macro   x,y,char,attr
                mov     dl,x
                mov     dh,y
                mov     al,char
                mov     ah,attr
                call    qprint
                endm

@WAIT           macro   time
                push    dx
                mov     dx,time
                call    iwait
                pop     dx
                endm

@STRCPY         macro   str1,str2
                mov     bx,offset str1
                mov     si,offset str2
                call    strcpy
                endm

@STRCMP         macro   str1,str2
                mov     bx,offset str1
                mov     si,offset str2
                call    strcmp
                endm

@INVERSE        macro   x,y,len
                mov     dl,x
                mov     dh,y
                mov     cx,len
                call    winvstr
                endm

@BELL		macro
		call	bell
		endm

@FILLSCR	macro	char,attr
		mov	al,char
		mov	ah,attr
		call	fillscr
		endm

@ASCIIZ		macro	buffer
		mov	bx,offset buffer
		call	asciiz
		endm

@ENDCHAR	macro	buffer,char,len
		mov	bx,offset buffer
		mov	dl,char
		mov	cx,len
		call	endchar
		endm

@ATOI		macro	str
		mov	si,offset str
		call	atoi
		endm

@CLRCURS	macro
		call	clrcurs
		endm

@BIGCURS	macro
		call	bigcurs
		endm

@ITOA		macro	number,str,using
		mov	ax,number
		mov	si,offset str
		mov	cx,using
		call	itoa
		endm

@ISGREEK	macro
		call	isgreek
		endm

@ISENGLISH	macro
		call	isenglish
		endm

@TAKECURSWORD	macro	buffer,end_word_buffer,cursor_position
		mov	si,offset end_word_buffer
		mov	bx,offset buffer
		mov	dx,cursor_position
		call	take_curs_word
		endm

@TOUPPER	macro	buffer
		mov	bx,offset buffer
		call	toupper
		endm

@GREEKAX	macro
		call	greekax
		endm

@UPPERAX	macro
		call	upperax
		endm

@ITOAAX		macro	str,using
		mov	si,offset str
		mov	cx,using
		call	itoa
		endm

@STRCOPY        macro   str1,str2,len
                mov     bx,offset str1
                mov     si,offset str2
		mov	cx,len
                call    strcopy
                endm

@USERBOX	macro	char
		mov	al,char
		call	userbox
		endm

@USERCHAR	macro	char
		mov	al,char
		call	userchr
		endm

@USERATR	macro	char
		mov	al,char
		call	useratr
		endm

@FILLSTR	macro	buffer,char,len
		mov	bx,offset buffer
		mov	al,char
		mov	cx,len
		call	fillstr
		endm

@STRXCHG        macro   str1,str2,len
                mov     bx,offset str1
                mov     si,offset str2
		mov	cx,len
                call    strxchg
                endm

@LOCATE		macro	x,y
		mov	dl,x
		mov	dh,y
		call	locate
		endm

@PRINTS		macro	str
		mov	bx,offset str
		call	prints
		endm

@PRINTC		macro	char
		mov	al,char
		call	printc
		endm

@OPENFILE 	macro	filenum,file,reclen
		mov	dx,offset file
		mov	si,filenum
		mov	cx,reclen
		call	openfile
		endm

@SOUND		macro	met1,met2
		push	cx
		push	bx
		mov	bx,met1
		mov	cx,met2
		call	sound
		pop	bx
		pop	cx
		endm
		
@CREATEFILE 	macro	filenum,file,reclen
		mov	dx,offset file
		mov	si,filenum
		mov	cx,reclen
		call	createfile
		endm

@CLOSEFILE	macro	filenum
		mov	si,filenum
		call	closefile
		endm

@LOADREC	macro	filenum,buffer,recnum
		mov	si,filenum
		mov	dx,offset buffer
		mov	cx,recnum
		call	loadrec
		endm

@SAVEREC	macro	filenum,buffer,recnum
		mov	si,filenum
		mov	dx,offset buffer
		mov	cx,recnum
		call	saverec
		endm


@LOADHEADER	macro	filenum,buffer
		mov	si,filenum
		mov	dx,offset buffer
		call	loadheader
		endm

@SAVEHEADER	macro	filenum,buffer
		mov	si,filenum
		mov	dx,offset buffer
		call	saveheader
		endm

@HEADERFILE	macro	filenum,length
		mov	si,filenum
		mov	word ptr cs:_fileheader[si],length
		endm

.MODEL TINY
.CODE

ORG	100h

start:	jmp	main

old_int_8	dw	?,?
old_int_28	dw	?,?
old_int_9	dw	?,?
old_dta		dw	?,?
old_sp		dw	?
old_ss		dw	?
dos_active	dw	?,?
new_stack	dw	STACK_SIZE dup(?)
cursor_type	dw	?
cursor_pos	dw	?
tsr_busy	dw	?
hot_key		dw	?
tsr_dta		dw	?,?

inter9	proc    far
	push	ax
	pushf
	cli
	call	dword ptr cs:old_int_9
	mov	ah,2
	int	16h
	and	al,5
	cmp	al,5
	jne	exit9
	mov	word ptr [cs:hot_key],1
exit9:	pop	ax
	iret
inter9	endp

inter28	proc	far
	pushf
	cli
	call	dword ptr cs:old_int_28
	cmp	word ptr [cs:hot_key],0
	je	exit28
	cmp	word ptr [cs:tsr_busy],1
	je	exit28
	call	main_int
exit28:	iret
inter28	endp

	dw	CODE

inter8	proc	far
	pushf
	cli
	call	dword ptr cs:old_int_8
	cmp	word ptr [cs:hot_key],0
	je	exit8
	cmp	word ptr [cs:tsr_busy],1
	je	exit8
	push	es
	push	bx
	les	bx,dword ptr cs:dos_active
	cmp	byte ptr [es:bx],0
	jne	exit8b
	call	main_int
exit8b:	pop	bx
	pop	es
exit8:	iret
inter8	endp

main_int proc	near
	mov	word ptr [cs:tsr_busy],1
	push	ax
	cli
	mov	word ptr [cs:old_sp],sp
	mov	word ptr [cs:old_ss],ss
	mov	ax,cs
	mov	ss,ax
	mov	sp,offset cs:new_stack[STACK_SIZE-2]
	sti
	@PUSH
	push	cs
	pop	ds
        @INITSCREEN
	jnc	syn1
	jmp	exit0
exit0:	@POP
	cli
	mov	sp,word ptr [cs:old_sp]
	mov	ss,word ptr [cs:old_ss]
	sti
	pop	ax
	mov	word ptr [cs:hot_key],0
	ret

syn1:	mov	ah,2fh
	int	21h
	mov	old_dta,bx
	mov	old_dta[2],es

	push	ds
	lds	dx,dword ptr cs:tsr_dta
	mov	ah,1ah
	int	21h
	pop	ds

	mov	ah,03h
	mov	bx,word ptr cs:_scrpage
	int	10h
	mov	word ptr cs:cursor_type,cx
	mov	word ptr cs:cursor_pos,dx
	mov	ah,1
	mov	ch,20h
	int	10h
	xor	dx,dx
	mov	ah,02h
	int	10h

;-------------------------------

	call	tsr_proj

;-------------------------------

	mov	ah,1
	mov	cx,cursor_type
	int	10h
	mov	dx,word ptr cs:cursor_pos
	mov	bx,word ptr cs:_scrpage
	mov	ah,02h
	int	10h

	push	ds
	lds	dx,dword ptr cs:old_dta
	mov	ah,1ah
	int	21h
	pop	ds

	@POP
	cli
	mov	sp,word ptr [cs:old_sp]
	mov	ss,word ptr [cs:old_ss]
	sti
	mov	word ptr [cs:hot_key],0
	mov	word ptr [cs:tsr_busy],0
	pop	ax
	ret
main_int endp

;*************************************************
;**						**
;**		  OUR TSR PROCEDURE		**
;**						**
;*************************************************

tsr_proj proc	near
	@BELL
	ret
tsr_proj endp

parametr	db	255 dup(?)

;*************************************************

ESCAPE = 27
LEFT = 75
RIGHT = 77
UP = 72
DOWN = 80
RETURN = 13
TAB = 9
LINE_FEED = 10
BACK_SPACE = 8		

;-----------------------------
; âÄáéêàëãéë âÄêíÄë éáéåÜë
;      úß†©´®ú≠ú† ©´û§
;   £ú´òô¢û´û  cs:sscreen
;   ´¶ segment ´û™ ¶üÊ§û™
;   õ†ò≠¶®ú´†°ò ò§òôú† ´¶
;         Carry Flag
;-----------------------------
;
initscreen proc near
	push	bx
	push	ax
	mov	byte ptr cs:_iscga,0
        mov     ah,0fh
        int     10h
        cmp     al,7
        je      herc
        cmp     al,2
        je      cga
        cmp     al,3
        je      cga
        stc
        ret
herc:   mov     ax,0b000h
        jmp     inret
cga:	mov	byte ptr cs:_iscga,1
	mov     ax,0b800h
	cmp	bh,0
	je	inret
	mov	cl,bh
	mov	ch,0
pagen:	add	ax,4000
	loop	pagen
inret:	mov	word ptr cs:_sscreen,ax
	mov	word ptr cs:_scrpage,bx
	pop	ax
	pop	bx
	clc
        ret
_sscreen dw     ?,?
_scrpage dw	?,?
_iscga	 db	0
initscreen endp
;
initwind proc	near
	mov	word ptr cs:_windPointer,bx
	ret
initwind endp
;	
;-------------------------------------------
;                INVERSE
;      ú†©òö‡öû : ´¶ attribute ©´¶§ ax
; úß†©´®ú≠ú† : ©´¶§ ax ´¶ attribute inverse
;-------------------------------------------
;
inverse proc    near
        push    dx
        push    ax
        and     ah,00001111b
        shl     ah,1
        shl     ah,1
        shl     ah,1
        shl     ah,1
        pop     dx
        and     dh,11110000b
        shr     dh,1
        shr     dh,1
        shr     dh,1
        shr     dh,1
        or      ah,dh
        pop     dx
        ret
inverse endp
;
;-------------------------------------------------------
;      ÄèéáÜâÑìëÜ èÄêÄáìêéì ëÑ ÅUFFER
;  ú†©òö‡öú™ : dh ´¶ ß·§‡ ßú®†ü‡®†¶
;              dl ´¶ ò®†©´ú®¶ ßú®†ü‡®†¶
;              ah ö®ò££ú™ ßò®òü¨®¶¨
;              al ©´û¢ú™ ßò®òü¨®¶¨
;	       bx offset buffer
; úß†©´®‚≠ú† : ©´¶§ òÆ ´o £û°¶™ ´û™ buffer ß¶¨ °ò¢¨Øú
;-------------------------------------------------------
;
getwind	proc near
        push    si
        push    bx
        push    dx
        push    cx
        push    ax
        mov     si,bx 
        xor     cx,cx
        mov     cl,ah
bb1:    pop     ax
        push    ax
        push    cx
        xor     cx,cx
        mov     cl,al
bbb:    call    qtake
        mov     word ptr [bx],ax
        inc     dx
        inc     bx
        inc     bx
        loop    bbb
        pop     cx
        inc     dh
        pop     ax
        push    ax
        sub     dl,al
        loop    bb1
        sub     bx,si
        mov     ax,bx
        pop     ax
        pop     cx
        pop     dx
        pop     bx
        pop     si
        ret
_windlen dw      0
getwind	endp
;
;-------------------------------------------------------
;         âÄäÑëãÄ èÄêÄáìêéì Aèé ÅUFFER
;  ú†©òö‡öú™ : dh ´¶ ß·§‡ ßú®†ü‡®†¶
;              dl ´¶ ò®†©´ú®¶ ßú®†ü‡®†¶
;              ah ö®ò££ú™ ßò®òü¨®¶¨
;              al ©´û¢ú™ ßò®òü¨®¶¨
;	       bx offset buffer
;-------------------------------------------------------
;
delwind	proc near
        push    si
        push    bx
        push    dx
        push    cx
        push    ax
        xor     cx,cx
        mov     cl,ah
cc1:    pop     ax
        push    ax
        push    cx
        mov     si,dx
        xor     cx,cx
        mov     cl,al
ccc:    mov     ax,word ptr [bx]
        call    qprint
        inc     bx
        inc     bx
        inc     dx
        loop    ccc
        mov     dx,si
        inc     dh
        pop     cx
        loop    cc1
        pop     ax
        pop     cx
        pop     dx
        pop     bx
        pop     si
        ret
delwind	endp
;
;-------------------------------------------------------
;         ÉÜãàéìêÇàÄ èÄêÄáìêéì Aèé ÅUFFER
;  ú†©òö‡öú™ : dh ´¶ ß·§‡ ßú®†ü‡®†¶
;              dl ´¶ ò®†©´ú®¶ ßú®†ü‡®†¶
;              ah ö®ò££ú™ ßò®òü¨®¶¨
;              al ©´û¢ú™ ßò®òü¨®¶¨
;	       cl attribute ßò®òü¨®¶¨
;	       di ú†õ¶™ ß¢ò†©†¶¨
;	       bx offset buffer
;-------------------------------------------------------
;
setwind	proc near
        push    bx
        push    si
        push    di
        push    dx
        push    cx
        push    ax
        push    ax
        mov     byte ptr cs:_windAttr,cl
        mov     ah,cl
        mov     si,dx
        xor     cx,cx
        mov     cl,al
        mov     al,byte ptr cs:_boxtype[di]
        call    qprint
        inc     dx
        mov     al,byte ptr cs:_boxtype[di+1]
siz0:   call    qprint
        inc     dx
        loop    siz0
        mov     al,byte ptr cs:_boxtype[di+2]
        call    qprint
        inc     dx
        mov     dx,si
        inc     dh
        mov     si,dx
        pop     ax
        push    ax
        xor     cx,cx
        mov     cl,ah
        mov     word ptr cs:_metrcx,cx
dd1:    pop     ax
        push    ax
        push    cx
        xor     cx,cx
        mov     cl,al
        mov     ah,byte ptr cs:_windAttr
        mov     al,byte ptr cs:_boxtype[di+3]
        call    qprint
        inc     dx
ddd:    mov     al,[bx]
        cmp     al,0
        je      qw13
        cmp     al,1
        je      qw131
        call    qprint
        inc     bx
        inc     dx
        loop    ddd
        jmp     qw12
qw131:  mov     al,[bx-1]
        jmp     ddd3
qw13:   mov     al," "
ddd3:   call    qprint
        inc     dx
        loop    ddd3
        inc     bx
qw12:   mov     ah,byte ptr cs:_windAttr
        mov     al,byte ptr cs:_boxtype[di+3]
        call    qprint
        cmp     cx,word ptr cs:_metrcx
        je      qsex
        inc     dx
	cmp	byte ptr cs:_iscga,0
	je	ishrc1
	cmp	byte ptr cs:_winatr,0
	je	ishrc1
	call	qtake
	mov	ah,byte ptr cs:_winatr
	call	qprint
	inc	dx
	call	qtake
	mov	ah,byte ptr cs:_winatr
	call	qprint
	jmp	qsex
dd111:	jmp	dd1
ishrc1:	mov     al,byte ptr cs:_winchar
	cmp	al,0
	je	qsex
        mov     ah,byte ptr cs:_windAttr
        call    qprint
        inc     dx
        call    qprint
qsex:   mov     dx,si
        inc     dh
        mov     si,dx
        pop     cx
        loop    dd111
        pop     ax
        push    ax
        xor     cx,cx
        mov     cl,al
        mov     ah,byte ptr cs:_windAttr
        mov     al,byte ptr cs:_boxtype[di+4]
        call    qprint
        inc     dx
        mov     al,byte ptr cs:_boxtype[di+1]
siz4:   call    qprint
        inc     dx
        loop    siz4
        mov     ah,byte ptr cs:_windAttr
        mov     al,byte ptr cs:_boxtype[di+5]
        call    qprint
        inc     dx
	cmp	byte ptr cs:_iscga,0
	je	ishrc2
	cmp	byte ptr cs:_winatr,0
	je	ishrc2
	call	qtake
	mov	ah,byte ptr cs:_winatr
	call	qprint
	inc	dx
	call	qtake
	mov	ah,byte ptr cs:_winatr
	call	qprint
	jmp	qsex1
ishrc2:	mov     al,byte ptr cs:_winchar
	cmp	al,0
	je	qsex1
        mov     ah,byte ptr cs:_windAttr
        call    qprint
        inc     dx
        call    qprint
qsex1:  mov     dx,si
        inc     dh
        inc     dx
        inc     dx
        pop     ax
        xor     cx,cx
        mov     cl,al
        inc     cx
        inc     cx
	cmp	byte ptr cs:_iscga,0
	je	ishrc3
	cmp	byte ptr cs:_winatr,0
	je	ishrc3
sd13:	call	qtake
	mov	ah,byte ptr cs:_winatr
	call	qprint
	inc	dx
	loop	sd13
	jmp	pidame
ishrc3: mov     ah,byte ptr cs:_windAttr
        mov     al,byte ptr cs:_winchar
	cmp	al,0
	je	pidame
siz5:   call    qprint
        inc     dx
        loop    siz5
pidame:	pop     ax
        pop     cx
        pop     dx
        pop     di
        pop     si
        pop     bx
        ret
_winchar db	"≤"
_winatr	 db	12h
;
_metrcx  dw      ?
_windAttr db     ?
_boxtype db	"      "
        db	"⁄ƒø≥¿Ÿ"
        db	"…Õª∫»º"
setwind	endp

setbox	proc	near
        push    bx
        push    si
        push    di
        push    dx
        push    cx
        push    ax
	push	cx
        push    ax
	dec	bh
	dec	bl
	mov	ax,di
	mov	cl,6
	mul	cl
	mov	di,ax
	pop	ax
	pop	cx
	mov	al,_boxtype[di]
	call	winddisp
 	add	dh,bh
	mov	al,_boxtype[di+4]
	call	winddisp
	sub	dh,bh
	push	dx
	xor	cx,cx
	mov	cl,bl
	mov	al,_boxtype[di+1]
setb1:	inc	dl
	call	winddisp
	add	dh,bh
	call	winddisp
	sub	dh,bh
	loop	setb1
	mov	al,_boxtype[di+2]
	call	winddisp
	add	dh,bh
	mov	al,_boxtype[di+5]
	call	winddisp
	pop	dx
	xor	cx,cx
	mov	cl,bh
	dec	cx
	mov	al,_boxtype[di+3]
setb2:	inc	dh
	call	winddisp
	add	dl,bl
	call	winddisp
	sub	dl,bl
	loop	setb2		
	pop     ax
        pop     cx
        pop     dx
        pop     di
        pop     si
        pop     bx
        ret
setbox	endp

setbox_popup	proc	near
        push    bx
        push    si
        push    di
        push    dx
        push    cx
        push    ax
	push	cx
        push    ax
	dec	bh
	dec	bl
	mov	ax,di
	mov	cl,6
	mul	cl
	mov	di,ax
	pop	ax
	pop	cx
	mov	al,_boxtype[di]
	call	qprint
 	add	dh,bh
	mov	al,_boxtype[di+4]
	call	qprint
	sub	dh,bh
	push	dx
	xor	cx,cx
	mov	cl,bl
	mov	al,_boxtype[di+1]
psetb1:	inc	dl
	call	qprint
	add	dh,bh
	call	qprint
	sub	dh,bh
	loop	psetb1
	mov	al,_boxtype[di+2]
	call	qprint
	add	dh,bh
	mov	al,_boxtype[di+5]
	call	qprint
	pop	dx
	xor	cx,cx
	mov	cl,bh
	dec	cx
	mov	al,_boxtype[di+3]
psetb2:	inc	dh
	call	qprint
	add	dl,bl
	call	qprint
	sub	dl,bl
	loop	psetb2
	pop     ax
        pop     cx
        pop     dx
        pop     di
        pop     si
        pop     bx
        ret
setbox_popup	endp

dopopup	proc	near
	@PUSH
	mov	cs:_popatr,cl
	push	ax
	mov	ax,di
	mov	cl,6
	div	cl
	mov	di,ax
	pop	ax
	add	ah,1
	push	ax
	mov	cl,2
	shr	al,cl
	mov	cs:_poplx,al
	shr	al,1
	mov	cs:_poppx,al
	shr	ah,cl
	mov	cs:_poply,ah
	shr	ah,1
	mov	cs:_poppy,ah
	pop	cx
	mov	al,cl
	shr	al,1
	mov	cs:_popx,al
	add	cs:_popx,dl
	mov	al,ch
	shr	al,1
	mov	cs:_popy,al
	add	cs:_popy,dh
	mov	cx,4
nextpopcx:
	push	cx
	mov	al,cs:_poppx
	sub	cs:_popx,al
	mov	al,cs:_popx
	mov	cs:_popx1,al
	mov	al,cs:_poppy
	sub	cs:_popy,al
	mov	al,cs:_popy
	mov	cs:_popy1,al
	mov	al,cs:_poplx
	add	cs:_popx1,al
	mov	al,cs:_poply
	add	cs:_popy1,al
	@INITWIND cs:_popx,cs:_popy,cs:_popx1,cs:_popy1,cs:_popatr
	mov	dl,cs:_popx
	mov	dh,cs:_popy
	mov	bl,cs:_poplx
	mov	bh,cs:_poply
	cmp	bl,3
	jb	pida
	cmp	bh,3
	jb	pida
	mov	ah,cs:_popatr
	inc	bl
	inc	bl
	inc	bh
	call	setbox_popup
pida:	mov	al,cs:_poppx
	add	cs:_poplx,al
	add	cs:_poplx,al
	mov	al,cs:_poppy
	add	cs:_poply,al
	add	cs:_poply,al
	mov	dx,1
	call	iwait
	pop	cx
	loop	nextpopcx1
	inc	cs:_popx1
	@INITWIND cs:_popx,cs:_popy,cs:_popx1,cs:_popy1,cs:_popatr
	@POP
	ret
nextpopcx1:	jmp	nextpopcx
_poplx	db	0
_poply	db	0
_popx	db	0
_popy	db	0
_poppx	db	0
_poppy	db	0
_popx1	db	0
_popy1	db	0
_popatr	db	0
dopopup	endp

userbox	proc	near
	@PUSH
	xor	bx,bx
	mov	cx,6
ub0:	mov	byte ptr cs:_boxtype[bx],al
	inc	bx
	loop	ub0
	@POP
	ret
userbox	endp
;
userchr proc	near
	mov	byte ptr cs:_winchar,al
	ret
userchr	endp
;
useratr proc	near
	mov	byte ptr cs:_winatr,al
	ret
useratr	endp
;
;--------------------------------
;   ú†©òö‡öú™ : dh ´¶ y
;               dl ´¶ x
;  úß†©´®ú≠ú† : ah ´¶ attribute
;	        al o Æò®ò°´û®ò™
;--------------------------------
;
qtake   proc    near
        push    si
        call    scrOffset
        push    ds
        push    ax
        mov     ax,word ptr cs:_sscreen
        mov     ds,ax
        pop     ax
        mov     ax,word ptr [si]
        pop     ds
        pop     si
        ret
qtake   endp
;
;------------------------------
;       INVERSE STRING
;   ú†©òö‡öú™ : dh ´¶ Æ
;               dl ´¶ y
;               cx ß¶©ò byte
;------------------------------
;
winvstr	proc    near
        push    si
        push    dx
        push    ax
        push    cx
invnxt:	call    windtake
        call    inverse
        call    winddisp
        inc     dx
        loop    invnxt
        pop     cx
        pop     ax
        pop     dx
        pop     si
        ret
winvstr endp
;
;--------------------------------
;   ú†©òö‡öú™ : dh ´¶ y
;               dl ´¶ x
;  	        ah ´¶ attributr
;	        al o Æò®ò°´û®ò™
;--------------------------------
;
qprint  proc    near
        push    si
        call    scrOffset
        push    ds
        push    ax
        mov     ax,word ptr cs:_sscreen
        mov     ds,ax
        pop     ax
        mov     word ptr [si],ax
        pop     ds
        pop     si
        ret
qprint  endp
;
;--------------------------------
;         OFFSET OáéåÜë
;   ú†©òö‡öú™ : dh ´¶ y
;               dl ´¶ x
;  	        ah ´¶ attribute
;	        al o Æò®ò°´û®ò™
;--------------------------------
;
scroffset proc near
        push    dx
        push    ax
        push    cx
        push    dx
        xor     ax,ax
        mov     al,dh
        mov     cl,160
        mul     cl
        mov     si,ax
        pop     dx
        mov     dh,0
        rol     dx,1
        add     si,dx
        pop     cx
        pop     ax
        pop     dx
        ret
scroffset endp
;
;---------------------------------------
; ÉÜãàéìêÇàÄ èÄêÄáìêéì Äèé BUFFER
;     ú†©òö‡öú™ : bx buffer
;    ´ò ß®‡´ò 6 bytes ú†§ò† :
;         1o     x
;         2o     y
;         3o     ö®ò££ú™
;         4¶     ©´û¢ú™
;         5o     attribute
;         6o     ß¢ò†©†¶
; °ò¢ú† ´û§ get_window °ò† òß¶üû°ú¨ú†
;   ´û§ ¶ü¶§û °ò´‡ òß¶ ´¶ ßò®òü¨®¶
;     ©´o§ ß†§ò°ò windows_buffer
;---------------------------------------
;
windmake proc    near
        push    cx
        push    ax
        push    dx
        push    bx
        inc     word ptr cs:_windMetr
        xor     ax,ax
        mov     al,[bx+5]
	xor     dx,dx
        mov     cx,6
        mul     cx
        mov     di,ax
	mov     dl,[bx]
        mov     dh,[bx+1]
        mov     al,[bx+2]
        mov     ah,[bx+3]
        mov     cl,[bx+4]
        add     bx,6
        push    bx
        push    ax
        mov     bx,word ptr cs:_windPointer
        add     ax,0000001100000100b
        call    getwind
        add     bx,ax
        mov     word ptr [bx],ax
        mov     word ptr [bx+2],dx
        pop     ax
        mov     word ptr [bx+4],ax
        add     bx,6
        mov     word ptr cs:_windPointer,bx
        pop     bx
        call    setwind
        pop     bx
        pop     dx
        pop     ax
        pop     cx
        ret
_windPointer	dw	0
_windMetr	dw	0
windmake endp
;
;------------------------------------------
; ÉÜãàéìêÇàÄ èÄêÄáìêéì 'POP UP' Äèé BUFFER
;     ú†©òö‡öú™ : bx buffer
;    ´ò ß®‡´ò 6 bytes ú†§ò† :
;         1o     x
;         2o     y
;         3o     ö®ò££ú™
;         4¶     ©´û¢ú™
;         5o     attribute
;         6o     ß¢ò†©†¶
; °ò¢ú† ´û§ get_window °ò† òß¶üû°ú¨ú†
;   ´û§ ¶ü¶§û °ò´‡ òß¶ ´¶ ßò®òü¨®¶
;     ©´o§ ß†§ò°ò windows_buffer
;---------------------------------------
;
popmake	proc    near
        push    cx
        push    ax
        push    dx
        push    bx
        inc     word ptr cs:_windMetr
        xor     ax,ax
        mov     al,[bx+5]
	xor     dx,dx
        mov     cx,6
        mul     cx
        mov     di,ax
	mov     dl,[bx]
        mov     dh,[bx+1]
        mov     al,[bx+2]
        mov     ah,[bx+3]
        mov     cl,[bx+4]
        add     bx,6
        push    bx
        push    ax
        mov     bx,word ptr cs:_windPointer
        add     ax,0000001100000100b
        call    getwind
        add     bx,ax
        mov     word ptr [bx],ax
        mov     word ptr [bx+2],dx
        pop     ax
        mov     word ptr [bx+4],ax
        add     bx,6
        mov     word ptr cs:_windPointer,bx
        pop     bx
	call	dopopup
        call    setwind
        pop     bx
        pop     dx
        pop     ax
        pop     cx
        ret
popmake endp
;
;------------------------------------
;  °¢ú†§ú† ´¶ ´ú¢ú¨´ò†¶ ßò®òü¨®¶
;     ß¶¨ õû£†¶¨®öûüû°ú £ú ´û§
;              windmake
; ò§òôú† ´¶ carry ¶´ò§ õú§ ¨ßò®Æú†
;          ò¢¢¶ ßò®òü¨®¶
;------------------------------------
;
winddel proc    near
        push    si
        push    dx
        push    ax
        push    bx
        cmp     word ptr cs:_windMetr,0
        jbe     windcarry
        dec     word ptr cs:_windMetr
        mov     bx,word ptr cs:_windPointer
        mov     ax,word ptr [bx-2]
        mov     dx,word ptr [bx-4]
        mov     si,word ptr [bx-6]
        add     si,6
        sub     bx,si
        add     ax,0000001100000100b  ;ah+3,al+4
        call    delwind
        mov     word ptr cs:_windPointer,bx
        pop     bx
        pop     ax
        pop     dx
        pop     si
        clc
        ret
windcarry:
        pop     bx
        pop     ax
        pop     dx
        pop     si
        stc
        ret
winddel endp
;
;--------------------------
;  ëÅìåÑà éäÄ íÄ èÄêÄáìêÄ
;--------------------------
;
winddelall proc	near
wdep:	call	winddel
	jc	wdout
	jmp	wdep
wdout:	ret
winddelall endp
;
;-----------------------------------------
;      ©¨§´ú´òö£ú§ú™ ßò®òü¨®¶¨
;  ú†©òö‡öû : dx ©¨§´ú´òö£ú§ú™ ßò®òü¨®¶¨
; úß†©®ú≠ú† : dx ©¨§´ú´òö£ú§ú™ ¶ü¶§û™
;-----------------------------------------
;
windcurs proc    near
        push    bx
        push    ax
        mov     bx,word ptr cs:_windPointer
        mov     ax,word ptr [bx-4]
        add     dx,ax
        pop     ax
        pop     bx
        ret
windcurs endp
;
winddisp proc  near
        push    dx
        call    windcurs
        call    qprint
        pop     dx
        ret
winddisp endp
;
windtake proc   near
        push    dx
        call    windcurs
        call    qtake
        pop     dx
        ret
windtake endp

windprint proc  near
        push    ax
        push    dx
        push    bx
        push    cx
	mov	cs:_wpatr,al
        mov     cx,dx
	call    windtake
	or	ah,cs:_wpatr
wpep:	mov     al,[bx]
        cmp     al,0
        je      wpout
        cmp     al,13
        jne     wpn13
        mov     dl,cl
        inc     bx
        jmp     wpep
wpn13:  cmp     al,10
        jne     wpn10
        inc     dh
        inc     bx
        jmp     wpep
wpn10:	call    winddisp
        inc     bx
        inc     dx
        jmp     wpep
wpout:  pop     cx
        pop     bx
        pop     dx
        pop     ax
        ret
_wpatr	db	0
windprint endp

windinput proc    near
	push	cx
        push    dx
        push    bx
	call	windprint
        xor     cx,cx
wip2:	cmp     byte ptr [bx],0
        je      wip1
        inc     bx
        inc     cx
        jmp     wip2
winpojo:
	pop	bx
	pop	dx
	pop	cx
	ret
wip1:	cmp	cx,0
	je	winpojo
	cmp	cx,79
	ja	winpojo
	pop     bx
        push    bx
        call    winvstr
wpali:  call    curswait
	cmp	al,0
	je	@@@9
	jmp	@@@1
@@@9:	cmp	ah,LEFT
	jne	nleft
	pop	ax
        push    ax
        cmp     bx,ax
        jbe     wpali
        call    windtake
        mov     al,[bx]
        call    winddisp
        dec     bx
        dec     dx
        jmp     wpali
wendp:	call	bell
	jmp	wpali
nleft:	cmp	ah,RIGHT
	jne	w@@1
	cmp	byte ptr [bx],0
	je	wendp
	inc	dx
	inc	bx
	jmp	wpali
w@@1:	jmp	went
@@@1:   cmp     al,BACK_SPACE
	jne	@1
        jmp     wdelw
@1:     cmp     al,RETURN
	jne	@22
	xor	ax,ax
        jmp     went
@22:	cmp	al,ESCAPE
	jne	@3
	jmp	went2
@3:	cmp     byte ptr [bx],0
        je      wendp
        cmp     al,32
        jb      wpali
        cmp     al,254
        ja      wpali
        mov     [bx],al
        call    windtake
        mov     al,[bx]
        call    winddisp
        inc     bx
        inc     dx
        jmp     wpali
wdelw:  pop     ax
        push    ax
        cmp     bx,ax
        jbe     wpali
        dec     bx
        dec     dx
        call    windtake
        mov     al," "
        call    winddisp
        mov     byte ptr [bx]," "
        jmp     wpali
went:	mov	word ptr cs:_curs_pos,dx
	push	ax
	call    windtake
        mov     al,[bx]
        call    winddisp
	pop	ax
        pop     bx
        pop     dx
        call    winvstr
	pop	cx
	mov	dx,word ptr cs:_curs_pos
	clc
        ret
went2:	push	ax
	call    windtake
        mov     al,[bx]
        call    winddisp
	pop	ax
        pop     bx
        pop     dx
        call    winvstr
	pop	cx
	stc
        ret
_curs_pos	dw	0
windinput endp
;
windinputnum proc near
wnpal1: push    bx
        call    windinput
wnum0:  cmp     byte    ptr [bx],0
        je      wnout
	cmp	byte ptr [bx]," "
	je	wnl1
	cmp     byte ptr [bx],"0"
        jb      wnpal
        cmp     byte ptr [bx],"9"
        ja      wnpal
wnl1:   inc     bx
        jmp     wnum0
wnpal:  push    cx
wsasa:  mov     byte    ptr [bx]," "
        inc     bx
        loop    wsasa
        mov     byte ptr [bx],0
        pop     cx
        pop     bx
	call	bell
        jmp     wnpal1
wnout:  pop     bx
        ret
windinputnum endp
;
;------------------------
;    °®¨ôú† ´¶§ cursor
;------------------------
;
clrcurs proc    near
        push    ax
        push    cx
        push    bx
        mov     ah,1
        mov     ch,20h
        int     10h
        pop     bx
        pop     cx
        pop     ax
        ret
clrcurs endp
;
;------------------------
;  £úöò¢‡§ú† ´¶§ cursor
;------------------------
;
bigcurs proc    near
        push    ax
        push    cx
        mov     ah,1
        mov     ch,3
        mov     cl,7
        int     10h
        pop     cx
        pop     ax
        ret
bigcurs endp
;
;-----------------------------------------
;  ò§ò£¶§û ©¨ö°ú°®†£ú§¶¨ Æ®¶§¶¨
;     °ò† õ†ò°¶ßû £ú ß¢û°´®¶
;  ú†©òö‡öû : dx Æ®¶§¶™ ©ú õú°ò´ò
; úß†©´®¶≠û : ò§òôú† ´¶ carry flag 
;	      ò§ ßò´ûüú† °òß¶†¶ ß¢û°´®¶
;	      °ò† úß†©´®ú≠ú† ©´¶§ ax
;-----------------------------------------
;
iwait   proc    near
        push    ax
        push    cx
        push    bx
        push    dx
        push    ds
        mov     ax,40h
        mov     ds,ax
        mov     ax,dx
        xor     dx,dx
        mov     cx,18
        mul     cx
        mov     cx,10
        div     cx
        mov     cx,ax
        add     cx,word ptr ds:6ch
        jnc     waitmore
        mov     cx,65535
waitmore:
        mov     ax,word ptr ds:6ch
        cmp     ax,cx
        jae     waitstop
        mov     ah,01h
        int     16h
        jne     waitbreak
        jmp     waitmore
waitstop:
        pop     ds
        pop     dx
        pop     bx
        pop     cx
        pop     ax
        clc
        ret
waitbreak:
        pop     ds
        pop     dx
        pop     bx
        pop     cx
        pop     ax
        mov     ah,0
        int     16h
        mov     word ptr cs:_switch,ax
        stc
        ret
_switch  dw      0
iwait   endp
;
curswait proc   near
curs0:  call    windtake
	call	inverse
;        mov     al,"ﬁ"
        call    winddisp
	push	dx
        mov	dx,2
	call	iwait
	pop	dx
        jc      cej
        call    windtake
;        mov     al,[bx]
	call	inverse
        call    winddisp
	push	dx
        mov	dx,2
	call	iwait
	pop	dx
        jc      cej1
        jmp     curs0
cej:	push    ax
        call    windtake
	call	inverse
        mov     al,[bx]
        call    winddisp
	pop     ax
cej1:   ret
curswait endp
;
getkey  proc    near
        mov     ah,0
        int     16h
        cmp     al,0
        je      rtr
        cmp     al,"a"
        jb      rtr
        cmp     al,"z"
        ja      rtr
        sub     al,"a"-"A"
rtr:    ret
getkey  endp

upperax	proc	near
        cmp     al,0
        je      rtrt
        cmp     al,"a"
        jb      rtrt
        cmp     al,"z"
        ja      rtrt
        sub     al,"a"-"A"
rtrt:   ret
upperax	endp

;
;------------------------------------------
;     £ú´ò´®¶ßû ascii si ©ú ò°ú®ò†¶
;------------------------------------------
;
atoi	proc   near
        push    bx
        push    si
        push    cx
        xor     bx,bx
numepom:
        mov     al,byte ptr [si]
        cmp     al,0
        je      numout
        sub     al,30h
        jl      numout
        cmp     al,9
        jg      numout
        cbw
        xchg    ax,bx
        mov     cx,10
        mul     cx
        xchg    ax,bx
        add     bx,ax
        inc     si
	jmp     numepom
numout: mov     ax,bx
        pop     cx
        pop     si
        pop     bx
        ret
atoi	endp
;
;------------------------------------------
;   £ú´ò´®¶ßû ò°ú®ò†¶¨ ax ©´¶ ascii si
;              £ú £û°¶™ cx
;------------------------------------------
;
itoa	proc   near
	push	bx
        push    si
        push    cx
	push	dx
	push	ax
	push	cx
itoa2:	mov	byte ptr [si]," "
	inc	si
	loop	itoa2
	mov	byte ptr [si],0
	dec	si
	pop	cx
itoa1:	xor	dx,dx
	mov	bx,10
	div	bx
	add	dl,30h
	mov	[si],dl
	cmp	ax,0
	je	itend
	dec	si
	loop	itoa1
itend:	pop	ax
	pop	dx
        pop     cx
        pop     si
	pop	bx
        ret
itoa	endp
;
;-----------------------------------------
; öú£†ùú† ´û§ ¶ü¶§û £ú ´¶§ Æò®ò°´û®ò al
;         °ò† ´¶ attribute ah
;-----------------------------------------
;
fillscr proc   near
	push	dx
	push	cx
	push	ax
        xor     dx,dx
        mov     cx,25
ms2:    push    cx
        mov     cx,80
ms1:    call    qprint
        inc     dx
        loop    ms1
        pop     cx
        inc     dh
        mov     dl,0
        loop    ms2
	pop	ax
	pop	cx
	pop	dx
        ret
fillscr endp
;
;---------------------------------------
;   ò§´†ö®ò≠ú† ú§ò string ©ú ú§ò ò¢¢¶
;   ú†©¶õ¶™ : bx 1o string
;	      si 2o string
;---------------------------------------
;
strcpy  proc    near
        push    ax
        push    si
        push    bx
stp0:   cmp     byte ptr [si],0
        je      stpout
        mov     al,[bx]
        cmp     al,0
        je      stpoul
        mov     [si],al
        inc     bx
        inc     si
        jmp     stp0
stpoul: mov     byte ptr [si]," "
        inc     si
        cmp     byte ptr [si],0
        je      stpout
        jmp     stpoul
stpout: pop     bx
        pop     si
        pop     ax
        ret
strcpy  endp
;
strcopy proc    near
	push	cx
        push    ax
        push    si
        push    bx
stp01:	mov     al,[bx]
        mov     [si],al
        inc     bx
        inc     si
        loop	stp01
	pop     bx
        pop     si
        pop     ax
	pop	cx
        ret
strcopy endp
;
strxchg	proc    near
	push	cx
        push    ax
        push    si
        push    bx
stpx1:	mov     al,[bx]
	mov	ah,[si]
        mov     [si],al
	mov	[bx],ah
        inc     bx
        inc     si
        loop	stpx1
	pop     bx
        pop     si
        pop     ax
	pop	cx
        ret
strxchg	endp
;
;-----------------------------------
;      ©¨ö°®†©û 2 string 
; ú†©òö‡öú™ : bx 1o string
;	      si 2o string
;
; úò§ ú†§ò† †©ò cf -> 0
; úò§ 1¶>2¶     cf -> 1 , ax=1
; úò§ 1¶<2¶     cf -> 1 , ax=0
;-----------------------------------
;
strcmp  proc    near
        push    ax
        push    si
        push    bx
stc0:   cmp     byte ptr [si],0
        je      stcout
        mov     al,[bx]
        cmp     al,0
        je      stcout
        cmp     [si],al
	je	stiso
	ja	stmax
	jmp	stmin
stiso:  inc     bx
        inc     si
        jmp     stc0
stcout: pop     bx
        pop     si
        pop     ax
	clc
        ret
stmax:	pop     bx
        pop     si
        pop     ax
	mov	ax,1
	stc
        ret
stmin:	pop     bx
        pop     si
        pop     ax
	mov	ax,0
	stc
        ret
strcmp  endp
;
fillstr	proc	near
	@PUSH
fst01:	mov	byte ptr [bx],al
	inc	bx
	loop	fst01
	mov	byte ptr [bx],0
	@POP
	ret
fillstr	endp
;
asciiz	proc	near
	@PUSH
	push	bx
chz0:	cmp	byte ptr [bx],0
	je	chz1
	inc	bx
	jmp	chz0
chz1:	dec	bx
	cmp	byte ptr [bx]," "
	jne	chzout
	pop	ax
	push	ax
	cmp	bx,ax
	je	chzer
	jmp	chz1
chzout:	mov	byte ptr [bx+1],0
	pop	ax
	@POP
	ret
chzer:	pop	ax
	@POP
	stc
	ret
asciiz	endp
;
endchar	proc	near
	@PUSH
@nxt:	cmp	byte ptr [bx]," "
	jae	@isok
	mov	byte ptr [bx]," "
@isok:	inc	bx
	loop	@nxt
	mov	byte ptr [bx],dl
	@POP
	ret
endchar	endp
;
take_curs_word proc	near
	push	si
	push	dx
	push	ax
	push	bx
	mov	word ptr cs:save_si,si
next0:	call	windtake
	cmp	al,32
	jbe	brika_arxi
	cmp	al,176
	jb	check_users
	cmp	al,224
	jb	brika_arxi
	cmp	al,234
	jbe	check_users
	jmp	brika_arxi
check_users:
	mov	si,word ptr cs:save_si
next2:	cmp	al,byte ptr [si]
	je	brika_arxi
	cmp	byte ptr [si],0
	je	next1
	inc	si
	jmp	next2
next1:	cmp	dl,0
	jbe	brika_0
	dec	dx
	jmp	next0

brika_arxi:

next3:	inc	dx

brika_0:
	call	windtake
	cmp	al,32
	jbe	brika_telos
	cmp	al,176
	jb	check_users1
	cmp	al,224
	jb	brika_telos
	cmp	al,234
	jbe	check_users1
	jmp	brika_telos
check_users1:
	mov	si,word ptr cs:save_si
next4:	cmp	al,byte ptr [si]
	je	brika_telos
	cmp	byte ptr [si],0
	je	next5
	inc	si
	jmp	next4
next5:	mov	byte ptr [bx],al
	cmp	dl,79
	jae	brika_telos
	inc	bx
	jmp	next3
brika_telos:
	mov	byte ptr [bx],0
	pop	bx
	pop	ax
	pop	dx
	pop	si
	ret
save_si	dw	?
take_curs_word endp
;
isenglish proc	near
	cmp	al,"A"
	jb	ieexit
	cmp	al,"Z"
	jbe	ieok
	cmp	al,"a"
	jb	ieexit
	cmp	al,"z"
	jbe	ieok
ieexit:	stc
	ret
ieok:	clc
	ret
isenglish endp
;
isgreek	proc	near
	cmp	al,128	;"A"
	jb	igexit
	cmp	al,175	;"z"
	jbe	igok
	cmp	al,224	;"‡"
	jb	igexit
	cmp	al,234	;"ó"
	jbe	igok
igexit:	stc
	ret
igok:	clc
	ret
isgreek	endp
;
toupper	proc	near
	push	ax
	push	bx
	push	cx
	push	si
upnext:	mov	al,byte ptr [bx]
	cmp	al,0
	je	upexit
	cmp	al,97	; "a"
	jb	upinc
	cmp	al,122
	ja	upgr
	sub	al,"a"-"A"
upinc:	mov	byte ptr [bx],al
	inc	bx
	jmp	upnext
upexit:	pop	si
	pop	cx
	pop	bx
	pop	ax
	ret
upgr:	cmp	al,152
	jb	upinc
	cmp	al,170
	jae	grek_style
	sub	al,152-128
	jmp	upinc
grek_style:
	xor	si,si
	mov	cx,16
other1:	cmp	al,byte ptr cs:_uptable[si]
	jne	other
	mov	al,byte ptr cs:_uptable[si+16]
	jmp	upinc
other:	inc	si
	loop	other1
	jmp	upinc
_uptable db	"™´¨≠ÆØ‡·‚„Â‰ÈÊÁË"
	db	"ëíìîïñóÄÑÜààóéìì"
toupper	endp

greekax	proc	near
	push	cx
	push	si
	cmp	al," "
        jb      _ep2
        cmp     al,126
        ja      _ep2
	mov	si,offset cs:engl
	mov	cx,24
_ep1:	cmp	al,byte ptr cs:[si]
	je	_ep3
	inc	si
	loop	_ep1
	jmp	_ep2
_ep3:	add	si,24
	mov	al,byte ptr cs:[si]
	jmp	_ep2
engl	db	"ABGDEZHUIKLMNJOPRSTYFXCV"
	db	"ÄÅÇÉÑÖÜáàâäãåçéèêëíìîïñó"
_ep2:	pop	si
	pop	cx
	ret
greekax	endp

;---------------------
;        BELL
;---------------------
;
bell	proc	near
	push	ax
	mov	al,7
	mov	ah,0eh
	int	10h
	pop	ax
	ret
bell	endp
;
locate	proc	near
	push	dx
	mov	word ptr cs:_locat_xy,dx
	pop	dx
	ret
_locat_xy dw	0
_tabshm	db	0
locate	endp
;
prints	proc	near
	@PUSH
ps01:	mov	al,[bx]
	cmp	al,0
	je	psout
	call	printc
	inc	bx
	jmp	ps01
psout:	@POP
	ret
prints	endp
;
printc	proc	near
	@PUSH
	mov	dx,word ptr cs:_locat_xy
	cmp	al,LINE_FEED
	jne	ch1
	inc	dh
	cmp	dh,25
	jb	pc02
	xor	dx,dx
	jmp	pcout
pc02:	jmp	pcout
ch1:	cmp	byte ptr cs:_tabshm,0
	je	ch5
	mov	dl,al
	mov	byte ptr cs:_tabshm,0
	jmp	pcout
ch5:	cmp	al,TAB
	jne	ch2
	mov	byte ptr cs:_tabshm,1
	jmp	pcout
ch2:	cmp	al,BACK_SPACE
	jne	ch4
	cmp	dl,0
	je	ch01
	dec	dl
	jmp	pcout
ch01:	cmp	dh,0
	je	pc03
	dec	dh
	mov	dl,79
pc03:	jmp	pcout
ch4:	cmp	al,RETURN
	jne	ch3
	mov	dl,0
	jmp	pcout
ch3:	push	ax
	call	qtake
	pop	cx
	mov	al,cl
	call	qprint
	inc	dl
	cmp	dl,79
	jb	pc01
	inc	dh
	mov	dl,0
	cmp	dh,25
	jb	pc01
	xor	dx,dx
pcout:
pc01:	mov	word ptr cs:_locat_xy,dx
	@POP
	ret
printc	endp

sound	proc	near
	push	ax
	push	bx
	push	cx
        in      al,61h
        and     al,0fch
pulse:	push	cx
	xor     al,2
        out     61h,al
s199:	loop	s199
	pop	cx
        dec     bx
        jnz     pulse
        and     al,0fch
        out     61h,al
	pop	cx
	pop	bx
	pop	ax
	ret
sound	endp

;
;
;-------------------- FILES
;
openfile proc	near
	@PUSH
	mov	word ptr cs:_reclen[si],cx
	mov	word ptr cs:_rrecord[si],0
	mov	al,I_RW
	mov	ah,3dh
	int	21h
	jc	nfound
	mov	word ptr cs:_handle[si],ax
	@POP
	clc
	ret
nfound:	@POP
	stc
	ret
openfile endp
;
createfile proc	near
	@PUSH
	mov	word ptr cs:_reclen[si],cx
	mov	word ptr cs:_rrecord[si],0
	mov	cx,0
	mov	ah,3ch
	int	21h
	jc	icant
	mov	word ptr cs:_handle[si],ax
	@POP
	clc
	ret
icant:	@POP
	stc
	ret
_handle	dw	10 dup(0)
_rrecord dw	10 dup(0)
_reclen	dw	10 dup(0)
_fileheader dw	10 dup(0)
createfile endp
;
closefile proc	near
	@PUSH
	mov     bx,_handle[si]
	mov     ah,3eh
	int     21h
	jc	clerr
	@POP
	clc
	ret
clerr:	@POP
	stc
	ret
closefile endp
;
gorec	proc	near
	@PUSH
	cmp	cx,0
	je	grpas
	cmp	cx,32500
	jbe	grr1
	jmp	grerr
grr1:	mov	ax,word ptr cs:_rrecord[si]
	mov	word ptr cs:_rrecord[si],cx
	cmp	ax,cx
	ja	grmax
	sub	cx,ax
	cmp	cx,0
	ja	grmin
	jb	grerr
	jmp	grok
grpas:	jmp	grout
grmax:	xor	dx,dx
	mov	ax,cs:_reclen[si]
	mul	cx
	@MOVEFP	_handle[si],dx,ax,I_BEG
	jc	grerr
	mov	ax,cs:_fileheader[si]
	@MOVEFP _handle[si],0,ax,I_CUR
	jc	grerr
	@POP
	clc
	ret
grmin:	xor	dx,dx
	mov	ax,cs:_reclen[si]
	mul	cx
	@MOVEFP	_handle[si],dx,ax,I_CUR
	jc	grerr
grok:	@POP
	clc
	ret
grerr:	mov	ax,cs:_fileheader[si]
	@MOVEFP	_handle[si],0,ax,I_BEG
	mov	word ptr cs:_rrecord[si],0
	@POP
	stc
	ret
grout:	mov	ax,cs:_fileheader[si]
	@MOVEFP	_handle[si],0,ax,I_BEG
	jc	grerr
	mov	word ptr cs:_rrecord[si],0
	@POP
	clc
	ret
gorec	endp
;
loadrec	proc	near
	@PUSH
	mov	ax,word ptr cs:_reclen[si]
	call	gorec
	jc	rderr
	xchg	ax,cx
	mov	bx,_handle[si]
	mov	ah,3fh
	int	21h
	jc	rderr
	cmp	ax,0
	je	rderr
	@POP
	inc	word ptr cs:_rrecord[si]
	clc
	ret
rderr:	mov	cx,0
	call	gorec
	@POP
	stc
	ret
loadrec	endp
;
saverec	proc	near
	@PUSH
	mov	ax,word ptr cs:_reclen[si]
	call	gorec
	jc	sverr
	xchg	ax,cx
	mov	bx,_handle[si]
	mov	ah,40h
	int	21h
	jc	sverr
	cmp	ax,0
	je	sverr
	@POP
	inc	word ptr cs:_rrecord[si]
	clc
	ret
sverr:	mov	cx,0
	call	gorec
	@POP
	stc
	ret
saverec	endp
;
loadheader proc	near
	@PUSH
	@PUSH
	mov	word ptr cs:_rrecord[si],65535
	@MOVEFP	_handle[si],0,0,I_BEG
	@POP
	jc	rderh
	mov	cx,word ptr cs:_fileheader[si]
	mov	bx,_handle[si]
	mov	ah,3fh
	int	21h
	jc	rderh
	cmp	ax,0
	je	rderh
	@POP
	clc
	ret
rderh:	@POP
	stc
	ret
loadheader endp
;
saveheader proc	near
	@PUSH
	@PUSH
	mov	word ptr cs:_rrecord[si],65535
	@MOVEFP	_handle[si],0,0,I_BEG
	@POP
	jc	sverh
	mov	cx,word ptr cs:_fileheader[si]
	mov	bx,_handle[si]
	mov	ah,40h
	int	21h
	jc	sverh
	cmp	ax,0
	je	sverh
	@POP
	clc
	ret
sverh:	@POP
	stc
	ret
saveheader endp

here	label	near

main	proc	near
        cmp     byte ptr ds:[128],0
        ja      take_parameters
help:   mov     dx,offset helpmsg
        mov     ah,09h
        int     21h
	mov	ah,4ch
	int	21h

take_parameters:
	mov	si,0
	mov	cx,35
        mov     bx,130
next:   mov     al,[bx]
	cmp	al,13
	je	start_init
	mov	byte ptr parametr[si],al
	inc	bx
	inc	si
	loop	next
	jmp	help

start_init:
	push	cs
	pop	ds
	mov	ah,35h
	mov	al,08h
	int	21h
	cmp	word ptr es:[bx-2],CODE
	jne	den_yparxei
	mov	dx,offset message
	mov	ah,9
	int	21h
	mov	ah,4ch
	int	21h
den_yparxei:
	mov	tsr_busy,0
	mov	hot_key,0
	mov	old_int_8,bx
	mov	old_int_8[2],es
	mov	dx,offset inter8
	mov	ah,25h
	mov	al,08h
	int	21h

	mov	ah,35h
	mov	al,9h
	int	21h
	mov	old_int_9,bx
	mov	old_int_9[2],es
	mov	dx,offset inter9
	mov	ah,25h
	mov	al,9h
	int	21h

	mov	ah,35h
	mov	al,28h
	int	21h
	mov	old_int_28,bx
	mov	old_int_28[2],es
	mov	dx,offset inter28
	mov	ah,25h
	mov	al,28h
	int	21h

	mov	ah,34h
	int	21h
	mov	dos_active,bx
	mov	dos_active[2],es
	mov	ah,62h
	int	21h
	mov	tsr_dta,80h
	mov	tsr_dta[2],bx
	mov	dx,offset message
	mov	ah,9
	int	21h
	mov	dx,offset here
	int	27h
main	endp

message	db	" …ÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕª",10,13
	db	" ∫                     Ctrl + Éú•†Ê Shift ö†ò ú§ú®ö¶ß¶Âû©û  ∫",10,13
	db	" ∫               @1990  èòßòõÊß¶¨¢¶™  äú‡§Âõò™              ∫",10,13
	db	" »ÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕº",10,13,"$"

helpmsg db	"  Æ®„©û  :  SoftHelp  [ ò®ÆúÂ¶ ú§û£‚®‡©û™ ]  ",10,13,"$"

	end	start
	end
