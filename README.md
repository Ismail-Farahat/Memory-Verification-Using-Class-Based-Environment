# Memory-Verification-Using-Class-Based-Environment
Memory Verification Using Class Based Environment

## Overview
This repository contains the SystemVerilog-based class-based testbench for verifying a 16x32 memory module. The testbench includes key verification components such as drivers, monitors, scoreboards, and sequencers to ensure comprehensive verification of the memory subsystem.

## Features
- Implements **class-based testbench** for verification
- Supports **16x32 memory module verification**
- Includes **driver, monitor, scoreboard, sequencer, subscriber, and environment modules**
- Provides **self-checking mechanisms** for automated verification
- Easily extendable for additional test scenarios

## Directory Structure
```
├── RTL
|  ├── memory16_32.sv             # 16x32 memory module RTL design
├── Testbench
|  ├── memory16_32_tb.sv          # Testbench top module
|  |  ├── mem_if.sv               # Memory interface
|  |  ├── env.sv                  # Test environment containing all verification components
|  |  |  ├── sequencer.sv         # Sequencer to generate stimulus
|  |  |  ├── driver.sv            # Class-based driver for memory transactions
|  |  |  ├── monitor.sv           # Class-based monitor to capture transactions
|  |  |  ├── scoreboard.sv        # Scoreboard for result comparison
|  |  |  ├── subscriber.sv        # Subscriber for additional checks
|  |  |  |  ├── transaction.sv    # Transaction class for memory operations

```

## Code Architecture
The testbench follows a class-based architecture with modular components to facilitate scalability and reusability. Below is a breakdown of the key classes:

### 1. **Transaction Class (`transaction.sv`)**
- Defines the data structure for memory transactions.
- Contains fields such as address, data, and command type (read/write).
- Implements `randomize()` function for generating test cases.

### 2. **Driver Class (`driver.sv`)**
- Responsible for driving transactions to the memory interface.
- Receives transaction objects from the sequencer.
- Implements a `run()` task to send data to the DUT.

### 3. **Monitor Class (`monitor.sv`)**
- Observes the DUT responses without interfering.
- Captures transactions from the memory interface.
- Sends observed data to the scoreboard for checking.

### 4. **Sequencer Class (`sequencer.sv`)**
- Generates stimulus sequences for the driver.
- Controls the order and type of transactions.
- Can be extended to create different test scenarios.

### 5. **Scoreboard Class (`scoreboard.sv`)**
- Compares expected vs. actual outputs.
- Maintains reference data to validate memory operations.
- Prints pass/fail results based on comparisons.

### 6. **Subscriber Class (`subscriber.sv`)**
- Listens to transaction activity.
- Used for additional checks like coverage collection.
- Can be extended to analyze different aspects of the test.

### 7. **Environment Class (`env.sv`)**
- Integrates all components into a single testbench.
- Instantiates driver, monitor, sequencer, scoreboard, and subscriber.
- Coordinates the execution of the testbench.

### 8. **Testbench Top (`memory16_32_tb.sv`)**
- The main testbench file that initializes the environment.
- Connects testbench components to the DUT.
- Calls test sequences and starts the simulation.

## Setup & Installation
### Prerequisites
Ensure you have the following tools installed:
- **Vivado / QuestaSim / ModelSim** (or any other simulator supporting SystemVerilog)

### Steps to Run Simulation
1. Clone the repository:
   ```sh
   git clone https://github.com/your-repo-name.git
   cd your-repo-name
   ```
2. Compile and run the simulation using your preferred simulator:
   ```sh
   vlog src/*.sv
   vsim -c -do "run -all"
   ```
3. Check the simulation logs and waveform outputs to analyze results.

## Usage
- Modify `sequencer.sv` to generate new test patterns.
- Analyze scoreboard results in `scoreboard.sv`.
- View captured transactions in `monitor.sv`.
- Extend the test environment in `env.sv` for additional test cases.

---

