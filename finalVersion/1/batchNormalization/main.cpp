#include "Drra.hpp"
#include "Util.hpp"
#include <cstdlib>

int main() { return run_simulation(); }

/*
 * Generate the input SRAM image.
 */
void init() {
#define N 10817 * 16 // size of input file
  // Set the seed for random number generator
  srand((unsigned)time(NULL));

  // Generate N random numbers in range [0,100)
  vector<int16_t> v(N);

  int a_size = 416; // matrix a: 208*208
  int a_1row_line = (a_size-1)/16 + 1; // 1 row of a uses 26 rows of RF

  for (int k = 0; k < N; k++) {
    v[k] = 0;
  }

  v[0] = 5;
  v[1] = 3; //b[x] = 5*b[x] + 3

  for (int i = 0; i < a_size; i++) { //row
    for (int j = 0; j < a_size; j++) { //column
      v[16 * a_1row_line * i + j + 16] = 16 * a_1row_line * i + j + 16;
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
  #define N 10817 * 16 // size of input file

  int a_size = 416; // matrix a: 416*416
  int b_size = 416; // matrix b: 416*416
  int b_1row_line = (b_size-1)/16 + 1; // 1 row of b uses 26 rows of RF
  int b_line = b_1row_line * b_size; // matrix b uses 10816 rows of RF
  int b_num  = b_line * 16; // matrix b uses 10816*16 data in RF
  int c_line = b_1row_line*2;
  int c_num  = c_line * 16;

  // Read the input buffer to A.
  vector<int16_t> f = __input_buffer__.read<int16_t>(0, 1);
  vector<int16_t> a = __input_buffer__.read<int16_t>(1, (N-1)/16);
  vector<int16_t> b(b_num);
  vector<int16_t> c(c_num);

  // Initialize matrix b
  for (int ii = 0; ii < b_num; ii++) {
    b[ii] = 0;
  }

  for (int i = 0; i < b_size; i++) { //row
    for (int j = 0; j < b_size; j++) { //column
      b[16 * b_1row_line * i + j] = a[16 * b_1row_line * i + j] * f[0] + f[1];
    }
  }

  for (int k = 0; k < c_num; k++) {
    c[k] = b[k];
  }

  // Write c to the output buffer
  __output_buffer__.write<int16_t>(0, b_line, b);
  //__output_buffer__.write<int16_t>(0, c_line, c);
}

/*
 * Define the DRR algorithm model. It will generate the DRR output SRAM image by
 * simulate the instruction execution using python simulator.
 */
void model_l1() { simulate_code_segment(0); }
