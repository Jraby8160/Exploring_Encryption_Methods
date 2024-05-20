module substitution(
 data,
substituted_data
);
input [0:127] data;
output [0:127] substituted_data;

aes_S_box aes01( data[000:007] , substituted_data[000:007] );
aes_S_box aes02( data[008:015] , substituted_data[008:015] );
aes_S_box aes03( data[016:023] , substituted_data[016:023] );
aes_S_box aes04( data[024:031] , substituted_data[024:031] );
aes_S_box aes05( data[032:039] , substituted_data[032:039] );
aes_S_box aes06( data[040:047] , substituted_data[040:047] );
aes_S_box aes07( data[048:055] , substituted_data[048:055] );
aes_S_box aes08( data[056:063] , substituted_data[056:063] );
aes_S_box aes09( data[064:071] , substituted_data[064:071] );
aes_S_box aes10( data[072:079] , substituted_data[072:079] );
aes_S_box aes11( data[080: 87] , substituted_data[080:087] );
aes_S_box aes12( data[088: 95] , substituted_data[088:095] );
aes_S_box aes13( data[096:103] , substituted_data[096:103] );
aes_S_box aes14( data[104:111] , substituted_data[104:111] );
aes_S_box aes15( data[112:119] , substituted_data[112:119] );
aes_S_box aes16( data[120:127] , substituted_data[120:127] );
endmodule
