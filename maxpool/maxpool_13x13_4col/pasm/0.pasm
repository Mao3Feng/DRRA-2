cell 0_0
#1-build route (from cell 0_0's slot2 to cell 1_0)
operation route0r slot=0, port=2
route slot=0, option=0, sr=0, source=2, target=0b10000000

#2.1-load input file
#round1: row0-3 of input matrix
operation load_r_2_1 slot=1, port=0
dsu slot=1, port=0, init_addr=0
rep slot=1, port=0, level=0, iter=4, step=1, delay=0

operation load_w_2_1 slot=1, port=2
dsu slot=1, port=2, init_addr=0
rep slot=1, port=2, level=0, iter=4, step=1, delay=0

#3.1-read IOSRAM
#round1: row0-3 of input matrix
operation read_io_3_1 slot=2, port=3
dsu slot=2, port=3, init_addr=0
rep slot=2, port=3, level=0, iter=2, step=1, delay=0
rep slot=2, port=3, level=1, iter=3, step=1, delay=t0


cell 1_0
#1-build route (from cell 0_0 to cell 1_0's slot3,4)
#  build route (from cell 1_0's slot5 to cell 2_0)
operation route1wr slot=0, port=2
route slot=0, option=0, sr=1, source=1, target=0b00011000
route slot=0, option=0, sr=0, source=5, target=0b10000000

#2-build swb (RF3,4 for 2 rows. RF5 for result.)
#round1: row0-3
operation swb slot=0, port=0
swb slot=0, option=0, source=3, target=1
swb slot=0, option=0, source=1, target=5

swb slot=0, option=1, source=4, target=1
swb slot=0, option=1, source=1, target=5

fsm slot=0, port=0, delay_0=1
rep slot=0, port=0, level=0, iter=12, step=0, delay=1
rep slot=0, port=0, level=1, iter=3, step=0, delay=1

#3.1-write matrix to RF3,4
#round1: row0-3
operation write_rf3 slot=3, port=2
dsu slot=3, port=2, init_addr=0
rep slot=3, port=2, level=0, iter=3, step=0, delay=t1

operation write_rf4 slot=4, port=2
dsu slot=4, port=2, init_addr=0
rep slot=4, port=2, level=0, iter=3, step=0, delay=t1

#4.1-read matrix from RF3,4. maxpool
#round1: row0-3
operation read_rf3 slot=3, port=1
dsu slot=3, port=1, init_addr=0
rep slot=3, port=1, level=0, iter=2, step=1, delay=0
rep slot=3, port=1, level=1, iter=12, step=1, delay=2
rep slot=3, port=1, level=2, iter=3, step=0, delay=2

operation read_rf4 slot=4, port=1
dsu slot=4, port=1, init_addr=0
rep slot=4, port=1, level=0, iter=2, step=1, delay=0
rep slot=4, port=1, level=1, iter=12, step=1, delay=2
rep slot=4, port=1, level=2, iter=3, step=0, delay=2

operation dpu slot=1, port=0
dpu slot=1, option=0, mode=16
rep slot=1, port=0, level=0, iter=36, step=0, delay=3

#5.1-write result to RF5
#round1: row0-3
operation write_rf5 slot=5, port=0
dsu slot=5, port=0, init_addr=0
rep slot=5, port=0, level=0, iter=12, step=1, delay=3
rep slot=5, port=0, level=1, iter=3, step=0, delay=3

#6.1-read result from RF5
#round1: row0-3
operation read_rf5 slot=5, port=3
dsu slot=5, port=3, init_addr=0
rep slot=5, port=3, level=0, iter=3, step=0, delay=t2


cell 2_0
#1-build route (from cell 1_0 to cell 2_0's slot2)
operation route2w slot=0, port=2
route slot=0, option=0, sr=1, source=1, target=0b0100

#2.1-write result to IOSRAM
#round1: store row0-2
operation write_io_2_1 slot=2, port=2
dsu slot=2, port=2, init_addr=0
rep slot=2, port=2, level=0, iter=3, step=1, delay=t2

#3.1-store result to output file
#round1: store row0-2 (actually store 13 lines due to data format)
operation output_r_3_1 slot=1, port=3
dsu slot=1, port=3, init_addr=0
rep slot=1, port=3, level=0, iter=3, step=1, delay=0

operation output_w_3_1 slot=1, port=1
dsu slot=1, port=1, init_addr=0
rep slot=1, port=1, level=0, iter=3, step=1, delay=0





