#importonce

Rand: {
    /* https://codebase64.org/doku.php?id=base:flexible_galois_lfsr */
    RandSeed:
        // Seed mustn't be zero!
        .byte $04

    Prng8:
        lsr RandSeed
        lda RandSeed
        bcc !Skip+
        eor #$14 // $01 - $1f
        sta RandSeed
    !Skip:
        rts
    _Prng8:

    SeedPrng8: // Seed random with CIA timers
    !SeedLoop:
        lda $d012
        eor $dc04
        sbc $dc05
        cmp #$00
        beq !SeedLoop-
        sta RandSeed
        rts
    __SeedPrng8:
}
