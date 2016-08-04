#!/bin/bash
# usage: run <bids_dir> <output_dir> {participant|group} [--participant_label <participant_label>]
#
# positional arguments:
#   <bids_dir>          
# 					  The directory with the input dataset formatted
# 						according to the BIDS standard.
#   <output_dir>		  
# 					  The directory where the output files should be stored.
# 						If you are running group level analysis this folder
# 						should be prepopulated with the results of the
# 						participant level analysis.
#   {participant|group} 
# 					  Level of the analysis that will be performed. Multiple
# 						participant level analyses can be run independently
# 						(in parallel) using the same output_dir.
# 
# optional arguments:
#   --participant_label <participant_label>
# 					  The label(s) of the participant(s) that should be
# 						analyzed. The label corresponds to
# 						sub-<participant_label> from the BIDS spec (so it does
# 						not include "sub-"). If this parameter is not provided
# 						all subjects should be analyzed. Multiple participants
# 						can be specified with a space separated list.

# Parsing arguments
BIDS_DIR=$1
ANADIR=$2

case "$3" in
    participant)
	
		ind=$(/opt/bin/look_for_arg.sh --participant_label $@);
		if [ "$ind" -gt 0 ]; then
			((ind+=1))
			SUBJLABEL=${!ind}
			/opt/automaticanalysis5/run_automaticanalysis.sh /opt/v80/ $BIDS_DIR $ANADIR $SUBJLABEL
		fi
        ;;
    group)
		echo "Not yet implemented"
        ;;
esac
