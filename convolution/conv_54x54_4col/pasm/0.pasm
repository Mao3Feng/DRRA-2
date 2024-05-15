cell 0_0
#1-build route (from cell 0_0's slot2 to cell 1_0)
operation route0r slot=0, port=2
route slot=0, option=0, sr=0, source=2, target=0b10000000

#2.0-load input file / write IOSRAM(line0=filter, 1-216=data)
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
#round1: row0-15 of input matrix
operation load_r_2_1 slot=1, port=0
dsu slot=1, port=0, init_addr=1
rep slot=1, port=0, level=0, iter=64, step=1, delay=0

operation load_w_2_1 slot=1, port=2
dsu slot=1, port=2, init_addr=0
rep slot=1, port=2, level=0, iter=64, step=1, delay=0

#3.1-read IOSRAM
#round1: row0-15 of input matrix
operation read_io_3_1 slot=2, port=3
dsu slot=2, port=3, init_addr=0
rep slot=2, port=3, level=0, iter=12, step=1, delay=0
rep slot=2, port=3, level=1, iter=14, step=4, delay=t0


cell 1_0
#1-build route (from cell 0_0 to cell 1_0's slot3,4,5,6)
#  build route (from cell 1_0's slot7 to cell 1_0)
operation route1wr slot=0, port=2
route slot=0, option=0, sr=1, source=1, target=0b01111000
route slot=0, option=0, sr=0, source=7, target=0b10000000

#2-write filter to RF3
operation write_filter slot=3, port=2
dsu slot=3, port=2, init_addr=0

#3-build swb (RF4,5,6 for 3 rows. RF3 for filter. RF7 for result.)
#round1: row0-15
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
rep slot=0, port=0, level=0, iter=52, step=0, delay=2
rep slot=0, port=0, level=1, iter=14, step=0, delay=2

#4.1-write matrix to RF4,5,6
#round1: row0-15
operation write_rf4 slot=4, port=2
dsu slot=4, port=2, init_addr=0
rep slot=4, port=2, level=0, iter=4, step=1, delay=0
rep slot=4, port=2, level=1, iter=14, step=0, delay=t1

operation write_rf5 slot=5, port=2
dsu slot=5, port=2, init_addr=0
rep slot=5, port=2, level=0, iter=4, step=1, delay=0
rep slot=5, port=2, level=1, iter=14, step=0, delay=t1

operation write_rf6 slot=6, port=2
dsu slot=6, port=2, init_addr=0
rep slot=6, port=2, level=0, iter=4, step=1, delay=0
rep slot=6, port=2, level=1, iter=14, step=0, delay=t1

#5.1-read matrix from RF4,5,6. read filter from RF3. convolution
#round1: row0-15
operation read_rf3 slot=3, port=1
dsu slot=3, port=1, init_addr=0
rep slot=3, port=1, level=0, iter=9, step=1, delay=0
rep slot=3, port=1, level=1, iter=52, step=0, delay=0
rep slot=3, port=1, level=2, iter=14, step=0, delay=0

operation read_rf4 slot=4, port=1
dsu slot=4, port=1, init_addr=0
rep slot=4, port=1, level=0, iter=3, step=1, delay=0
rep slot=4, port=1, level=1, iter=52, step=1, delay=6
rep slot=4, port=1, level=2, iter=14, step=0, delay=6

operation read_rf5 slot=5, port=1
dsu slot=5, port=1, init_addr=0
rep slot=5, port=1, level=0, iter=3, step=1, delay=0
rep slot=5, port=1, level=1, iter=52, step=1, delay=6
rep slot=5, port=1, level=2, iter=14, step=0, delay=6

operation read_rf6 slot=6, port=1
dsu slot=6, port=1, init_addr=0
rep slot=6, port=1, level=0, iter=3, step=1, delay=0
rep slot=6, port=1, level=1, iter=52, step=1, delay=6
rep slot=6, port=1, level=2, iter=14, step=0, delay=6

operation dpu slot=1, port=0
dpu slot=1, option=0, mode=2
rep slot=1, port=0, level=0, iter=52, step=0, delay=8
rep slot=1, port=0, level=1, iter=14, step=0, delay=8

#6.1-write result to RF7
#round1: store row0-13 of output matrix
operation write_rf7 slot=7, port=0
dsu slot=7, port=0, init_addr=0
rep slot=7, port=0, level=0, iter=52, step=1, delay=8
rep slot=7, port=0, level=1, iter=14, step=0, delay=8

