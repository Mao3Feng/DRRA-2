epoch <config> {
  cell (x=0, y=0) {
    #1 - Build route (from cell 0_0's slot2 to cell 1_0)
    rop <route0r> (slot=0, port=2) {
      route (slot=0, option=0, sr=0, source=2, target=0b10000000)
    }
    #2.0 - Load input file / Write IOSRAM (0=filter, 1-742=input matrix)
    # Filter
    rop <load_r_2_0> (slot=1, port=0) {
      dsu (slot=1, port=0, init_addr=0)
    }

    rop <load_w_2_0> (slot=1, port=2) {
      dsu (slot=1, port=2, init_addr=0)
    }
    #3.0 - Read IOSRAM
    # Filter
    rop <read_io_3_0> (slot=2, port=3) {
      dsu (slot=2, port=3, init_addr=0)
    }
  }
  cell (x=1, y=0) {
    #1 - Build route (from cell 0_0 to cell 1_0's slot3,4,5,6,7)
    #   Build route (from cell 1_0's slot7 to cell 1_0)
    rop <route1wr> (slot=0, port=2) {
      route (slot=0, option=0, sr=1, source=1, target=0b11111000)
      route (slot=0, option=0, sr=0, source=7, target=0b10000000)
    }
    #2 - Write filter to RF3
    rop <write_filter> (slot=3, port=2) {
      dsu (slot=3, port=2, init_addr=0)
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
  cell (x=0, y=0){
    cop <addr_init0>{
      calc (mode=1, operand1=1, operand2_sd=0, operand2=1, result=1)
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

loop <lb0> (iter=104) {
  epoch <rb0> {
    cell (x=0, y=0) {
      #2.1 - Load input file
      # Round1: row0-8 of input matrix
      rop <load_r_2_1> (slot=1, port=0) {
        dsu (slot=1, port=0, init_addr_sd=1, init_addr=1)
        rep (slot=1, port=0, level=0, iter=21, step=1, delay=0)
      }
    
      rop <load_w_2_1> (slot=1, port=2) {
        dsu (slot=1, port=2, init_addr=0)
        rep (slot=1, port=2, level=0, iter=21, step=1, delay=0)
      }
    
      #3.1 - Read IOSRAM
      # Round1: row0-8 of input matrix
      rop <read_io_3_1_1> (slot=2, port=3) {
        dsu (slot=2, port=3, init_addr=0)
        rep (slot=2, port=3, level=0, iter=4, step=1, delay=0)
        rep (slot=2, port=3, level=1, iter=3, step=7, delay=0)
      }
    
      rop <read_io_3_1_2> (slot=2, port=3) {
        dsu (slot=2, port=3, init_addr=3)
        rep (slot=2, port=3, level=0, iter=2, step=1, delay=0)
        rep (slot=2, port=3, level=1, iter=3, step=7, delay=0)
      }
    
      rop <read_io_3_1_3> (slot=2, port=3) {
        dsu (slot=2, port=3, init_addr=4)
        rep (slot=2, port=3, level=0, iter=3, step=1, delay=0)
        rep (slot=2, port=3, level=1, iter=3, step=7, delay=0)
      }
    
      rop <read_io_zero> (slot=2, port=3) {
        dsu (slot=2, port=3, init_addr=63)
        rep (slot=2, port=3, level=0, iter=4, step=0, delay=0)
      }
    }

    cell (x=1, y=0) {
      #3 - Build SWB (RF4,5,6 for 3 rows. RF3 for filter. RF7 for result.)
      # Round1: row0-8
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
        rep (slot=0, port=0, level=0, iter=105, step=0, delay=2)
      }
      #4.1 - Write matrix to RF4,5,6
      # Round1: row0-8
      rop <write_rf4_1> (slot=4, port=2) {
        dsu (slot=4, port=2, init_addr=0)
        rep (slot=4, port=2, level=0, iter=4, step=1, delay=0)
      }
    
      rop <write_rf5_1> (slot=5, port=2) {
        dsu (slot=5, port=2, init_addr=0)
        rep (slot=5, port=2, level=0, iter=4, step=1, delay=0)
      }
    
      rop <write_rf6_1> (slot=6, port=2) {
        dsu (slot=6, port=2, init_addr=0)
        rep (slot=6, port=2, level=0, iter=4, step=1, delay=0)
      }
    
      rop <write_rf4_2> (slot=4, port=2) {
        dsu (slot=4, port=2, init_addr=0)
        rep (slot=4, port=2, level=0, iter=2, step=1, delay=0)
      }
    
      rop <write_rf5_2> (slot=5, port=2) {
        dsu (slot=5, port=2, init_addr=0)
        rep (slot=5, port=2, level=0, iter=2, step=1, delay=0)
      }
    
      rop <write_rf6_2> (slot=6, port=2) {
        dsu (slot=6, port=2, init_addr=0)
        rep (slot=6, port=2, level=0, iter=2, step=1, delay=0)
      }
    
      rop <write_rf4_3> (slot=4, port=2) {
        dsu (slot=4, port=2, init_addr=0)
        rep (slot=4, port=2, level=0, iter=3, step=1, delay=0)
      }
    
      rop <write_rf5_3> (slot=5, port=2) {
        dsu (slot=5, port=2, init_addr=0)
        rep (slot=5, port=2, level=0, iter=3, step=1, delay=0)
      }
    
      rop <write_rf6_3> (slot=6, port=2) {
        dsu (slot=6, port=2, init_addr=0)
        rep (slot=6, port=2, level=0, iter=3, step=1, delay=0)
      }
    
      #5.1 - Read matrix from RF4,5,6. Read filter from RF7. Convolution
      # Round1: row0-8
      rop <read_rf3_1> (slot=3, port=1) {
        dsu (slot=3, port=1, init_addr=0)
        rep (slot=3, port=1, level=0, iter=9, step=1, delay=0)
        rep (slot=3, port=1, level=1, iter=64, step=0, delay=0)
      }
    
      rop <read_rf3_3> (slot=3, port=1) {
        dsu (slot=3, port=1, init_addr=0)
        rep (slot=3, port=1, level=0, iter=9, step=1, delay=0)
        rep (slot=3, port=1, level=1, iter=40, step=0, delay=0)
      }
    
      rop <read_rf4_1> (slot=4, port=1) {
        dsu (slot=4, port=1, init_addr=0)
        rep (slot=4, port=1, level=0, iter=3, step=1, delay=0)
        rep (slot=4, port=1, level=1, iter=62, step=1, delay=6)
      }
    
      rop <read_rf4_2> (slot=4, port=1) {
        dsu (slot=4, port=1, init_addr=14)
        rep (slot=4, port=1, level=0, iter=3, step=1, delay=0)
        rep (slot=4, port=1, level=1, iter=2, step=1, delay=6)
      }
    
      rop <read_rf4_3> (slot=4, port=1) {
        dsu (slot=4, port=1, init_addr=0)
        rep (slot=4, port=1, level=0, iter=3, step=1, delay=0)
        rep (slot=4, port=1, level=1, iter=40, step=1, delay=6)
      }
    
      rop <read_rf5_1> (slot=5, port=1) {
        dsu (slot=5, port=1, init_addr=0)
        rep (slot=5, port=1, level=0, iter=3, step=1, delay=0)
        rep (slot=5, port=1, level=1, iter=62, step=1, delay=6)
      }
    
      rop <read_rf5_2> (slot=5, port=1) {
        dsu (slot=5, port=1, init_addr=14)
        rep (slot=5, port=1, level=0, iter=3, step=1, delay=0)
        rep (slot=5, port=1, level=1, iter=2, step=1, delay=6)
      }
    
      rop <read_rf5_3> (slot=5, port=1) {
        dsu (slot=5, port=1, init_addr=0)
        rep (slot=5, port=1, level=0, iter=3, step=1, delay=0)
        rep (slot=5, port=1, level=1, iter=40, step=1, delay=6)
      }
    
      rop <read_rf6_1> (slot=6, port=1) {
        dsu (slot=6, port=1, init_addr=0)
        rep (slot=6, port=1, level=0, iter=3, step=1, delay=0)
        rep (slot=6, port=1, level=1, iter=62, step=1, delay=6)
      }
    
      rop <read_rf6_2> (slot=6, port=1) {
        dsu (slot=6, port=1, init_addr=14)
        rep (slot=6, port=1, level=0, iter=3, step=1, delay=0)
        rep (slot=6, port=1, level=1, iter=2, step=1, delay=6)
      }
    
      rop <read_rf6_3> (slot=6, port=1) {
        dsu (slot=6, port=1, init_addr=0)
        rep (slot=6, port=1, level=0, iter=3, step=1, delay=0)
        rep (slot=6, port=1, level=1, iter=40, step=1, delay=6)
      }
    
      rop <dpu> (slot=1, port=0) {
        dpu (slot=1, option=0, mode=2)
        rep (slot=1, port=0, level=0, iter=105, step=0, delay=8)
      }
    
      #6.1 - Write result to RF7
      # Round1: row0-8
      rop <write_rf7_1> (slot=7, port=0) {
        dsu (slot=7, port=0, init_addr=0)
        rep (slot=7, port=0, level=0, iter=64, step=1, delay=8)
      }
    
      rop <write_rf7_2> (slot=7, port=0) {
        dsu (slot=7, port=0, init_addr=0)
        rep (slot=7, port=0, level=0, iter=40, step=1, delay=8)
      }
    
      #7.1 - Read result from RF7
      # Round1: row0-8
      rop <read_rf7_1> (slot=7, port=3) {
        dsu (slot=7, port=3, init_addr=0)
        rep (slot=7, port=3, level=0, iter=4, step=1, delay=0)
      }
    
      rop <read_rf7_2> (slot=7, port=3) {
        dsu (slot=7, port=3, init_addr=0)
        rep (slot=7, port=3, level=0, iter=3, step=1, delay=0)
      }
    
      #8.1 - Empty RF7
      # Round1: row0-8
      rop <write_rf7_zero> (slot=7, port=2) {
        dsu (slot=7, port=2, init_addr=0)
        rep (slot=7, port=2, level=0, iter=4, step=1, delay=0)
      }
    }

    cell (x=2, y=0) {
      #2.1 - Write result to IOSRAM
      # Round1: row0-6 of output matrix
      rop <write_io_2_1_1> (slot=2, port=2) {
        dsu (slot=2, port=2, init_addr=0)
        rep (slot=2, port=2, level=0, iter=4, step=1, delay=0)
      }
    
      rop <write_io_2_1_2> (slot=2, port=2) {
        dsu (slot=2, port=2, init_addr=4)
        rep (slot=2, port=2, level=0, iter=3, step=1, delay=0)
      }
    
      #3.1 - Store result to output file
      # Round1: row0-6
      rop <output_r_3_1> (slot=1, port=3) {
        dsu (slot=1, port=3, init_addr=0)
        rep (slot=1, port=3, level=0, iter=7, step=1, delay=0)
      }
    
      rop <output_w_3_1> (slot=1, port=1) {
        dsu (slot=1, port=1, init_addr_sd=1, init_addr=2)
        rep (slot=1, port=1, level=0, iter=7, step=1, delay=0)
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
    cell (x=2, y=0) {
      cop <addr_calc1> {
        calc (mode=1, operand1=2, operand2_sd=0, operand2=7, result=2)
      }
    }
  }
}