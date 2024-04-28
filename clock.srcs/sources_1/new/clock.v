`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 26.04.2024 14:09:47
// Design Name: 
// Module Name: clock
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


`timescale 1ns / 1ps


module seven_segment_display (
    input [3:0] display_input, 
    output reg [6:0] segment_output
);

always @(*) begin
    case (display_input)
        4'b0000: segment_output = 7'b1000000; 
        4'b0001: segment_output = 7'b1111001; 
        4'b0010: segment_output = 7'b0100100; 
        4'b0011: segment_output = 7'b0110000; 
        4'b0100: segment_output = 7'b0011001; 
        4'b0101: segment_output = 7'b0010010; 
        4'b0110: segment_output = 7'b0000010;
        4'b0111: segment_output = 7'b1111000; 
        4'b1000: segment_output = 7'b0000000; 
        4'b1001: segment_output = 7'b0010000; 
        default: segment_output = 7'b1111111;  
    endcase
end
endmodule


module DigitalClock(
    input clk,       
    input reset,     
    input start_stop, 
    input reset_stopwatch,
    input [1:0] mode_sel, 
    input set_hour,
    input set_min,
    input set,
    
    output reg [6:0] seg_data, 
    output reg [3:0] digit_sel,   
    output reg [5:0] blink,
    output reg [1:0] blue,
    output reg [1:0] red,
    output reg [1:0] green
);

// Define custom clock with 1 hz signal
reg [26:0] count=0;
reg [26:0] counting=0;
reg divclk = 1'b1;
reg co = 1'b0;


