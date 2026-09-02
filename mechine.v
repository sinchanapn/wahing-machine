`timescale 1ns/1ps

module washing_machine_controller (
    input  logic clk,
    input  logic reset,
    input  logic start,

    output logic water_valve,
    output logic wash_motor,
    output logic drain_pump,
    output logic spin_motor,
    output logic done,

    output logic [4:0] minute
);

    // State declaration
    typedef enum logic [2:0] {
        IDLE  = 3'b000,
        FILL  = 3'b001,
        WASH  = 3'b010,
        DRAIN = 3'b011,
        SPIN  = 3'b100,
        DONE  = 3'b101
    } state_t;

    state_t state, next_state;

    // =====================================================
    // State register and minute counter
    // =====================================================

    always_ff @(posedge clk or posedge reset) begin

        if (reset) begin
            state  <= IDLE;
            minute <= 5'd0;
        end

        else begin

            state <= next_state;

            // Start of washing cycle
            if (state == IDLE && start) begin
                minute <= 5'd1;
            end

            // Fill: 5 minutes
            else if (state == FILL) begin
                if (minute < 5)
                    minute <= minute + 1;
                else
                    minute <= 1;
            end

            // Wash: 15 minutes
            else if (state == WASH) begin
                if (minute < 15)
                    minute <= minute + 1;
                else
                    minute <= 1;
            end

            // Drain: 5 minutes
            else if (state == DRAIN) begin
                if (minute < 5)
                    minute <= minute + 1;
                else
                    minute <= 1;
            end

            // Spin: 5 minutes
            else if (state == SPIN) begin
                if (minute < 5)
                    minute <= minute + 1;
                else
                    minute <= 0;
            end

            else if (state == IDLE) begin
                minute <= 0;
            end

            else if (state == DONE) begin
                minute <= 0;
            end

        end
    end


    // =====================================================
    // Next-state logic
    // =====================================================

    always_comb begin

        next_state = state;

        case (state)

            IDLE: begin
                if (start)
                    next_state = FILL;
            end

            FILL: begin
                if (minute >= 5)
                    next_state = WASH;
            end

            WASH: begin
                if (minute >= 15)
                    next_state = DRAIN;
            end

            DRAIN: begin
                if (minute >= 5)
                    next_state = SPIN;
            end

            SPIN: begin
                if (minute >= 5)
                    next_state = DONE;
            end

            DONE: begin
                next_state = IDLE;
            end

            default: begin
                next_state = IDLE;
            end

        endcase

    end


    // =====================================================
    // Output logic
    // =====================================================

    always_comb begin

        // Default outputs
        water_valve = 1'b0;
        wash_motor  = 1'b0;
        drain_pump  = 1'b0;
        spin_motor  = 1'b0;
        done        = 1'b0;

        case (state)

            IDLE: begin
                // Everything OFF
            end

            FILL: begin
                water_valve = 1'b1;
            end

            WASH: begin
                wash_motor = 1'b1;
            end

            DRAIN: begin
                drain_pump = 1'b1;
            end

            SPIN: begin
                spin_motor = 1'b1;
            end

            DONE: begin
                done = 1'b1;
            end

            default: begin
                // Everything OFF
            end

        endcase

    end

endmodule
