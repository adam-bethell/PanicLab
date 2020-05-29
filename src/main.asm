#import "assests/assests.asm"
#import "zero.asm"

BasicUpstart2(Start)

#import "lib/vic.asm"
#import "lib/lib.asm"
#import "lib/macros.asm"
#import "lib/rand.asm"
#import "irq.asm"
#import "cards.asm"
#import "dice.asm"

Start:
    Init()
    jsr IRQ.Init
    ClearScreen()

    // Game Loop
    // Shuffle and show cards
    jsr Cards.ShuffleCards
    jsr Cards.DisplayCards

    // Roll dice
    jsr Dice.RollAlien
    jsr Dice.RollEntry
    jsr Dice.RollDirection

    jmp * //inf loop



