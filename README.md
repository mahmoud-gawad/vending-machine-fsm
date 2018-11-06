# Vending Machine FSM

## Introduction
In this project, the objective was to build a simple chip to control a cans vending machine.

### Machine Operation
The machine operates as follows:
- The price of the can is 1.5 LE.
- The machine only accepts 1 LE and 0.5 LE coin, with a maximum of one coin entered at each cycle.
- The machine returns the change if there is any.

### Chip Specifications
The chip must have the following specs:
- Two input bits; **one_in** is high if the entered coin is 1 LE, and **half_in** is high if the entered coin is 0.5 LE. If no coin is inserted, both inputs are low.
- Two output bits; **can_out** is high when a can is to be output, and **change_out** is high if there is a change.
- An externally supplied **Reset** signal, which is also triggered after the can/change is ready. **Reset** is applied at the first falling clock edge after the can/change is out.
- Works at 10MHz.

## Design Process
### 1. FSM Design
The FSM design process was straightforward. The tables below show the state transition and output table, while the figure shows the state transition diagram.
The chosen FSM is a Moore FSM, with 5 states that transition as shown. Depending on the input, the FSM either transitions to another state or stays at the current state waiting for input to come. A reset signal, that is supplied externally, is used to bring the FSM back to the known initial state IDLE.

|State|state[2]|state[1]|state[0]|ne_in|half_in|nstate[2]|nstate[1]|nstate[0]|
|-----|--------|--------|--------|-----|-------|---------|---------|---------|
|IDLE|0|0|0|0|1|0|1|0|
|IDLE|0|0|0|1|0|0|0|1|
|ONELE|0|0|1|0|1|0|1|1|
|ONELE|0|0|1|1|0|1|0|0|
|HALFLE|0|1|0|0|1|0|0|1|
|HALFLE|0|1|0|1|0|0|1|1|
|CANOUT|0|1|1|X|X|0|0|0|
|CHNGOUT|1|0|0|X|X|0|0|0|

|State|state[2]|state[1]|state[0]|can_out|change_out|
|-----|--------|--------|--------|-------|----------|
|IDLE|0|0|0|0|0|
|ONELE|0|0|1|0|0|
|HALFLE|0|1|0|0|0|
|CANOUT|0|1|1|1|0|
|CHNGOUT|1|0|0|1|1|

![FSM Diagram](https://i.imgur.com/Pn0OESe.png "FSM Diagram")

## 2. High Level RTL Design
The RTL description of the FSM is coded in Verilog. The code describes the above FSM and allows for functional testing and simulation.
The simulation is carried out using ModelSim. The result of the simulation is shown in the next figure.

![FSM Testing Results](https://i.imgur.com/tUaPP7I.png "FSM Testing Results")

## 3. Design Synthesis
The realization of the design is made using Synopsys' *Design Compiler* tool. The schematic of the synthesis output is shown in the next figure.
The timing report tells us that the Slack is met and the design is ready to move to the next stage. The area and power reports are also supplied, and the total area is approximately 262 nm2 and the chip uses 0.8088 μW of power.

![Chip Synthesis](https://i.imgur.com/IdNT8KD.png "Chip Synthesis")

## 4. Placement & Routing
The PnR is carried out using *IC Compiler* tool. The placement starts with importing the cells.

![Design Cells](https://i.imgur.com/eKtbU5Q.png "Design Cells")

Then a floorplan is designed and made ready for placing the cells inside. We also add VDD and VSS track lines around the chip to be used by the cells.

![Floorplan](https://i.imgur.com/Oz5G9sF.png "Floorplan")

After floorplanning comes the placement step. We place the cells inside the chip to minimize area and power usage, and maximize performance.

![Cells Placement](https://i.imgur.com/gV2Z1s8.png "Cells Placement")

Then comes the routing step, where we route every cell and port together trying to maximize performance and minimize power usage.

![Cells Routing](https://i.imgur.com/tCGvvBZ.png "Cells Routing")

## 5. Padding
Before sending the IC to manufacturing, we need to add pads to it. Pads are used to protect the IC from electrostatic discharge (ESD), provide level shifting from external to core and vice versa, limit current caused by voltage spikes and drain away high voltages by using diodes. The next figure provides a look at how the chip looks like after adding the pads. A zoomed-in version is provided below to have an idea of the actual area of the chip.

![Final Chip With Pads](https://i.imgur.com/Gj77knn.png "Final Chip With Pads")

![Zoomed-in Chip View](https://i.imgur.com/4m7CyLc.png "Zoomed-in Chip View")

# Conclusion
A final chip to control the vending machine is designed for the required specifications and a final GDSII is completed to be ready for manufacturing.
The chip was tested using the specified frequency and it was proved functionally correct within it with positive Slack.
This is a simple design, but it uses all the steps and tools that can be used to design larger and more complicated chips.
