cell 0_0
#1-build route (from cell 0_0's slot2 to cell 1_0)
operation route0r slot=0, port=2
route slot=0, option=0, sr=0, source=2, target=0b10000000

#2.0-load input file / write IOSRAM(0=filter, 1-742=input matrix)
#filter
operation load_r_2_0 slot=1, port=0
dsu slot=1, port=0, init_addr=0

operation load_w_2_0 slot=1, port=2
dsu slot=1, port=2, init_addr=0

#3.0-read IOSRAM
#filter
operation read_io_3_0 slot=2, port=3
dsu slot=2, port=3, init_addr=0

#2.1-load input file
#round1: row0-8 of input matrix
operation load_r_2_1 slot=1, port=0
dsu slot=1, port=0, init_addr=1
rep slot=1, port=0, level=0, iter=63, step=1, delay=0

operation load_w_2_1 slot=1, port=2
dsu slot=1, port=2, init_addr=0
rep slot=1, port=2, level=0, iter=63, step=1, delay=0

#3.1-read IOSRAM
#round1: row0-8 of input matrix
operation read_io_3_1_1 slot=2, port=3
dsu slot=2, port=3, init_addr=0
rep slot=2, port=3, level=0, iter=4, step=1, delay=0
rep slot=2, port=3, level=1, iter=3, step=7, delay=0

operation read_io_3_1_2 slot=2, port=3
dsu slot=2, port=3, init_addr=3
rep slot=2, port=3, level=0, iter=2, step=1, delay=0
rep slot=2, port=3, level=1, iter=3, step=7, delay=0

operation read_io_3_1_3 slot=2, port=3
dsu slot=2, port=3, init_addr=4
rep slot=2, port=3, level=0, iter=3, step=1, delay=0
rep slot=2, port=3, level=1, iter=3, step=7, delay=0

operation read_io_zero slot=2, port=3
dsu slot=2, port=3, init_addr=63
rep slot=2, port=3, level=0, iter=4, step=0, delay=0


cell 1_0
#1-build route (from cell 0_0 to cell 1_0's slot3,4,5,6,7)
#  build route (from cell 1_0's slot7 to cell 1_0)
operation route1wr slot=0, port=2
route slot=0, option=0, sr=1, source=1, target=0b11111000
route slot=0, option=0, sr=0, source=7, target=0b10000000

#2-write filter to RF3
operation write_filter slot=3, port=2
dsu slot=3, port=2, init_addr=0

#3-build swb (RF4,5,6 for 3 rows. RF3 for filter. RF7 for result.)
#round1: row0-8
operation swb slot=0, port=0
swb slot=0, option=0, source=4, target=2
swb slot=0, option=0, source=3, target=1
swb slot=0, option=0, source=1, target=7

swb slot=0, option=1, source=5, target=2
swb slot=0, option=1, source=3, target=1
swb slot=0, option=1, source=1, target=7

swb slot=0, option=2, source=6, target=2
swb slot=0, option=2, source=3, target=1
swb slot=0, option=2, source=1, target=7

fsm slot=0, port=0, delay_0=2, delay_1=2
rep slot=0, port=0, level=0, iter=105, step=0, delay=2

#4.1-write matrix to RF4,5,6
#round1: row0-8
operation write_rf4_1 slot=4, port=2
dsu slot=4, port=2, init_addr=0
rep slot=4, port=2, level=0, iter=4, step=1, delay=0

operation write_rf5_1 slot=5, port=2
dsu slot=5, port=2, init_addr=0
rep slot=5, port=2, level=0, iter=4, step=1, delay=0

operation write_rf6_1 slot=6, port=2
dsu slot=6, port=2, init_addr=0
rep slot=6, port=2, level=0, iter=4, step=1, delay=0

operation write_rf4_2 slot=4, port=2
dsu slot=4, port=2, init_addr=0
rep slot=4, port=2, level=0, iter=2, step=1, delay=0

operation write_rf5_2 slot=5, port=2
dsu slot=5, port=2, init_addr=0
rep slot=5, port=2, level=0, iter=2, step=1, delay=0

operation write_rf6_2 slot=6, port=2
dsu slot=6, port=2, init_addr=0
rep slot=6, port=2, level=0, iter=2, step=1, delay=0

operation write_rf4_3 slot=4, port=2
dsu slot=4, port=2, init_addr=0
rep slot=4, port=2, level=0, iter=3, step=1, delay=0

operation write_rf5_3 slot=5, port=2
dsu slot=5, port=2, init_addr=0
rep slot=5, port=2, level=0, iter=3, step=1, delay=0

operation write_rf6_3 slot=6, port=2
dsu slot=6, port=2, init_addr=0
rep slot=6, port=2, level=0, iter=3, step=1, delay=0

#5.1-read matrix from RF4,5,6. read filter from RF7. convolution
#round1: row0-8
operation read_rf3_1 slot=3, port=1
dsu slot=3, port=1, init_addr=0
rep slot=3, port=1, level=0, iter=9, step=1, delay=0
rep slot=3, port=1, level=1, iter=64, step=0, delay=0

