epoch <config> {
  cell (x=0, y=0) {
    #1 - Build route (from cell 0_0's slot2 to cell 1_0)
    rop <route0r> (slot=0, port=2) {
      route (slot=0, option=0, sr=0, source=2, target=0b10000000)
    }
  }

  cell (x=1, y=0) {
    #1 - Build route (from cell 0_0 to cell 1_0's slot3,4)
    #   Build route (from cell 1_0's slot3 to cell 2_0)
    rop <route1wr> (slot=0, port=2) {
      route (slot=0, option=0, sr=1, source=1, target=0b00011000)
      route (slot=0, option=0, sr=0, source=3, target=0b10000000)
    }

    #2 - Build SWB (RF3 for 1 row in layer0. RF4 for 1 row in remaining layers. Write back to RF3.)
    # Round1: row0
    rop <swb> (slot=0, port=0) {
      swb (slot=0, option=0, source=3, target=1)
      swb (slot=0, option=0, source=4, target=2)
      swb (slot=0, option=0, source=1, target=3)
    }
  }

  cell (x=2, y=0) {
    #1 - Build route (from cell 1_0 to cell 2_0's slot2)
    rop <route2w> (slot=0, port=2) {
      route (slot=0, option=0, sr=1, source=1, target=0b0100)
    }
  }
}



epoch <cbi0>{ # calculation block initial 0
  cell (x=0, y=0) {
    cop <addr_init0> {
      calc (mode=1, operand1=1, operand2_sd=0, operand2=0, result=1)
    }
  }
}

epoch <cbi1>{
  cell (x=0, y=0){
    cop <addr_init1>{
      calc (mode=1, operand1=2, operand2_sd=0, operand2=728, result=2)
    }
  }
}

epoch <cbi2>{
  cell (x=2, y=0){
    cop <addr_init2>{
      calc (mode=1, operand1=3, operand2_sd=0, operand2=0, result=3)
    }
  }
}

epoch <cbi3>{ # calculation block initial 0
  cell (x=0, y=0) {
    cop <addr_init3> {
      calc (mode=1, operand1=3, operand2_sd=0, operand2=4, result=3)
    }
  }
}

epoch <cbi4>{
  cell (x=0, y=0){
    cop <addr_init4>{
      calc (mode=1, operand1=4, operand2_sd=0, operand2=732, result=4)
    }
  }
}

epoch <cbi5>{
  cell (x=2, y=0){
    cop <addr_init5>{
      calc (mode=1, operand1=5, operand2_sd=0, operand2=4, result=5)
    }
  }
}



