#!/bin/sh
set -e
rm -rf work
mkdir work
cd pasm
vs-schedule -s all -p 0.pasm -c 0.cstr
cp instr_lists.txt ../asm/0.txt
cd ..
cd work
cp ../main.cpp ./
cp ../include/*.hpp ./
g++ -g -Wall -Wno-strict-aliasing -Wno-unknown-pragmas -O2 -o main main.cpp
export PROTOCOL_BUFFERS_PYTHON_IMPLEMENTATION=python
./main
