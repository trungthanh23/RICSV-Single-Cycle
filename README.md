# 32-bit Single-Cycle RISC-V Core (RTL Design)

This repository contains the Register-Transfer Level (RTL) design for a 32-bit processor core that implements a subset of the RISC-V (RV32I) instruction set architecture. The core is designed with a single-cycle datapath, where each instruction is executed in exactly one clock cycle. The primary goal of this project is to provide a clear, well-documented, and modular Verilog implementation for educational purposes.

---

## 🌟 Core Features

* **ISA**: RISC-V 32-bit (RV32I Base Integer Instruction Set)
* **Architecture Type**: Single-Cycle
* **Modularity**: Designed with distinct modules for the datapath, control unit, and ALU for clarity and reusability.
* **Supported Instructions**:
    * **R-Type**: `add`, `sub`, `and`, `or`, `slt`
    * **I-Type**: `addi`, `lw`
    * **S-Type**: `sw`
    * **B-Type**: `beq`
    * **J-Type**: `jal`

---

## 🏗️ Architecture and Design

The processor's architecture is presented using a top-down approach, starting from the highest-level system view and progressively detailing each major component.

### 1. System-Level Block Diagram

At the highest level, the system consists of the **Processor** and external **Instruction** and **Data Memories**. The processor itself is composed of two main blocks: the **Controller**, which generates control signals, and the **Datapath**, which processes the data.

![System-Level Block Diagram](./images/System_block.png)

### 2. Detailed Processor Datapath

Zooming into the processor, this diagram illustrates the detailed single-cycle datapath. It shows the main functional units—such as the Program Counter (PC), Register File, ALU, and memory interfaces—and the flow of data and control signals between them.

![Detailed Processor Datapath](./images/Datapath.png)

### 3. Control Unit

The Control Unit is the "brain" of the processor. It decodes the instruction's opcode to generate all necessary signals that command the datapath for the duration of an instruction's execution.

![Main and ALU Decoder Diagram](./images/Main and ALU Decoder Diagram.png)

The logic for the main control signals is defined in the following table:

| op (binary) | Instruction | RegWrite | ImmSrc | ALUSrc | MemWrite | ResultSrc | Branch | ALUOp | Jump |
| :---------: | :---------: | :------: | :----: | :----: | :------: | :-------: | :----: | :---: | :--: |
| `0000011`   | `lw`        | 1        | 00     | 1      | 0        | 01        | 0      | 00    | 0    |
| `0100011`   | `sw`        | 0        | 01     | 1      | 1        | XX        | 0      | 00    | 0    |
| `0110011`   | R-type      | 1        | XX     | 0      | 0        | 00        | 0      | 10    | 0    |
| `1100011`   | `beq`       | 0        | 10     | 0      | 0        | XX        | 1      | 01    | 0    |
| `0010011`   | I-type      | 1        | 00     | 1      | 0        | 00        | 0      | 10    | 0    |
| `1101111`   | `jal`       | 1        | 11     | X      | 0        | 10        | 0      | XX    | 1    |

### 4. Immediate Generation Unit (ImmExt)

The `ImmExt` unit is a crucial combinational logic block responsible for generating the 32-bit immediate value from different instruction formats. The selection logic is as follows:

| ImmSrc[1:0] | Instruction Type | Immediate Value Generation (ImmExt)                   |
| :---------: | :--------------: | :---------------------------------------------------- |
| `00`        |      I-Type      | `{ {20{instr[31]}}, instr[31:20] }`                    |
| `01`        |      S-Type      | `{ {20{instr[31]}}, instr[31:25], instr[11:7] }`       |
| `10`        |      B-Type      | `{ {19{instr[31]}}, instr[31], instr[7], instr[30:25], instr[11:8], 1'b0 }` |
| `11`        |      J-Type      | `{ {12{instr[31]}}, instr[19:12], instr[20], instr[30:21], 1'b0 }` |

The diagram below provides a visual representation of how the bits are extracted from each instruction format to construct the immediate value.

![Instruction Formats](./images/Instruction_Format.png)

### 5. Arithmetic Logic Unit (ALU)

The ALU is the core computational component of the processor. This section details its functionality, control logic, and the RTL implementation of a single-bit slice.

#### 5.1. Supported ALU Operations

The ALU is capable of performing the following fundamental operations based on the 3-bit `ALUControl` signal.

| `ALUControl[2:0]` | Function |
| :---------------: | :------: |
| `000`             | add      |
| `001`             | subtract |
| `010`             | and      |
| `011`             | or       |
| `101`             | SLT      |

#### 5.2. ALU Decoder Logic

To select the correct operation, the **ALU Decoder** uses the `ALUOp` signal from the Main Control unit along with fields from the instruction itself to produce the `ALUControl` signal.

| ALUOp | funct3 | op₅, funct7₅ | Instruction | ALUControl      |
| :---: | :----: | :----------: | :---------: | :-------------: |
| 00    | x      | x            | `lw`, `sw`  | 000 (add)       |
| 01    | x      | x            | `beq`       | 001 (subtract)  |
| 10    | 000    | 00, 01, 10   | `add`       | 000 (add)       |
|       | 000    | 11           | `sub`       | 001 (subtract)  |
|       | 010    | x            | `slt`       | 101 (set <)     |
|       | 110    | x            | `or`        | 011 (or)        |
|       | 111    | x            | `and`       | 010 (and)       |

#### 5.3. ALU Architecture and Implementation

The N-bit ALU is constructed by replicating a 1-bit ALU slice. The diagram below shows the detailed RTL logic for a single bit, implementing functions like AND, OR, ADD, and SUB (using A + ~B + 1 for subtraction) based on the `ALUControl` signals.

![1-bit ALU Slice RTL Diagram](./images/ALU.png)

---

## 📂 RTL Structure

The RTL code is organized into a hierarchy of modules, with `RISC_V_single_cycle` serving as the top-level entity.

* **`RISC_V_single_cycle.v`**: The top-level wrapper for the entire system. It instantiates the processor core (`risc_v_core`), instruction memory (`inmem`), and data memory (`datamem`).
* **`risc_v_core.v`**: This is the main processor module that contains the core logic. It connects the two primary sub-modules: the `control` unit and the `datapath`.
* **`control.v`**: This module acts as the control unit. It takes parts of the instruction (`op`, `funct3`, `funct7`) and the `zero` flag as inputs and generates all the control signals for the datapath. It contains the `main_decoder` and `alu_decoder`.
* **`datapath.v`**: (File not shown) This module contains the main data-processing elements, including the Program Counter (PC), the register file, the ALU, and various multiplexers. It executes operations based on the signals from the `control` unit.
* **`inmem.v`**: The instruction memory module. It is implemented as a read-only 64-word memory that is initialized from a hex file (`memfile.txt`) at the start of simulation.
* **`datamem.v`**: The data memory module. It is a 64-word memory that supports both read and write operations. Data is written on the positive edge of the clock if the write enable (`we`) signal is active.

---
