# RISCV_Core
My implementation of a five stage RISCV RV32 Core based on Patterson and Hennessys Computer Organization and Design with full RV32I support.

This code was successfully synthesized via Vivado and passed timing analysis for 100MHz on a Nexys A7 board (A-100T).

Development is still in progress to implement a cache controller, branch prediction, and to increase the stage count (from 5 to 7) in addition to adding support for the multiplication (M) extension.