operation read_rf3_3 slot=3, port=1
dsu slot=3, port=1, init_addr=0
rep slot=3, port=1, level=0, iter=9, step=1, delay=0
rep slot=3, port=1, level=1, iter=40, step=0, delay=0

operation read_rf4_1 slot=4, port=1
dsu slot=4, port=1, init_addr=0
rep slot=4, port=1, level=0, iter=3, step=1, delay=0
rep slot=4, port=1, level=1, iter=62, step=1, delay=6

operation read_rf4_2 slot=4, port=1
dsu slot=4, port=1, init_addr=14
rep slot=4, port=1, level=0, iter=3, step=1, delay=0
rep slot=4, port=1, level=1, iter=2, step=1, delay=6

operation read_rf4_3 slot=4, port=1
dsu slot=4, port=1, init_addr=0
rep slot=4, port=1, level=0, iter=3, step=1, delay=0
rep slot=4, port=1, level=1, iter=40, step=1, delay=6

operation read_rf5_1 slot=5, port=1
dsu slot=5, port=1, init_addr=0
rep slot=5, port=1, level=0, iter=3, step=1, delay=0
rep slot=5, port=1, level=1, iter=62, step=1, delay=6

operation read_rf5_2 slot=5, port=1
dsu slot=5, port=1, init_addr=14
rep slot=5, port=1, level=0, iter=3, step=1, delay=0
rep slot=5, port=1, level=1, iter=2, step=1, delay=6

operation read_rf5_3 slot=5, port=1
dsu slot=5, port=1, init_addr=0
rep slot=5, port=1, level=0, iter=3, step=1, delay=0
rep slot=5, port=1, level=1, iter=40, step=1, delay=6

operation read_rf6_1 slot=6, port=1
dsu slot=6, port=1, init_addr=0
rep slot=6, port=1, level=0, iter=3, step=1, delay=0
rep slot=6, port=1, level=1, iter=62, step=1, delay=6

operation read_rf6_2 slot=6, port=1
dsu slot=6, port=1, init_addr=14
rep slot=6, port=1, level=0, iter=3, step=1, delay=0
rep slot=6, port=1, level=1, iter=2, step=1, delay=6

operation read_rf6_3 slot=6, port=1
dsu slot=6, port=1, init_addr=0
rep slot=6, port=1, level=0, iter=3, step=1, delay=0
rep slot=6, port=1, level=1, iter=40, step=1, delay=6

operation dpu slot=1, port=0
dpu slot=1, option=0, mode=2
rep slot=1, port=0, level=0, iter=105, step=0, delay=8

#6.1-write result to RF7
#round1: row0-8
operation write_rf7_1 slot=7, port=0
dsu slot=7, port=0, init_addr=0
rep slot=7, port=0, level=0, iter=64, step=1, delay=8

operation write_rf7_2 slot=7, port=0
dsu slot=7, port=0, init_addr=0
rep slot=7, port=0, level=0, iter=40, step=1, delay=8

#7.1-read result from RF7
#round1: row0-8
operation read_rf7_1 slot=7, port=3
dsu slot=7, port=3, init_addr=0
rep slot=7, port=3, level=0, iter=4, step=1, delay=0

operation read_rf7_2 slot=7, port=3
dsu slot=7, port=3, init_addr=0
rep slot=7, port=3, level=0, iter=3, step=1, delay=0

#8.1-emptify RF7
#round1: row0-8
operation write_rf7_zero slot=7, port=2
dsu slot=7, port=2, init_addr=0
rep slot=7, port=2, level=0, iter=4, step=1, delay=0


cell 2_0
#1-build route (from cell 1_0 to cell 2_0's slot2)
operation route2w slot=0, port=2
route slot=0, option=0, sr=1, source=1, target=0b0100

#2.1-write result to IOSRAM
#round1: row0-6 of output matrix
operation write_io_2_1_1 slot=2, port=2
dsu slot=2, port=2, init_addr=0
rep slot=2, port=2, level=0, iter=4, step=1, delay=0

operation write_io_2_1_2 slot=2, port=2
dsu slot=2, port=2, init_addr=4
rep slot=2, port=2, level=0, iter=3, step=1, delay=0

#3.1-store result to output file
#round1: row0-6
operation output_r_3_1 slot=1, port=3
dsu slot=1, port=3, init_addr=0
rep slot=1, port=3, level=0, iter=7, step=1, delay=0

operation output_w_3_1 slot=1, port=1
dsu slot=1, port=1, init_addr=0
rep slot=1, port=1, level=0, iter=7, step=1, delay=0





cell 0_1
#1-build route (from cell 0_1's slot2 to cell 1_1)
operation route0r_c1 slot=0, port=2
route slot=0, option=0, sr=0, source=2, target=0b10000000

