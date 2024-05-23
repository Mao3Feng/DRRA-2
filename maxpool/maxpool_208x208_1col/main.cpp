#include "Drra.hpp"
#include "Util.hpp"
#include <cstdlib>

int main() { return run_simulation(); }

/*
 * Generate the input SRAM image.
 */
void init() {
#define N 2704 * 16 // size of input file
  // Set the seed for random number generator
  srand((unsigned)time(NULL));

  // Generate N random numbers in range [0,100)
  vector<int16_t> v(N);
  for (auto i = 0; i < N; i++) {
    v[i] = i;
  }

  // Write the random numbers to the input buffer.
  __input_buffer__.write<int16_t>(0, N/16, v);
}

/*
 * Define the reference algorithm model. It will generate the reference output
 * SRAM image. You can use free C++ programs.
 */
void model_l0() {
  #define N 2704 * 16 // size of input file
  #define STRIDE 2

  int a_size = 208; // matrix a: 208*208
  int a_1row_line = (a_size-1)/16 + 1; // 1 row of a uses 13 rows of RF
  int b_size = 104; // filter: 2*2/2, matrix b: 104*104
  int b_1row_line = (b_size-1)/16 + 1; // 1 row of b uses 7 rows of RF
  int b_line = b_1row_line * b_size; // matrix b uses 728 rows of RF
  int b_num  = b_line * 16; // matrix b uses 728*16 data in RF
  int c_line = b_1row_line * 2;
  int c_num = c_line * 16;

  // Read the input buffer to A.
  vector<int16_t> a = __input_buffer__.read<int16_t>(0, N/16);
  vector<int16_t> b(b_num);
  vector<int16_t> c(c_num);

  // Initialize matrix b
  for (int ii = 0; ii < b_num; ii++) {
    b[ii] = 0;
  }

  for (int i = 0; i < b_size; i++) { //b_size-1?
    for (int j = 0; j < b_size; j++) {
      int maxVal = a[i * STRIDE * a_1row_line * 16 + j * STRIDE];
      
      for (int x = 0; x < 2; x++) {
        for (int y = 0; y < 2; y++) {
          int idx = (i * STRIDE + x) * a_1row_line * 16 + (j * STRIDE + y);
          if (a[idx] > maxVal) {
            maxVal = a[idx];
          }
        }
      }
      
      b[i * b_1row_line * 16 + j] = maxVal;
    }
  }
  for (int jj = 0; jj < c_num; jj++) {
    c[jj] = b[jj];
  }
  // Write b to the output buffer
  __output_buffer__.write<int16_t>(0, c_line, c);
}

/*
 * Define the DRR algorithm model. It will generate the DRR output SRAM image by
 * simulate the instruction execution using python simulator.
 */
void model_l1() { simulate_code_segment(0); }