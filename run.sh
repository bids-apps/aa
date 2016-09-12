#!/bin/bash
# usage: run <bids_dir> <tasklist> <user_customisation> <output_dir> {participant|group} [--participant_label <participant_label>]
#
# positional arguments:
#   <bids_dir>          
# 					  The directory with the input dataset formatted
# 						according to the BIDS standard.
#   <tasklist>          
# 					  aa tasklist describing the steps (XML file)
#   <user_customisation>          
# 					  Pipeline customisation (XML file for editing aap structure)
# 						- Its structure must correspond to that of the aap
# 						  apart from special cases (see later).
# 						- Index in lists of structures (e.g. aamod_smooth(1))
# 						  can be indicated following to aa practice: 
# 						  e.g. aamod_smooth_00001. Default is 1
# 						- Special cases
# 							- firstlevel_contrasts
# 							- input.isBIDS
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
CONFIG=/opt/aap_parameters_defaults_CRN.xml
BIDS_DIR=$1
TASKLIST=$2
UMS=$3
ANADIR=$4
LEVEL=$5

case "$LEVEL" in
    participant)
	
		ind=$(/opt/bin/look_for_arg.sh --participant_label $@);
		if [ "$ind" -gt 0 ]; then
			((ind+=1))
			SUBJLABEL=${!ind}
			/opt/automaticanalysis5/run_automaticanalysis.sh /opt/v80/ $CONFIG $TASKLIST $UMS mridatadir $BIDS_DIR anadir $ANADIR subj $SUBJLABEL
		fi
        ;;
    group)
		echo "Not yet implemented"
        ;;
esac
