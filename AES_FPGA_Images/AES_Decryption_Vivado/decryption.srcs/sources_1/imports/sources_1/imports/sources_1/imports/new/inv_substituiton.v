module inv_substitution(
 mixcol_data,
inv_substituted_data
);
input [0:127] mixcol_data;
output [0:127] inv_substituted_data;

aes_invS_box invaes01( mixcol_data[000:007] , inv_substituted_data[000:007] );
aes_invS_box invaes02( mixcol_data[008:015] , inv_substituted_data[008:015] );
aes_invS_box invaes03( mixcol_data[016:023] , inv_substituted_data[016:023] );
aes_invS_box invaes04( mixcol_data[024:031] , inv_substituted_data[024:031] );
aes_invS_box invaes05( mixcol_data[032:039] , inv_substituted_data[032:039] );
aes_invS_box invaes06( mixcol_data[040:047] , inv_substituted_data[040:047] );
aes_invS_box invaes07( mixcol_data[048:055] , inv_substituted_data[048:055] );
aes_invS_box invaes08( mixcol_data[056:063] , inv_substituted_data[056:063] );
aes_invS_box invaes09( mixcol_data[064:071] , inv_substituted_data[064:071] );
aes_invS_box invaes10( mixcol_data[072:079] , inv_substituted_data[072:079] );
aes_invS_box invaes11( mixcol_data[080: 87] , inv_substituted_data[080:087] );
aes_invS_box invaes12( mixcol_data[088: 95] , inv_substituted_data[088:095] );
aes_invS_box invaes13( mixcol_data[096:103] , inv_substituted_data[096:103] );
aes_invS_box invaes14( mixcol_data[104:111] , inv_substituted_data[104:111] );
aes_invS_box invaes15( mixcol_data[112:119] , inv_substituted_data[112:119] );
aes_invS_box invaes16( mixcol_data[120:127] , inv_substituted_data[120:127] );
endmodule
