`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/12/21 11:50:35
// Design Name: 
// Module Name: Conv_layer_TB
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module Conv_layer_TB();

    //参数定义
    parameter map_width = 32;
    parameter map_height = 32;
    parameter map_channels = 1;
    parameter kernel_nums = 6;
    parameter kernel_width = 5;
    parameter kernel_height = 5;
    parameter kernel_channels = map_channels;
    parameter DATA_WIDTH = 16;
    //计算输出结果的尺寸
    localparam result_width = map_width - (kernel_width - 1);
    localparam result_height = map_height - (kernel_height - 1);
    localparam result_channels = kernel_nums;
    localparam result_single_channel_size = result_width * result_height;
    localparam kernel_size = kernel_channels * kernel_width * kernel_height;
    
    //定义输入输出的尺寸
    reg clk,reset;
    reg [0 : map_channels * map_width * map_height * DATA_WIDTH - 1] in_feature_maps_set;
    reg [0 : kernel_nums * kernel_channels * kernel_width * kernel_height * DATA_WIDTH - 1] kernels_set;
    wire [0 : result_channels * result_width * result_height * DATA_WIDTH - 1] out_feature_maps_set;
    
    localparam PERIOD = 100;
    always
        #(PERIOD / 2) clk = ~clk;  
        
    initial begin
        # 0;
        clk = 1'b0;
        reset = 1;
        in_feature_maps_set = 16384'hb6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b424_35d7_3c28_3b32_b1d6_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b105_3a2e_3e9a_402b_3de4_aec9_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b661_b09d_3aca_3f92_3f6b_3cec_37e0_b4c0_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b695_b424_3aca_4086_3e25_346a_b5c5_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b4f4_353a_4102_3fc6_349e_b695_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b62d_2e40_3fac_404b_3506_b55d_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_285a_3d47_40e8_37e0_b424_b695_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b661_36a7_404b_4004_b105_b661_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_a454_3cab_4099_3afe_b55d_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_3710_3f37_3f92_adf8_b661_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b48c_3b18_3ffa_3c0e_b6ca_b6ca_b6ca_b3df_b30f_b528_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_3059_3df1_3f5e_ac57_b695_b2a7_2d6f_38f5_39ab_3436_b3df_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_39ab_3f51_3d7b_b591_b55d_3a7c_405f_4129_4136_3fac_38db_b5f9_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_3d54_3f51_363f_b695_b1d6_404b_3c36_31fa_36db_3e66_3fb9_346a_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_af99_3e59_3f5e_349e_b4f4_3436_3e4c_2fe1_b55d_b4c0_38db_3ece_3d61_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_2e40_3ee8_3ec1_285a_b5c5_ac57_3506_b458_b6ca_b6ca_a454_3cab_4004_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_3129_3f0f_3e25_b2a7_b695_b591_b528_b661_b6ca_b6ca_b48c_3a7c_4065_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_3129_3f0f_3de4_b4f4_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b23e_3b66_4045_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_3192_3f1c_3de4_b4f4_b6ca_b6ca_b6ca_b6ca_b6ca_b695_3262_3d7b_3f02_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_2e40_3ec1_3e25_b105_b6ca_b6ca_b6ca_b6ca_b695_b1d6_3ae4_3ece_3aca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b30f_3d2d_3f37_38c1_b591_b695_b62d_b5c5_b3df_3a96_3f5e_3daf_b377_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b695_3673_3edb_4017_390f_b377_3059_38db_3edb_405f_3d06_ad28_b695_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b48c_3778_3e73_40ad_4079_4099_4093_3ece_39ab_ad28_b5f9_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b377_3192_3872_38a7_38a7_3858_3333_b1d6_b695_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca_b6ca;
        kernels_set = 2400'h3a09_37ea_3576_ab48_ae82_3514_ad5c_b815_b942_b764_3164_b42e_b8ac_bb05_b879_38cb_33f6_b4c5_b5b9_b6e5_3876_35c7_3296_33f0_2fec_b71a_3596_39b3_3807_b118_b799_3458_3a7f_3837_b4f3_b8b9_2fe3_3b67_3784_b877_b203_3481_3ab0_38a4_b4c6_b5f6_3385_37d6_387a_b06f_b575_b31a_3568_315b_381b_b8e1_bc1f_aebf_22b9_b28b_b6d7_ba4a_b846_b8d3_b30f_af72_af1d_b9fb_bcf7_b72f_36d1_37e6_9eb6_b42d_3277_2658_34cb_3580_34a3_303a_b6a8_b4e9_b672_b4eb_b92c_b36f_bbd6_bc08_bc2d_b965_b28f_b69c_a2b6_adba_b434_381c_36e3_3a27_38bb_36fd_3866_38db_37aa_3635_38dc_361c_b3bd_b662_b369_2d80_31bc_b582_bbc6_bb25_311a_3698_b176_ba75_b847_3415_353d_b31a_b6db_b61f_2d22_b53c_b333_b192_a95f_30a7_326f_2d65_3007_3af2_3a6f_39f5_3a32_3891_3c45_395d_3a3f_3bd3_3234_31e1_ac87_3321_2c4b_b076_b132_b5eb;
        
        # PERIOD;
        reset = 0;
        
        #(300000*PERIOD);
	    $display(out_feature_maps_set);
	    $stop;
    end 
    
    Conv_layer #(.map_width(map_width), .map_height(map_height), .map_channels(map_channels), .kernel_nums(kernel_nums), .kernel_width(kernel_width), .kernel_height(kernel_height), .kernel_channels(kernel_channels), .DATA_WIDTH(DATA_WIDTH))
    conv_layer_agent (.clk(clk), .reset(reset), .in_feature_maps_set(in_feature_maps_set), .kernels_set(kernels_set), .out_feature_maps_set(out_feature_maps_set));

endmodule
