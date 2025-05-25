org 100h
jmp basla

sonuc db 160 dup(0)
girilen dw 0
sayiGirMesaj db 0Dh,0Ah,"Faktoriyeli alinacak sayiyi girin: $"
sonucMesaj db 0Dh,0Ah,0Dh,0Ah,"Girilen sayinin faktoriyeli: $"
dosyaMesaj db 0Dh,0Ah,0Dh,0Ah,"Cikan sonuc, ...\vdrive\C\faktoriyelSonuc.txt dizinine yazdirildi!$"   
fazlaKarakterUyari db 0Dh,0Ah,"En fazla iki basamakli sayi girebilirsiniz!$", 0Dh,0Ah, "$"
dosya db "C:\faktoriyelSonuc.txt",0
dosyaHandle dw ?
dosyaBuffer db 160 dup(' ')
dosyaSize dw 0

basla:
lea si, sonuc
mov byte ptr [si], 1

mov dx, offset sayiGirMesaj
mov ah, 09h
int 21h

; iki basamakli sayi alma
mov bx, 0
mov cx, 10

; ilk karakter
mov ah, 01h
int 21h
cmp al, 0Dh
jz no_input
sub al, 30h
mov bl, al

; ikinci karakter veya enter
mov ah, 01h
int 21h
cmp al, 0Dh
jz tek_basamak
sub al, 30h
mov bh, al

;3. kontrol
mov ah, 01h
int 21h
cmp al, 0Dh
jz devam_et 

;uyari
mov dx, offset fazlaKarakterUyari
mov ah, 09h
int 21h
mov ax, 4C00h
int 21h

devam_et:


; birlestir
mov ax, 0
mov al, bl
mul cx
add al, bh
mov bl, al
jmp giris_bitti

tek_basamak:
jmp giris_bitti

no_input:
mov bl, 1

giris_bitti:
mov ax, 0
mov al, bl
mov dl, al

cmp dl, 0
jne devam
mov dl, 1
mov al, dl

devam:
cmp dl, 25
jb kucuk
mov girilen, ax
add girilen, 60
jmp hesap

kucuk:
mov girilen, ax

;faktoriyel hesaplama
hesap:
push dx
cmp dl, 1
jz atla

lea si, sonuc
mov dh, 10
mov bx, 0
mov cx, girilen

carp_basla:
mov al, [si]
mov ah, 0
mul dl
add ax, bx
div dh
mov [si], ah
inc si
mov bl, al
loop carp_basla

atla:
pop dx
dec dl
jnz hesap

; sonucu ekrana yazdirma
mov dx, offset sonucMesaj
mov ah, 09h
int 21h

mov bp, 0
lea si, sonuc
mov di, si
mov cx, 160
add di, cx
dec di

temizle:
cmp byte ptr [di], 0
jne bas
dec di
jmp temizle

bas:
mov ah, 2

yaz:
mov dl, [di]
add dl, 30h
mov dosyaBuffer[bp], dl
inc bp
int 21h
cmp si, di
je bitir
dec di
loop yaz

bitir:
mov dl, 0Dh
mov dosyaBuffer[bp], dl
inc bp
mov dl, 0Ah
mov dosyaBuffer[bp], dl
inc bp

mov dosyaSize, bp

; dosyayi acma
mov ah, 3Dh        
mov al, 1         
mov dx, offset dosya
int 21h
jc dosya_yoksa_olustur
mov dosyaHandle, ax

; sonuna git
mov ah, 42h
mov al, 2
mov bx, dosyaHandle
mov cx, 0
mov dx, 0
int 21h
jmp dosya_yaz

dosya_yoksa_olustur:
mov ah, 3Ch
mov cx, 0
mov dx, offset dosya
int 21h
mov dosyaHandle, ax

dosya_yaz:
mov ah, 40h
mov bx, dosyaHandle
lea dx, dosyaBuffer
mov cx, dosyaSize
int 21h

mov ah, 3Eh
mov bx, dosyaHandle
int 21h
mov dx, offset dosyaMesaj
mov ah, 09h
int 21h

mov ax, 4C00h
int 21h
