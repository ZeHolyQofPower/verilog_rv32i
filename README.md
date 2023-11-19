## What Am I Looking At?
This is a Verilog implementation of a RISC-V Processor, specifically [The RV32I ISA](https://riscv.org/wp-content/uploads/2019/12/riscv-spec-20191213.pdf#chapter2). This processor can be simulated inside of Modelsim, or compiled and flashed to a DE2-115 FPGA. 

[//]: # ( TODO Check compliance with the RISC-V Architecture Test Suite https://github.com/riscv-non-isa/riscv-arch-test )

## Technical Skills Presented
* This project was built in compliance with [The lowRISC Verilog Style Guide](https://github.com/lowRISC/style-guides/blob/master/VerilogCodingStyle.md). This aligns with Google's growing open silicon community.
* Digital logic, incorrect connections, and individual instruction paths, were manually debugged and tested in Intel's distro of Modelsim named QuestaSim.
* Some Verilog unit tests were written for drivers and instructions. These were scrapped for being too slow for development.
* Carefully planned nonfunctional programs with pre-planned waveforms were created and used for instruction testing instead:

<img src="https://github.com/ZeHolyQofPower/verilog_rv32i/blob/main/test_instructions.png" width="400" height="400"/>

<img src="https://github.com/ZeHolyQofPower/verilog_rv32i/blob/main/registers_state.png"/>

* RISC-V code was written, tested, and converted to hex automatically in a modified fork of [RARS](https://github.com/TheThirdOne/rars).
* Outside of software simulation, Quartus was used for compiling and flashing to an Altera DE2-115 FPGA.
* Board peripherals like the reset button, switches, and hexidecimal displays had drivers built and connected to the discrete processor.
* A Pulse Width Modulator was also implemented in software to power board LEDs for hardware status.
* A five stage pipeline was added to increase IPC; all jumping and branch instructions have appropriate stalls within this pipeline.
* Data forwarding resolution and some data hazard detection has been added.
* There are 32 instructions total. Any code using those FPGA peripherals can be compiled to run on this processor and board.

## Soft Skills Presented
* This project was completed alone in twelve weeks. It was the most technically challening project in my undergraduate degree.
* As I learned multiple different pieces of complex software, I was able to share my notes and guides with my colleagues.
* I experimented with different testing and debugging solutions to find the best one for different development steps.
* I discovered I have a passion for designing computer hardware and have spent more hours on this than any other project ever.

## Digging Into the Details and Code
Want to really take a look yourself?

First, if you want to simulate the assembly programs I've included included for testing, you'll need a distribution of ModelSim. I'd recommend the [QuestaSim Starter Edition](https://www.intel.com/content/www/us/en/software-kit/782455/questa-intel-fpgas-pro-edition-software-version-23-2.html?). This needs a free license from [Intel's Self-Service Licensing Center](https://licensing.intel.com/psg/s/?language=en_US). I do not use any Intel IP, so you could potentialy use a different distro of ModelSim if you already have it installed. Getting Intel's licensing to work correctly is quite a challenge for no good reason, so email me if you get stuck.

Once you've got Questa open, here's an example set of directions for running the set of test instructions:
* Change the working directory to this project: `cd [PATH]/verilog_rv32i/`
* Compile to networks for simulation: `vlog *.sv`
* Load in working design: `vsim simtop.sv`
* Load the design in full debug mode for development:
* Select in the top bar: "Simulate" > "Start Simulation..." > "+ work" > "simtop" > "Optamization Options" > "Apply full visibility to all modules(full debug mode)"
* Examine the state of the registers:
  * Select in the left window: "+ simtop" > "+ dut" > "+ mr_cpu" > select "mr_registers"
  * In the blue objects window: right click "mem" > "add Wave"
  * In the large wave window: select "+ /simtop/dut/mr_cpu/mr_registers/mem"
* Recompile: `vlog *.sv`
* Force restart, and run for a period of 300 ms: `restart -f; run 300`
* Examine and play with the window showing the state of the registers, you've run those commands and can fully trace and examine every signal inside the processor now!

Second, if you want to test your own programs, you will need a tool for writting RISC-V assembly directly. Cross compiling from C to the target ISA is very close to perfect, there are eight missing instructions: SLTI[U], AUIPC, LOAD, STORE, FENCE, ECALL, and EBREAK. There are two [Zicsr instructions](https://riscv.org/wp-content/uploads/2019/12/riscv-spec-20191213.pdf#chapter9) for board IO. The last barriers are then some unresolved data hazards.

Third, if you're an FPGA engineer and happen to have Quartus installed and a DE2-115 board sitting around, this repo has all the Quartus Project Files including the specially designed PIO components set up. I've included two interesting programs: "bin2dec.dat" takes the switches' binary input, converts it to decimal, and outputs it to the seven-seg displays. "sqrt2.dat" takes the binary input of the switches and finds the fixed point square root, converts it decimal, and displays it on the seven-seg displays.