#7.1-read result from RF7
#round1: store row0-13
operation read_rf7 slot=7, port=3
dsu slot=7, port=3, init_addr=0
rep slot=7, port=3, level=0, iter=4, step=1, delay=0
rep slot=7, port=3, level=1, iter=14, step=0, delay=t2


cell 2_0
#1-build route (from cell 1_0 to cell 2_0's slot2)
operation route2w slot=0, port=2
route slot=0, option=0, sr=1, source=1, target=0b0100

#2.1-write result to IOSRAM
#round1: store row0-13
operation write_io_2_1 slot=2, port=2
dsu slot=2, port=2, init_addr=0
rep slot=2, port=2, level=0, iter=4, step=1, delay=0
rep slot=2, port=2, level=1, iter=14, step=4, delay=t2

#3.1-store result to output file
#round1: store row0-13
operation output_r_3_1 slot=1, port=3
dsu slot=1, port=3, init_addr=0
rep slot=1, port=3, level=0, iter=56, step=1, delay=0

operation output_w_3_1 slot=1, port=1
dsu slot=1, port=1, init_addr=0
rep slot=1, port=1, level=0, iter=56, step=1, delay=0





cell 0_1
#1-build route (from cell 0_1's slot2 to cell 1_1)
operation route0r_c1 slot=0, port=2
route slot=0, option=0, sr=0, source=2, target=0b10000000

#2.0-load input file / write IOSRAM(line0=filter, 1-216=data)
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
#round2: row14-29 of input matrix
operation load_r_2_1_c1 slot=1, port=0
dsu slot=1, port=0, init_addr=57
rep slot=1, port=0, level=0, iter=64, step=1, delay=0

operation load_w_2_1_c1 slot=1, port=2
dsu slot=1, port=2, init_addr=0
rep slot=1, port=2, level=0, iter=64, step=1, delay=0

#3.1-read IOSRAM
#round2: row14-29 of input matrix
operation read_io_3_1_c1 slot=2, port=3
dsu slot=2, port=3, init_addr=0
rep slot=2, port=3, level=0, iter=12, step=1, delay=0
rep slot=2, port=3, level=1, iter=14, step=4, delay=t0


cell 1_1
#1-build route (from cell 0_1 to cell 1_1's slot3,4,5,6)
#  build route (from cell 1_1's slot7 to cell 2_1)
operation route1wr_c1 slot=0, port=2
route slot=0, option=0, sr=1, source=1, target=0b01111000
route slot=0, option=0, sr=0, source=7, target=0b10000000

#2-write filter to RF3
operation write_filter_c1 slot=3, port=2
dsu slot=3, port=2, init_addr=0

#3-build swb (RF4,5,6 for 3 rows. RF3 for filter. RF7 for result.)
#round2: row14-29
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
rep slot=0, port=0, level=0, iter=52, step=0, delay=2
rep slot=0, port=0, level=1, iter=14, step=0, delay=2

#4.1-write matrix to RF4,5,6
#round2: row14-29
operation write_rf4_c1 slot=4, port=2
dsu slot=4, port=2, init_addr=0
rep slot=4, port=2, level=0, iter=4, step=1, delay=0
rep slot=4, port=2, level=1, iter=14, step=0, delay=t1

operation write_rf5_c1 slot=5, port=2
dsu slot=5, port=2, init_addr=0
rep slot=5, port=2, level=0, iter=4, step=1, delay=0
rep slot=5, port=2, level=1, iter=14, step=0, delay=t1

operation write_rf6_c1 slot=6, port=2
dsu slot=6, port=2, init_addr=0
rep slot=6, port=2, level=0, iter=4, step=1, delay=0
rep slot=6, port=2, level=1, iter=14, step=0, delay=t1

#5.1-read matrix from RF4,5,6. read filter from RF3. convolution
#round2: row14-29
operation read_rf3_c1 slot=3, port=1
dsu slot=3, port=1, init_addr=0
rep slot=3, port=1, level=0, iter=9, step=1, delay=0
rep slot=3, port=1, level=1, iter=52, step=0, delay=0
rep slot=3, port=1, level=2, iter=14, step=0, delay=0

operation read_rf4_c1 slot=4, port=1
dsu slot=4, port=1, init_addr=0
rep slot=4, port=1, level=0, iter=3, step=1, delay=0
rep slot=4, port=1, level=1, iter=52, step=1, delay=6
rep slot=4, port=1, level=2, iter=14, step=0, delay=6