cell 0_1
#1-build route (from cell 0_1's slot2 to cell 1_1)
operation route0r_c1 slot=0, port=2
route slot=0, option=0, sr=0, source=2, target=0b10000000

#2.1-load input file
#round1: row3-6 of input matrix
operation load_r_2_1_c1 slot=1, port=0
dsu slot=1, port=0, init_addr=3
rep slot=1, port=0, level=0, iter=4, step=1, delay=0

operation load_w_2_1_c1 slot=1, port=2
dsu slot=1, port=2, init_addr=0
rep slot=1, port=2, level=0, iter=4, step=1, delay=0

#3.1-read IOSRAM
#round1: row3-6 of input matrix
operation read_io_3_1_c1 slot=2, port=3
dsu slot=2, port=3, init_addr=0
rep slot=2, port=3, level=0, iter=2, step=1, delay=0
rep slot=2, port=3, level=1, iter=3, step=1, delay=t0


cell 1_1
#1-build route (from cell 0_1 to cell 1_1's slot3,4)
#  build route (from cell 1_1's slot5 to cell 2_1)
operation route1wr_c1 slot=0, port=2
route slot=0, option=0, sr=1, source=1, target=0b00011000
route slot=0, option=0, sr=0, source=5, target=0b10000000

#2-build swb (RF3,4 for 2 rows. RF5 for result.)
#round1: row3-6
operation swb_c1 slot=0, port=0
swb slot=0, option=0, source=3, target=1
swb slot=0, option=0, source=1, target=5

swb slot=0, option=1, source=4, target=1
swb slot=0, option=1, source=1, target=5

fsm slot=0, port=0, delay_0=1
rep slot=0, port=0, level=0, iter=12, step=0, delay=1
rep slot=0, port=0, level=1, iter=3, step=0, delay=1

#3.1-write matrix to RF3,4
#round1: row3-6
operation write_rf3_c1 slot=3, port=2
dsu slot=3, port=2, init_addr=0
rep slot=3, port=2, level=0, iter=3, step=0, delay=t1

operation write_rf4_c1 slot=4, port=2
dsu slot=4, port=2, init_addr=0
rep slot=4, port=2, level=0, iter=3, step=0, delay=t1

#4.1-read matrix from RF3,4. maxpool
#round1: row3-6
operation read_rf3_c1 slot=3, port=1
dsu slot=3, port=1, init_addr=0
rep slot=3, port=1, level=0, iter=2, step=1, delay=0
rep slot=3, port=1, level=1, iter=12, step=1, delay=2
rep slot=3, port=1, level=2, iter=3, step=0, delay=2

operation read_rf4_c1 slot=4, port=1
dsu slot=4, port=1, init_addr=0
rep slot=4, port=1, level=0, iter=2, step=1, delay=0
rep slot=4, port=1, level=1, iter=12, step=1, delay=2
rep slot=4, port=1, level=2, iter=3, step=0, delay=2

operation dpu_c1 slot=1, port=0
dpu slot=1, option=0, mode=16
rep slot=1, port=0, level=0, iter=36, step=0, delay=3

#5.1-write result to RF5
#round1: row3-6
operation write_rf5_c1 slot=5, port=0
dsu slot=5, port=0, init_addr=0
rep slot=5, port=0, level=0, iter=12, step=1, delay=3
rep slot=5, port=0, level=1, iter=3, step=0, delay=3

#6.1-read result from RF5
#round1: row3-6
operation read_rf5_c1 slot=5, port=3
dsu slot=5, port=3, init_addr=0
rep slot=5, port=3, level=0, iter=3, step=0, delay=t2


cell 2_1
#1-build route (from cell 1_1 to cell 2_1's slot2)
operation route2w_c1 slot=0, port=2
route slot=0, option=0, sr=1, source=1, target=0b0100

#2.1-write result to IOSRAM
#round1: store row3-5
operation write_io_2_1_c1 slot=2, port=2
dsu slot=2, port=2, init_addr=0
rep slot=2, port=2, level=0, iter=3, step=1, delay=t2

#3.1-store result to output file
#round1: store row3-5 (actually store 13 lines due to data format)
operation output_r_3_1_c1 slot=1, port=3
dsu slot=1, port=3, init_addr=0
rep slot=1, port=3, level=0, iter=3, step=1, delay=0

operation output_w_3_1_c1 slot=1, port=1
dsu slot=1, port=1, init_addr=3
rep slot=1, port=1, level=0, iter=3, step=1, delay=0