#2.0-load input file / write IOSRAM(0=filter, 1-742=input matrix)
#filter
operation load_r_2_0_c1 slot=1, port=0
dsu slot=1, port=0, init_addr=0

operation load_w_2_0_c1 slot=1, port=2
dsu slot=1, port=2, init_addr=0

#3.0-read IOSRAM
#filter
operation read_io_3_0_c1 slot=2, port=3
dsu slot=2, port=3, init_addr=0

#2.1-load input file
#round5: row28-36 of input matrix
operation load_r_2_1_c1 slot=1, port=0
dsu slot=1, port=0, init_addr=197
rep slot=1, port=0, level=0, iter=63, step=1, delay=0

operation load_w_2_1_c1 slot=1, port=2
dsu slot=1, port=2, init_addr=0
rep slot=1, port=2, level=0, iter=63, step=1, delay=0

#3.1-read IOSRAM
#round5: row28-36 of input matrix
operation read_io_3_1_1_c1 slot=2, port=3
dsu slot=2, port=3, init_addr=0
rep slot=2, port=3, level=0, iter=4, step=1, delay=0
rep slot=2, port=3, level=1, iter=3, step=7, delay=0

operation read_io_3_1_2_c1 slot=2, port=3
dsu slot=2, port=3, init_addr=3
rep slot=2, port=3, level=0, iter=2, step=1, delay=0
rep slot=2, port=3, level=1, iter=3, step=7, delay=0

operation read_io_3_1_3_c1 slot=2, port=3
dsu slot=2, port=3, init_addr=4
rep slot=2, port=3, level=0, iter=3, step=1, delay=0
rep slot=2, port=3, level=1, iter=3, step=7, delay=0

operation read_io_zero_c1 slot=2, port=3
dsu slot=2, port=3, init_addr=63
rep slot=2, port=3, level=0, iter=4, step=0, delay=0


cell 1_1
#1-build route (from cell 0_1 to cell 1_1's slot3,4,5,6,7)
#  build route (from cell 1_1's slot7 to cell 1_1)
operation route1wr_c1 slot=0, port=2
route slot=0, option=0, sr=1, source=1, target=0b11111000
route slot=0, option=0, sr=0, source=7, target=0b10000000

#2-write filter to RF3
operation write_filter_c1 slot=3, port=2
dsu slot=3, port=2, init_addr=0

#3-build swb (RF4,5,6 for 3 rows. RF3 for filter. RF7 for result.)
#round5: row28-36
operation swb_c1 slot=0, port=0
swb slot=0, option=0, source=4, target=2
swb slot=0, option=0, source=3, target=1
swb slot=0, option=0, source=1, target=7

swb slot=0, option=1, source=5, target=2
swb slot=0, option=1, source=3, target=1
swb slot=0, option=1, source=1, target=7

swb slot=0, option=2, source=6, target=2
swb slot=0, option=2, source=3, target=1
swb slot=0, option=2, source=1, target=7

fsm slot=0, port=0, delay_0=2, delay_1=2
rep slot=0, port=0, level=0, iter=105, step=0, delay=2

#4.1-write matrix to RF4,5,6
#round5: row28-36
operation write_rf4_1_c1 slot=4, port=2
dsu slot=4, port=2, init_addr=0
rep slot=4, port=2, level=0, iter=4, step=1, delay=0

operation write_rf5_1_c1 slot=5, port=2
dsu slot=5, port=2, init_addr=0
rep slot=5, port=2, level=0, iter=4, step=1, delay=0

operation write_rf6_1_c1 slot=6, port=2
dsu slot=6, port=2, init_addr=0
rep slot=6, port=2, level=0, iter=4, step=1, delay=0

operation write_rf4_2_c1 slot=4, port=2
dsu slot=4, port=2, init_addr=0
rep slot=4, port=2, level=0, iter=2, step=1, delay=0

operation write_rf5_2_c1 slot=5, port=2
dsu slot=5, port=2, init_addr=0
rep slot=5, port=2, level=0, iter=2, step=1, delay=0

operation write_rf6_2_c1 slot=6, port=2
dsu slot=6, port=2, init_addr=0
rep slot=6, port=2, level=0, iter=2, step=1, delay=0

operation write_rf4_3_c1 slot=4, port=2
dsu slot=4, port=2, init_addr=0
rep slot=4, port=2, level=0, iter=3, step=1, delay=0

operation write_rf5_3_c1 slot=5, port=2
dsu slot=5, port=2, init_addr=0
rep slot=5, port=2, level=0, iter=3, step=1, delay=0

operation write_rf6_3_c1 slot=6, port=2
dsu slot=6, port=2, init_addr=0
rep slot=6, port=2, level=0, iter=3, step=1, delay=0

#5.1-read matrix from RF4,5,6. read filter from RF7. convolution
#round5: row28-36
operation read_rf3_1_c1 slot=3, port=1
dsu slot=3, port=1, init_addr=0
rep slot=3, port=1, level=0, iter=9, step=1, delay=0
rep slot=3, port=1, level=1, iter=64, step=0, delay=0

