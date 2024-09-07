epoch <cbi0>{ # calculation block initial 0
  cell (x=0, y=0){
    cop <addr_init0>{
      calc (mode=1, operand1=1, operand2_sd=0, operand2=0, result=1)
    }
  }
}

epoch <cbi1>{
  cell (x=2, y=0){
    cop <addr_init1>{
      calc (mode=1, operand1=2, operand2_sd=0, operand2=0, result=2)
    }
  }
}


loop <lb0> (iter=208) { 
  epoch <rb0> {
    cell (x=0, y=0) {
      #1 - Build route (from cell 0_0's slot2 to cell 1_0)
      rop <route0r> (slot=0, port=2) {
        route (slot=0, option=0, sr=0, source=2, target=0b10000000)
      }

      #2.1 - Load input file
      # Round1: row0 of input matrix
      rop <load_r_2_1> (slot=1, port=0) {
        dsu (slot=1, port=0, init_addr_sd=1, init_addr=1)
        rep (slot=1, port=0, level=0, iter=13, step=1, delay=0)
      }

      rop <load_w_2_1> (slot=1, port=2) {
        dsu (slot=1, port=2, init_addr=0)
        rep (slot=1, port=2, level=0, iter=13, step=1, delay=0)
      }

      #3.1 - Read IOSRAM
      # Round1: row0 of input matrix
      rop <read_io_3_1> (slot=2, port=3) {
        dsu (slot=2, port=3, init_addr=0)
        rep (slot=2, port=3, level=0, iter=4, step=1, delay=0)
        rep (slot=2, port=3, level=1, iter=3, step=4, delay=60)
      }

      rop <read_io_3_2> (slot=2, port=3) {
        dsu (slot=2, port=3, init_addr=12)
      }
    }

    cell (x=1, y=0) {
      #1 - Build route (from cell 0_0 to cell 1_0's slot3)
      #   Build route (from cell 1_0's slot4 to cell 2_0)
      rop <route1wr> (slot=0, port=2) {
        route (slot=0, option=0, sr=1, source=1, target=0b1000)
        route (slot=0, option=0, sr=0, source=4, target=0b10000000)
      }

      #2 - Build SWB (RF3 for input. Write back to RF4.)
      # Round1: row0
      rop <swb> (slot=0, port=0) {
        swb (slot=0, option=0, source=3, target=1)
        swb (slot=0, option=0, source=1, target=4)
      }

      #3 - Write matrix to RF3
      # Round1: row0
      rop <write_rf3_1> (slot=3, port=2) {
        dsu (slot=3, port=2, init_addr=0)
        rep (slot=3, port=2, level=0, iter=4, step=1, delay=0)
        rep (slot=3, port=2, level=1, iter=3, step=0, delay=60)
      }

      rop <write_rf3_2> (slot=3, port=2) {
        dsu (slot=3, port=2, init_addr=0)
      }

      #4 - Read matrix from RF3
      # Round1: row0
      rop <read_rf3_1> (slot=3, port=1) {
        dsu (slot=3, port=1, init_addr=0)
        rep (slot=3, port=1, level=0, iter=64, step=1, delay=0)
        rep (slot=3, port=1, level=1, iter=3, step=0, delay=0)
      }

      rop <read_rf3_2> (slot=3, port=1) {
        dsu (slot=3, port=1, init_addr=0)
        rep (slot=3, port=1, level=0, iter=16, step=1, delay=0)
      }

      rop <dpu_relu> (slot=1, port=0) {
        dpu (slot=1, option=0, mode=22)
      }

      #5 - Write result to RF4
      # Round1: row0
      rop <write_rf4_1> (slot=4, port=0) {
        dsu (slot=4, port=0, init_addr=0)
        rep (slot=4, port=0, level=0, iter=64, step=1, delay=0)
        rep (slot=4, port=0, level=1, iter=3, step=0, delay=0)
      }

      rop <write_rf4_2> (slot=4, port=0) {
        dsu (slot=4, port=0, init_addr=0)
        rep (slot=4, port=0, level=0, iter=16, step=1, delay=0)
      }

      #6 - Read result from RF4
      # Round1: row0
      rop <read_rf4_1> (slot=4, port=3) {
        dsu (slot=4, port=3, init_addr=0)
        rep (slot=4, port=3, level=0, iter=4, step=1, delay=0)
        rep (slot=4, port=3, level=1, iter=3, step=0, delay=60)
      }

      rop <read_rf4_2> (slot=4, port=3) {
        dsu (slot=4, port=3, init_addr=0)
      }
    }

    cell (x=2, y=0) {
      #1 - Build route (from cell 1_0 to cell 2_0's slot2)
      rop <route2w> (slot=0, port=2) {
        route (slot=0, option=0, sr=1, source=1, target=0b0100)
      }

      #2.1 - Write result to IOSRAM
      # Round1: store row0
      rop <write_io_2_1> (slot=2, port=2) {
        dsu (slot=2, port=2, init_addr=0)
        rep (slot=2, port=2, level=0, iter=4, step=1, delay=0)
        rep (slot=2, port=2, level=1, iter=3, step=4, delay=60)
      }

      rop <write_io_2_2> (slot=2, port=2) {
        dsu (slot=2, port=2, init_addr=12)
      }

      #3.1 - Store result to output file
      # Round1: store row0
      rop <output_r_3_1> (slot=1, port=3) {
        dsu (slot=1, port=3, init_addr=0)
        rep (slot=1, port=3, level=0, iter=13, step=1, delay=0)
      }

      rop <output_w_3_1> (slot=1, port=1) {
        dsu (slot=1, port=1, init_addr_sd=1, init_addr=2)
        rep (slot=1, port=1, level=0, iter=13, step=1, delay=0)
      }
    }
  }

  epoch <cbl0> { # calculation block loop 0
    cell (x=0, y=0) {
      cop <addr_calc0> {
        calc (mode=1, operand1=1, operand2_sd=0, operand2=13, result=1)
      }
    }
  }

  epoch <cbl1> { # calculation block loop 0
    cell (x=2, y=0) {
      cop <addr_calc1> {
        calc (mode=1, operand1=2, operand2_sd=0, operand2=13, result=2)
      }
    }
  }
}