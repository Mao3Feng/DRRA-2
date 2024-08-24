epoch <config> {
  cell (x=0, y=0) {
    #1-build route (from cell 0_0's slot2 to cell 1_0)
    rop <route0r> (slot=0, port=2) {
      route (slot=0, option=0, sr=0, source=2, target=0b10000000) 
    }
  }
  
  cell (x=1, y=0) {
    #1-build route (from cell 0_0 to cell 1_0's slot3,4)
    #  build route (from cell 1_0's slot3 to cell 2_0)
    rop <route1wr> (slot=0, port=2) {
      route (slot=0, option=0, sr=1, source=1, target=0b00011000)
      route (slot=0, option=0, sr=0, source=3, target=0b10000000)
    }

    #2-build swb (RF3 for 1 row in layer0. RF4 for 1 row in remaining layers. Write bakc to RF3.)
    #round1: row0
    rop <swb> (slot=0, port=0) {
      swb (slot=0, option=0, source=3, target=1)
      swb (slot=0, option=0, source=4, target=2)
      swb (slot=0, option=0, source=1, target=3)
    }
  }
  
  cell (x=2, y=0) {
    #1-build route (from cell 1_0 to cell 2_0's slot2)
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
      calc (mode=1, operand1=2, operand2_sd=0, operand2=52, result=2)
    }
  }
}

epoch <cbi0>{
  cell (x=2, y=0){
    cop <addr_init2>{
      calc (mode=1, operand1=3, operand2_sd=0, operand2=0, result=3)
    }
  }
}

loop <lb0> (iter=26) {
  epoch <rb0> {
    cell (x=0, y=0) {
      #2.1-load input file
      #round1: layer0 row0 of input matrix
      rop <load_r_2_1> (slot=1, port=0) {
        dsu (slot=1, port=0, init_addr_sd=1, init_addr=1)
        rep (slot=1, port=0, level=0, iter=2, step=1, delay=0)
      }
      rop <load_w_2_1> (slot=1, port=2) {
        dsu (slot=1, port=2, init_addr=0)
        rep (slot=1, port=2, level=0, iter=2, step=1, delay=0)
      }
      #3.1-read IOSRAM
      #round1: layer0 row0 of input matrix
      rop <read_io_3_1> (slot=2, port=3) {
        dsu (slot=2, port=3, init_addr=0)
        rep (slot=2, port=3, level=0, iter=2, step=1, delay=0)
      }
    }

    cell (x=1, y=0) {
      #3-write matrix to RF3,4
      #round1: row0
      rop <write_rf3> (slot=3, port=2) {
        dsu (slot=3, port=2, init_addr=0)
        rep (slot=3, port=2, level=0, iter=2, step=1, delay=0)
      }
    }
  }

  epoch <rb1> {
    cell (x=0, y=0) {
      #2.2-load input file
      #round1: layer1 row0 of input matrix
      rop <load_r_2_2> (slot=1, port=0) {
        dsu (slot=1, port=0, init_addr_sd=1, init_addr=2)
        rep (slot=1, port=0, level=0, iter=2, step=1, delay=0)
        rep (slot=1, port=0, level=1, iter=127, step=52, delay=25)
      }
    
      rop <load_w_2_2> (slot=1, port=2) {
        dsu (slot=1, port=2, init_addr=2)
        rep (slot=1, port=2, level=0, iter=2, step=1, delay=0)
        rep (slot=1, port=2, level=1, iter=127, step=0, delay=25)
      }
    
      #3.2-read IOSRAM
      #round1: layer1 row0 of input matrix
      rop <read_io_3_2> (slot=2, port=3) {
        dsu (slot=2, port=3, init_addr=2)
        rep (slot=2, port=3, level=0, iter=2, step=1, delay=0)
        rep (slot=2, port=3, level=1, iter=127, step=0, delay=25)
      }
    }
    
    cell (x=1, y=0) {
      #remaining layers
      rop <write_rf4> (slot=4, port=2) {
        dsu (slot=4, port=2, init_addr=0)
        rep (slot=4, port=2, level=0, iter=2, step=1, delay=0)
        rep (slot=4, port=2, level=1, iter=127, step=0, delay=25)
      }
    
      #4-read matrix from RF3,4. add
      #round1: row0
      rop <read_rf3> (slot=3, port=1) {
        dsu (slot=3, port=1, init_addr=0)
        rep (slot=3, port=1, level=0, iter=26, step=1, delay=0)
        rep (slot=3, port=1, level=1, iter=127, step=0, delay=1)
      }
    
      rop <read_rf4> (slot=4, port=1) {
        dsu (slot=4, port=1, init_addr=0)
        rep (slot=4, port=1, level=0, iter=26, step=1, delay=0)
        rep (slot=4, port=1, level=1, iter=127, step=0, delay=1)
      }
    
      rop <dpu> (slot=1, port=0) {
        dpu (slot=1, option=0, mode=1)
      }
    
      #5-write result to RF3
      #round1: row0
      rop <write_rf3_back> (slot=3, port=0) {
        dsu (slot=3, port=0, init_addr=0)
        rep (slot=3, port=0, level=0, iter=26, step=1, delay=0)
        rep (slot=3, port=0, level=1, iter=127, step=0, delay=1)
      }
    
      #6-read result from RF3
      #round1: row0
      rop <read_rf3_back> (slot=3, port=3) {
        dsu (slot=3, port=3, init_addr=0)
        rep (slot=3, port=3, level=0, iter=2, step=1, delay=0)
      }
    }
    
    cell (x=2, y=0) {
      #2.1-write result to IOSRAM
      #round1: store row0
      rop <write_io_2_1> (slot=2, port=2) {
        dsu (slot=2, port=2, init_addr=0)
        rep (slot=2, port=2, level=0, iter=2, step=1, delay=0)
      }
    
      #3.1-store result to output file
      #round1: store row0
      rop <output_r_3_1> (slot=1, port=3) {
        dsu (slot=1, port=3, init_addr=0)
        rep (slot=1, port=3, level=0, iter=2, step=1, delay=0)
      }
    
      rop <output_w_3_1> (slot=1, port=1) {
        dsu (slot=1, port=1, init_addr_sd=1, init_addr=3)
        rep (slot=1, port=1, level=0, iter=2, step=1, delay=0)
      }
    }
  }

  epoch <cbl0> { # calculation block loop 0
    cell (x=0, y=0) {
      cop <addr_calc0> {
        calc (mode=1, operand1=1, operand2_sd=0, operand2=2, result=1)
      }
    }
  }

  epoch <cbl1> {
    cell (x=0, y=0) {
      cop <addr_calc1> {
        calc (mode=1, operand1=2, operand2_sd=0, operand2=2, result=2)
      }
    }
  }

  epoch <cbl2> {
    cell (x=2, y=0){
      cop <addr_calc2>{
        calc (mode=1, operand1=3, operand2_sd=0, operand2=2, result=3)
      }
    }
  }

}