operation read_rf3_3_c1 slot=3, port=1
dsu slot=3, port=1, init_addr=0
rep slot=3, port=1, level=0, iter=9, step=1, delay=0
rep slot=3, port=1, level=1, iter=40, step=0, delay=0

operation read_rf4_1_c1 slot=4, port=1
dsu slot=4, port=1, init_addr=0
rep slot=4, port=1, level=0, iter=3, step=1, delay=0
rep slot=4, port=1, level=1, iter=62, step=1, delay=6

operation read_rf4_2_c1 slot=4, port=1
dsu slot=4, port=1, init_addr=14
rep slot=4, port=1, level=0, iter=3, step=1, delay=0
rep slot=4, port=1, level=1, iter=2, step=1, delay=6

operation read_rf4_3_c1 slot=4, port=1
dsu slot=4, port=1, init_addr=0
rep slot=4, port=1, level=0, iter=3, step=1, delay=0
rep slot=4, port=1, level=1, iter=40, step=1, delay=6

operation read_rf5_1_c1 slot=5, port=1
dsu slot=5, port=1, init_addr=0
rep slot=5, port=1, level=0, iter=3, step=1, delay=0
rep slot=5, port=1, level=1, iter=62, step=1, delay=6

operation read_rf5_2_c1 slot=5, port=1
dsu slot=5, port=1, init_addr=14
rep slot=5, port=1, level=0, iter=3, step=1, delay=0
rep slot=5, port=1, level=1, iter=2, step=1, delay=6

operation read_rf5_3_c1 slot=5, port=1
dsu slot=5, port=1, init_addr=0
rep slot=5, port=1, level=0, iter=3, step=1, delay=0
rep slot=5, port=1, level=1, iter=40, step=1, delay=6

operation read_rf6_1_c1 slot=6, port=1
dsu slot=6, port=1, init_addr=0
rep slot=6, port=1, level=0, iter=3, step=1, delay=0
rep slot=6, port=1, level=1, iter=62, step=1, delay=6

operation read_rf6_2_c1 slot=6, port=1
dsu slot=6, port=1, init_addr=14
rep slot=6, port=1, level=0, iter=3, step=1, delay=0
rep slot=6, port=1, level=1, iter=2, step=1, delay=6

operation read_rf6_3_c1 slot=6, port=1
dsu slot=6, port=1, init_addr=0
rep slot=6, port=1, level=0, iter=3, step=1, delay=0
rep slot=6, port=1, level=1, iter=40, step=1, delay=6

operation dpu_c1 slot=1, port=0
dpu slot=1, option=0, mode=2
rep slot=1, port=0, level=0, iter=105, step=0, delay=8

#6.1-write result to RF7
#round5: row28-36
operation write_rf7_1_c1 slot=7, port=0
dsu slot=7, port=0, init_addr=0
rep slot=7, port=0, level=0, iter=64, step=1, delay=8

operation write_rf7_2_c1 slot=7, port=0
dsu slot=7, port=0, init_addr=0
rep slot=7, port=0, level=0, iter=40, step=1, delay=8

#7.1-read result from RF7
#round5: row28-36
operation read_rf7_1_c1 slot=7, port=3
dsu slot=7, port=3, init_addr=0
rep slot=7, port=3, level=0, iter=4, step=1, delay=0

operation read_rf7_2_c1 slot=7, port=3
dsu slot=7, port=3, init_addr=0
rep slot=7, port=3, level=0, iter=3, step=1, delay=0

#8.1-emptify RF7
#round5: row28-36
operation write_rf7_zero_c1 slot=7, port=2
dsu slot=7, port=2, init_addr=0
rep slot=7, port=2, level=0, iter=4, step=1, delay=0


cell 2_1
#1-build route (from cell 1_1 to cell 2_1's slot2)
operation route2w_c1 slot=0, port=2
route slot=0, option=0, sr=1, source=1, target=0b0100

#2.1-write result to IOSRAM
#round5: row28-34 of output matrix
operation write_io_2_1_1_c1 slot=2, port=2
dsu slot=2, port=2, init_addr=0
rep slot=2, port=2, level=0, iter=4, step=1, delay=0

operation write_io_2_1_2_c1 slot=2, port=2
dsu slot=2, port=2, init_addr=4
rep slot=2, port=2, level=0, iter=3, step=1, delay=0

#3.1-store result to output file
#round5: row28-34
operation output_r_3_1_c1 slot=1, port=3
dsu slot=1, port=3, init_addr=0
rep slot=1, port=3, level=0, iter=7, step=1, delay=0

operation output_w_3_1_c1 slot=1, port=1
dsu slot=1, port=1, init_addr=7
rep slot=1, port=1, level=0, iter=7, step=1, delay=0
#temporal storage





cell 0_2
#1-build route (from cell 0_2's slot2 to cell 1_2)
operation route0r_c2 slot=0, port=2
route slot=0, option=0, sr=0, source=2, target=0b10000000

