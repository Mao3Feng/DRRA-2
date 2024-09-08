epoch <config> {
  cell (x=0, y=0) {
    #1-build route (from cell 0_0's slot2 to cell 1_0)
    rop <route0r> (slot=0, port=2) {
      route (slot=0, option=0, sr=0, source=2, target=0b10000000)
    }
    #2.1-load input file
    #round1: MUL, ADD of input matrix
    rop <load_r_2_1> (slot=1, port=0) {
      dsu (slot=1, port=0, init_addr=0)
    }
    rop <load_w_2_1> (slot=1, port=2) {
      dsu (slot=1, port=2, init_addr=0)
    }
    #3.1-read IOSRAM
    #round1: MUL, ADD of input matrix
    rop <read_io_3_1> (slot=2, port=3) {
      dsu (slot=2, port=3, init_addr=0)
    }
  }
  cell (x=1, y=0) {
    #1-build route (from cell 0_0 to cell 1_0's slot5,6,7)
    #  build route (from cell 1_0's slot3 to cell 2_0)
    rop <route1wr> (slot=0, port=2) {
      route (slot=0, option=0, sr=1, source=1, target=0b11100000)
      route (slot=0, option=0, sr=0, source=9, target=0b10000000)
    }
    #2-build swb (RF5,6 for MUL. RF7,8 for ADD. Write back to RF9.)
    #round1: row0-12
    rop <swb> (slot=0, port=0) {
      swb (slot=0, option=0, source=5, target=1)
      swb (slot=0, option=0, source=6, target=2)
      swb (slot=0, option=0, source=7, target=3)
      swb (slot=0, option=0, source=8, target=4)
      swb (slot=0, option=0, source=1, target=8)
      swb (slot=0, option=0, source=3, target=9)
    }
    #3-write matrix to RF5,6,7
    #round1: row0-12
    rop <write_rf5> (slot=5, port=2) {
      dsu (slot=5, port=2, init_addr=0)
    }
    rop <write_rf7> (slot=7, port=2) {
      dsu (slot=7, port=2, init_addr=0)
    }
  }
  cell (x=2, y=0) {
    #1-build route (from cell 1_0 to cell 2_0's slot2)
    rop <route2w> (slot=0, port=2) {
      route (slot=0, option=0, sr=1, source=1, target=0b0100)
    }
  }
}




