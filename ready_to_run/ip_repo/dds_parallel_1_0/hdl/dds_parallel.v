`timescale 1ns / 1ps

module dds_parallel (
    input  wire audio_48_clk,
    input  wire audio_44_clk,
    input  wire fs_family,    // 0 = 48k family, 1 = 44.1k family
    input  wire fs_mode,      // 0 = normal, 1 = double Fs (x2)
    input  wire dds_enable,
    input  wire dds_mode,     // 0 = sine, 1 = square
    input  wire [15:0] dds_freq,
    output reg  signed [15:0] sample_out,
    output reg                 valid
);

    // Create internal_mclk same as original i2s_dds (BUFGMUX)
    wire internal_mclk;
    (* ASYNC_REG = "TRUE" *) reg fs_family_stage1_q;
    (* ASYNC_REG = "TRUE" *) reg fs_family_sync_q;
    always @(posedge audio_48_clk) begin
        fs_family_stage1_q <= fs_family;
        fs_family_sync_q   <= fs_family_stage1_q;
    end

    BUFGMUX #(.CLK_SEL_TYPE("ASYNC")) mclk_mux (
        .O  (internal_mclk),
        .I0 (audio_48_clk),
        .I1 (audio_44_clk),
        .S  (fs_family_sync_q)
    );

    // Phase increment per Hz table (rounded multiplier)
    reg [16:0] dds_phase_step_per_hz;
    always @(*) begin
        case ({fs_mode, fs_family})
            2'b00: dds_phase_step_per_hz = 17'd89478; // 48 kHz
            2'b01: dds_phase_step_per_hz = 17'd97392; // 44.1 kHz
            2'b10: dds_phase_step_per_hz = 17'd44739; // 96 kHz
            2'b11: dds_phase_step_per_hz = 17'd48696; // 88.2 kHz
        endcase
    end

    wire [32:0] phase_inc_full_w = {17'd0, dds_freq} * {16'd0, dds_phase_step_per_hz};
    wire [31:0] phase_inc_w      = phase_inc_full_w[31:0];

    reg [31:0] phase_acc_q;

    // 256-entry sine LUT (16-bit)
    reg [15:0] sine_lut [0:255];
    integer idx;
    initial begin
        for (idx = 0; idx < 256; idx = idx + 1) begin
            sine_lut[idx] = $rtoi(32767.0 * $sin(2.0 * 3.1415926535 * idx / 256.0));
        end
    end

    // Sample-rate strobe generator: divide internal_mclk by 512 (normal)
    // or 256 (double-rate). This approximates the original frame timing
    // without reproducing the full I2S bit generator state machine.
    reg [8:0] div_counter_q;
    wire [8:0] div_reload = fs_mode ? 9'd255 : 9'd511; // counts 0..N-1

    always @(posedge internal_mclk) begin
        if (!dds_enable) begin
            div_counter_q <= div_reload;
            valid <= 1'b0;
        end else begin
            if (div_counter_q == 9'd0) begin
                div_counter_q <= div_reload;
                // produce a one-cycle valid pulse and tick the phase
                phase_acc_q <= phase_acc_q + phase_inc_w;
                valid <= 1'b1;
                // produce sample based on mode
                if (dds_mode) begin
                    sample_out <= phase_acc_q[31] ? 16'sh7FFF : 16'sh8001;
                end else begin
                    sample_out <= sine_lut[phase_acc_q[31:24]];
                end
            end else begin
                div_counter_q <= div_counter_q - 9'd1;
                valid <= 1'b0;
            end
        end
    end

endmodule
