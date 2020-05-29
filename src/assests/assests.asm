#importonce
/*
	$c000 - $c3ff Screen
	$c400 - $c7ff 16 sprites
	$d000 - $efff 128 Sprites
	$f000 - $f7ff 1 charset
	$f800 - $fffd 16 sprites
*/

* = $f000 "Charset"
CHARS:
    .import binary "chars.bin"


* = $8000 "Tile Data"
TILES:
	.import binary "tiles.bin"
ATTRS:
	.import binary "attrs.bin"