#2.0-load input file / write IOSRAM(0=filter, 1-742=input matrix)
#filter
operation load_r_2_0_c2 slot=1, port=0
dsu slot=1, port=0, init_addr=0

operation load_w_2_0_c2 slot=1, port=2
dsu slot=1, port=2, init_addr=0

#3.0-read IOSRAM
#filter
operation read_io_3_0_c2 slot=2, port=3
dsu slot=2, port=3, init_addr=0

#2.1-load input file
#round9: row56-64 of input matrix
operation load_r_2_1_c2 slot=1, port=0
dsu slot=1, port=0, init_addr=393
rep slot=1, port=0, level=0, iter=63, step=1, delay=0

operation load_w_2_1_c2 slot=1, port=2
dsu slot=1, port=2, init_addr=0
rep slot=1, port=2, level=0, iter=63, step=1, delay=0

#3.1-read IOSRAM
#round9: row56-64 of input matrix
operation read_io_3_1_1_c2 slot=2, port=3
dsu slot=2, port=3, init_addr=0
rep slot=2, port=3, level=0, iter=4, step=1, delay=0
rep slot=2, port=3, level=1, iter=3, step=7, delay=0

operation read_io_3_1_2_c2 slot=2, port=3
dsu slot=2, port=3, init_addr=3
rep slot=2, port=3, level=0, iter=2, step=1, delay=0
rep slot=2, port=3, level=1, iter=3, step=7, delay=0

operation read_io_3_1_3_c2 slot=2, port=3
dsu slot=2, port=3, init_addr=4
rep slot=2, port=3, level=0, iter=3, step=1, delay=0
rep slot=2, port=3, level=1, iter=3, step=7, delay=0

operation read_io_zero_c2 slot=2, port=3
dsu slot=2, port=3, init_addr=63
rep slot=2, port=3, level=0, iter=4, step=0, delay=0


cell 1_2
#1-build route (from cell 0_2 to cell 1_2's slot3,4,5,6,7)
#  build route (from cell 1_2's slot7 to cell 1_2)
operation route1wr_c2 slot=0, port=2
route slot=0, option=0, sr=1, source=1, target=0b11111000
route slot=0, option=0, sr=0, source=7, target=0b10000000

#2-write filter to RF3
operation write_filter_c2 slot=3, port=2
dsu slot=3, port=2, init_addr=0

#3-build swb (RF4,5,6 for 3 rows. RF3 for filter. RF7 for result.)
#round9: row56-64
operation swb_c2 slot=0, port=0
swb slot=0, option=0, source=4, target=2
swb slot=0, option=0, source=3, target=1
swb slot=0, option=0, source=1, target=7

swb slot=0, option=1, source=5, target=2
swb slot=0, option=1, source=3, target=1
swb slot=0, option=1, source=1, target=7

swb slot=0, option=2, source=6, target=2
swb slot=0, option=2, source=3, target=1
swb slot=0, option=2, source=1, target=7

fsm slot=0, port=0, delay_0=2, delay_1=2
rep slot=0, port=0, level=0, iter=105, step=0, delay=2

#4.1-write matrix to RF4,5,6
#round9: row56-64
operation write_rf4_1_c2 slot=4, port=2
dsu slot=4, port=2, init_addr=0
rep slot=4, port=2, level=0, iter=4, step=1, delay=0

operation write_rf5_1_c2 slot=5, port=2
dsu slot=5, port=2, init_addr=0
rep slot=5, port=2, level=0, iter=4, step=1, delay=0

operation write_rf6_1_c2 slot=6, port=2
dsu slot=6, port=2, init_addr=0
rep slot=6, port=2, level=0, iter=4, step=1, delay=0

operation write_rf4_2_c2 slot=4, port=2
dsu slot=4, port=2, init_addr=0
rep slot=4, port=2, level=0, iter=2, step=1, delay=0

operation write_rf5_2_c2 slot=5, port=2
dsu slot=5, port=2, init_addr=0
rep slot=5, port=2, level=0, iter=2, step=1, delay=0

operation write_rf6_2_c2 slot=6, port=2
dsu slot=6, port=2, init_addr=0
rep slot=6, port=2, level=0, iter=2, step=1, delay=0

operation write_rf4_3_c2 slot=4, port=2
dsu slot=4, port=2, init_addr=0
rep slot=4, port=2, level=0, iter=3, step=1, delay=0

operation write_rf5_3_c2 slot=5, port=2
dsu slot=5, port=2, init_addr=0
rep slot=5, port=2, level=0, iter=3, step=1, delay=0

operation write_rf6_3_c2 slot=6, port=2
dsu slot=6, port=2, init_addr=0
rep slot=6, port=2, level=0, iter=3, step=1, delay=0

#5.1-read matrix from RF4,5,6. read filter from RF7. convolution
#round9: row56-64
operation read_rf3_1_c2 slot=3, port=1
dsu slot=3, port=1, init_addr=0
rep slot=3, port=1, level=0, iter=9, step=1, delay=0
rep slot=3, port=1, level=1, iter=64, step=0, delay=0

