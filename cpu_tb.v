module cpu_tb;
    reg clk;

    wire [7:0] prog_addr, prog_data;
    wire [7:0] data_cmd, data_addr, data_line;
    
    datamemory ram(clk, data_cmd, data_addr, data_line);
    programmemory kode(prog_addr, prog_data);
    cpu chip(clk, prog_data, data_addr, prog_addr, data_cmd, data_line);

    always
    begin
        clk = !clk;
    end

    initial
    begin
        #0 clk = 0;
    end
endmodule