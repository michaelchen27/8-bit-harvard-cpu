module cpu_tb();
    reg clk;
	 reg rst;

    wire [7:0] pmi_addr, pmi_data;
    wire [7:0] mi_cmd, mi_addr, mi_data;
    
	harvardcpu cpu(
			clk, rst,
			pmi_data, pmi_addr,
			mi_cmd, mi_addr, mi_data
	);

    always #5 clk = ~clk;

    initial
    begin
        #0 	clk = 0;
				rst = 1;
		  #1 	rst = 0;
    end
endmodule