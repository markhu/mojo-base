module mojo_top(
  input clk,
  input rst_n,
  input cclk,
  output [7:0] led,
  output spi_miso,
  input spi_ss,
  input spi_mosi,
  input spi_sck,
  output [3:0] spi_channel,
  input avr_tx,
  output avr_rx,
  input avr_rx_busy
);

wire rst = ~rst_n;

wire [7:0] tx_data;
wire new_tx_data;
wire tx_busy;
wire [7:0] rx_data;
wire new_rx_data;

wire [3:0] dac_channel = 4'hF;
wire new_dac_sample;
wire [9:0] dac_sample;
wire [3:0] dac_sample_channel;


// led_wave #(.CTR_LEN(28)) led_wave (
//     .rst(rst),
//     .clk(clk),
//     .led(led)
// );

assign led = new_dac_sample ^ dac_sample[7:0] ^ dac_sample[9:8] ^ dac_sample_channel ^ tx_busy;

serial_loop serial_loop (
  .rx_data(rx_data),
  .new_rx_data(new_rx_data),
  .tx_data(tx_data),
  .new_tx_data(new_tx_data)
);

avr_interface avr_interface (
  .clk(clk),
  .rst(rst),
  .cclk(cclk),
  .spi_miso(spi_miso),
  .spi_mosi(spi_mosi),
  .spi_sck(spi_sck),
  .spi_ss(spi_ss),
  .spi_channel(spi_channel),
  .tx(avr_rx),
  .rx(avr_tx),
  .channel(dac_channel),
  .new_sample(new_dac_sample),
  .sample(dac_sample),
  .sample_channel(dac_sample_channel),
  .tx_data(tx_data),
  .new_tx_data(new_tx_data),
  .tx_busy(tx_busy),
  .tx_block(avr_rx_busy),
  .rx_data(rx_data),
  .new_rx_data(new_rx_data)
);

endmodule