#importonce

*=$02 "Zero page" virtual
ZP: {
    TEMP_1:
        .byte $00
    TEMP_2:
        .byte $00


    CurrentAlien:
        .byte $00
    CurrentEntryAndDir:
        // Upper nibble: Start 0, 1, or 2
        // Lower nibble: Direction clockwise (0) or anticlockwise (1)
        .byte $00


}





