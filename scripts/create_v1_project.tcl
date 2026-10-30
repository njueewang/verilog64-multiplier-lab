# Create the V1 Vivado project from version-controlled source files.
set script_dir [file normalize [file dirname [info script]]]
set repo_dir   [file normalize [file join $script_dir ".."]]
set project_dir [file join $repo_dir "vivado" "multiplier64_v1"]

file mkdir $project_dir

create_project multiplier64_v1 $project_dir \
    -part xc7a35tcsg324-1 \
    -force

set_property target_language Verilog [current_project]

add_files -fileset sources_1 [list \
    [file join $repo_dir "rtl" "multiplier64.v"] \
]

add_files -fileset sim_1 [list \
    [file join $repo_dir "tb" "multiplier64_tb.v"] \
]

set_property top multiplier64 [get_filesets sources_1]
set_property top multiplier64_tb [get_filesets sim_1]

update_compile_order -fileset sources_1
update_compile_order -fileset sim_1

puts "Created V1 Vivado project: [file join $project_dir multiplier64_v1.xpr]"
close_project