cell 0_2
#1-build route (from cell 0_2's slot2 to cell 1_2)
operation route0r_c2 slot=0, port=2
route slot=0, option=0, sr=0, source=2, target=0b10000000

#2.1-load input file
#round1: row6-9 of input matrix
operation load_r_2_1_c2 slot=1, port=0
dsu slot=1, port=0, init_addr=6
rep slot=1, port=0, level=0, iter=4, step=1, delay=0

operation load_w_2_1_c2 slot=1, port=2
dsu slot=1, port=2, init_addr=0
rep slot=1, port=2, level=0, iter=4, step=1, delay=0

#3.1-read IOSRAM
#round1: row6-9 of input matrix
operation read_io_3_1_c2 slot=2, port=3
dsu slot=2, port=3, init_addr=0
rep slot=2, port=3, level=0, iter=2, step=1, delay=0
rep slot=2, port=3, level=1, iter=3, step=1, delay=t0


cell 1_2
#1-build route (from cell 0_0 to cell 1_0's slot3,4)
#  build route (from cell 1_0's slot5 to cell 2_0)
operation route1wr_c2 slot=0, port=2
route slot=0, option=0, sr=1, source=1, target=0b00011000
route slot=0, option=0, sr=0, source=5, target=0b10000000

#2-build swb (RF3,4 for 2 rows. RF5 for result.)
#round1: row6-9
operation swb_c2 slot=0, port=0
swb slot=0, option=0, source=3, target=1
swb slot=0, option=0, source=1, target=5

swb slot=0, option=1, source=4, target=1
swb slot=0, option=1, source=1, target=5

fsm slot=0, port=0, delay_0=1
rep slot=0, port=0, level=0, iter=12, step=0, delay=1
rep slot=0, port=0, level=1, iter=3, step=0, delay=1

#3.1-write matrix to RF3,4
#round1: row6-9
operation write_rf3_c2 slot=3, port=2
dsu slot=3, port=2, init_addr=0
rep slot=3, port=2, level=0, iter=3, step=0, delay=t1

operation write_rf4_c2 slot=4, port=2
dsu slot=4, port=2, init_addr=0
rep slot=4, port=2, level=0, iter=3, step=0, delay=t1

#4.1-read matrix from RF3,4. maxpool
#round1: row6-9
operation read_rf3_c2 slot=3, port=1
dsu slot=3, port=1, init_addr=0
rep slot=3, port=1, level=0, iter=2, step=1, delay=0
rep slot=3, port=1, level=1, iter=12, step=1, delay=2
rep slot=3, port=1, level=2, iter=3, step=0, delay=2

operation read_rf4_c2 slot=4, port=1
dsu slot=4, port=1, init_addr=0
rep slot=4, port=1, level=0, iter=2, step=1, delay=0
rep slot=4, port=1, level=1, iter=12, step=1, delay=2
rep slot=4, port=1, level=2, iter=3, step=0, delay=2

operation dpu_c2 slot=1, port=0
dpu slot=1, option=0, mode=16
rep slot=1, port=0, level=0, iter=36, step=0, delay=3

#5.1-write result to RF5
#round1: row6-9
operation write_rf5_c2 slot=5, port=0
dsu slot=5, port=0, init_addr=0
rep slot=5, port=0, level=0, iter=12, step=1, delay=3
rep slot=5, port=0, level=1, iter=3, step=0, delay=3

#6.1-read result from RF5
#round1: row6-9
operation read_rf5_c2 slot=5, port=3
dsu slot=5, port=3, init_addr=0
rep slot=5, port=3, level=0, iter=3, step=0, delay=t2


cell 2_2
#1-build route (from cell 1_2 to cell 2_2's slot2)
operation route2w_c2 slot=0, port=2
route slot=0, option=0, sr=1, source=1, target=0b0100

#2.1-write result to IOSRAM
#round1: store row6-8
operation write_io_2_1_c2 slot=2, port=2
dsu slot=2, port=2, init_addr=0
rep slot=2, port=2, level=0, iter=3, step=1, delay=t2

#3.1-store result to output file
#round1: store row6-8 (actually store 13 lines due to data format)
operation output_r_3_1_c2 slot=1, port=3
dsu slot=1, port=3, init_addr=0
rep slot=1, port=3, level=0, iter=3, step=1, delay=0

operation output_w_3_1_c2 slot=1, port=1
dsu slot=1, port=1, init_addr=6
rep slot=1, port=1, level=0, iter=3, step=1, delay=0





