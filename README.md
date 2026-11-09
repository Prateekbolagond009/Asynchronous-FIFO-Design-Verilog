# Asynchronous-FIFO-Design-Verilog
Design and verification of an asynchronous FIFO using Verilog HDL with independent 100 MHz and 40 MHz clock domains.
# Asynchronous FIFO Design and Verification using Verilog HDL

## 1. Project Overview

This project focuses on the design and functional verification of an Asynchronous FIFO (First-In First-Out) using Verilog HDL.

An asynchronous FIFO is a dual-port memory that allows data to be written and read using two independent clock domains. It is commonly used in digital systems to transfer data between modules operating at different clock frequencies.

The design uses independent write and read clocks, Gray-code pointer conversion, and double-flop synchronizers for clock-domain crossing (CDC).

## 2. Design Specifications

| Parameter | Specification |
|---|---|
| HDL | Verilog |
| Data Width | 8 bits |
| FIFO Depth | 8 |
| Address Width | 3 bits |
| Pointer Width | 4 bits |
| Write Clock | 100 MHz |
| Read Clock | 40 MHz |
| Data Transfer | 9 bytes |
| Synchronizer | Double-flop |

## 3. FIFO Architecture

The design consists of five main RTL modules:

1. **DF_SYNC:** Implements a double-flop synchronizer to transfer Gray-coded pointers between clock domains.
2. **FIFO_MEM_CNTRL:** Implements the FIFO storage memory with independent write and read access.
3. **FIFO_WR:** Generates the write pointer, write address and FULL flag.
4. **FIFO_RD:** Generates the read pointer, read address and EMPTY flag.
5. **ASYNC_FIFO:** Top-level module integrating all the individual blocks.

## 4. Key Design Concepts

- Binary write and read pointer generation.
- Binary-to-Gray code conversion.
- Double-flop synchronization.
- Clock-domain crossing (CDC).
- FIFO FULL and EMPTY detection.
- Pointer wrap-around.
- Independent read and write clock operation.
- Overflow protection using FULL-based backpressure.

## 5. FIFO Depth Calculation

The design uses:

- Write frequency = 100 MHz
- Read frequency = 40 MHz
- Burst length = 9 bytes

The selected FIFO depth is 8 entries.

Since the writer monitors the FULL flag and pauses when the FIFO is full, it can transfer all nine bytes without overwriting unread data.

The writer resumes when the read pointer synchronization indicates that space is available.

**Note:** The eight-entry FIFO does not hold all nine bytes simultaneously. Backpressure is necessary for this transfer.

## 6. Verification and Testbench

A Verilog testbench was developed to validate the asynchronous FIFO operation.

### Testbench Features

- Independent 100 MHz write clock generation.
- Independent 40 MHz read clock generation.
- Asynchronous reset generation.
- Automated write and read operations.
- FULL and EMPTY flag monitoring.
- Scoreboard-based data comparison.
- Watchdog timer.
- VCD waveform generation.

### Test Data

The following nine bytes were transferred:

`A1 → B2 → C3 → D4 → E5 → F6 → 17 → 28 → 39`

### Verification Results

- All 9 bytes successfully transferred.
- Data ordering maintained.
- Zero data mismatches.
- FULL condition observed.
- Final EMPTY condition verified.

## 7. Simulation Waveforms

The `Simulation` folder contains waveform screenshots demonstrating:

- Independent write and read clocks.
- Write and read pointer progression.
- Gray-code pointer synchronization.
- FULL and EMPTY flag transitions.
- Data transfer and verification.

## 8. Tools and Technologies

- Verilog HDL
- HDL Simulation
- GTKWave / Vivado Simulator (use the simulator actually used)

## 9. Repository Structure

```text
Asynchronous-FIFO-Design-Verilog/
│
├── RTL/
│   ├── DF_SYNC.v
│   ├── FIFO_MEM_CNTRL.v
│   ├── FIFO_WR.v
│   ├── FIFO_RD.v
│   └── ASYNC_FIFO.v
│
├── Testbench/
│   └── ASYNC_FIFO_TB.v
│
├── Simulation/
│   ├── FIFO_Waveform_1.png
│   └── FIFO_Waveform_2.png
│
├── Documentation/
│   ├── ASYNC_FIFO_Assignment.pdf
│   └── Interview_Questions.md
│
└── README.md
```

## 10. Learning Outcomes

Through this project, I explored:

- Asynchronous FIFO architecture and operation.
- Clock-domain crossing techniques.
- Gray-code pointer implementation.
- Metastability and synchronizer design.
- FIFO status flag generation.
- RTL design using modular Verilog.
- Functional verification using self-checking testbenches.
- Simulation waveform analysis.

## 11. Author

**Prateek Bolagond**

B.Tech – Electronics and Communication Engineering  
University of Visvesvaraya College of Engineering (UVCE), Bengaluru

GitHub: [Prateekbolagond009](https://github.com/Prateekbolagond009)
