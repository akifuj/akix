; hello-os
; TAB=4

CYLS	EQU	10

		ORG		0x7c00
		
; �ȉ��͕W���I��FAT12�t�H�[�}�b�g�t���b�s�[�f�B�X�N�̂��߂̋L�q

		JMP		entry
		DB		0x90
		DB		"HELLOIPL"		; �u�[�g�Z�N�^�̖��O�����R�ɏ����Ă悢�i8�o�C�g�j
		DW		512				; 1�Z�N�^�̑傫���i512�ɂ��Ȃ���΂����Ȃ��j
		DB		1				; �N���X�^�̑傫���i1�Z�N�^�ɂ��Ȃ���΂����Ȃ��j
		DW		1				; FAT���ǂ�����n�܂邩�i���ʂ�1�Z�N�^�ڂ���ɂ���j
		DB		2				; FAT�̌��i2�ɂ��Ȃ���΂����Ȃ��j
		DW		224				; ���[�g�f�B���N�g���̈�̑傫���i���ʂ�224�G���g���ɂ���j
		DW		2880			; ���̃h���C�u�̑傫���i2880�Z�N�^�ɂ��Ȃ���΂����Ȃ��j
		DB		0xf0			; ���f�B�A�̃^�C�v�i0xf0�ɂ��Ȃ���΂����Ȃ��j
		DW		9				; FAT�̈�̒����i9�Z�N�^�ɂ��Ȃ���΂����Ȃ��j
		DW		18				; 1�g���b�N�ɂ����̃Z�N�^�����邩�i18�ɂ��Ȃ���΂����Ȃ��j
		DW		2				; �w�b�h�̐��i2�ɂ��Ȃ���΂����Ȃ��j
		DD		0				; �p�[�e�B�V�������g���ĂȂ��̂ł����͕K��0
		DD		2880			; ���̃h���C�u�傫����������x����
		DB		0,0,0x29		; �悭�킩��Ȃ����ǂ��̒l�ɂ��Ă����Ƃ����炵��
		DD		0xffffffff		; ���Ԃ�{�����[���V���A���ԍ�
		DB		"HELLO-OS   "	; �f�B�X�N�̖��O�i11�o�C�g�j
		DB		"FAT12   "		; �t�H�[�}�b�g�̖��O�i8�o�C�g�j
		RESB	18				; �Ƃ肠����18�o�C�g�����Ă���

; �v���O�����{��

entry:
	mov	ax,0
	mov	ss,ax
	mov	sp,0x7c00
	mov	ds,ax

; �f�B�X�N��ǂ�

	mov	ax,0x0820
	mov	es,ax
	mov	ch,0
	mov	dh,0
	mov	cl,2
readloop:
	mov	si,0
retry:
	mov	ah,0x02
	mov	al,1
	mov	bx,0
	mov	dl,0x00
	int	0x13
	jnc	next
	add	si,1
	cmp	si,5
	jae	error
	mov	ah,0x00
	mov	dl,0x00
	int	0x13
	jmp	retry
next:
	mov	ax,es
	add	ax,0x0020
	mov	es,ax
	add	cl,1
	cmp	cl,18
	jbe	readloop
	mov	cl,1
	add	dh,1
	cmp	dh,2
	jb	readloop
	mov	dh,0
	add	ch,1
	cmp	ch,CYLS
	jb	readloop

	mov	[0x0ff0],ch
	jmp	0xc200

error:
	mov	si,msg
putloop:
	mov	al,[si]
	add	si,1
	cmp	al,0
	je	fin
	mov	ah,0x0e
	mov	bx,15
	int	0x10
	jmp	putloop
fin:
	hlt
	jmp	fin

msg:
	db	0x0a, 0x0a
	db	"load error"
	db	0x0a
	db	0

	resb	0x7dfe-$

	db	0x55, 0xaa
