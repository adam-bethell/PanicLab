#importonce

#import "vic.asm"

.macro Init() {
	//Bank out BASIC and Kernal ROM
	lda $01
	and #%11111000
	ora #%00000101
	sta $01

    //Set VIC BANK 3
	lda $dd00
	and #%11111100
	sta $dd00

    // Set char and screen pointers
    lda #%00001100
    sta $d018

    // Multicolour mode for chars
    lda $d016
    ora #%00010000
    sta $d016

    // Set multicolour colours
    lda #$0a // Pink
    sta VIC.MULTICOLOUR_1
    lda #$06 // Blue
    sta VIC.MULTICOLOUR_2

    // Set background and border colour
    lda #$0f // Light grey
    sta VIC.BORDER_COLOUR
    sta VIC.BACKGROUND_COLOUR
}

.macro ClearScreen() {
    lda #$a1 // Fully transparent char
    ldx #$00
!:
    sta VIC.SCREEN_RAM + 000, x
    sta VIC.SCREEN_RAM + 250, x
    sta VIC.SCREEN_RAM + 500, x
    sta VIC.SCREEN_RAM + 750, x
    inx
    cpx #$ff
    bne !-
}
