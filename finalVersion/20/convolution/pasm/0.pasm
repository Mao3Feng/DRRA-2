epoch <config> {
  cell (x=0, y=0) {
    #1-build route (from cell 0_0's slot2 to cell 1_0)
    rop <route0r> (slot=0, port=2) {
      route (slot=0, option=0, sr=0, source=2, target=0b10000000) 
    }

    #2.0-load input file / write IOSRAM (line0=filter, 1-56=data)
    #filter
    rop <load_r_2_0> (slot=1, port=0) {
      dsu (slot=1, port=0, init_addr=0)
    }
    rop <load_w_2_0> (slot=1, port=2) {
      dsu (slot=1, port=2, init_addr=0)
    }

    #3.0-read IOSRAM
    #filter
    rop <read_io_3_0> (slot=2, port=3) {
      dsu (slot=2, port=3, init_addr=0)
    }
  }
  cell (x=1, y=0) {
    #1-build route (from cell 0_0 to cell 1_0's slot3,4,5,6)
    #  build route (from cell 1_0's slot7 to cell 1_0)
    rop <route1wr> (slot=0, port=2) {
      route (slot=0, option=0, sr=1, source=1, target=0b01111000)
      route (slot=0, option=0, sr=0, source=7, target=0b10000000)
    }

    #2-write filter to RF3
    rop <write_filter> (slot=3, port=2) {
      dsu (slot=3, port=2, init_addr=0)
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
    #2.1-load input file
    #round1: row0-27 of input matrix
    rop <load_r_2_1> (slot=1, port=0) {
      dsu (slot=1, port=0, init_addr=1)
      rep (slot=1, port=0, level=0, iter=56, step=1, delay=0)
    }

    rop <load_w_2_1> (slot=1, port=2) {
      dsu (slot=1, port=2, init_addr=0)
      rep (slot=1, port=2, level=0, iter=56, step=1, delay=0)
    }

    #3.1-read IOSRAM
    #round1: row0-27 of input matrix
    rop <read_io_3_1> (slot=2, port=3) {
      dsu (slot=2, port=3, init_addr=0)
      rep (slot=2, port=3, level=0, iter=6, step=1, delay=0)
      rep (slot=2, port=3, level=1, iter=26, step=2, delay=t0)
    }
  }

  cell (x=1, y=0) {
    #3-build swb (RF4,5,6 for 3 rows. RF3 for filter. RF7 for result.)
    #round1: row0-14
    rop <swb> (slot=0, port=0) {
      swb (slot=0, option=0, source=4, target=2)
      swb (slot=0, option=0, source=3, target=1)
      swb (slot=0, option=0, source=1, target=7)

      swb (slot=0, option=1, source=5, target=2)
      swb (slot=0, option=1, source=3, target=1)
      swb (slot=0, option=1, source=1, target=7)

      swb (slot=0, option=2, source=6, target=2)
      swb (slot=0, option=2, source=3, target=1)
      swb (slot=0, option=2, source=1, target=7)

      fsm (slot=0, port=0, delay_0=2, delay_1=2)
      rep (slot=0, port=0, level=0, iter=676, step=0, delay=2)
    }

    #4.1-write matrix to RF4,5,6
    #round1: row0-27
    rop <write_rf4> (slot=4, port=2) {
      dsu (slot=4, port=2, init_addr=0)
      rep (slot=4, port=2, level=0, iter=2, step=1, delay=0)
      rep (slot=4, port=2, level=1, iter=26, step=0, delay=t1)
    }

    rop <write_rf5> (slot=5, port=2) {
      dsu (slot=5, port=2, init_addr=0)
      rep (slot=5, port=2, level=0, iter=2, step=1, delay=0)
      rep (slot=5, port=2, level=1, iter=26, step=0, delay=t1)
    }

    rop <write_rf6> (slot=6, port=2) {
      dsu (slot=6, port=2, init_addr=0)
      rep (slot=6, port=2, level=0, iter=2, step=1, delay=0)
      rep (slot=6, port=2, level=1, iter=26, step=0, delay=t1)
    }

    #5.1-read matrix from RF4,5,6. read filter from RF3. convolution
    #round1: row0-14
    rop <read_rf3> (slot=3, port=1) {
      dsu (slot=3, port=1, init_addr=0)
      rep (slot=3, port=1, level=0, iter=9, step=1, delay=0)
      rep (slot=3, port=1, level=1, iter=676, step=0, delay=0)
    }

    rop <read_rf4> (slot=4, port=1) {
      dsu (slot=4, port=1, init_addr=0)
      rep (slot=4, port=1, level=0, iter=3, step=1, delay=0)
      rep (slot=4, port=1, level=1, iter=26, step=1, delay=6)
      rep (slot=4, port=1, level=2, iter=26, step=0, delay=6)
    }

    rop <read_rf5> (slot=5, port=1) {
      dsu (slot=5, port=1, init_addr=0)
      rep (slot=5, port=1, level=0, iter=3, step=1, delay=0)
      rep (slot=5, port=1, level=1, iter=26, step=1, delay=6)
      rep (slot=5, port=1, level=2, iter=26, step=0, delay=6)
    }

    rop <read_rf6> (slot=6, port=1) {
      dsu (slot=6, port=1, init_addr=0)
      rep (slot=6, port=1, level=0, iter=3, step=1, delay=0)
      rep (slot=6, port=1, level=1, iter=26, step=1, delay=6)
      rep (slot=6, port=1, level=2, iter=26, step=0, delay=6)
    }

    rop <dpu> (slot=1, port=0) {
      dpu (slot=1, option=0, mode=2)
      rep (slot=1, port=0, level=0, iter=676, step=0, delay=8)
    }

    #6.1-write result to RF7
    #round1: store row0-25 of output matrix
    rop <write_rf7> (slot=7, port=0) {
      dsu (slot=7, port=0, init_addr=0)
      rep (slot=7, port=0, level=0, iter=26, step=1, delay=8)
      rep (slot=7, port=0, level=1, iter=26, step=0, delay=8)
    }

    #7.1-read result from RF7
    #round1: store row0-25
    rop <read_rf7> (slot=7, port=3) {
      dsu (slot=7, port=3, init_addr=0)
      rep (slot=7, port=3, level=0, iter=2, step=1, delay=0)
      rep (slot=7, port=3, level=1, iter=26, step=0, delay=t2)
    }
  }

  cell (x=2,y=0) {
    

    #2.1-write result to IOSRAM
    #round1: store row0-25
    rop <write_io_2_1> (slot=2, port=2) {
      dsu (slot=2, port=2, init_addr=0)
      rep (slot=2, port=2, level=0, iter=2, step=1, delay=0)
      rep (slot=2, port=2, level=1, iter=26, step=2, delay=t2)
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
