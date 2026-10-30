# Compile and run the V1 behavioral simulation in batch mode.
set script_dir  [file normalize [file dirname [info script]]]
set repo_dir    [file normalize [file join $script_dir ".."]]
set project_file [file join $repo_dir "vivado" "multiplier64_v1" "multiplier64_v1.xpr"]

if {![file exists $project_file]} {
    error "Project not found: $project_file. Run scripts/create_v1_project.tcl first."
}

open_project $project_file
launch_simulation -mode behavioral
run all
close_sim
close_project
