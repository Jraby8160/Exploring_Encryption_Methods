module inverse_permutation(
  input logic [7:0] image [0:255][0:255], // Assuming 256x256 image and 8-bit grayscale
  input logic [7:0] M [0:255], // Column array of length equal to rows in image
  input logic [7:0] N [0:255], // Row array of length equal to columns in image
  output logic [7:0] permutated_image [0:255][0:255] // Image after undoing permutation
);

  // Variables for image dimensions
  int m = 256;
  int n = 256;

  // Variables for loop counters
  int i, j;

  // Column shift
  initial begin
      // Column shift
      for (i=0; i<n; i++) begin
          // Shifting ith column N[i] times down
          for (j=0; j<m; j++) begin
              permutated_image[j][i] = image[((j - N[i]) + m) % m][i];
          end
      end

      // Row shift
      for (i=0; i<m; i++) begin
          // Shifting ith row M[i] times right
          for (j=0; j<n; j++) begin
              permutated_image[i][j] = image[i][((j - M[i]) + n) % n];
          end
      end
  end
endmodule



/*
This SystemVerilog module inverse_permutation takes inputs image, M, and N, which represent 
the image after permutation, the row array, and the column array respectively. It outputs 
the image after undoing the permutation as permutated_image.

Inside the module, m and n are declared to store the dimensions of the image.
Loop counters i and j are declared.

The initial block is used to initialize the values of m and n using the $dimensions system function.
The first loop iterates over each column of the image. Within this loop, another loop iterates over
each row of the image. The value of permutated_image[j][i] is assigned by shifting the elements 
of the image array based on the values in the N array to undo the column shift.

The second loop iterates over each row of the image. Within this loop, another loop iterates 
over each column of the image. The value of permutated_image[i][j] is assigned by shifting the 
elements of the image array based on the values in the M array to undo the row shift.
*/