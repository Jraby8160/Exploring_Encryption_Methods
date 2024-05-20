module inverse_substitution(
  input [7:0] image [0:255][0:255], // Assuming 8-bit grayscale image
  input [7:0] M,
  input [7:0] N,
  input [7:0] F,
  output logic [7:0] substituted_image [0:255][0:255]
);

// Define variables
int i, j;
int m = 256; // Assuming image size of 256x256
int n = 256;

// Inverse Substitution step
always_comb begin
  for (i = 1; i < m; i++) begin
      substituted_image[i][0] = (image[i][0] - image[i-1][0]) % F;
      if (substituted_image[i][0] < 0) substituted_image[i][0] += F; // Handling negative modulo result
  end
  substituted_image[0][0] = (image[0][0] - N) % F;
  if (substituted_image[0][0] < 0) substituted_image[0][0] += F;
  for (j = 1; j < n; j++) begin
      substituted_image[0][j] = (image[0][j] - M) % F;
      if (substituted_image[0][j] < 0) substituted_image[0][j] += F;
  end
  for (i = n-1; i >= 2; i--) begin
      substituted_image[i][0] = (image[i][0] - image[i-1][0]) % F;
      if (substituted_image[i][0] < 0) substituted_image[i][0] += F;
  end
  for (j = n-1; j >= 2; j--) begin
      substituted_image[0][j] = (image[0][j] - image[0][j-1]) % F;
      if (substituted_image[0][j] < 0) substituted_image[0][j] += F;
  end
end

endmodule

/*
Inputs/Outputs:

Same as in the previous code.
Variable Definitions:

Same as in the previous code.
Inverse Substitution Process:

The inverse substitution process follows the logic of the 
provided MATLAB code but in reverse order:
First, subtract the key parameter N from the first row of 
the image and take the modulo F.
Then, subtract the key parameter M from the first column of 
the image and take the modulo F.
Next, iterate backward through the columns, subtracting each 
column from the previous one and taking the modulo F.
Finally, iterate backward through the rows, subtracting each 
row from the previous one and taking the modulo F.
Additionally, there's a check for negative modulo results, 
adjusting them to stay within the range of 0 to F-1.
*/