operation read_rf5_c1 slot=5, port=1
dsu slot=5, port=1, init_addr=0
rep slot=5, port=1, level=0, iter=3, step=1, delay=0
rep slot=5, port=1, level=1, iter=52, step=1, delay=6
rep slot=5, port=1, level=2, iter=14, step=0, delay=6

operation read_rf6_c1 slot=6, port=1
dsu slot=6, port=1, init_addr=0
rep slot=6, port=1, level=0, iter=3, step=1, delay=0
rep slot=6, port=1, level=1, iter=52, step=1, delay=6
rep slot=6, port=1, level=2, iter=14, step=0, delay=6

operation dpu_c1 slot=1, port=0
dpu slot=1, option=0, mode=2
rep slot=1, port=0, level=0, iter=52, step=0, delay=8
rep slot=1, port=0, level=1, iter=14, step=0, delay=8

#6.1-write result to RF7
#round2: store row14-27 of output matrix
operation write_rf7_c1 slot=7, port=0
dsu slot=7, port=0, init_addr=0
rep slot=7, port=0, level=0, iter=52, step=1, delay=8
rep slot=7, port=0, level=1, iter=14, step=0, delay=8

#7.1-read result from RF7
#round2: store row14-27
operation read_rf7_c1 slot=7, port=3
dsu slot=7, port=3, init_addr=0
rep slot=7, port=3, level=0, iter=4, step=1, delay=0
rep slot=7, port=3, level=1, iter=14, step=0, delay=t2


cell 2_1
#1-build route (from cell 1_1 to cell 2_1's slot2)
operation route2w_c1 slot=0, port=2
route slot=0, option=0, sr=1, source=1, target=0b0100

#2.1-write result to IOSRAM
#round2: store row14-27
operation write_io_2_1_c1 slot=2, port=2
dsu slot=2, port=2, init_addr=0
rep slot=2, port=2, level=0, iter=4, step=1, delay=0
rep slot=2, port=2, level=1, iter=14, step=4, delay=t2

#3.1-store result to output file
#round2: store row14-27
operation output_r_3_1_c1 slot=1, port=3
dsu slot=1, port=3, init_addr=0
rep slot=1, port=3, level=0, iter=56, step=1, delay=0

operation output_w_3_1_c1 slot=1, port=1
dsu slot=1, port=1, init_addr=56
rep slot=1, port=1, level=0, iter=56, step=1, delay=0





cell 0_2
#1-build route (from cell 0_2's slot2 to cell 1_2)
operation route0r_c2 slot=0, port=2
route slot=0, option=0, sr=0, source=2, target=0b10000000

#2.0-load input file / write IOSRAM(line0=filter, 1-216=data)
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
#round3: row28-43 of input matrix
operation load_r_2_1_c2 slot=1, port=0
dsu slot=1, port=0, init_addr=113
rep slot=1, port=0, level=0, iter=64, step=1, delay=0

operation load_w_2_1_c2 slot=1, port=2
dsu slot=1, port=2, init_addr=0
rep slot=1, port=2, level=0, iter=64, step=1, delay=0

#3.1-read IOSRAM
#round3: row28-43 of input matrix
operation read_io_3_1_c2 slot=2, port=3
dsu slot=2, port=3, init_addr=0
rep slot=2, port=3, level=0, iter=12, step=1, delay=0
rep slot=2, port=3, level=1, iter=14, step=4, delay=t0


cell 1_2
#1-build route (from cell 0_2 to cell 1_2's slot3,4,5,6)
#  build route (from cell 1_2's slot7 to cell 2_2)
operation route1wr_c2 slot=0, port=2
route slot=0, option=0, sr=1, source=1, target=0b01111000
route slot=0, option=0, sr=0, source=7, target=0b10000000

#2-write filter to RF3
operation write_filter_c2 slot=3, port=2
dsu slot=3, port=2, init_addr=0

#3-build swb (RF4,5,6 for 3 rows. RF3 for filter. RF7 for result.)
#round3: row28-43
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
rep slot=0, port=0, level=0, iter=52, step=0, delay=2
rep slot=0, port=0, level=1, iter=14, step=0, delay=2

#4.1-write matrix to RF4,5,6
#round3: row28-43
operation write_rf4_c2 slot=4, port=2
dsu slot=4, port=2, init_addr=0
rep slot=4, port=2, level=0, iter=4, step=1, delay=0
rep slot=4, port=2, level=1, iter=14, step=0, delay=t1

operation write_rf5_c2 slot=5, port=2
dsu slot=5, port=2, init_addr=0
rep slot=5, port=2, level=0, iter=4, step=1, delay=0
rep slot=5, port=2, level=1, iter=14, step=0, delay=t1

