module cpu_tb;
    reg clk;

    wire [7:0] prog_addr, prog_data;
    wire [7:0] data_cmd, data_addr, data_line;
    
    datamemory ram(clk, cmd_in, addr_in, data);
    programmemory code(addr_in, data_out);
    harvardcpu chip(clk, prog_data, data_addr, prog_addr, data_cmd, data_line);

    always
    begin
        clk = !clk;
    end

    initial
    begin
        #0 clk = 0;
    end
endmodule