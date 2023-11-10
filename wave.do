onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -divider TOP
add wave -noupdate /tb/DUT/rst
add wave -noupdate /tb/DUT/clk
add wave -noupdate /tb/DUT/EA
add wave -noupdate /tb/DUT/PE
add wave -noupdate /tb/DUT/start_f
add wave -noupdate /tb/DUT/start_t
add wave -noupdate /tb/DUT/stop_f_t
add wave -noupdate /tb/DUT/parity
add wave -noupdate -divider DCM
add wave -noupdate /tb/DUT/dcm/update
add wave -noupdate -radix unsigned /tb/DUT/prog
add wave -noupdate -radix unsigned -childformat {{{/tb/DUT/dcm/prog_reg[2]} -radix unsigned} {{/tb/DUT/dcm/prog_reg[1]} -radix unsigned} {{/tb/DUT/dcm/prog_reg[0]} -radix unsigned}} -subitemconfig {{/tb/DUT/dcm/prog_reg[2]} {-height 15 -radix unsigned} {/tb/DUT/dcm/prog_reg[1]} {-height 15 -radix unsigned} {/tb/DUT/dcm/prog_reg[0]} {-height 15 -radix unsigned}} /tb/DUT/dcm/prog_reg
add wave -noupdate /tb/DUT/dcm/clk_1
add wave -noupdate /tb/DUT/dcm/clk_2
add wave -noupdate /tb/clk
add wave -noupdate /tb/DUT/dcm/clock
add wave -noupdate /tb/DUT/dcm/clock_1
add wave -noupdate -divider FIB
add wave -noupdate /tb/DUT/clk_1
add wave -noupdate /tb/DUT/fibonacci/f_en
add wave -noupdate /tb/DUT/fibonacci/f_valid
add wave -noupdate -radix unsigned /tb/DUT/fibonacci/f_out
add wave -noupdate -divider TIMER
add wave -noupdate /tb/DUT/clk_1
add wave -noupdate /tb/DUT/timer/t_en
add wave -noupdate /tb/DUT/timer/t_valid
add wave -noupdate -radix unsigned /tb/DUT/timer/t_out
add wave -noupdate -divider WRAPPER
add wave -noupdate /tb/DUT/wrapper/clk_1
add wave -noupdate /tb/DUT/wrapper/clk_2
add wave -noupdate /tb/DUT/wrapper/buffer_empty
add wave -noupdate /tb/DUT/wrapper/buffer_full
add wave -noupdate /tb/DUT/wrapper/data_1_en
add wave -noupdate -radix unsigned /tb/DUT/wrapper/data_1
add wave -noupdate /tb/DUT/wrapper/data_2_valid
add wave -noupdate -radix unsigned /tb/DUT/wrapper/data_2
add wave -noupdate -radix unsigned /tb/DUT/wrapper/pointer_w
add wave -noupdate -radix unsigned /tb/DUT/wrapper/pointer_r
add wave -noupdate -radix unsigned /tb/DUT/wrapper/t_buffer
add wave -noupdate -divider DM
add wave -noupdate -radix unsigned /tb/DUT/dm/prog
add wave -noupdate -radix unsigned /tb/DUT/dm/modulo
add wave -noupdate -radix unsigned /tb/DUT/dm/data_2
add wave -noupdate -radix hexadecimal /tb/DUT/dm/an
add wave -noupdate -radix hexadecimal /tb/DUT/dm/dec_ddp
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {26 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 1
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {0 ns} {285 ns}
