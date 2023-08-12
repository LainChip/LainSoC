module video_stream_modifier (  
    input  logic        aclk,
    input  logic        aresetn,
    input  logic [31:0] ctl_reg1,
    // slave
    output logic        s_axis_video_TREADY,    // reg
    input  logic        s_axis_video_TVALID,
    input  logic [23:0] s_axis_video_TDATA,
    input  logic [ 2:0] s_axis_video_TKEEP,
    input  logic [ 2:0] s_axis_video_TSTRB,
    input  logic        s_axis_video_TUSER,
    input  logic        s_axis_video_TLAST,
    input  logic        s_axis_video_TID,
    input  logic        s_axis_video_TDEST,
    // master
    input  logic        m_axis_video_TREADY,
    output logic        m_axis_video_TVALID,    // reg
    output logic [23:0] m_axis_video_TDATA,     // reg
    output logic [ 2:0] m_axis_video_TKEEP,     // reg
    output logic [ 2:0] m_axis_video_TSTRB,     // reg
    output logic        m_axis_video_TUSER,     // reg
    output logic        m_axis_video_TLAST,     // reg
    output logic        m_axis_video_TID,       // reg
    output logic        m_axis_video_TDEST      // reg
);

reg [31:0]  ctl_reg1_sync;
reg         en_constant;
reg [23:0]  constant_value;

always @(*) begin : proc_axis
    m_axis_video_TDATA  = en_constant ? constant_value : (s_axis_video_TDATA ^ constant_value);

    m_axis_video_TVALID = s_axis_video_TVALID;
    m_axis_video_TKEEP  = s_axis_video_TKEEP;
    m_axis_video_TSTRB  = s_axis_video_TSTRB;
    m_axis_video_TUSER  = s_axis_video_TUSER;
    m_axis_video_TLAST  = s_axis_video_TLAST;
    m_axis_video_TID    = s_axis_video_TID;
    m_axis_video_TDEST  = s_axis_video_TDEST;

    s_axis_video_TREADY = m_axis_video_TREADY;
end

always_ff @(posedge aclk) begin : proc_en
    ctl_reg1_sync   <= ctl_reg1;

    en_constant     <= ctl_reg1_sync[31];
    constant_value  <= ctl_reg1_sync[23:0];
end

endmodule
