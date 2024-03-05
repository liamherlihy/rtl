// Verilog wrapper for the pwm_driver SystemVerilog module
module pwm_driver_wrapper #(
    parameter PWM_SIZE = 32  // Default parameter value, can be overridden at instantiation
)(
    input wire clk,
    input wire rst,
    input wire [PWM_SIZE-1:0] pwm_period,
    input wire [PWM_SIZE-1:0] pwm_duty,
    output wire pwm_out
);

    // Instantiate the SystemVerilog pwm_driver module, passing the PWM_SIZE parameter
    pwm_driver #(
        .PWM_SIZE(PWM_SIZE)
    ) pwm_driver_inst (
        .clk(clk),
        .rst(rst),
        .pwm_period(pwm_period),
        .pwm_duty(pwm_duty),
        .pwm_out(pwm_out)
    );

endmodule
