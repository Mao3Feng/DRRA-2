# DRRA-2 Programming Steps

## Define Architecture

Modify the **arch.json** file to define the architecture of the system. Use predefined resources and controllers to define new cells and compose the fabric using the defined cells.

## Create Verification Environment

Modify the **main.cpp** file to create the verification environment. You need to create three functions:

1. `init()`: Generate the stimuli as input buffer.
2. `model_l0`: Describe the behavior of the algorithm in free-style C++ format. This function will create the reference output buffer once being called.
3. `model_l1`: Describe the behavior of the algorithm by calling the simulator with specific code segment. The code segments are defined in folder **asm** as assembly language files. Their names are purely natural numbers starting from 0. You can also use free-style C++ code such as for-loops to wrap the execution of assembly code segments. For now, the free-style C++ code will not be executed on the fabric. It will just be emulated by the computer simulator.

## Write Assembly Code Segments

Put the assembly code segments in the **asm** folder. The file names should be purely natural numbers starting from 0. Each code segment should be self contained in terms of timing. Meaning that it cannot have any part that relies on event-driving mechanism. After execution of each code segment, the global controller on the fabric is fully synchronized and ready for the next code segment.

## About the asm: (106x106) * (3x3) = (104*104)

It's unnecessary to fulfill the whole process of convolution, because it'll be time-consuming and hard to debug. The code only covers the convolution of row0, row1, row2. The rest timing consumption can thus be deduced.