operation read_rf3_3_c2 slot=3, port=1
dsu slot=3, port=1, init_addr=0
rep slot=3, port=1, level=0, iter=9, step=1, delay=0
rep slot=3, port=1, level=1, iter=40, step=0, delay=0

operation read_rf4_1_c2 slot=4, port=1
dsu slot=4, port=1, init_addr=0
rep slot=4, port=1, level=0, iter=3, step=1, delay=0
rep slot=4, port=1, level=1, iter=62, step=1, delay=6

operation read_rf4_2_c2 slot=4, port=1
dsu slot=4, port=1, init_addr=14
rep slot=4, port=1, level=0, iter=3, step=1, delay=0
rep slot=4, port=1, level=1, iter=2, step=1, delay=6

operation read_rf4_3_c2 slot=4, port=1
dsu slot=4, port=1, init_addr=0
rep slot=4, port=1, level=0, iter=3, step=1, delay=0
rep slot=4, port=1, level=1, iter=40, step=1, delay=6

operation read_rf5_1_c2 slot=5, port=1
dsu slot=5, port=1, init_addr=0
rep slot=5, port=1, level=0, iter=3, step=1, delay=0
rep slot=5, port=1, level=1, iter=62, step=1, delay=6

operation read_rf5_2_c2 slot=5, port=1
dsu slot=5, port=1, init_addr=14
rep slot=5, port=1, level=0, iter=3, step=1, delay=0
rep slot=5, port=1, level=1, iter=2, step=1, delay=6

operation read_rf5_3_c2 slot=5, port=1
dsu slot=5, port=1, init_addr=0
rep slot=5, port=1, level=0, iter=3, step=1, delay=0
rep slot=5, port=1, level=1, iter=40, step=1, delay=6

operation read_rf6_1_c2 slot=6, port=1
dsu slot=6, port=1, init_addr=0
rep slot=6, port=1, level=0, iter=3, step=1, delay=0
rep slot=6, port=1, level=1, iter=62, step=1, delay=6

operation read_rf6_2_c2 slot=6, port=1
dsu slot=6, port=1, init_addr=14
rep slot=6, port=1, level=0, iter=3, step=1, delay=0
rep slot=6, port=1, level=1, iter=2, step=1, delay=6

operation read_rf6_3_c2 slot=6, port=1
dsu slot=6, port=1, init_addr=0
rep slot=6, port=1, level=0, iter=3, step=1, delay=0
rep slot=6, port=1, level=1, iter=40, step=1, delay=6

operation dpu_c2 slot=1, port=0
dpu slot=1, option=0, mode=2
rep slot=1, port=0, level=0, iter=105, step=0, delay=8

#6.1-write result to RF7
#round9: row56-64
operation write_rf7_1_c2 slot=7, port=0
dsu slot=7, port=0, init_addr=0
rep slot=7, port=0, level=0, iter=64, step=1, delay=8

operation write_rf7_2_c2 slot=7, port=0
dsu slot=7, port=0, init_addr=0
rep slot=7, port=0, level=0, iter=40, step=1, delay=8

#7.1-read result from RF7
#round9: row56-64
operation read_rf7_1_c2 slot=7, port=3
dsu slot=7, port=3, init_addr=0
rep slot=7, port=3, level=0, iter=4, step=1, delay=0

operation read_rf7_2_c2 slot=7, port=3
dsu slot=7, port=3, init_addr=0
rep slot=7, port=3, level=0, iter=3, step=1, delay=0

#8.1-emptify RF7
#round9: row56-64
operation write_rf7_zero_c2 slot=7, port=2
dsu slot=7, port=2, init_addr=0
rep slot=7, port=2, level=0, iter=4, step=1, delay=0


cell 2_2
#1-build route (from cell 1_2 to cell 2_2's slot2)
operation route2w_c2 slot=0, port=2
route slot=0, option=0, sr=1, source=1, target=0b0100

#2.1-write result to IOSRAM
#round9: row56-62 of output matrix
operation write_io_2_1_1_c2 slot=2, port=2
dsu slot=2, port=2, init_addr=0
rep slot=2, port=2, level=0, iter=4, step=1, delay=0

operation write_io_2_1_2_c2 slot=2, port=2
dsu slot=2, port=2, init_addr=4
rep slot=2, port=2, level=0, iter=3, step=1, delay=0

#3.1-store result to output file
#round9: row56-62
operation output_r_3_1_c2 slot=1, port=3
dsu slot=1, port=3, init_addr=0
rep slot=1, port=3, level=0, iter=7, step=1, delay=0

operation output_w_3_1_c2 slot=1, port=1
dsu slot=1, port=1, init_addr=14
rep slot=1, port=1, level=0, iter=7, step=1, delay=0





