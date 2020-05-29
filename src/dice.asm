#importonce

#import "assests/assests.asm"
#import "lib/vic.asm"
#import "lib/rand.asm"
#import "lib/lib.asm"
#import "zero.asm"
#import "cards.asm"


Dice: {
    RollAlien:
            // Flip through aliens
            .label AlienLoopIndex = ZP.TEMP_1
            lda #$00
            sta ZP.CurrentAlien
            jsr Rand.Prng8
            sta AlienLoopIndex
        !CardLoop:
            // Wait for VBlank
            lda Flags
            and #Flag.VBlank
            beq !CardLoop-
            lda #$00
            sta Flags

            // Inc Alien tile
            inc ZP.CurrentAlien
            lda ZP.CurrentAlien
            cmp #$08
            bne !Skip+
            lda #$00
            sta ZP.CurrentAlien
        !Skip:

            // Set TILES $DEAD
            ldy ZP.CurrentAlien
            lda Mult9, y // TILES low byte is $00 to no adc needed
            sta !Tiles+ + 1
            lda #>TILES
            sta !Tiles+ + 2

            // Set the ATTRS $DEAD
            clc
            lda #<ATTRS
            adc ZP.CurrentAlien
            sta !Attrs+ + 1
            lda #>ATTRS
            adc #$00
            sta !Attrs+ + 2

            // Display alien
            ldx #$00
        !TileLoop:
        !Tiles:
            lda $DEAD, x // TILES
            ldy TileScreenPositions, x
        !Scr:
            sta StartAlienLocation_SCREEN, y // SCREEN_RAM
        !Attrs:
            lda $DEAD // ATTRS
            ldy TileScreenPositions, x
        !Colr:
            sta StartAlienLocation_COLOUR, y // COLOUR_RAM
            inx
            cpx #$09
            bne !TileLoop-

            // Inc counter
            dec AlienLoopIndex
            bne !CardLoop-

            rts
    __RollAlien:

    RollEntry:
            // Flip through aliens
            .label EntryLoopIndex = ZP.TEMP_1
            .label CurrentEntry = ZP.TEMP_2
            lda #$0c
            sta CurrentEntry
            jsr Rand.Prng8
            sta EntryLoopIndex
        !CardLoop:
            // Wait for VBlank
            lda Flags
            and #Flag.VBlank
            beq !CardLoop-
            lda #$00
            sta Flags

            // Inc entry tile
            inc CurrentEntry
            lda CurrentEntry
            cmp #$0f
            bne !Skip+
            lda #$0c
            sta CurrentEntry
        !Skip:

            // Set TILES $DEAD
            ldy CurrentEntry
            lda Mult9, y // TILES low byte is $00 to no adc needed
            sta !Tiles+ + 1
            lda #>TILES
            sta !Tiles+ + 2

            // Set the ATTRS $DEAD
            clc
            lda #<ATTRS
            adc CurrentEntry
            sta !Attrs+ + 1
            lda #>ATTRS
            adc #$00
            sta !Attrs+ + 2

            // Display alien
            ldx #$00
        !TileLoop:
        !Tiles:
            lda $DEAD, x // TILES
            ldy TileScreenPositions, x
        !Scr:
            sta StartEntryLocation_SCREEN, y // SCREEN_RAM
        !Attrs:
            lda $DEAD // ATTRS
            ldy TileScreenPositions, x
        !Colr:
            sta StartEntryLocation_COLOUR, y // COLOUR_RAM
            inx
            cpx #$09
            bne !TileLoop-

            // Inc counter
            dec EntryLoopIndex
            bne !CardLoop-

            // Store Entry
            sec
            lda CurrentEntry
            sbc #$0c
            asl
            asl
            asl
            asl
            and #%00001111
            sta CurrentEntry
            lda ZP.CurrentEntryAndDir
            and CurrentEntry
            sta ZP.CurrentEntryAndDir

            rts
    __RollEntry:

    RollDirection:
            // Flip through aliens
            .label DirectionLoopIndex = ZP.TEMP_1
            .label CurrentDirection = ZP.TEMP_2
            lda #$0f
            sta CurrentDirection
            jsr Rand.Prng8
            sta DirectionLoopIndex
        !CardLoop:
            // Wait for VBlank
            lda Flags
            and #Flag.VBlank
            beq !CardLoop-
            lda #$00
            sta Flags

            // Inc direction tile
            inc CurrentDirection
            lda CurrentDirection
            cmp #$11
            bne !Skip+
            lda #$0f
            sta CurrentDirection
        !Skip:

            // Set TILES $DEAD
            ldy CurrentDirection
            lda Mult9, y // TILES low byte is $00 to no adc needed
            sta !Tiles+ + 1
            lda #>TILES
            sta !Tiles+ + 2

            // Set the ATTRS $DEAD
            clc
            lda #<ATTRS
            adc CurrentDirection
            sta !Attrs+ + 1
            lda #>ATTRS
            adc #$00
            sta !Attrs+ + 2

            // Display alien
            ldx #$00
        !TileLoop:
        !Tiles:
            lda $DEAD, x // TILES
            ldy TileScreenPositions, x
        !Scr:
            sta StartEntryDirection_SCREEN, y // SCREEN_RAM
        !Attrs:
            lda $DEAD // ATTRS
            ldy TileScreenPositions, x
        !Colr:
            sta StartEntryDirection_COLOUR, y // COLOUR_RAM
            inx
            cpx #$09
            bne !TileLoop-

            // Inc counter
            dec DirectionLoopIndex
            bne !CardLoop-

            // Store direction
            sec
            lda CurrentDirection
            sbc #$0f
            and #%11110000
            sta CurrentDirection
            lda ZP.CurrentEntryAndDir
            and CurrentDirection
            sta ZP.CurrentEntryAndDir

            rts
    __RollDirection:
}