operation write_rf6_c2 slot=6, port=2
dsu slot=6, port=2, init_addr=0
rep slot=6, port=2, level=0, iter=4, step=1, delay=0
rep slot=6, port=2, level=1, iter=14, step=0, delay=t1

#5.1-read matrix from RF4,5,6. read filter from RF3. convolution
#round3: row28-43
operation read_rf3_c2 slot=3, port=1
dsu slot=3, port=1, init_addr=0
rep slot=3, port=1, level=0, iter=9, step=1, delay=0
rep slot=3, port=1, level=1, iter=52, step=0, delay=0
rep slot=3, port=1, level=2, iter=14, step=0, delay=0

operation read_rf4_c2 slot=4, port=1
dsu slot=4, port=1, init_addr=0
rep slot=4, port=1, level=0, iter=3, step=1, delay=0
rep slot=4, port=1, level=1, iter=52, step=1, delay=6
rep slot=4, port=1, level=2, iter=14, step=0, delay=6

operation read_rf5_c2 slot=5, port=1
dsu slot=5, port=1, init_addr=0
rep slot=5, port=1, level=0, iter=3, step=1, delay=0
rep slot=5, port=1, level=1, iter=52, step=1, delay=6
rep slot=5, port=1, level=2, iter=14, step=0, delay=6

operation read_rf6_c2 slot=6, port=1
dsu slot=6, port=1, init_addr=0
rep slot=6, port=1, level=0, iter=3, step=1, delay=0
rep slot=6, port=1, level=1, iter=52, step=1, delay=6
rep slot=6, port=1, level=2, iter=14, step=0, delay=6

operation dpu_c2 slot=1, port=0
dpu slot=1, option=0, mode=2
rep slot=1, port=0, level=0, iter=52, step=0, delay=8
rep slot=1, port=0, level=1, iter=14, step=0, delay=8

#6.1-write result to RF7
#round3: store row28-41 of output matrix
operation write_rf7_c2 slot=7, port=0
dsu slot=7, port=0, init_addr=0
rep slot=7, port=0, level=0, iter=52, step=1, delay=8
rep slot=7, port=0, level=1, iter=14, step=0, delay=8

#7.1-read result from RF7
#round3: store row28-41
operation read_rf7_c2 slot=7, port=3
dsu slot=7, port=3, init_addr=0
rep slot=7, port=3, level=0, iter=4, step=1, delay=0
rep slot=7, port=3, level=1, iter=14, step=0, delay=t2


cell 2_2
#1-build route (from cell 1_2 to cell 2_2's slot2)
operation route2w_c2 slot=0, port=2
route slot=0, option=0, sr=1, source=1, target=0b0100

#2.1-write result to IOSRAM
#round3: store row28-41
operation write_io_2_1_c2 slot=2, port=2
dsu slot=2, port=2, init_addr=0
rep slot=2, port=2, level=0, iter=4, step=1, delay=0
rep slot=2, port=2, level=1, iter=14, step=4, delay=t2

#3.1-store result to output file
#round3: store row28-41
operation output_r_3_1_c2 slot=1, port=3
dsu slot=1, port=3, init_addr=0
rep slot=1, port=3, level=0, iter=56, step=1, delay=0

operation output_w_3_1_c2 slot=1, port=1
dsu slot=1, port=1, init_addr=112
rep slot=1, port=1, level=0, iter=56, step=1, delay=0





cell 0_3
#1-build route (from cell 0_3's slot2 to cell 1_3)
operation route0r_c3 slot=0, port=2
route slot=0, option=0, sr=0, source=2, target=0b10000000

#2.0-load input file / write IOSRAM(line0=filter, 1-216=data)
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
#round4: row42-53 of input matrix
operation load_r_2_1_c3 slot=1, port=0
dsu slot=1, port=0, init_addr=169
rep slot=1, port=0, level=0, iter=48, step=1, delay=0

operation load_w_2_1_c3 slot=1, port=2
dsu slot=1, port=2, init_addr=0
rep slot=1, port=2, level=0, iter=48, step=1, delay=0

#3.1-read IOSRAM
#round4: row42-53 of input matrix
operation read_io_3_1_c3 slot=2, port=3
dsu slot=2, port=3, init_addr=0
rep slot=2, port=3, level=0, iter=12, step=1, delay=0
rep slot=2, port=3, level=1, iter=10, step=4, delay=t0


