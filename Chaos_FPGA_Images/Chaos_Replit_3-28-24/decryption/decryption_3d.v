module decryption_3d (
  input logic [7:0] C [][],
  input logic [127:0] K,
  input logic [7:0] F,
  output logic [7:0] decrypted_image [][]
);

  // Parameters
  parameter MAX_X = $size(C, 0);
  parameter MAX_Y = $size(C, 1);
  parameter MAX_Z = $size(C, 2);

  // Local variables
  logic [7:0] Q [MAX_X][MAX_Y][MAX_Z];
  integer i, j, k;

  // Function to decrypt image of multiple layers
  always_comb begin
      for (i = 0; i < MAX_X; i++) begin
          for (j = 0; j < MAX_Y; j++) begin
              for (k = 0; k < MAX_Z; k++) begin
                  // Calling decryption module for each element
                  Q[i][j][k] = decryption(C[i][j][k], K, F);
              end
          end
      end
      // Assigning decrypted image
      for (i = 0; i < MAX_X; i++) begin
          for (j = 0; j < MAX_Y; j++) begin
              for (k = 0; k < MAX_Z; k++) begin
                  decrypted_image[i][j][k] = Q[i][j][k];
              end
          end
      end
  end
endmodule

/*
C, K, and F are input ports representing the encrypted image, 128-bit key, and bit depth of the image, respectively.
decrypted_image is the output port representing the decrypted image.
Local variables Q and i are declared to handle the decryption process.
A loop iterates over each layer of the encrypted image (MAX_Z), decrypting them one by one using the decryption module.
Finally, the decrypted image is assigned to the output port.
*/