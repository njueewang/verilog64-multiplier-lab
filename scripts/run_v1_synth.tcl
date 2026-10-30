# Synthesize V1 and write a utilization summary for comparison with later versions.
set script_dir  [file normalize [file dirname [info script]]]
set repo_dir    [file normalize [file join $script_dir ".."]]
set project_file [file join $repo_dir "vivado" "multiplier64_v1" "multiplier64_v1.xpr"]
set report_dir   [file join $repo_dir "vivado" "multiplier64_v1" "reports"]

if {![file exists $project_file]} {
    error "Project not found: $project_file. Run scripts/create_v1_project.tcl first."
}

open_project $project_file
reset_run synth_1
launch_runs synth_1 -jobs 2
wait_on_run synth_1

if {[get_property PROGRESS [get_runs synth_1]] != "100%"} {
    error "V1 synthesis failed. Check the synth_1 run log in Vivado."
}

open_run synth_1
file mkdir $report_dir
report_utilization -file [file join $report_dir "v1_utilization.rpt"]
report_timing_summary -file [file join $report_dir "v1_timing_summary.rpt"]
close_project