cell 0_3
#1-build route (from cell 0_3's slot2 to cell 1_3)
operation route0r_c3 slot=0, port=2
route slot=0, option=0, sr=0, source=2, target=0b10000000

#2.1-load input file
#round1: row9-12 of input matrix
operation load_r_2_1_c3 slot=1, port=0
dsu slot=1, port=0, init_addr=9
rep slot=1, port=0, level=0, iter=4, step=1, delay=0

operation load_w_2_1_c3 slot=1, port=2
dsu slot=1, port=2, init_addr=0
rep slot=1, port=2, level=0, iter=4, step=1, delay=0

#3.1-read IOSRAM
#round1: row9-12 of input matrix
operation read_io_3_1_c3 slot=2, port=3
dsu slot=2, port=3, init_addr=0
rep slot=2, port=3, level=0, iter=2, step=1, delay=0
rep slot=2, port=3, level=1, iter=3, step=1, delay=t0


cell 1_3
#1-build route (from cell 0_0 to cell 1_0's slot3,4)
#  build route (from cell 1_0's slot5 to cell 2_0)
operation route1wr_c3 slot=0, port=2
route slot=0, option=0, sr=1, source=1, target=0b00011000
route slot=0, option=0, sr=0, source=5, target=0b10000000

#2-build swb (RF3,4 for 2 rows. RF5 for result.)
#round1: row9-12
operation swb_c3 slot=0, port=0
swb slot=0, option=0, source=3, target=1
swb slot=0, option=0, source=1, target=5

swb slot=0, option=1, source=4, target=1
swb slot=0, option=1, source=1, target=5

fsm slot=0, port=0, delay_0=1
rep slot=0, port=0, level=0, iter=12, step=0, delay=1
rep slot=0, port=0, level=1, iter=3, step=0, delay=1

#3.1-write matrix to RF3,4
#round1: row9-12
operation write_rf3_c3 slot=3, port=2
dsu slot=3, port=2, init_addr=0
rep slot=3, port=2, level=0, iter=3, step=0, delay=t1

operation write_rf4_c3 slot=4, port=2
dsu slot=4, port=2, init_addr=0
rep slot=4, port=2, level=0, iter=3, step=0, delay=t1

#4.1-read matrix from RF3,4. maxpool
#round1: row9-12
operation read_rf3_c3 slot=3, port=1
dsu slot=3, port=1, init_addr=0
rep slot=3, port=1, level=0, iter=2, step=1, delay=0
rep slot=3, port=1, level=1, iter=12, step=1, delay=2
rep slot=3, port=1, level=2, iter=3, step=0, delay=2

operation read_rf4_c3 slot=4, port=1
dsu slot=4, port=1, init_addr=0
rep slot=4, port=1, level=0, iter=2, step=1, delay=0
rep slot=4, port=1, level=1, iter=12, step=1, delay=2
rep slot=4, port=1, level=2, iter=3, step=0, delay=2

operation dpu_c3 slot=1, port=0
dpu slot=1, option=0, mode=16
rep slot=1, port=0, level=0, iter=36, step=0, delay=3

#5.1-write result to RF5
#round1: row9-12
operation write_rf5_c3 slot=5, port=0
dsu slot=5, port=0, init_addr=0
rep slot=5, port=0, level=0, iter=12, step=1, delay=3
rep slot=5, port=0, level=1, iter=3, step=0, delay=3

#6.1-read result from RF5
#round1: row9-12
operation read_rf5_c3 slot=5, port=3
dsu slot=5, port=3, init_addr=0
rep slot=5, port=3, level=0, iter=3, step=0, delay=t2


cell 2_3
#1-build route (from cell 1_3 to cell 2_3's slot2)
operation route2w_c3 slot=0, port=2
route slot=0, option=0, sr=1, source=1, target=0b0100

#2.1-write result to IOSRAM
#round1: store row9-11
operation write_io_2_1_c3 slot=2, port=2
dsu slot=2, port=2, init_addr=0
rep slot=2, port=2, level=0, iter=3, step=1, delay=t2

#3.1-store result to output file
#round1: store row9-11 (actually store 13 lines due to data format)
operation output_r_3_1_c3 slot=1, port=3
dsu slot=1, port=3, init_addr=0
rep slot=1, port=3, level=0, iter=4, step=1, delay=0

operation output_w_3_1_c3 slot=1, port=1
dsu slot=1, port=1, init_addr=9
rep slot=1, port=1, level=0, iter=4, step=1, delay=0