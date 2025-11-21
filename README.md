# FPGA-Based Multifunctional Digital Clock

A versatile digital clock system implemented in Verilog for the PYNQ-Z2 FPGA board, featuring multiple operational modes including clock, stopwatch, timer, and alarm functionality with 7-segment display output.

## Project Overview

This project implements a comprehensive digital clock system on FPGA hardware, demonstrating synchronous digital design principles, finite state machine architecture, and real-time display multiplexing.

## Features

### 🕐 **Four Operational Modes**
1. **Digital Clock Mode** - Real-time 24-hour clock display (HH:MM format)
2. **Stopwatch Mode** - Countdown/count-up timer (MM:SS format)
3. **Timer Mode** - Configurable countdown timer with visual alert
4. **Alarm Mode** - Programmable alarm with RGB LED indicators

### 🔧 **Technical Features**
- **Modular Verilog Design**: Separate modules for display drivers and main controller
- **Frequency Division**: 125 MHz system clock divided to 1 Hz for timekeeping
- **7-Segment Display Multiplexing**: Time-multiplexed 4-digit display control
- **FSM-Based Mode Control**: Clean state machine for mode switching
- **RGB LED Alerts**: Visual feedback for alarm activation
- **User Input Controls**: Buttons for mode selection, time setting, and control

## Hardware Specifications

- **FPGA Board**: PYNQ-Z2 (Zynq-7020)
- **System Clock**: 125 MHz
- **Display**: 4-digit 7-segment display (common anode)
- **Inputs**: 
  - 2 switches (mode selection)
  - 4 push buttons (reset, set operations, stopwatch control)
- **Outputs**:
  - 7-segment display (7 segments + 4 digit selectors)
  - 2 RGB LEDs (alarm indication)
  - 6 blink LEDs (timer alert)

## Architecture

### Module Hierarchy

```
DigitalClock (Top Module)
├── seven_segment_display (x18 instances)
│   └── BCD to 7-segment decoder
└── Main Controller
    ├── Clock dividers (125 MHz → 1 Hz)
    ├── FSM for mode management
    ├── Time counters (clock, stopwatch, timer, alarm)
    └── Display multiplexer
```

### State Machine

The system uses a 2-bit FSM with 4 states:
- `2'b00`: Clock Mode
- `2'b01`: Stopwatch Mode
- `2'b10`: Timer Mode
- `2'b11`: Alarm Mode

### Clock Division

- **Primary Clock**: 125 MHz input from FPGA board
- **Display Refresh**: ~1 kHz for 7-segment multiplexing
- **Timekeeping**: 1 Hz for second counter

## Pin Mapping

### Inputs
| Signal | Pin | Description |
|--------|-----|-------------|
| `clk` | H16 | 125 MHz system clock |
| `mode_sel[1:0]` | M19, M20 | Mode selection switches |
| `reset` | D19 | Global reset button |
| `reset_stopwatch` | D20 | Stopwatch reset |
| `set_min` | L20 | Minute increment |
| `set_hour` | L19 | Hour increment |

### Outputs
| Signal | Description |
|--------|-------------|
| `seg_data[6:0]` | 7-segment data (a-g) |
| `digit_sel[3:0]` | Digit selector (active low) |
| `blue[1:0]` | Blue RGB LED channels |
| `red[1:0]` | Red RGB LED channels |
| `green[1:0]` | Green RGB LED channels |
| `blink[5:0]` | Timer alert LEDs |

## Usage

### Mode Selection
Use switches `mode_sel[1:0]` to select operational mode:
- `00`: Digital Clock
- `01`: Stopwatch
- `10`: Timer
- `11`: Alarm

### Clock Mode
- Press `set_hour` to increment hours
- Press `set_min` to increment minutes
- Hold `set` button while pressing hour/min buttons to adjust time

### Stopwatch Mode
- Press `start_stop` to start/pause
- Press `reset_stopwatch` to reset to 00:00

### Timer Mode
- Press `set` + `set_hour`/`set_min` to configure countdown time
- Timer automatically counts down when not in set mode
- LEDs blink when timer reaches 00:00

### Alarm Mode
- Press `set_hour`/`set_min` to set alarm time
- RGB LEDs flash in sequence when alarm time matches current time

## File Structure

```
DigitalClock/
├── clock.srcs/
│   ├── sources_1/new/
│   │   └── clock.v              # Main Verilog source
│   ├── sim_1/new/
│   │   └── testbench.v          # Simulation testbench
│   └── constrs_1/imports/Vivado/
│       └── PYNQ-Z2 v1.0.xdc     # Pin constraints
├── clock.runs/                   # Synthesis & implementation
├── clock.sim/                    # Simulation files
└── clock.xpr                     # Vivado project file
```

## Implementation Details

### Seven-Segment Encoding
The `seven_segment_display` module converts 4-bit BCD values to 7-segment display codes:
- Active-low encoding for common anode displays
- Supports digits 0-9
- Blank display for invalid inputs

### Time Counters
- **Seconds**: 6-bit counter (0-59)
- **Minutes**: 6-bit counter (0-59)
- **Hours**: 5-bit counter (0-23)

### Display Multiplexing
- Refresh rate: ~1 kHz (configurable via clock divider)
- Sequential digit activation for flicker-free display
- Each digit displays for ~250 µs

## Simulation

A testbench (`testbench.v`) is provided for functional verification:
- Tests all four operational modes
- Validates mode transitions
- Verifies time setting functionality
- Simulates stopwatch and timer operations

### Running Simulation
```tcl
# In Vivado TCL Console
launch_simulation
run 500ns
```

## Synthesis & Implementation

### Tool Version
- **Vivado**: 2023.2
- **Target Device**: xc7z020clg400-1 (Zynq-7020)

### Resource Utilization
- Registers: ~148 flip-flops
- LUTs: Minimal combinational logic
- I/O Pins: 31 (8 inputs, 23 outputs)

## Known Limitations

1. **No Timing Constraints**: Design currently lacks formal timing constraints (XDC clock definitions)
2. **No Button Debouncing**: Direct button inputs may cause bouncing issues
3. **Unconstrained Timing**: No formal Static Timing Analysis performed
4. **No Metastability Protection**: Cross-clock domain signals not synchronized

## Future Enhancements

- [ ] Add button debouncing circuits
- [ ] Implement proper timing constraints
- [ ] Add synchronizers for button inputs
- [ ] Include seconds display option
- [ ] Add date functionality
- [ ] Implement 12-hour format with AM/PM
- [ ] Add buzzer output for alarm
- [ ] Battery backup for timekeeping

## Author

Created: April 2024

## License

This project is provided as-is for educational purposes.
