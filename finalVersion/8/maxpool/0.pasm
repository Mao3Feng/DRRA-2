epoch <rb0> {
  cell (x=0, y=0) {
    #1 - Build route (from cell (x=0, y=0)'s slot2 to cell (x=1, y=0))
    rop <route0r> (slot=0, port=2) {
      route (slot=0, option=0, sr=0, source=2, target=0b10000000)
    }
  
    #2.1 - Load input file
    # Rounds 1, 2, 3: row0-15, 16-31, 32-47 of input matrix
    rop <load_r_2_1> (slot=1, port=0) {
      dsu (slot=1, port=0, init_addr=0)
      rep (slot=1, port=0, level=0, iter=64, step=1, delay=0)
      rep (slot=1, port=0, level=1, iter=3, step=64, delay=t0)
    }
  
    rop <load_w_2_1> (slot=1, port=2) {
      dsu (slot=1, port=2, init_addr=0)
      rep (slot=1, port=2, level=0, iter=64, step=1, delay=0)
      rep (slot=1, port=2, level=1, iter=3, step=0, delay=t0)
    }
  
    #3.1 - Read IOSRAM
    # Rounds 1, 2, 3: row0-15, 16-31, 32-47 of input matrix
    rop <read_io_3_1> (slot=2, port=3) {
      dsu (slot=2, port=3, init_addr=0)
      rep (slot=2, port=3, level=0, iter=8, step=1, delay=0)
      rep (slot=2, port=3, level=1, iter=8, step=8, delay=t1)
      rep (slot=2, port=3, level=2, iter=3, step=0, delay=t1)
    }
  
    #2.2 - Load input file
    # Round 4: row48-51 of input matrix
    rop <load_r_2_2> (slot=1, port=0) {
      dsu (slot=1, port=0, init_addr=192)
      rep (slot=1, port=0, level=0, iter=16, step=1, delay=0)
    }
  
    rop <load_w_2_2> (slot=1, port=2) {
      dsu (slot=1, port=2, init_addr=0)
      rep (slot=1, port=2, level=0, iter=16, step=1, delay=0)
    }
  
    #3.2 - Read IOSRAM
    # Round 4: row48-51 of input matrix
    rop <read_io_3_2> (slot=2, port=3) {
      dsu (slot=2, port=3, init_addr=0)
      rep (slot=2, port=3, level=0, iter=8, step=1, delay=0)
      rep (slot=2, port=3, level=1, iter=2, step=8, delay=t1)
    }
  }
  
  cell (x=1, y=0) {
    #1 - Build route (from cell (x=0, y=0) to cell (x=1, y=0)'s slot3,4)
    #   Build route (from cell (x=1, y=0)'s slot5 to cell (x=2, y=0))
    rop <route1wr> (slot=0, port=2) {
      route (slot=0, option=0, sr=1, source=1, target=0b00011000)
      route (slot=0, option=0, sr=0, source=5, target=0b10000000)
    }
  
    #2 - Build SWB (RF3,4 for 2 rows. RF5 for result.)
    # Rounds 1, 2, 3, 4: row0-15, 16-31, 32-47, 48-51
    rop <swb> (slot=0, port=0) {
      swb (slot=0, option=0, source=3, target=1)
      swb (slot=0, option=0, source=1, target=5)
      swb (slot=0, option=1, source=4, target=1)
      swb (slot=0, option=1, source=1, target=5)
  
      fsm (slot=0, port=0, delay_0=1)
      rep (slot=0, port=0, level=0, iter=26, step=0, delay=1)
      rep (slot=0, port=0, level=1, iter=26, step=0, delay=1)
    }
  
    #3.1 - Write matrix to RF3,4
    # Rounds 1, 2, 3, 4: row0-15, 16-31, 32-47, 48-51
    rop <write_rf3> (slot=3, port=2) {
      dsu (slot=3, port=2, init_addr=0)
      rep (slot=3, port=2, level=0, iter=4, step=1, delay=0)
      rep (slot=3, port=2, level=1, iter=26, step=0, delay=t2)
    }
  
    rop <write_rf4> (slot=4, port=2) {
      dsu (slot=4, port=2, init_addr=0)
      rep (slot=4, port=2, level=0, iter=4, step=1, delay=0)
      rep (slot=4, port=2, level=1, iter=26, step=0, delay=t2)
    }
  
    #4.1 - Read matrix from RF3,4. Maxpool
    # Rounds 1, 2, 3, 4: row0-15, 16-31, 32-47, 48-51
    rop <read_rf3> (slot=3, port=1) {
      dsu (slot=3, port=1, init_addr=0)
      rep (slot=3, port=1, level=0, iter=2, step=1, delay=0)
      rep (slot=3, port=1, level=1, iter=26, step=2, delay=2)
      rep (slot=3, port=1, level=2, iter=26, step=0, delay=2)
    }
  
    rop <read_rf4> (slot=4, port=1) {
      dsu (slot=4, port=1, init_addr=0)
      rep (slot=4, port=1, level=0, iter=2, step=1, delay=0)
      rep (slot=4, port=1, level=1, iter=26, step=2, delay=2)
      rep (slot=4, port=1, level=2, iter=26, step=0, delay=2)
    }
  
    rop <dpu> (slot=1, port=0) {
      dpu (slot=1, option=0, mode=16)
      rep (slot=1, port=0, level=0, iter=676, step=0, delay=3)
    }
  
    #5.1 - Write result to RF5
    # Rounds 1, 2, 3, 4: row0-15, 16-31, 32-47, 48-51
    rop <write_rf5> (slot=5, port=0) {
      dsu (slot=5, port=0, init_addr=0)
      rep (slot=5, port=0, level=0, iter=26, step=1, delay=3)
      rep (slot=5, port=0, level=1, iter=26, step=0, delay=3)
    }
  
    #6.1 - Read result from RF5
    # Rounds 1, 2, 3, 4: row0-15, 16-31, 32-47, 48-51
    rop <read_rf5> (slot=5, port=3) {
      dsu (slot=5, port=3, init_addr=0)
      rep (slot=5, port=3, level=0, iter=2, step=1, delay=0)
      rep (slot=5, port=3, level=1, iter=26, step=0, delay=t3)
    }
  }
  
  cell (x=2, y=0) {
    #1 - Build route (from cell (x=1, y=0) to cell (x=2, y=0)'s slot2)
    rop <route2w> (slot=0, port=2) {
      route (slot=0, option=0, sr=1, source=1, target=0b0100)
    }
  
    #2.1 - Write result to IOSRAM
    # Rounds 1, 2, 3, 4: store row0-7, 8-15, 16-23, 24-25
    rop <write_io_2_1> (slot=2, port=2) {
      dsu (slot=2, port=2, init_addr=0)
      rep (slot=2, port=2, level=0, iter=2, step=1, delay=0)
      rep (slot=2, port=2, level=1, iter=26, step=2, delay=t3)
    }
  
    #3.1 - Store result to output file
    # Rounds 1, 2, 3, 4: store row0-7, 8-15, 16-23, 24-25
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