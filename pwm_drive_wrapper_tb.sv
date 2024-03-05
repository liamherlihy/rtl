`timescale 1ns / 1ps
module pwm_driver_tb;

parameter PWM_SIZE = 16;

// Testbench Signals
logic clk;
logic rst;
logic [PWM_SIZE-1:0] pwm_period;
logic [PWM_SIZE-1:0] pwm_duty;
logic pwm_out;

// Instantiate the PWM Driver
pwm_driver #(.PWM_SIZE(PWM_SIZE)) uut (
    .clk(clk),
    .rst(rst),
    .pwm_period(pwm_period),
    .pwm_duty(pwm_duty),
    .pwm_out(pwm_out)
);

// Clock Generation
always #10 clk = ~clk; // Generate a clock with a period of 10 time units

// Testbench Stimulus
initial begin
    // Initialize
    clk = 0;
    rst = 1;
    pwm_period = 0;
    pwm_duty = 0;
    
    // Apply Reset
    #15;
    rst = 0;
    
    // Test Case 1: PWM with 50% duty cycle
    pwm_period = 16'h10; // Set period
    pwm_duty = 16'h08;   // Set duty cycle to 50%
    #200;
    
    // Test Case 2: PWM with 25% duty cycle
    pwm_duty = 16'h04;   // Set duty cycle to 25%
    #200;
    
    // Test Case 3: PWM with 75% duty cycle
    pwm_duty = 16'h0C;   // Set duty cycle to 75%
    #200;

    // Finish the simulation
   // $finish;
end

endmodule
