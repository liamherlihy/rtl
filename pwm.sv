module pwm_driver #(
    parameter PWM_SIZE = 16
) (
    input logic clk,
    input logic rst,
    input logic [PWM_SIZE-1:0]pwm_period,
    input logic [PWM_SIZE-1:0]pwm_duty,
    output logic pwm_out
);

logic [PWM_SIZE-1:0] period_counter;
logic [PWM_SIZE-1:0] duty_counter;
logic done = 0;
logic out = 0;

always_ff @( posedge clk ) begin : PWM
    if (rst | done) begin    
        {done,period_counter} <= pwm_period-1;
        {out, duty_counter} <= pwm_duty-1;
    end     
    else begin
        if (out|done) begin
            duty_counter <= duty_counter-1;
        end      
        else begin
            {out, duty_counter} <= duty_counter-1;  
        end           
       period_counter <= period_counter-1;
       done <= ~(|(period_counter-1));
    end
    //pwm_out <= rst ? 1'b0 : ~out;
end
assign pwm_out = rst ? 1'b0 : ~out;
endmodule