set script_dir [file dirname [ file dirname [ file normalize [ info script ]/... ] ] ]

puts $script_dir

source "$script_dir/../../../common/carbon-carp/rev4.1/carbon-carp_system_bd.tcl"
source "$script_dir/../../scripts/fmcomms5_bd.tcl"
source "$script_dir/../../../common/scripts/common_bd.tcl"