cell 0_3
#1-build route (from cell 0_3's slot2 to cell 1_3)
operation route0r_c3 slot=0, port=2
route slot=0, option=0, sr=0, source=2, target=0b10000000

#2.0-load input file / write IOSRAM(0=filter, 1-742=input matrix)
#filter
operation load_r_2_0_c3 slot=1, port=0
dsu slot=1, port=0, init_addr=0

operation load_w_2_0_c3 slot=1, port=2
dsu slot=1, port=2, init_addr=0

#3.0-read IOSRAM
#filter
operation read_io_3_0_c3 slot=2, port=3
dsu slot=2, port=3, init_addr=0

#2.1-load input file
#round13: row84-92 of input matrix
operation load_r_2_1_c3 slot=1, port=0
dsu slot=1, port=0, init_addr=589
rep slot=1, port=0, level=0, iter=63, step=1, delay=0

operation load_w_2_1_c3 slot=1, port=2
dsu slot=1, port=2, init_addr=0
rep slot=1, port=2, level=0, iter=63, step=1, delay=0

#3.1-read IOSRAM
#round13: row84-92 of input matrix
operation read_io_3_1_1_c3 slot=2, port=3
dsu slot=2, port=3, init_addr=0
rep slot=2, port=3, level=0, iter=4, step=1, delay=0
rep slot=2, port=3, level=1, iter=3, step=7, delay=0

operation read_io_3_1_2_c3 slot=2, port=3
dsu slot=2, port=3, init_addr=3
rep slot=2, port=3, level=0, iter=2, step=1, delay=0
rep slot=2, port=3, level=1, iter=3, step=7, delay=0

operation read_io_3_1_3_c3 slot=2, port=3
dsu slot=2, port=3, init_addr=4
rep slot=2, port=3, level=0, iter=3, step=1, delay=0
rep slot=2, port=3, level=1, iter=3, step=7, delay=0

operation read_io_zero_c3 slot=2, port=3
dsu slot=2, port=3, init_addr=63
rep slot=2, port=3, level=0, iter=4, step=0, delay=0


cell 1_3
#1-build route (from cell 0_3 to cell 1_3's slot3,4,5,6,7)
#  build route (from cell 1_3's slot7 to cell 1_3)
operation route1wr_c3 slot=0, port=2
route slot=0, option=0, sr=1, source=1, target=0b11111000
route slot=0, option=0, sr=0, source=7, target=0b10000000

#2-write filter to RF3
operation write_filter_c3 slot=3, port=2
dsu slot=3, port=2, init_addr=0

#3-build swb (RF4,5,6 for 3 rows. RF3 for filter. RF7 for result.)
#round13: row84-92
operation swb_c3 slot=0, port=0
swb slot=0, option=0, source=4, target=2
swb slot=0, option=0, source=3, target=1
swb slot=0, option=0, source=1, target=7

swb slot=0, option=1, source=5, target=2
swb slot=0, option=1, source=3, target=1
swb slot=0, option=1, source=1, target=7

swb slot=0, option=2, source=6, target=2
swb slot=0, option=2, source=3, target=1
swb slot=0, option=2, source=1, target=7

fsm slot=0, port=0, delay_0=2, delay_1=2
rep slot=0, port=0, level=0, iter=105, step=0, delay=2

#4.1-write matrix to RF4,5,6
#round13: row84-92
operation write_rf4_1_c3 slot=4, port=2
dsu slot=4, port=2, init_addr=0
rep slot=4, port=2, level=0, iter=4, step=1, delay=0

operation write_rf5_1_c3 slot=5, port=2
dsu slot=5, port=2, init_addr=0
rep slot=5, port=2, level=0, iter=4, step=1, delay=0

operation write_rf6_1_c3 slot=6, port=2
dsu slot=6, port=2, init_addr=0
rep slot=6, port=2, level=0, iter=4, step=1, delay=0

operation write_rf4_2_c3 slot=4, port=2
dsu slot=4, port=2, init_addr=0
rep slot=4, port=2, level=0, iter=2, step=1, delay=0

operation write_rf5_2_c3 slot=5, port=2
dsu slot=5, port=2, init_addr=0
rep slot=5, port=2, level=0, iter=2, step=1, delay=0

operation write_rf6_2_c3 slot=6, port=2
dsu slot=6, port=2, init_addr=0
rep slot=6, port=2, level=0, iter=2, step=1, delay=0

operation write_rf4_3_c3 slot=4, port=2
dsu slot=4, port=2, init_addr=0
rep slot=4, port=2, level=0, iter=3, step=1, delay=0

operation write_rf5_3_c3 slot=5, port=2
dsu slot=5, port=2, init_addr=0
rep slot=5, port=2, level=0, iter=3, step=1, delay=0

operation write_rf6_3_c3 slot=6, port=2
dsu slot=6, port=2, init_addr=0
rep slot=6, port=2, level=0, iter=3, step=1, delay=0

