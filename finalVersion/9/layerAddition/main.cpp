#include "Drra.hpp"
#include "Util.hpp"
#include <cstdlib>

#define N 128*52 * 16 // size of input file
#define M 128 // number of layer

int main() { return run_simulation(); }

/*
 * Generate the input SRAM image.
 */
void init() {

  // Set the seed for random number generator
  srand((unsigned)time(NULL));

  // Generate N random numbers in range [0,100)
  vector<int16_t> v(N);

  int a_size = 26; // matrix a: 26*26
  int a_1row_line = (a_size-1)/16 + 1; // 1 row of a uses 2 rows of RF

  for (int i = 0; i < M * a_size; i++) { //row
    for (int j = 0; j < a_size; j++) { //column
      v[16 * a_1row_line * i + j] = (16 * a_1row_line * i + j) % 15;
    }
  }

  // Write the random numbers to the input buffer.
  __input_buffer__.write<int16_t>(0, N/16, v);
}

/*
 * Define the reference algorithm model. It will generate the reference output
 * SRAM image. You can use free C++ programs.
 */
void model_l0() {
  int a_size = 26; // matrix a: 26*26
  int b_size = 26; // matrix b: 26*26
  int b_1row_line = (b_size-1)/16 + 1; // 1 row of b uses 2 rows of RF
  int b_line = b_1row_line * b_size; // matrix b uses 52 rows of RF
  int b_num  = b_line * 16; // matrix b uses 52*16 data in RF

  // Read the input buffer to A.
  vector<int16_t> a = __input_buffer__.read<int16_t>(0, N/16);
  vector<int16_t> b(b_num);

  // Initialize matrix b
  for (int ii = 0; ii < b_num; ii++) {
    b[ii] = 0;
  }

  for (int i = 0; i < b_size; i++) { //row
    for (int j = 0; j < b_size; j++) { //column
      for (int k = 0; k < M; k++) { //layer
        b[16 * b_1row_line * i + j] += a[16 * b_1row_line * i + j + k * b_num];
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