cell 1_3
#1-build route (from cell 0_3 to cell 1_3's slot3,4,5,6)
#  build route (from cell 1_3's slot7 to cell 2_3)
operation route1wr_c3 slot=0, port=2
route slot=0, option=0, sr=1, source=1, target=0b01111000
route slot=0, option=0, sr=0, source=7, target=0b10000000

#2-write filter to RF3
operation write_filter_c3 slot=3, port=2
dsu slot=3, port=2, init_addr=0

#3-build swb (RF4,5,6 for 3 rows. RF3 for filter. RF7 for result.)
#round4: row42-53
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
rep slot=0, port=0, level=0, iter=52, step=0, delay=2
rep slot=0, port=0, level=1, iter=10, step=0, delay=2

#4.1-write matrix to RF4,5,6
#round4: row42-53
operation write_rf4_c3 slot=4, port=2
dsu slot=4, port=2, init_addr=0
rep slot=4, port=2, level=0, iter=4, step=1, delay=0
rep slot=4, port=2, level=1, iter=10, step=0, delay=t1

operation write_rf5_c3 slot=5, port=2
dsu slot=5, port=2, init_addr=0
rep slot=5, port=2, level=0, iter=4, step=1, delay=0
rep slot=5, port=2, level=1, iter=10, step=0, delay=t1

operation write_rf6_c3 slot=6, port=2
dsu slot=6, port=2, init_addr=0
rep slot=6, port=2, level=0, iter=4, step=1, delay=0
rep slot=6, port=2, level=1, iter=10, step=0, delay=t1

#5.1-read matrix from RF4,5,6. read filter from RF3. convolution
#round4: row42-53
operation read_rf3_c3 slot=3, port=1
dsu slot=3, port=1, init_addr=0
rep slot=3, port=1, level=0, iter=9, step=1, delay=0
rep slot=3, port=1, level=1, iter=52, step=0, delay=0
rep slot=3, port=1, level=2, iter=10, step=0, delay=0

operation read_rf4_c3 slot=4, port=1
dsu slot=4, port=1, init_addr=0
rep slot=4, port=1, level=0, iter=3, step=1, delay=0
rep slot=4, port=1, level=1, iter=52, step=1, delay=6
rep slot=4, port=1, level=2, iter=10, step=0, delay=6

operation read_rf5_c3 slot=5, port=1
dsu slot=5, port=1, init_addr=0
rep slot=5, port=1, level=0, iter=3, step=1, delay=0
rep slot=5, port=1, level=1, iter=52, step=1, delay=6
rep slot=5, port=1, level=2, iter=10, step=0, delay=6

operation read_rf6_c3 slot=6, port=1
dsu slot=6, port=1, init_addr=0
rep slot=6, port=1, level=0, iter=3, step=1, delay=0
rep slot=6, port=1, level=1, iter=52, step=1, delay=6
rep slot=6, port=1, level=2, iter=10, step=0, delay=6

operation dpu_c3 slot=1, port=0
dpu slot=1, option=0, mode=2
rep slot=1, port=0, level=0, iter=52, step=0, delay=8
rep slot=1, port=0, level=1, iter=10, step=0, delay=8

#6.1-write result to RF7
#round4: store row42-51 of output matrix
operation write_rf7_c3 slot=7, port=0
dsu slot=7, port=0, init_addr=0
rep slot=7, port=0, level=0, iter=52, step=1, delay=8
rep slot=7, port=0, level=1, iter=10, step=0, delay=8

#7.1-read result from RF7
#round4: store row42-51
operation read_rf7_c3 slot=7, port=3
dsu slot=7, port=3, init_addr=0
rep slot=7, port=3, level=0, iter=4, step=1, delay=0
rep slot=7, port=3, level=1, iter=10, step=0, delay=t2


cell 2_3
#1-build route (from cell 1_3 to cell 2_3's slot2)
operation route2w_c3 slot=0, port=2
route slot=0, option=0, sr=1, source=1, target=0b0100

#2.1-write result to IOSRAM
#round4: store row42-51
operation write_io_2_1_c3 slot=2, port=2
dsu slot=2, port=2, init_addr=0
rep slot=2, port=2, level=0, iter=4, step=1, delay=0
rep slot=2, port=2, level=1, iter=10, step=4, delay=t2

#3.1-store result to output file
#round4: store row42-51
operation output_r_3_1_c3 slot=1, port=3
dsu slot=1, port=3, init_addr=0
rep slot=1, port=3, level=0, iter=40, step=1, delay=0

operation output_w_3_1_c3 slot=1, port=1
dsu slot=1, port=1, init_addr=168
rep slot=1, port=1, level=0, iter=40, step=1, delay=0