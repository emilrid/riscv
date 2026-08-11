# RISC-V processor

Written in Veryl, this processor is a mostly single cycle RV32I processor with unified memory and efficient component usage. 

Currently it can do all RV32I instructions except for CSR (Control and Status Register) instructions, which are planned to be implemented.

All instructions complete in 1 cycle except Load and Store instructions, which take 2 cycle. This is due to the use of unified memory.

## Instructions
Install the Veryl toolchain, accessible at https://veryl-lang.org/install/

1. Build: `veryl build`
2. Test : `veryl test`

This will run the current simple program `program.S` (vibed together) which I've previously compiled to `program.hex` which the program inserts into memory at compilation. 
The program runs checks on the implemented instructions and returns 0 in register `x31` if the test is completed successfully. 

This is a preliminary test and thorough test are planned to be implemented. 
