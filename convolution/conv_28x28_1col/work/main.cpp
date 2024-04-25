#include "Drra.hpp"
#include "Util.hpp"
#include <cstdlib>

int main() { return run_simulation(); }

/*
 * Generate the input SRAM image.
 */
void init() {
#define N 57 * 16 // size of input file
  // Set the seed for random number generator
  srand((unsigned)time(NULL));

  // Generate N random numbers in range [0,100)
  vector<int16_t> v(N);
  for (auto i = 0; i < N; i++) {
    v[i] = rand() % 5;
  }

  // Write the random numbers to the input buffer.
  //__input_buffer__.write<int16_t>(0, 1, v);
  //__input_buffer__.write<int16_t>(1, N/16-1, v);
  __input_buffer__.write<int16_t>(0, N/16, v);
}

/*
 * Define the reference algorithm model. It will generate the reference output
 * SRAM image. You can use free C++ programs.
 */
void model_l0() {
#define N 57 * 16 // size of input file

  int a_size = 28; // matrix a: 28*28
  int b_size = a_size-2; // filter: 3*3, matrix b: 26*26
  int b_1row_line = (b_size-1)/16 + 1; // 1 row of b uses 2 rows of RF
  int b_line = ((b_size-1)/16 + 1) * b_size; // matrix b uses 52 rows of RF
  int b_num  = b_line * 16; // matrix b uses 52*16 data in RF

  // Read the input buffer to A.
  vector<int16_t> f = __input_buffer__.read<int16_t>(0, 1);
  vector<int16_t> a = __input_buffer__.read<int16_t>(1, N/16-1);
  vector<int16_t> b(b_num);

  // Initialize matrix b
  for (int ii = 0; ii < b_num; ii++) {
    b[ii] = 0;
  }

  for (int i = 0; i < b_size; i++) { // index of row, line0,1,2, line1,2,3 ... line25,26,27 of a
    for (int j =0; j < b_size; j++) { // index of column, b[0], b[1], ... b[25]
      for (int k = 0; k < 9; k++) { // index of filter, f[0], f[1], ... f[8]
        int row_offset = k / 3;
        int col_offset = k % 3;
        b[16*b_1row_line*i + j] += a[b_1row_line * 16 * (i + row_offset) + (j + col_offset)] * f[k];
      }
    }
  }

  // Write b to the output buffer
  __output_buffer__.write<int16_t>(0, b_line, b);
}

/*
 * Define the DRR algorithm model. It will generate the DRR output SRAM image by
 * simulate the instruction execution using python simulator.
 */
void model_l1() { simulate_code_segment(0); }
