module pwm_driver #(
    parameter PWM_SIZE = 16
) (
    input logic clk,
    input logic rst,
    input logic [PWM_SIZE-1:0] pwm_period,
    input logic [PWM_SIZE-1:0] pwm_duty,
    output logic pwm_out
);

logic [PWM_SIZE-1:0] pwm_counter;

always_ff @(posedge clk) begin
    if (rst) begin
        pwm_counter <= 0;  // Reset counter to 0
    end
    else begin
        if (pwm_counter >= pwm_period - 1) begin
            pwm_counter <= 0;  // Reset counter when the period is reached
        end
        else begin
            pwm_counter <= pwm_counter + 1;  // Increment counter
        end
    end

    pwm_out <= (pwm_counter < pwm_duty);  // Set output high during duty cycle
end

endmodule
