`timescale 1ns/1ps

module washing_machine_tb;

    // =====================================================
    // Inputs
    // =====================================================

    logic clk;
    logic reset;
    logic start;

    // =====================================================
    // Outputs
    // =====================================================

    logic water_valve;
    logic wash_motor;
    logic drain_pump;
    logic spin_motor;
    logic done;

    logic [4:0] minute;


    // =====================================================
    // Instantiate Design Under Test
    // =====================================================

    washing_machine_controller uut (
        .clk(clk),
        .reset(reset),
        .start(start),

        .water_valve(water_valve),
        .wash_motor(wash_motor),
        .drain_pump(drain_pump),
        .spin_motor(spin_motor),
        .done(done),

        .minute(minute)
    );


    // =====================================================
    // Clock generation
    // 10 ns clock period
    // =====================================================

    initial begin
        clk = 1'b0;

        forever begin
            #5 clk = ~clk;
        end
    end


    // =====================================================
    // Test sequence
    // =====================================================

    initial begin

        // Initial conditions
        reset = 1'b1;
        start = 1'b0;

        // Keep reset active for 10 ns
        #10;

        // Release reset
        reset = 1'b0;

        // Wait 10 ns
        #10;

        // Press START
        start = 1'b1;

        // Keep START high for 10 ns
        #10;

        // Release START
        start = 1'b0;

        // =================================================
        // Washing machine runs
        // =================================================

        // Wait for complete cycle
        #400;

        // Finish simulation
        $stop;

    end


    // =====================================================
    // Display results
    // =====================================================

    initial begin

        $monitor(
            "TIME=%0t ns | STATE=%b | MINUTE=%0d | VALVE=%b | WASH=%b | DRAIN=%b | SPIN=%b | DONE=%b",
            $time,
            uut.state,
            minute,
            water_valve,
            wash_motor,
            drain_pump,
            spin_motor,
            done
        );

    end

endmodule