// CLK DIV 
always@(posedge clk)
begin
    count = count+1;
    if(counting==26'b00000000111011100110101100)
    begin
        divclk=~divclk;
        counting=0;
    end
    else
    begin
        counting=counting+1;
    end
    if(count == 27'b011111111000000000100000000)    //slow
    begin
        co = ~co;
        count = 0;
    end
end

reg [5:0] counter = 0;     
reg [5:0] min = 0;
reg [4:0] hour = 0;
wire [6:0] hour_tens;
wire [6:0] hour_ones;
wire [6:0] min_tens;
wire [6:0] min_ones;
wire [6:0] sec_tens;
wire [6:0] sec_ones;

reg [5:0] stpwthsec = 0;
reg [5:0] stpwthmin = 0;   
wire [6:0] stpmin_tens;
wire [6:0] stpmin_ones;
wire [6:0] stpsec_tens;
wire [6:0] stpsec_ones;

      
reg [5:0] tmin = 0;
reg [4:0] thour = 0; 
reg [5:0] tsec = 0;
wire [6:0] thour_tens;
wire [6:0] thour_ones;
wire [6:0] tmin_tens;
wire [6:0] tmin_ones;
wire [6:0] tsec_tens;
wire [6:0] tsec_ones;

reg [5:0] amin = 0;
reg [4:0] ahour = 0;
reg [3:0] litdown = 0;
reg litup = 0; 
wire [6:0] ahour_tens;
wire [6:0] ahour_ones;
wire [6:0] amin_tens;
wire [6:0] amin_ones;


reg [2:0] alm_sel;
reg [1:0] dis_sel;
reg [1:0] state;        
reg [1:0] prev_mode_sel; 

initial begin
    state = 2'b00; 
    dis_sel = 2'b00;
    alm_sel = 3'b000;
    prev_mode_sel = mode_sel;
end


// Clock divider to generate 1 Hz signal
always @(posedge co)
begin
    if (reset)
    begin
        counter <= 0;
        min <= 0;
        hour <= 0;
    end
    else if(set)
    begin
        if (state == 2'b00)
        begin
            if(set_hour)
            begin
                if(hour == 5'b10111)
                begin
                    hour = 0;
                end
                else
                begin
                    hour = hour + 1;
                end
            end
            else if(set_min)
            begin
                if(min == 6'b111011)
                begin
                    min = 0;
                    if(hour == 5'b10111)
                    begin
                        hour = 0;
                    end
                    else
                    begin
                        hour = hour + 1;
                    end
                end
                else
                begin
                    min = min + 1;
                end
            end
        end
    end
    else if (counter == 6'b111011) // Assuming 1 Hz clock
    begin
        counter <= 0;
        if (min == 6'b111011)
        begin
            min <= 0;
            if(hour == 5'b10111)
            begin
                hour <= 0;
            end
            else
            begin
                hour <= hour + 1;
            end
        end
        else
        begin
            min <= min + 1;
        end
    end
    else
    begin
        counter <= counter + 1;
    end
end

// alarm 
always @(posedge co)
begin
    if(min == amin)
    begin
        if(hour == ahour)
        begin
            case(alm_sel)
            3'b000:
            begin
                alm_sel <= 3'b001;
                blue <= 2'b01;
                green <= 2'b10;
                red <= 2'b00;
            end
            3'b001:
            begin
                alm_sel <= 3'b010;
                blue <= 2'b00;
                green <= 2'b00;
                red <= 2'b00;
            end
            3'b010:
            begin
                alm_sel <= 3'b011;
                blue <= 2'b00;
                green <= 2'b01;
                red <= 2'b10;
            end
            3'b011:
            begin
                alm_sel <= 3'b100;
                blue <= 2'b00;
                green <= 2'b00;
                red <= 2'b00;
            end
            3'b100:
            begin
                alm_sel <= 3'b101;
                blue <= 2'b10;
                green <= 2'b00;
                red <= 2'b01;
            end
            3'b101:
            begin
                alm_sel <= 3'b000;
                blue <= 2'b00;
                green <= 2'b00;
                red <= 2'b00;
            end
            endcase
        end
    end
    else
    begin
        blue <= 2'b00;
        green <= 2'b00;
        red <= 2'b00;
    end  
end

// stopwatch and timer.
always @(posedge co)
begin
    if (reset)
    begin
        state <= 2'b00; 
        stpwthmin <= 0;
        stpwthsec <= 0; 
        tmin <= 0;
        thour <= 0;
        tsec <= 0;
        amin <= 0;
        ahour <= 0;
    end
    else if (mode_sel != prev_mode_sel) 
    begin
        prev_mode_sel <= mode_sel;
        if (mode_sel == 2'b00) 
        begin
            state <= 2'b00;
            blink = 6'b000000;
        end
        else if (mode_sel == 2'b01) 
            state <= 2'b01;
        else if (mode_sel == 2'b10) 
            state <= 2'b10;
        else if (mode_sel == 2'b11)
            state <= 2'b11;
    end
    else if (state == 2'b01) //  stopwatch mode
    begin
        blink = 6'b000000;
        if(~reset_stopwatch)
        begin
            if(start_stop == 1)
            begin
                if(stpwthsec == 6'b111011)
                begin
                    stpwthsec = 0;
                    if(stpwthmin == 6'b111011)
                    begin
                        stpwthmin = 0;
                    end
                    else
                    begin
                        stpwthmin = stpwthmin + 1;
                    end
                end
                else
                begin
                    stpwthsec = stpwthsec + 1;
                end
            end
        end
        else
        begin
            stpwthsec = 0;
            stpwthmin = 0;
        end
    end
    else if (state == 2'b10) // Timer mode
    begin
        if(set)
        begin
            blink = 6'b000000;
            if(set_hour)
            begin
                if(thour == 5'b10111)
                begin
                    thour = 0;
                end
                else
                begin
                    thour = thour + 1;
                end
            end
            else if(set_min)
            begin
                if(tmin == 6'b111011)
                begin
                    tmin = 0;
                    if(thour == 5'b10111)
                    begin
                        thour = 0;
                    end
                    else
                    begin
                    thour = thour + 1;
                    end
                end
                else
                begin
                    tmin = tmin + 1;
                end
            end
        end
        else
        begin
            if(tsec == 6'b000000)
            begin
                if(tmin != 6'b000000)
                begin
                    tsec = 6'b111011;
                    tmin = tmin - 1;
                end
                else
                begin
                    if(thour != 5'b00000)
                    begin
                        thour = thour - 1;
                        tmin = 6'b111011;
                        tsec = 6'b111011;
                    end
                    else
                    begin
                        blink = ~blink;
                    end
                end
            end
            else
            begin
                tsec = tsec - 1;
            end
        end
    end
    else if (state == 2'b11) // alarm
    begin
        blink = 6'b000000;
        if(set_hour)
        begin
            if(ahour == 5'b10111)
            begin
                ahour = 0;
            end
            else
            begin
                ahour = ahour + 1;
            end
        end
        else if(set_min)
        begin
            if(amin == 6'b111011)
            begin
                amin = 0;
                if(ahour == 5'b10111)
                begin
                    ahour = 0;
                end
                else
                begin
                ahour = ahour + 1;
                end
            end
            else
            begin
                amin = amin + 1;
            end
        end
    end
end


seven_segment_display ssd1(hour / 10, hour_tens);
seven_segment_display ssd2(hour % 10, hour_ones);
seven_segment_display ssd3(min / 10, min_tens);
seven_segment_display ssd4(min % 10, min_ones);
seven_segment_display ssd5(stpwthmin / 10, stpmin_tens);
seven_segment_display ssd6(stpwthmin % 10, stpmin_ones);
seven_segment_display ssd7(stpwthsec / 10, stpsec_tens);
seven_segment_display ssd8(stpwthsec % 10, stpsec_ones);
seven_segment_display ssd9(thour / 10, thour_tens);
seven_segment_display ssd10(thour % 10, thour_ones);
seven_segment_display ssd11(tmin / 10, tmin_tens);
seven_segment_display ssd12(tmin % 10, tmin_ones);
seven_segment_display ssd13((tsec) / 10, tsec_tens);
seven_segment_display ssd14((tsec) % 10, tsec_ones);
seven_segment_display ssd15(ahour / 10, ahour_tens);
seven_segment_display ssd16(ahour % 10, ahour_ones);
seven_segment_display ssd17(amin / 10, amin_tens);
seven_segment_display ssd18(amin % 10, amin_ones);
    

always @(posedge divclk)
begin
    case(state)
    2'b00:
    begin
        case(dis_sel)
        2'b00:
        begin
            dis_sel <= 2'b01;
            digit_sel <= 4'b1110;
            seg_data <= min_ones;
        end
        2'b01:
        begin
            dis_sel <= 2'b10;
            digit_sel <= 4'b1101;
            seg_data <= min_tens;
        end
        2'b10:
        begin
            dis_sel <= 2'b11;
            digit_sel <= 4'b1011;
            seg_data <= hour_ones;
        end
        2'b11:
        begin
            dis_sel <= 2'b00;
            digit_sel <= 4'b0111;
            seg_data <= hour_tens;
        end
        endcase
    end
    2'b01:
    begin
        case(dis_sel)
        2'b00:
        begin
            dis_sel <= 2'b01;
            digit_sel <= 4'b1110;
            seg_data <= stpsec_ones;
        end
        2'b01:
        begin
            dis_sel <= 2'b10;
            digit_sel <= 4'b1101;
            seg_data <= stpsec_tens;
        end
        2'b10:
        begin
            dis_sel <= 2'b11;
            digit_sel <= 4'b1011;
            seg_data <= stpmin_ones;
        end
        2'b11:
        begin
            dis_sel <= 2'b00;
            digit_sel <= 4'b0111;
            seg_data <= stpmin_tens;
        end
        endcase
    end
    2'b10:
    begin
        if(thour != 5'b00000)
        begin
            case(dis_sel)
            2'b00:
            begin
                dis_sel <= 2'b01;
                digit_sel <= 4'b1110;
                seg_data <= tmin_ones;
            end
            2'b01:
            begin
                dis_sel <= 2'b10;
                digit_sel <= 4'b1101;
                seg_data <= tmin_tens;
            end
            2'b10:
            begin
                dis_sel <= 2'b11;
                digit_sel <= 4'b1011;
                seg_data <= thour_ones;
            end
            2'b11:
            begin
                dis_sel <= 2'b00;
                digit_sel <= 4'b0111;
                seg_data <= thour_tens;
            end
            endcase
        end
        else
        begin
            case(dis_sel)
            2'b00:
            begin
                dis_sel <= 2'b01;
                digit_sel <= 4'b1110;
                seg_data <= tsec_ones;
            end
            2'b01:
            begin
                dis_sel <= 2'b10;
                digit_sel <= 4'b1101;
                seg_data <= tsec_tens;
            end
            2'b10:
            begin
                dis_sel <= 2'b11;
                digit_sel <= 4'b1011;
                seg_data <= tmin_ones;
            end
            2'b11:
            begin
                dis_sel <= 2'b00;
                digit_sel <= 4'b0111;
                seg_data <= tmin_tens;
            end
            endcase
        end
    end
    2'b11:
    begin
        case(dis_sel)
        2'b00:
        begin
            dis_sel <= 2'b01;
            digit_sel <= 4'b1110;
            seg_data <= amin_ones;
        end
        2'b01:
        begin
            dis_sel <= 2'b10;
            digit_sel <= 4'b1101;
            seg_data <= amin_tens;
        end
        2'b10:
        begin
            dis_sel <= 2'b11;
            digit_sel <= 4'b1011;
            seg_data <= ahour_ones;
        end
        2'b11:
        begin
            dis_sel <= 2'b00;
            digit_sel <= 4'b0111;
            seg_data <= ahour_tens;
        end
        endcase
    end
    endcase    
end

endmodule
