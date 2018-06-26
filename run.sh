#!/bin/bash
# usage: run <bids_dir> <output_dir> {participant|group} [--participant_label <participant_label>] [--freesurfer_license <license_file>] [<tasklist>] [<user_customisation>]
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
#   --freesurfer_license <license_file>
#					  Path to FreeSurfer license key file. Required if you specify
#						tasklist with freesurfer modules. To obtain it you
#                            			need to register (for free) at
#                            			https://surfer.nmr.mgh.harvard.edu/registration.html
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

# Parsing arguments
CONFIG=/opt/aap_parameters_defaults_BIDS.xml

indUMS=$# # UMS is expected at the last position
((indTL=indUMS-1)) # tasklist is expected before the UMS
TASKLIST=${!indTL}
UMS=${!indUMS}
if [[ $TASKLIST != *".xml" ]]; then
	TASKLIST=/opt/BIDS_tasklist.xml
	UMS=/opt/BIDS_aa.xml
fi

# Freesurfer licese (if specified)
ind=$(/opt/bin/look_for_arg.sh --freesurfer_license $@);
if [ "$ind" -gt 0 ]; then
	((ind+=1))
	LICENSE=${!ind}
	cp $LICENSE $FS_HOME/license.txt
fi

# Analysis
BIDS_DIR=$1
ANADIR=$2
LEVEL=$3

case "$LEVEL" in
    participant)
		ind=$(/opt/bin/look_for_arg.sh --participant_label $@);
		if [ "$ind" -gt 0 ]; then
			((ind+=1))
			SUBJLABEL=${!ind}

			/opt/automaticanalysis5/run_automaticanalysis.sh /opt/mcr/${MCR_VERSION} $CONFIG $TASKLIST $UMS mridatadir $BIDS_DIR anadir $ANADIR subj "sub-$SUBJLABEL"
		fi
        ;;
    group)
		/opt/automaticanalysis5/run_automaticanalysis.sh /opt/mcr/${MCR_VERSION} $CONFIG $TASKLIST $UMS mridatadir $BIDS_DIR anadir $ANADIR
        ;;
esac
