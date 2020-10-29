# z3randomizer
Zelda 3 Randomizer Template ASM

How to create the bps patch:

* Assemble the ROM with asar (recommend to use a copy of original rom)

`asar LTTP_RND_GeneralBugfixes.asm copy_original_rom.sfc`
(copy_orignal_rom.sfc is now assembled_rom.sfc)

* Use flips to create a bps file

`flips original_rom.sfc assembled_rom.sfc  base2current.bps`

* Update RANDOMIZERBASEHASH in DR with the md5 sum of assembled_rom.sfc. And put base2current.bps in the data directory.