#5.1-read matrix from RF4,5,6. read filter from RF7. convolution
#round13: row84-92
operation read_rf3_1_c3 slot=3, port=1
dsu slot=3, port=1, init_addr=0
rep slot=3, port=1, level=0, iter=9, step=1, delay=0
rep slot=3, port=1, level=1, iter=64, step=0, delay=0

operation read_rf3_3_c3 slot=3, port=1
dsu slot=3, port=1, init_addr=0
rep slot=3, port=1, level=0, iter=9, step=1, delay=0
rep slot=3, port=1, level=1, iter=40, step=0, delay=0

operation read_rf4_1_c3 slot=4, port=1
dsu slot=4, port=1, init_addr=0
rep slot=4, port=1, level=0, iter=3, step=1, delay=0
rep slot=4, port=1, level=1, iter=62, step=1, delay=6

operation read_rf4_2_c3 slot=4, port=1
dsu slot=4, port=1, init_addr=14
rep slot=4, port=1, level=0, iter=3, step=1, delay=0
rep slot=4, port=1, level=1, iter=2, step=1, delay=6

operation read_rf4_3_c3 slot=4, port=1
dsu slot=4, port=1, init_addr=0
rep slot=4, port=1, level=0, iter=3, step=1, delay=0
rep slot=4, port=1, level=1, iter=40, step=1, delay=6

operation read_rf5_1_c3 slot=5, port=1
dsu slot=5, port=1, init_addr=0
rep slot=5, port=1, level=0, iter=3, step=1, delay=0
rep slot=5, port=1, level=1, iter=62, step=1, delay=6

operation read_rf5_2_c3 slot=5, port=1
dsu slot=5, port=1, init_addr=14
rep slot=5, port=1, level=0, iter=3, step=1, delay=0
rep slot=5, port=1, level=1, iter=2, step=1, delay=6

operation read_rf5_3_c3 slot=5, port=1
dsu slot=5, port=1, init_addr=0
rep slot=5, port=1, level=0, iter=3, step=1, delay=0
rep slot=5, port=1, level=1, iter=40, step=1, delay=6

operation read_rf6_1_c3 slot=6, port=1
dsu slot=6, port=1, init_addr=0
rep slot=6, port=1, level=0, iter=3, step=1, delay=0
rep slot=6, port=1, level=1, iter=62, step=1, delay=6

operation read_rf6_2_c3 slot=6, port=1
dsu slot=6, port=1, init_addr=14
rep slot=6, port=1, level=0, iter=3, step=1, delay=0
rep slot=6, port=1, level=1, iter=2, step=1, delay=6

operation read_rf6_3_c3 slot=6, port=1
dsu slot=6, port=1, init_addr=0
rep slot=6, port=1, level=0, iter=3, step=1, delay=0
rep slot=6, port=1, level=1, iter=40, step=1, delay=6

operation dpu_c3 slot=1, port=0
dpu slot=1, option=0, mode=2
rep slot=1, port=0, level=0, iter=105, step=0, delay=8

#6.1-write result to RF7
#round13: row84-92
operation write_rf7_1_c3 slot=7, port=0
dsu slot=7, port=0, init_addr=0
rep slot=7, port=0, level=0, iter=64, step=1, delay=8

operation write_rf7_2_c3 slot=7, port=0
dsu slot=7, port=0, init_addr=0
rep slot=7, port=0, level=0, iter=40, step=1, delay=8

#7.1-read result from RF7
#round13: row84-92
operation read_rf7_1_c3 slot=7, port=3
dsu slot=7, port=3, init_addr=0
rep slot=7, port=3, level=0, iter=4, step=1, delay=0

operation read_rf7_2_c3 slot=7, port=3
dsu slot=7, port=3, init_addr=0
rep slot=7, port=3, level=0, iter=3, step=1, delay=0

#8.1-emptify RF7
#round13: row84-92
operation write_rf7_zero_c3 slot=7, port=2
dsu slot=7, port=2, init_addr=0
rep slot=7, port=2, level=0, iter=4, step=1, delay=0


cell 2_3
#1-build route (from cell 1_3 to cell 2_3's slot2)
operation route2w_c3 slot=0, port=2
route slot=0, option=0, sr=1, source=1, target=0b0100

#2.1-write result to IOSRAM
#round13: row84-90 of output matrix
operation write_io_2_1_1_c3 slot=2, port=2
dsu slot=2, port=2, init_addr=0
rep slot=2, port=2, level=0, iter=4, step=1, delay=0

operation write_io_2_1_2_c3 slot=2, port=2
dsu slot=2, port=2, init_addr=4
rep slot=2, port=2, level=0, iter=3, step=1, delay=0

#3.1-store result to output file
#round13: row84-90
operation output_r_3_1_c3 slot=1, port=3
dsu slot=1, port=3, init_addr=0
rep slot=1, port=3, level=0, iter=7, step=1, delay=0

operation output_w_3_1_c3 slot=1, port=1
dsu slot=1, port=1, init_addr=21
rep slot=1, port=1, level=0, iter=7, step=1, delay=0