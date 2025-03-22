# Brainfuck CPU

This an implementation of [brainfuck](https://en.wikipedia.org/wiki/Brainfuck) as a CPU, written in VHDL.
This is somewhat created for RIT CMPE-350, Computer Organization.
It is in theory able to run any brainfuck program, and additionally has a load immediate instruction to better fill the 16 bit ISA requirement.

## ISA

|  15..8   | 7..0 |   Description  |
|----------|------|----------------|
| 00000000 |   -  | No Op          |
| 10000000 |   -  | >              |
| 01000000 |   -  | <              |
| 00100000 |   -  | +              |
| 00010000 |   -  | -              |
| 00001000 |   -  | .              |
| 00000100 |   -  | ,              |
| 00000010 |   -  | [              |
| 00000001 |   -  | ]              |
| 11111111 |   -  | Load Immediate |