loop <lb0> (iter=1) {
  epoch <rb0> { # Round1: 4 lines
    cell (x=0, y=0) {
      #2.1 - Load input file
      # Round1: layer0 row0 line0-3 of input matrix
      rop <load_r_2_1> (slot=1, port=0) {
        dsu (slot=1, port=0, init_addr_sd=1, init_addr=1)
        rep (slot=1, port=0, level=0, iter=4, step=1, delay=0)
      }
      rop <load_w_2_1> (slot=1, port=2) {
        dsu (slot=1, port=2, init_addr=0)
        rep (slot=1, port=2, level=0, iter=4, step=1, delay=0)
      }
      #3.1 - Read IOSRAM
      # Round1: layer0 row0 line0-3 of input matrix
      rop <read_io_3_1> (slot=2, port=3) {
        dsu (slot=2, port=3, init_addr=0)
        rep (slot=2, port=3, level=0, iter=4, step=1, delay=0)
      }
    }
    cell (x=1, y=0) {
      #3 - Write matrix to RF3,4
      # Round1: row0, line0-3
      rop <write_rf3_1> (slot=3, port=2) {
        dsu (slot=3, port=2, init_addr=0)
        rep (slot=3, port=2, level=0, iter=4, step=1, delay=0)
      }
    }
  }
  
  epoch <rb1> { # Round1: 4 lines
    cell (x=0, y=0) {
      #2.2 - Load input file
      # Round1: layer1 row0 line0-3 of input matrix
      rop <load_r_2_2> (slot=1, port=0) {
        #dsu (slot=1, port=0, init_addr_sd=1, init_addr=2)
        dsu (slot=1, port=0, init_addr_sd=0, init_addr=728)
        rep (slot=1, port=0, level=0, iter=4, step=1, delay=0)
        rep (slot=1, port=0, level=1, iter=32, step=728, delay=61)
      }
    
      rop <load_w_2_2> (slot=1, port=2) {
        dsu (slot=1, port=2, init_addr=7)
        rep (slot=1, port=2, level=0, iter=4, step=1, delay=0)
        rep (slot=1, port=2, level=1, iter=32, step=728, delay=61)
      }
    
      #3.2 - Read IOSRAM
      # Round1: layer1 row0 line4-6 of input matrix
      rop <read_io_3_2> (slot=2, port=3) {
        dsu (slot=2, port=3, init_addr=7)
        rep (slot=2, port=3, level=0, iter=4, step=1, delay=0)
        rep (slot=2, port=3, level=1, iter=32, step=728, delay=61)
      }
    }

    cell (x=1, y=0) {
      # Remaining layers
      rop <write_rf4_1> (slot=4, port=2) {
        dsu (slot=4, port=2, init_addr=0)
        rep (slot=4, port=2, level=0, iter=4, step=1, delay=0)
        rep (slot=4, port=2, level=1, iter=32, step=728, delay=61)
      }
      #4 - Read matrix from RF3,4 and add
      # Round1: row0
      rop <read_rf3_1> (slot=3, port=1) {
        dsu (slot=3, port=1, init_addr=0)
        rep (slot=3, port=1, level=0, iter=64, step=1, delay=0)
        rep (slot=3, port=1, level=1, iter=32, step=0, delay=1)
      }
      rop <read_rf4_1> (slot=4, port=1) {
        dsu (slot=4, port=1, init_addr=0)
        rep (slot=4, port=1, level=0, iter=64, step=1, delay=0)
        rep (slot=4, port=1, level=1, iter=32, step=0, delay=1)
      }
      rop <dpu> (slot=1, port=0) {
        dpu (slot=1, option=0, mode=1)
      }
      #5 - Write result to RF3
      # Round1: row0
      rop <write_rf3_back_1> (slot=3, port=0) {
        dsu (slot=3, port=0, init_addr=0)
        rep (slot=3, port=0, level=0, iter=64, step=1, delay=0)
        rep (slot=3, port=0, level=1, iter=32, step=0, delay=1)
      }
      #6 - Read result from RF3
      # Round1: row0
      rop <read_rf3_back_1> (slot=3, port=3) {
        dsu (slot=3, port=3, init_addr=0)
        rep (slot=3, port=3, level=0, iter=4, step=1, delay=0)
      }
    }

    cell (x=2, y=0) {
      #2.1 - Write result to IOSRAM
      # Round1: store row0
      rop <write_io_2_1> (slot=2, port=2) {
        dsu (slot=2, port=2, init_addr=0)
        rep (slot=2, port=2, level=0, iter=4, step=1, delay=0)
      }
      #3.1 - Store result to output file
      # Round1: store row0
      rop <output_r_3_1> (slot=1, port=3) {
        dsu (slot=1, port=3, init_addr=0)
        rep (slot=1, port=3, level=0, iter=4, step=1, delay=0)
      }
      rop <output_w_3_1> (slot=1, port=1) {
        dsu (slot=1, port=1, init_addr_sd=1, init_addr=2)
        rep (slot=1, port=1, level=0, iter=4, step=1, delay=0)
      }
    }
  }

  epoch <rb2> { # Round2: 3 lines
    cell (x=0, y=0) {
      #2.3 - Load input file
      # Round1: layer0 row0 line4-6 of input matrix
      rop <load_r_2_3> (slot=1, port=0) {
        dsu (slot=1, port=0, init_addr_sd=1, init_addr=3)
        rep (slot=1, port=0, level=0, iter=3, step=1, delay=0)
      }
    
      rop <load_w_2_3> (slot=1, port=2) {
        dsu (slot=1, port=2, init_addr=4)
        rep (slot=1, port=2, level=0, iter=3, step=1, delay=0)
      }
    
      #3.3 - Read IOSRAM
      # Round1: layer0 row0 line4-6 of input matrix
      rop <read_io_3_3> (slot=2, port=3) {
        dsu (slot=2, port=3, init_addr=4)
        rep (slot=2, port=3, level=0, iter=3, step=1, delay=0)
      }
    }
    cell (x=1, y=0) {
      # Round1: row0, line4-6
      rop <write_rf3_2> (slot=3, port=2) {
        dsu (slot=3, port=2, init_addr=0)
        rep (slot=3, port=2, level=0, iter=3, step=1, delay=0)
      }
    }
  }

  epoch <rb3> { # Round2: 3 lines
    cell (x=0, y=0) {
      #2.4 - Load input file
      # Round1: layer1 row0 line4-6 of input matrix
      rop <load_r_2_4> (slot=1, port=0) {
        #dsu (slot=1, port=0, init_addr_sd=1, init_addr=4)
        dsu (slot=1, port=0, init_addr_sd=0, init_addr=732)
        rep (slot=1, port=0, level=0, iter=3, step=1, delay=0)
        rep (slot=1, port=0, level=1, iter=32, step=728, delay=61)
      }
    
      rop <load_w_2_4> (slot=1, port=2) {
        dsu (slot=1, port=2, init_addr=11)
        rep (slot=1, port=2, level=0, iter=3, step=1, delay=0)
        rep (slot=1, port=2, level=1, iter=32, step=728, delay=61)
      }
    
      #3.4 - Read IOSRAM
      # Round1: layer1 row0 line0-3 of input matrix
      rop <read_io_3_4> (slot=2, port=3) {
        dsu (slot=2, port=3, init_addr=11)
        rep (slot=2, port=3, level=0, iter=3, step=1, delay=0)
        rep (slot=2, port=3, level=1, iter=32, step=728, delay=61)
      }
    }

    cell (x=1, y=0) {
      # Remaining layers
      rop <write_rf4_2> (slot=4, port=2) {
        dsu (slot=4, port=2, init_addr=0)
        rep (slot=4, port=2, level=0, iter=3, step=1, delay=0)
        rep (slot=4, port=2, level=1, iter=32, step=728, delay=61)
      }
      rop <read_rf3_2> (slot=3, port=1) {
        dsu (slot=3, port=1, init_addr=0)
        rep (slot=3, port=1, level=0, iter=40, step=1, delay=0)
        rep (slot=3, port=1, level=1, iter=32, step=0, delay=1)
      }
      rop <read_rf4_2> (slot=4, port=1) {
        dsu (slot=4, port=1, init_addr=0)
        rep (slot=4, port=1, level=0, iter=40, step=1, delay=0)
        rep (slot=4, port=1, level=1, iter=32, step=0, delay=1)
      }
      rop <write_rf3_back_2> (slot=3, port=0) {
        dsu (slot=3, port=0, init_addr=0)
        rep (slot=3, port=0, level=0, iter=40, step=1, delay=0)
        rep (slot=3, port=0, level=1, iter=32, step=0, delay=1)
      }
      rop <read_rf3_back_2> (slot=3, port=3) {
        dsu (slot=3, port=3, init_addr=0)
        rep (slot=3, port=3, level=0, iter=3, step=1, delay=0)
      }
    }

    cell (x=2, y=0) {
      #2.2 - Write result to IOSRAM
      # Round1: store row0
      rop <write_io_2_2> (slot=2, port=2) {
        dsu (slot=2, port=2, init_addr=4)
        rep (slot=2, port=2, level=0, iter=3, step=1, delay=0)
      }
      #3.2 - Store result to output file
      # Round1: store row0
      rop <output_r_3_2> (slot=1, port=3) {
        dsu (slot=1, port=3, init_addr=4)
        rep (slot=1, port=3, level=0, iter=3, step=1, delay=0)
      }
      rop <output_w_3_2> (slot=1, port=1) {
        dsu (slot=1, port=1, init_addr_sd=1, init_addr=5)
        rep (slot=1, port=1, level=0, iter=3, step=1, delay=0)
      }
    }
  }



  epoch <cbl0> { # calculation block loop 0
    cell (x=0, y=0) {
      cop <addr_calc0> {
        calc (mode=1, operand1=1, operand2_sd=0, operand2=7, result=1)
      }
    }
  }

  epoch <cbl1> {
    cell (x=0, y=0) {
      cop <addr_calc1> {
        calc (mode=1, operand1=2, operand2_sd=0, operand2=7, result=2)
      }
    }
  }

  epoch <cbl2> {
    cell (x=2, y=0){
      cop <addr_calc2>{
        calc (mode=1, operand1=3, operand2_sd=0, operand2=7, result=3)
      }
    }
  }

  epoch <cbl3> { # calculation block loop 3
    cell (x=0, y=0) {
      cop <addr_calc3> {
        calc (mode=1, operand1=3, operand2_sd=0, operand2=7, result=3)
      }
    }
  }

  epoch <cbl4> {
    cell (x=0, y=0) {
      cop <addr_calc4> {
        calc (mode=1, operand1=4, operand2_sd=0, operand2=7, result=4)
      }
    }
  }

  epoch <cbl5> {
    cell (x=2, y=0){
      cop <addr_calc5>{
        calc (mode=1, operand1=5, operand2_sd=0, operand2=7, result=5)
      }
    }
  }
}
