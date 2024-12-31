`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/12/24 14:47:37
// Design Name: 
// Module Name: LeNet
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


module LeNet(
    clk,
    reset,
    in_images_set,
    C1_kernels_set,
    C3_kernels_set,
    L5_weights,
    L5_bias,
    L6_weights,
    L6_bias,
    L7_weights,
    L7_bias,
    likelihood_predict
);
    //输入用到的参数
    parameter DATA_WIDTH = 16;
    parameter image_width = 32;
    parameter image_height = 32;
    parameter image_channels = 1;
    //C1卷积层参数
    localparam C1_map_width = image_width;
    localparam C1_map_height = image_height;
    localparam C1_map_channels = image_channels;
    parameter C1_kernel_nums = 6;
    parameter C1_kernel_width = 5;
    parameter C1_kernel_height = 5;
    localparam C1_kernel_channels = C1_map_channels;
    localparam C1_result_width = C1_map_width - (C1_kernel_width - 1);
    localparam C1_result_height = C1_map_height - (C1_kernel_height - 1);
    localparam C1_result_channels = C1_kernel_nums;
    //Sigmoid层参数
    localparam C1_sigmoid_nums = C1_result_width * C1_result_height * C1_result_channels;
    //S2平均池化层参数
    localparam S2_map_width = C1_result_width;
    localparam S2_map_height = C1_result_height;
    localparam S2_map_channels = C1_result_channels;
    localparam S2_result_width = S2_map_width / 2;
    localparam S2_result_height = S2_map_height / 2;
    localparam S2_result_channels = S2_map_channels;
    //C3卷积层参数
    localparam C3_map_width = S2_result_width;
    localparam C3_map_height = S2_result_height;
    localparam C3_map_channels = S2_result_channels;
    localparam C3_kernel_nums = 16;
    localparam C3_kernel_width = 5;
    localparam C3_kernel_height = 5;
    localparam C3_kernel_channels = C3_map_channels;
    localparam C3_result_width = C3_map_width - (C3_kernel_width - 1);
    localparam C3_result_height = C3_map_height - (C3_kernel_height - 1);
    localparam C3_result_channels = C3_kernel_nums;
    //Sigmoid层参数
    localparam C3_sigmoid_nums = C3_result_width * C3_result_height * C3_result_channels;
    //S4池化层参数
    localparam S4_map_width = C3_result_width;
    localparam S4_map_height = C3_result_height;
    localparam S4_map_channels = C3_result_channels;
    localparam S4_result_width = S4_map_width / 2;
    localparam S4_result_height = S4_map_height / 2;
    localparam S4_result_channels = S4_map_channels;
    //L5全连接层参数
    localparam L5_in_features_dim = S4_map_channels;
    parameter L5_out_features_dim = 120;
    //Sigmoid层参数
    localparam L5_sigmoid_nums = L5_out_features_dim;
    //L6全连接层参数
    localparam L6_in_features_dim = L5_out_features_dim;
    parameter L6_out_features_dim = 84;
    //Sigmoid层参数
    localparam L6_sigmoid_nums = L6_out_features_dim;
    //L7全连接层参数
    localparam L7_in_features_dim = L6_out_features_dim;
    parameter L7_out_features_dim = 10;
    //Softmax层参数
    localparam Softmax_nums = L7_out_features_dim;
    
    
    input clk,reset;
    input in_images_set;
    input C1_kernels_set;
    input C3_kernels_set;
    input L5_weights;
    input L5_bias;
    input L6_weights;
    input L6_bias;
    input L7_weights;
    input L7_bias;
    output likelihood_predict;
    
    wire [0 : image_width * image_height * image_channels * DATA_WIDTH - 1] in_images_set;
    wire [0 : C1_kernel_nums * C1_kernel_width * C1_kernel_height * C1_kernel_channels * DATA_WIDTH - 1] C1_kernels_set;
    wire [0 : C3_kernel_nums * C3_kernel_width * C3_kernel_height * C3_kernel_channels * DATA_WIDTH - 1] C3_kernels_set;
    wire [0 : L5_in_features_dim * L5_out_features_dim * DATA_WIDTH - 1] L5_weights;
    wire [0 : L5_out_features_dim * DATA_WIDTH - 1] L5_bias;
    wire [0 : L6_in_features_dim * L6_out_features_dim * DATA_WIDTH - 1] L6_weights;
    wire [0 : L6_out_features_dim * DATA_WIDTH - 1] L6_bias;
    wire [0 : L7_in_features_dim * L7_out_features_dim * DATA_WIDTH - 1] L7_weights;
    wire [0 : L7_out_features_dim * DATA_WIDTH - 1] L7_bias;
    wire [0 : Softmax_nums * DATA_WIDTH - 1] likelihood_predict;
    
    wire [0 : C1_result_width * C1_result_height * C1_result_channels * DATA_WIDTH - 1] C1_conv_output;
    wire [0 : C1_result_width * C1_result_height * C1_result_channels * DATA_WIDTH - 1] C1_sigmoid_output;
    wire [0 : S2_result_width * S2_result_height * S2_result_channels * DATA_WIDTH - 1] S2_pooling_output;
    wire [0 : C3_result_width * C3_result_height * C3_result_channels * DATA_WIDTH - 1] C3_conv_output;
    wire [0 : C3_result_width * C3_result_height * C3_result_channels * DATA_WIDTH - 1] C3_sigmoid_output;
    wire [0 : S4_result_width * S4_result_height * S4_result_channels * DATA_WIDTH - 1] S4_pooling_output;
    wire [0 : L5_out_features_dim * DATA_WIDTH - 1] L5_linear_output;
    wire [0 : L5_out_features_dim * DATA_WIDTH - 1] L5_sigmoid_output;
    wire [0 : L6_out_features_dim * DATA_WIDTH - 1] L6_linear_output;
    wire [0 : L6_out_features_dim * DATA_WIDTH - 1] L6_sigmoid_output;
    wire [0 : L7_out_features_dim * DATA_WIDTH - 1] L7_linear_output;
    
    
    //C1卷积层
    Conv_layer #(
        .map_width(C1_map_width),
        .map_height(C1_map_height),
        .map_channels(C1_map_channels),
        .kernel_nums(C1_kernel_nums),
        .kernel_width(C1_kernel_width),
        .kernel_height(C1_kernel_height),
        .kernel_channels(C1_kernel_channels),
        .DATA_WIDTH(DATA_WIDTH)
    )
    C1_conv_layer (
        .clk(clk),
        .reset(reset),
        .in_feature_maps_set(in_images_set),
        .kernels_set(C1_kernels_set),
        .out_feature_maps_set(C1_conv_output)
    );
    
    //Sigmoid层
    Sigmoid_layer #(
        .nums(C1_sigmoid_nums),
        .DATA_WIDTH(DATA_WIDTH)
    )
    C1_sigmoid_layer (
        .clk(clk),
        .reset(reset),
        .vector_x(C1_conv_output),
        .vector_sigmoid_x(C1_conv_sigmoid_output)
    );
    
    //S2池化层
    AveragePooling_layer #(
        .map_width(S2_map_width),
        .map_height(S2_map_height),
        .map_channels(S2_map_channels),
        .DATA_WIDTH(DATA_WIDTH)
    )
    S2_average_pooling_layer (
        .clk(clk),
        .reset(reset),
        .in_feature_maps_set(C1_conv_sigmoid_output),
        .out_feature_map(S2_pooling_output)
    );
    
    //C3卷积层
    Conv_layer #(
        .map_width(C3_map_width),
        .map_height(C3_map_height),
        .map_channels(C3_map_channels),
        .kernel_nums(C3_kernel_nums),
        .kernel_width(C3_kernel_width),
        .kernel_height(C3_kernel_height),
        .kernel_channels(C3_kernel_channels),
        .DATA_WIDTH(DATA_WIDTH)
    )
    C3_conv_layer (
        .clk(clk),
        .reset(reset),
        .in_feature_maps_set(S2_pooling_output),
        .kernels_set(C3_kernels_set),
        .out_feature_maps_set(C3_conv_output)
    );
    
    //Sigmoid层
    Sigmoid_layer #(
        .nums(C3_sigmoid_nums),
        .DATA_WIDTH(DATA_WIDTH)
    )
    C3_sigmoid_layer (
        .clk(clk),
        .reset(reset),
        .vector_x(C3_conv_output),
        .vector_sigmoid_x(C3_conv_sigmoid_output)
    );
    
    //S4池化层
    AveragePooling_layer #(
        .map_width(S4_map_width),
        .map_height(S4_map_height),
        .map_channels(S4_map_channels),
        .DATA_WIDTH(DATA_WIDTH)
    )
    S4_average_pooling_layer (
        .clk(clk),
        .reset(reset),
        .in_feature_maps_set(C3_conv_sigmoid_output),
        .out_feature_map(S4_pooling_output)
    );
    
    //L5全连接层
    Linear_layer #(
        .in_features_dim(L5_in_features_dim),
        .out_features_dim(L5_out_features_dim),
        .DATA_WIDTH(DATA_WIDTH)
    )
    L5_linear_layer (
        .clk(clk),
        .reset(reset),
        .weights(L5_weights),
        .bias(L5_bias),
        .in_features(S4_pooling_output),
        .out_features(L5_linear_output)
    );
    
    //Sigmoid层
    Sigmoid_layer #(
        .nums(L5_sigmoid_nums),
        .DATA_WIDTH(DATA_WIDTH)
    )
    L5_sigmoid_layer (
        .clk(clk),
        .reset(reset),
        .vector_x(L5_linear_output),
        .vector_sigmoid_x(L5_sigmoid_output)
    );
    
    //L6全连接层
    Linear_layer #(
        .in_features_dim(L6_in_features_dim),
        .out_features_dim(L6_out_features_dim),
        .DATA_WIDTH(DATA_WIDTH)
    )
    L6_linear_layer (
        .clk(clk),
        .reset(reset),
        .weights(L6_weights),
        .bias(L6_bias),
        .in_features(L5_sigmoid_output),
        .out_features(L6_linear_output)
    );
    
    //Sigmoid层
    Sigmoid_layer #(
        .nums(L6_sigmoid_nums),
        .DATA_WIDTH(DATA_WIDTH)
    )
    L6_sigmoid_layer (
        .clk(clk),
        .reset(reset),
        .vector_x(L6_linear_output),
        .vector_sigmoid_x(L6_sigmoid_output)
    );
    
    //L7全连接层
    Linear_layer #(
        .in_features_dim(L7_in_features_dim),
        .out_features_dim(L7_out_features_dim),
        .DATA_WIDTH(DATA_WIDTH)
    )
    L7_linear_layer (
        .clk(clk),
        .reset(reset),
        .weights(L7_weights),
        .bias(L7_bias),
        .in_features(L6_sigmoid_output),
        .out_features(L7_linear_output)
    );
    
    //Softmax层
    Softmax_layer #(
        .nums(Softmax_nums),
        .DATA_WIDTH(DATA_WIDTH)
    )
    S_softmax_layer (
        .clk(clk),
        .reset(reset),
        .vector_x(L7_linear_output),
        .vector_softmax_x(likelihood_predict)
    );
    
    

endmodule
