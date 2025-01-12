module l1_cache #(
    parameter ADDR_WIDTH = 32,                              // using 32-bit addresses
    parameter DATA_WIDTH = 3,                              // each data word is 32 bits
    parameter LINE_SIZE = 64,                               // each cache line is 64 bytes
    parameter CACHE_SIZE = 4096                             // cache size in bytes
)(

    input logic i_clk,
    input logic i_rst,

    // CPU interface
    input logic i_cpu_read_en,                              // reads only occur when this signal asserted
    input logic i_cpu_write_en,                             // write only occur when this signal asserted
    input logic [ADDR_WIDTH - 1:0] i_cpu_addr,              // addr to read/write
    input logic [DATA_WIDTH - 1:0] i_cpu_write_data,        // data we are writing to cpu from cache
    output logic [DATA_WIDTH - 1:0] o_cpu_read_data,        // data output read from cpu to cache
    output logic o_cpu_data_valid,                          // asserted when the data requested by cpu is provided on output

    // memory interface
    output logic o_mem_read_en,                             // if cache miss, then cache must read from lower level memory
    output logic o_mem_write_en,                            // cache writes evicted lines to lower level memory
    output logic [ADDR_WIDTH - 1:0] o_mem_addr,             // the mem addr we are reading/writing
    output logic [DATA_WIDTH - 1:0] o_mem_write_data,       // the data that is being written to memory from cache
    input logic [DATA_WIDTH - 1:0] i_mem_read_data,         // the data that is read from mem into cache
    input logic i_mem_data_valid                            // indicates that memory has data ready for transfer to the cache
);
    // additional derived parameters (cache line field sizes)
    localparam NUM_CACHE_LINES = CACHE_SIZE / LINE_SIZE;
    localparam INDEX_BITS = $clog2(NUM_CACHE_LINES);        
    localparam OFFSET_BITS = $clog2(LINE_SIZE);             
    localparam TAG_BITS = ADDR_WIDTH - INDEX_BITS - OFFSET_BITS;

    // internal signals for each cache field
    logic [TAG_BITS - 1:0] tag = i_cpu_addr[ADDR_WIDTH - 1 : ADDR_WIDTH - TAG_BITS];                //
    logic [INDEX_BITS - 1:0] index = i_cpu_addr[ADDR_WIDTH - TAG_BITS - 1: OFFSET_BITS];            // index bits identify the cache line being accessed
    logic [OFFSET_BITS - 1:0] offset = i_cpu_addr[OFFSET_BITS - 1 : 0];                             //

    // primary cache storage array DATA_WIDTH sized cells on a grid of WORDS_PER_LINE x NUM_CACHE_LINES (4 byte word, 64 x 16 byte memory array)
    logic [DATA_WIDTH-1:0] data_array [NUM_CACHE_LINES-1:0][WORDS_PER_LINE-1:0];

    // other storage arrays
    logic [TAG_BITS - 1 : 0] tag_array [NUM_CACHE_LINES - 1 : 0];
    logic [NUM_CACHE_LINES - 1 : 0] dirty_array;
    logic [NUM_CACHE_LINES - 1 : 0] valid_array;
    
    /* ----- FSM LOGIC ----- */

    // hit detection logic
    logic cache_hit;
    assign cache_hit = valid_array[index] && (tag_array[index] == tag);

    // counter for tracking words for line evictions and fetches - log_2(64 / (32/8)) = 4 bits for storing # of words (16 words so this checks out)
    logic [$clog2(LINE_SIZE / (DATA_WIDTH / 8)) - 1 : 0] word_counter;

    // enumeration of states
    typedef enum logic [2:0] {
        IDLE,
        CHECK_TAG,
        CHECK_DIRTY,
        WRITE_BACK,
        FETCH_LINE,
        WRITE_DATA
    } t_state;

    // state register declaration
    logic [2:0] current_state, next_state;

    // combinatorial logic for determining next state
    case current_state
        
        // IDLE handling
        IDLE:

        // CHECK_TAG handling
        CHECK_TAG:

        // CHECK_DIRTY handling
        CHECK_DIRTY:

        // WRITE_BACK handling
        WRITE_BACK:

        // FETCH_LINE handling
        FETCH_LINE:

        // WRITE_DATA handling
        WRITE_DATA:

        // default case
        default: next_state = IDLE;
    endcase
    
    // state transition logic - sequential block
    always @(posedge i_clk) begin

        // reset handling - deassert all outputs and reset to IDLE state
        if (i_rst) begin
            t_state <= IDLE;
            o_cpu_read_data <= 1'b0;
            o_cpu_data_valid <= 1'b0;
            o_mem_addr <= 1'b0;
            o_mem_read_en <= 1'b0;
            o_mem_write_data <= 1'b0;
            o_mem_write_en <= 1'b0;
        end else begin
            
            // actual transition of states every cycle 
            current_state <= next_state;
        end
    end
endmodule