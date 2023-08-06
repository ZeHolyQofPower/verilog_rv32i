## What Am I Looking At?
This is a Verilog implementation of [The RISC-V RV32I](https://riscv.org/wp-content/uploads/2019/12/riscv-spec-20191213.pdf#chapter2) ISA. This processor can be simulated inside of Modelsim, or compiled and flashed to an FPGA. 

[//]: # ( TODO Check compliance with the RISC-V Architecture Test Suite https://github.com/riscv-non-isa/riscv-arch-test )

## Technical Skills Presented
* This project was built in compliance with [The lowRISC Verilog Style Guide](https://github.com/lowRISC/style-guides/blob/master/VerilogCodingStyle.md). This aligns with Google's open silicon community.
* Digital logic, incorrect connections, and individual instruction paths, were manually debugged and tested in QuestaSim.
* Some Verilog unit tests were written for drivers and instructions. These were scrapped for being too slow for development.
* Carefully planned nonfunctional programs with pre-planned waveforms were created and used for instruction testing instead.

TODO add a picture of an expected register state compared to a Questa waveform.

* RISC-V code was written, tested, and converted to hex automatically in a modified fork of [RARS](https://github.com/TheThirdOne/rars).
* Outside of software simulation, Quartus was used for compiling and flashing to an Altera DE2-115 FPGA.

TODO find a picture or video of the final demo.

* Board peripherals like the reset button, switches, and hexidecimal displays had drivers built and connected to the processor.
* A Pulse Width Modulator was also implemented in software to power board LEDs for hardwares' status.
* A five stage pipeline was added to increase IPC; all jumping and branch instructions have appropriate stalls within this pipeline.
* Data forwarding resolution and some data hazard detection has been added.
* There are 32 instructions total. Any code using those FPGA perihperals can be compiled to run on this processor and board.

## Soft Skills Presented
* This project was completed alone in twelve weeks. It was the most technically challening project in my undergraduate degree.
* As I learned multiple different pieces of complex software, I was able to share my notes and guides with my colleagues.
* I experimented with different testing and debugging solutions to find the best one for different development steps.
* I discovered I have a passion for designing computer hardware and have spent more hours on this than any other project ever.

## Digging Into the Details and Code
Want to really take a look yourself?

First you will need a distribution of ModelSim.

Second you will need a tool for writting RISC-V assembly.
Cross compiling to the target ISA is very close to perfect. Data hazards and some IO registers are the last barriers.

Third you need to find the waveform to see the results.
