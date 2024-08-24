epoch <rb0> {
  cell (x=0, y=0) {
    #1-build route (from cell 0_0's slot2 to cell 1_0)
    rop <route0r> (slot=0, port=2) {
      route (slot=0, option=0, sr=0, source=2, target=0b10000000)
    }

    #2.1-load input file
    #round1: row0-25 of input matrix
    rop <load_r_2_1> (slot=1, port=0) {
      dsu (slot=1, port=0, init_addr=0)
      rep (slot=1, port=0, level=0, iter=52, step=1, delay=0)
    }

    rop <load_w_2_1> (slot=1, port=2) {
      dsu (slot=1, port=2, init_addr=0)
      rep (slot=1, port=2, level=0, iter=52, step=1, delay=0)
    }

    #3.1-read IOSRAM
    #round1: row0-25 of input matrix
    rop <read_io_3_1> (slot=2, port=3) {
      dsu (slot=2, port=3, init_addr=0)
      rep (slot=2, port=3, level=0, iter=4, step=1, delay=0)
      rep (slot=2, port=3, level=1, iter=13, step=4, delay=48)
    }
  }

  cell (x=1, y=0) {
    #1-build route (from cell 0_0 to cell 1_0's slot3)
    #  build route (from cell 1_0's slot4 to cell 2_0)
    rop <route1wr> (slot=0, port=2) {
      route (slot=0, option=0, sr=1, source=1, target=0b1000)
      route (slot=0, option=0, sr=0, source=4, target=0b10000000)
    }

    #2-build swb (RF3 for input. Write back to RF4.)
    #round1: row0-25
    rop <swb> (slot=0, port=0) {
      swb (slot=0, option=0, source=3, target=1)
      swb (slot=0, option=0, source=1, target=4)
    }

    #3-write matrix to RF3
    #round1: row0-25
    rop <write_rf3_1> (slot=3, port=2) {
      dsu (slot=3, port=2, init_addr=0)
      rep (slot=3, port=2, level=0, iter=4, step=1, delay=0)
      rep (slot=3, port=2, level=1, iter=13, step=0, delay=48)
    }

    #4-read matrix from RF3
    #round1: row0-25
    rop <read_rf3_1> (slot=3, port=1) {
      dsu (slot=3, port=1, init_addr=0)
      rep (slot=3, port=1, level=0, iter=26, step=1, delay=0)
      rep (slot=3, port=1, level=1, iter=2, step=32, delay=0)
      rep (slot=3, port=1, level=2, iter=13, step=0, delay=0)
    }

    rop <dpu_relu> (slot=1, port=0) {
      dpu (slot=1, option=0, mode=22)
    }

    #5-write result to RF4
    #round1: row0-25
    rop <write_rf4_1> (slot=4, port=0) {
      dsu (slot=4, port=0, init_addr=0)
      rep (slot=4, port=0, level=0, iter=26, step=1, delay=0)
      rep (slot=4, port=0, level=1, iter=2, step=32, delay=0)
      rep (slot=4, port=0, level=2, iter=13, step=0, delay=0)
    }

    #6-read result from RF4
    #round1: row0-25
    rop <read_rf4_1> (slot=4, port=3) {
      dsu (slot=4, port=3, init_addr=0)
      rep (slot=4, port=3, level=0, iter=4, step=1, delay=0)
      rep (slot=4, port=3, level=1, iter=13, step=0, delay=48)
    }
  }

  cell (x=2, y=0) {
    #1-build route (from cell 1_0 to cell 2_0's slot2)
    rop <route2w> (slot=0, port=2) {
      route (slot=0, option=0, sr=1, source=1, target=0b0100)
    }

    #2.1-write result to IOSRAM
    #round1: store row0-25
    rop <write_io_2_1> (slot=2, port=2) {
      dsu (slot=2, port=2, init_addr=0)
      rep (slot=2, port=2, level=0, iter=4, step=1, delay=0)
      rep (slot=2, port=2, level=1, iter=13, step=4, delay=48)
    }

    #3.1-store result to output file
    #round1: store row0-25
    rop <output_r_3_1> (slot=1, port=3) {
      dsu (slot=1, port=3, init_addr=0)
      rep (slot=1, port=3, level=0, iter=52, step=1, delay=0)
    }

    rop <output_w_3_1> (slot=1, port=1) {
      dsu (slot=1, port=1, init_addr=0)
      rep (slot=1, port=1, level=0, iter=52, step=1, delay=0)
    }
  }
}