epoch <rb0> {
  cell (x=0, y=0) {
    #2.2-load input file
    #round1: row0-47 of input matrix
    rop <load_r_2_2> (slot=1, port=0) {
      dsu (slot=1, port=0, init_addr=1)
      rep (slot=1, port=0, level=0, iter=64, step=1, delay=0)
      rep (slot=1, port=0, level=1, iter=3, step=64, delay=t0)
    }
    rop <load_w_2_2> (slot=1, port=2) {
      dsu (slot=1, port=2, init_addr=0)
      rep (slot=1, port=2, level=0, iter=64, step=1, delay=0)
      rep (slot=1, port=2, level=1, iter=3, step=0, delay=t0)
    }
    #3.2-read IOSRAM
    #round1: row0-47 of input matrix
    rop <read_io_3_2> (slot=2, port=3) {
      dsu (slot=2, port=3, init_addr=0)
      rep (slot=2, port=3, level=0, iter=4, step=1, delay=0)
      rep (slot=2, port=3, level=1, iter=16, step=4, delay=48)
      rep (slot=2, port=3, level=2, iter=3, step=0, delay=48)
    }
    #2.3-load input file (tail)
    #round2: row48-51 of input matrix
    rop <load_r_2_3> (slot=1, port=0) {
      dsu (slot=1, port=0, init_addr=193)
      rep (slot=1, port=0, level=0, iter=16, step=1, delay=0)
    }
    rop <load_w_2_3> (slot=1, port=2) {
      dsu (slot=1, port=2, init_addr=0)
      rep (slot=1, port=2, level=0, iter=16, step=1, delay=0)
    }
    #3.3-read IOSRAM (tail)
    #round2: row48-51 of input matrix
    rop <read_io_3_3> (slot=2, port=3) {
      dsu (slot=2, port=3, init_addr=0)
      rep (slot=2, port=3, level=0, iter=4, step=1, delay=0)
      rep (slot=2, port=3, level=1, iter=4, step=4, delay=48)
    }
  }
  
  cell (x=1, y=0) {
    rop <write_rf6_1> (slot=6, port=2) {
      dsu (slot=6, port=2, init_addr=0)
      rep (slot=6, port=2, level=0, iter=4, step=1, delay=0)
      rep (slot=6, port=2, level=1, iter=16, step=0, delay=48)
      rep (slot=6, port=2, level=2, iter=3, step=0, delay=48)
    }
    rop <write_rf6_2> (slot=6, port=2) {
      dsu (slot=6, port=2, init_addr=0)
      rep (slot=6, port=2, level=0, iter=4, step=1, delay=0)
      rep (slot=6, port=2, level=1, iter=4, step=0, delay=48)
    }
    #4-read matrix from RF5,6. MUL
    #  read matrix from RF7,8. ADD
    #round1: row0-51
    rop <read_rf5_1> (slot=5, port=1) {
      dsu (slot=5, port=1, init_addr=0)
      rep (slot=5, port=1, level=0, iter=52, step=0, delay=0)
      rep (slot=5, port=1, level=1, iter=16, step=0, delay=0)
      rep (slot=5, port=1, level=2, iter=3, step=0, delay=0)
    }
    rop <read_rf6_1> (slot=6, port=1) {
      dsu (slot=6, port=1, init_addr=0)
      rep (slot=6, port=1, level=0, iter=52, step=1, delay=0)
      rep (slot=6, port=1, level=1, iter=16, step=0, delay=0)
      rep (slot=6, port=1, level=2, iter=3, step=0, delay=0)
    }
    rop <read_rf5_2> (slot=5, port=1) {
      dsu (slot=5, port=1, init_addr=0)
      rep (slot=5, port=1, level=0, iter=52, step=0, delay=0)
      rep (slot=5, port=1, level=1, iter=4, step=0, delay=0)
    }
    rop <read_rf6_2> (slot=6, port=1) {
      dsu (slot=6, port=1, init_addr=0)
      rep (slot=6, port=1, level=0, iter=52, step=1, delay=0)
      rep (slot=6, port=1, level=1, iter=4, step=0, delay=0)
    }
    rop <dpu_mul> (slot=1, port=0) {
      dpu (slot=1, option=0, mode=7)
    }
    rop <read_rf7_1> (slot=7, port=1) {
      dsu (slot=7, port=1, init_addr=1)
      rep (slot=7, port=1, level=0, iter=52, step=0, delay=0)
      rep (slot=7, port=1, level=1, iter=16, step=0, delay=0)
      rep (slot=7, port=1, level=2, iter=3, step=0, delay=0)
    }
    rop <read_rf8_1> (slot=8, port=1) {
      dsu (slot=8, port=1, init_addr=0)
      rep (slot=8, port=1, level=0, iter=52, step=1, delay=0)
      rep (slot=8, port=1, level=1, iter=16, step=0, delay=0)
      rep (slot=8, port=1, level=2, iter=3, step=0, delay=0)
    }
    rop <read_rf7_2> (slot=7, port=1) {
      dsu (slot=7, port=1, init_addr=1)
      rep (slot=7, port=1, level=0, iter=52, step=0, delay=0)
      rep (slot=7, port=1, level=1, iter=4, step=0, delay=0)
    }
    rop <read_rf8_2> (slot=8, port=1) {
      dsu (slot=8, port=1, init_addr=0)
      rep (slot=8, port=1, level=0, iter=52, step=1, delay=0)
      rep (slot=8, port=1, level=1, iter=4, step=0, delay=0)
    }
    rop <dpu_add> (slot=3, port=0) {
      dpu (slot=3, option=0, mode=1)
    }
    #5-write result to RF8,9
    #round1: row0-51
    rop <write_rf8_1> (slot=8, port=0) {
      dsu (slot=8, port=0, init_addr=0)
      rep (slot=8, port=0, level=0, iter=52, step=1, delay=0)
      rep (slot=8, port=0, level=1, iter=16, step=0, delay=0)
      rep (slot=8, port=0, level=2, iter=3, step=0, delay=0)
    }
    rop <write_rf9_1> (slot=9, port=0) {
      dsu (slot=9, port=0, init_addr=0)
      rep (slot=9, port=0, level=0, iter=52, step=1, delay=0)
      rep (slot=9, port=0, level=1, iter=16, step=0, delay=0)
      rep (slot=9, port=0, level=2, iter=3, step=0, delay=0)
    }
    rop <write_rf8_2> (slot=8, port=0) {
      dsu (slot=8, port=0, init_addr=0)
      rep (slot=8, port=0, level=0, iter=52, step=1, delay=0)
      rep (slot=8, port=0, level=1, iter=4, step=0, delay=0)
    }
    rop <write_rf9_2> (slot=9, port=0) {
      dsu (slot=9, port=0, init_addr=0)
      rep (slot=9, port=0, level=0, iter=52, step=1, delay=0)
      rep (slot=9, port=0, level=1, iter=4, step=0, delay=0)
    }
    #6-read result from RF9
    #round1: row0-51
    rop <read_rf9_1> (slot=9, port=3) {
      dsu (slot=9, port=3, init_addr=0)
      rep (slot=9, port=3, level=0, iter=4, step=1, delay=0)
      rep (slot=9, port=3, level=1, iter=16, step=0, delay=48)
      rep (slot=9, port=3, level=2, iter=3, step=0, delay=48)
    }
    rop <read_rf9_2> (slot=9, port=3) {
      dsu (slot=9, port=3, init_addr=0)
      rep (slot=9, port=3, level=0, iter=4, step=1, delay=0)
      rep (slot=9, port=3, level=1, iter=4, step=0, delay=48)
    }
  }
  
  cell (x=2, y=0) {
    #2.1-write result to IOSRAM
    #round1: store row0-51
    rop <write_io_2_1> (slot=2, port=2) {
      dsu (slot=2, port=2, init_addr=0)
      rep (slot=2, port=2, level=0, iter=4, step=1, delay=0)
      rep (slot=2, port=2, level=1, iter=16, step=4, delay=48)
      rep (slot=2, port=2, level=2, iter=3, step=0, delay=48)
    }
    rop <write_io_2_2> (slot=2, port=2) {
      dsu (slot=2, port=2, init_addr=0)
      rep (slot=2, port=2, level=0, iter=4, step=1, delay=0)
      rep (slot=2, port=2, level=1, iter=4, step=4, delay=48)
    }
    #3.1-store result to output file
    #round1: store row0-51
    rop <output_r_3_1> (slot=1, port=3) {
      dsu (slot=1, port=3, init_addr=0)
      rep (slot=1, port=3, level=0, iter=64, step=1, delay=0)
      rep (slot=1, port=3, level=1, iter=3, step=0, delay=t2)
    }
    rop <output_w_3_1> (slot=1, port=1) {
      dsu (slot=1, port=1, init_addr=0)
      rep (slot=1, port=1, level=0, iter=64, step=1, delay=0)
      rep (slot=1, port=1, level=1, iter=3, step=64, delay=t2)
    }
    rop <output_r_3_2> (slot=1, port=3) {
      dsu (slot=1, port=3, init_addr=0)
      rep (slot=1, port=3, level=0, iter=16, step=1, delay=0)
    }
    rop <output_w_3_2> (slot=1, port=1) {
      dsu (slot=1, port=1, init_addr=192)
      rep (slot=1, port=1, level=0, iter=16, step=1, delay=0)
    }
  }
  
  
}