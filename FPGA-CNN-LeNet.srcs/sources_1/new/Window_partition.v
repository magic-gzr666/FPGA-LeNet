`timescale 1ns / 1ps

module Window_partition(
    clk,
    reset,
    feature_map,
    feature_map_window
);

    //定义参数
    parameter map_width = 28;
    parameter map_height = 28;
    parameter DATA_WIDTH = 16;
    parameter window_width = 3;
    parameter window_height = 3;
    localparam delta_counter = 3;

    //定义接口类型
    input clk,reset;
    input feature_map;
    output feature_map_window;
    
    //定义接口尺寸
    wire [0 : map_width * map_height * DATA_WIDTH - 1] feature_map;
    reg [0 : window_width * window_height * DATA_WIDTH - 1] feature_map_window;
    
    integer col_index;
    integer row_index;
    integer col = map_height - (window_height - 1);
    integer row = map_width - (window_width - 1);
    integer flag;
    integer i,j;
    
    //提取窗口至tmp
//    always @(row_index or col_index) begin
//        for(i = 0; i < window_height; i = i+1)
//        begin
//            for(j = 0; j < window_width; j = j+1)
//            begin
//                feature_map_window[(i * window_width + j) * DATA_WIDTH +: DATA_WIDTH] = feature_map[((i+col_index)*map_width + (j+row_index)) * DATA_WIDTH +: DATA_WIDTH];
//            end
//        end           
//    end
    
    
    integer counter;
    
    //通过改变col_index和row_index来更新窗口位置
    always @ (posedge clk or posedge reset) begin
        if(reset == 1) begin
            counter = 0;
            col_index = 0;
            row_index = 0;
            flag = 0;
        end else begin
            counter = counter + 1;
        end
        if(flag) begin
            ;
        end else if(counter > window_width * window_height + delta_counter) begin
            counter = 0;
            row_index = row_index + 1;
            if(row_index >= row) begin
                col_index = col_index + 1;
                row_index = 0;
            end
            if(col_index >= col) begin
                flag = 1;
                row_index = row - 1;
                col_index = col_index-1;
            end
        end
        
        for(i = 0; i < window_height; i = i+1)
        begin
            for(j = 0; j < window_width; j = j+1)
            begin
                feature_map_window[(i * window_width + j) * DATA_WIDTH +: DATA_WIDTH] = feature_map[((i+col_index)*map_width + (j+row_index)) * DATA_WIDTH +: DATA_WIDTH];
            end
        end
        
    end
    

endmodule
