## aa
BIDS App containing an instance of the **Automatic Analysis**.

Automatic Analysis software was originally developed by Dr Rhodri Cusack
for supporting research at the MRC Cognition and Brain Science Unit. It
is made available to the academic community in the hope that it may
prove useful.

Definitions: aa means the Automatic Analysis software package and any
associated documentation whether electronic or printed.

aa is a pipeline system for neuroimaging written primarily in Matlab. It
robustly supports recent versions of SPM, as well as selected functions
from other software packages. The goal is to facilitate automatic,
flexible, and replicable neuroimaging analyses through a comprehensive
pipeline system.

### License
Use of this software is subject to the terms of the license, found in
the license.txt file distributed with this software.

### Documentations
More information can be found on the official [**aa** webpage](http://www.automaticanalysis.org)

### Error Reporting
Experiencing problems? Please open an [issue](https://github.com/rhodricusack/automaticanalysis/issues/new) and explain what's happening so we can help.

### Acknowledgement
For any papers that report data analyzed with aa, please include the
website (http://www.automaticanalysis.org) and cite the [aa paper](http://dx.doi.org/10.3389/fninf.2014.00090):

Cusack R, Vicente-Grabovetsky A, Mitchell DJ, Wild CJ, Auer T, Linke AC,
Peelle JE (2015) Automatic analysis (aa): Efficient neuroimaging
workflows and parallel processing using Matlab and XML. Frontiers in
Neuroinformatics 8:90.

### Instructions

The [bids/aa](https://hub.docker.com/r/bids/aa/) Docker container enables users to run Automatic Analysis right from container launch. The pipeline requires that data be organized in accordance with the [BIDS](http://bids.neuroimaging.io) spec.

**To get your container ready to run just follow these steps:**

- In your terminal, type:
```{bash}
$ docker pull bids/aa
```

**Now we're ready to launch our instances and process some data!**

Like a normal docker container, you can startup your container with a single line.

    usage: run <bids_dir> <output_dir> {participant|group}
               [--participant_label <participant_label>]
               [--freesurfer_license <license_file>]
               [--connection <pipeline to connect to>]
               [<tasklist> <user_customisation>]

    positional arguments:
        <bids_dir>
                                The directory with the input dataset formatted
                                according to the BIDS standard.
        <output_dir>
                                The directory where the output files should be stored.
                                If you are running group level analysis this folder
                                should be prepopulated with the results of the
                                participant level analysis.
        {participant|group}
                                Level of the analysis that will be performed. Multiple
                                participant level analyses can be run independently
                                (in parallel) using the same output_dir.

    optional arguments:
        --participant_label <participant_label>
                                The label(s) of the participant(s) that should be
                                analyzed. The label corresponds to
                                sub-<participant_label> from the BIDS spec (so it does
                                not include "sub-"). If this parameter is not provided
                                all subjects should be analyzed. Multiple participants
                                can be specified with a space separated list.
        --freesurfer_license <license_file>
                                Path to FreeSurfer license key file. Required if you specify
                                tasklist with freesurfer modules. To obtain it you
                                need to register (for free) at
                                https://surfer.nmr.mgh.harvard.edu/registration.html
        --connection <pipeline to connect to>
                                Path to a previously processed pipeline, from where inputs
                                will be taken.
        <tasklist>
                                aa tasklist describing the steps (XML file). It also requires
                                <user_customisation>.
        <user_customisation>
                                Customisation of the provided <tasklist>. It must be an XML
                                file corresponding to aa's aap structure.
                                    - Its structure must correspond to that of the aap
                                      apart from special cases (see later).
                                    - Index in lists of structures (e.g. aamod_smooth(1))
                                      can be indicated following to aa practice:
                                      e.g. aamod_smooth_00001. Default is 1
                                    - Special cases
                                        - firstlevel_contrasts
                                        - input.isBIDS
