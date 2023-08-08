.org $8000

;;;;;;;;;;;;;;;;;;;;;;;
;; CONSTANTS GO HERE ;;
;;;;;;;;;;;;;;;;;;;;;;;

VERA_ADDR_LOW       = $9F20
VERA_ADDR_HIGH      = $9F21
VERA_ADDR_BANK      = $9F22

VERA_DATA1          = $9F24
VERA_CTRL           = $9F25

.segment "ONCE"
.segment "CODE"

start:
    lda #%00000100           ; DCSEL=2, ADDRSEL=0
    sta VERA_CTRL
   
    lda #%11100000           ; ADDR0 increment: +320 bytes
    sta VERA_ADDR_BANK
    
    lda #%00000001           ; Entering *line draw mode*
    sta $9F29
    
    lda #%00000101           ; DCSEL=2, ADDRSEL=1
    sta VERA_CTRL
    
    lda #%00010000           ; ADDR1 increment: +1 byte
    sta VERA_ADDR_BANK
    lda #0                   ; Setting start to $00000
    sta VERA_ADDR_HIGH
    lda #0                   ; Setting start to $00000
    sta VERA_ADDR_LOW
    
    lda #%00000110           ; DCSEL=3, ADDRSEL=0
    sta VERA_CTRL
    
    ; Note: 73 is just a nice looking slope ;)
    ; 73 means: for each x pixel-step there is 73/256th y pixel-step
    lda #<(73<<1)            ; X increment low 
    sta $9F29
    lda #>(73<<1)            ; X increment high
    sta $9F2A

    ;;;;;;;;;;;;;;;;;;
    ;; DRAWING HERE ;;
    ;;;;;;;;;;;;;;;;;;

    ldx #150 ; Drawing 150 pixels to the right
    lda #1   ; White color

draw_line_next_pixel:
    sta VERA_DATA1
    dex
    bne draw_line_next_pixel

hang:
    jmp hang
