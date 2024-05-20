
module encryption_3d (
  input logic [7:0] P [][],
  input logic [127:0] K,
  input logic [7:0] F,
  output logic [7:0] encrypted_image [][]
);

  // Parameters
  parameter MAX_X = $size(P, 0);
  parameter MAX_Y = $size(P, 1);
  parameter MAX_Z = $size(P, 2);

  // Local variables
  logic [7:0] C [MAX_X][MAX_Y][MAX_Z];
  integer i, j, k;
  logic [7:0] K_param, F_param;

  // Extracting parameters from the key
  always_comb begin
    K_param = K[15:0]; // Assuming K_param holds the 16 least significant bits of K
    F_param = F;
  end

  // Instantiate encryption module
  genvar idx;
  generate
    for (idx = 0; idx < MAX_X; idx++) begin : ENC_INST
      encryption enc_inst (
        .image(P[idx]),
        .K(K_param),
        .F(F_param),
        .image_encrypted(C[idx])
      );
    end
  endgenerate

  // Assigning encrypted image
  always_comb begin
    for (i = 0; i < MAX_X; i++) begin
      for (j = 0; j < MAX_Y; j++) begin
        for (k = 0; k < MAX_Z; k++) begin
          encrypted_image[i][j][k] = C[i][j][k];
        end
      end
    end
  end
endmodule



/*
P, K, and F are input ports representing the PlainImage, 128-bit key, and bit depth of the image, respectively.
encrypted_image is the output port representing the encrypted image.
Local variables C and i are declared to handle the encryption process.
A loop iterates over each layer of the image (MAX_Z), encrypting them one by one using the encryption module.
Finally, the encrypted image is assigned to the output port.
*/