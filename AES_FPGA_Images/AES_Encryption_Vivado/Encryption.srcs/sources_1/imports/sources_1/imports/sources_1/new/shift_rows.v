`timescale 1ns / 1ps


module shift_rows(
sub_data,
data_in
);
input  [0:127] sub_data;
output  [0:127] data_in;

assign data_in[ 0   : 7   ] = sub_data[ 0   : 7   ];
assign data_in[ 8   : 15  ] = sub_data[ 104 : 111 ];
assign data_in[ 16  : 23  ] = sub_data[ 80  : 87  ];
assign data_in[ 24  : 31  ] = sub_data[ 53  : 63  ];

assign data_in[ 32  : 39  ] = sub_data[ 32  : 39  ];
assign data_in[ 40  : 47  ] = sub_data[ 8   : 15  ];
assign data_in[ 48  : 55  ] = sub_data[ 112 : 119 ];
assign data_in[ 56  : 63  ] = sub_data[ 88  : 95  ];

assign data_in[ 64  : 71  ] = sub_data[ 64  : 71  ];
assign data_in[ 72  : 79  ] = sub_data[ 40  : 47  ];
assign data_in[ 80  : 87  ] = sub_data[ 16  : 23  ];
assign data_in[ 88  : 95  ] = sub_data[ 120 : 127 ];

assign data_in[ 96  : 103 ] = sub_data[ 96  : 103 ];
assign data_in[ 104 : 111 ] = sub_data[ 72  : 79  ];
assign data_in[ 112 : 119 ] = sub_data[ 48  : 55  ];
assign data_in[ 120 : 127 ] = sub_data[ 24  : 31  ];

endmodule
