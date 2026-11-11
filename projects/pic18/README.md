# PIC18F45K22 embedded firmware

**INTEC coursework, 2018.** PIC18 assembly project for sampling an analog input, displaying the result on a multiplexed seven-segment display, and alerting when it crosses adjustable limits.

The archived implementation configures the oscillator and GPIO, sets up the ADC, and uses Timer0 and external interrupt handlers for threshold checks and user input. A lookup table maps display digits to segment patterns. Buttons enter and navigate the interface for adjusting upper and lower limits.

This case study documents the behavior observed in the recovered assembly. The original hardware wiring and toolchain have not been reproduced. Source publication is pending review of shared contributions.
