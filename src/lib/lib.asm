#importonce
#import "vic.asm"

// Lookup tables
// Utils
TileScreenPositions:
    .byte 00,01,02
    .byte 40,41,42
    .byte 80,81,82
CardLocations:
    .word $0009 // 9
    .word $000c // 12
    .word $000f // 15
    .word $0012 // 18
    .word $003d // 61
    .word $00b7 // 183
    .word $0130 // 304
    .word $01a9 // 425
    .word $0222 // 546
    .word $0299 // 665
    .word $0310 // 784
    .word $0335 // 821
    .word $035a // 858
    .word $037f // 895
    .word $037c // 892
    .word $0379 // 889
    .word $034e // 846
    .word $0323 // 803
    .word $02aa // 682
    .word $0231 // 561
    .word $01b8 // 440
    .word $0141 // 321
    .word $00ca // 202
    .word $0053 // 83
    .word $002e // 46

    .const DiceX = [40 * 8] + 13
    .label StartAlienLocation_SCREEN = VIC.SCREEN_RAM + DiceX
    .label StartAlienLocation_COLOUR = VIC.COLOUR_RAM + DiceX
    .label StartEntryLocation_SCREEN = VIC.SCREEN_RAM + DiceX + 120
    .label StartEntryLocation_COLOUR = VIC.COLOUR_RAM + DiceX + 120
    .label StartEntryDirection_SCREEN = VIC.SCREEN_RAM + DiceX + 240
    .label StartEntryDirection_COLOUR = VIC.COLOUR_RAM + DiceX + 240

// Gameplay
Mult9:
    .byte 0,9,18,27,36,45,54,63,72,81,90,99,108,117,126,135,144,153

Flags:
    .byte $00
Flag: {
    .label VBlank = %00000001
}

Joystick_1: {
    .label Fire  = %10000
    .label Right = %01000
    .label Left  = %00100
    .label Down  = %00010
    .label Up    = %00001
    Buffer:
        .byte $00
}
