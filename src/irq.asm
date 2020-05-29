#import "lib/lib.asm"
IRQ: {
    Init:
        sei // Disable interupts

        // Disable CIA IRQ's to prevent crash because
        lda #$7f
	    sta $dc0d
	    sta $dd0d

        // Enable raster interupts
        lda $d01a
        ora #%00000001
        sta $d01a

        // Set interupt vector
        lda #<MainIRQ
        sta $fffe
        lda #>MainIRQ
        sta $ffff

        // Set raster line on which to trigger irq
        lda #$ff
        sta $d012
        lda $d011 // Clear the 9th bit
        and #%01111111
        sta $d011


        asl $d019 // Ack the irq

        cli // Enable interupts
        rts
    __Init:

    MainIRQ:
        // Store registers
        sta !RestoreRegisters+ + 1
        stx !RestoreRegisters+ + 3
        sty !RestoreRegisters+ + 5

        // Set VBlank flag
        lda Flags
        ora #Flag.VBlank
        sta Flags

        // Get input
        lda $dc00
        sta Joystick_1.Buffer

        asl $d019 // Ack the irq

    !RestoreRegisters: // Self mod code
        lda #$DD
        ldx #$DD
        ldy #$DD

        rti
    __MainIRQ:
}
