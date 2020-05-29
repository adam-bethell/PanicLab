#importonce

#import "assests/assests.asm"
#import "lib/vic.asm"
#import "lib/rand.asm"
#import "lib/lib.asm"
#import "zero.asm"

Cards: {
    .label Index = ZP.TEMP_1
    AllCards:
        .byte $00,$00,$01,$01,$02,$02,$03,$03,$04,$04,$05,$05,$06,$06,$07,$07,$08,$08,$08,$09,$0a,$0b,$0c,$0d,$0e
    ShuffledCards:
        .fill 25, $ff // 25 bytes init to $ff

    ShuffleCards:
        // Init cards
        ldx #$00
        stx Index
        lda #$ff
    !ResetCardsLoop:
        sta ShuffledCards, x
        inx
        cpx #25
        bne !ResetCardsLoop-
    !NewSeed:
        jsr Rand.SeedPrng8
    !ShuffleLoop:
        jsr Rand.Prng8 // Loads random number into A from $01 - $1f
        sec
        sbc #$01
        cmp #25
        bcs !NewSeed- // The number is too big, get new seed to prevent inf loop
        tax
        lda ShuffledCards, x
        cmp #$ff
        bne !ShuffleLoop- // The shuffled card index has already been set
        ldy Index
        lda AllCards, y
        sta ShuffledCards, x
        iny
        sty Index
        cpy #25
        bne !ShuffleLoop- // Get the next card
        rts
    __ShuffleCards:

    DisplayCards:
        lda #$00
        sta Index
    !CardLoop:
        // Card index * 2 for the 16 bit locations
        lda Index
        asl
        tax // CardIndex * 2
        tay
        iny // Cardindex *2 + 1

        // Set SCREEN_RAM $DEAD
        clc
        lda #<VIC.SCREEN_RAM
        adc CardLocations, x
        sta Scr + 1
        lda #>VIC.SCREEN_RAM
        adc CardLocations, y
        sta Scr + 2

        // Set COLOUR_RAM $DEAD
        clc
        lda #<VIC.COLOUR_RAM
        adc CardLocations, x
        sta Colr + 1
        lda #>VIC.COLOUR_RAM
        adc CardLocations, y
        sta Colr + 2

        // Set TILES $DEAD
        ldy Index
        ldx ShuffledCards, y
        lda Mult9, x // TILES low byte is $00 to no adc needed
        sta Tiles + 1
        lda #>TILES
        sta Tiles + 2

        // Set ATTRS $DEAD
        clc
        lda #<ATTRS
        ldy Index
        adc ShuffledCards, y
        sta Attrs + 1
        lda #>ATTRS
        adc #$00
        sta Attrs + 2

        ldx #$00
    !TileLoop:
    Tiles:
        lda $DEAD, x // TILES
        ldy TileScreenPositions, x
    Scr:
        sta $DEAD, y // SCREEN_RAM
    Attrs:
        lda $DEAD // ATTRS
        ldy TileScreenPositions, x
    Colr:
        sta $DEAD, y // COLOUR_RAM
        inx
        cpx #$09
        bne !TileLoop-

        inc Index
        ldx Index
        cpx #25
        bne !CardLoop-
        rts
    __DisplayCards:
}
