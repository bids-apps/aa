FROM bids/base_validator

MAINTAINER Tibor Auer <tibor.auer@rhul.ac.uk>

# Install dependencies
RUN apt-get -qq update && apt-get -qq install -y \
    unzip xorg wget rsync csh tcsh bc libgomp1 perl-modules && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* && \
    mkdir /opt/bin /opt/Download

# FSL
RUN wget -qO- http://fsl.fmrib.ox.ac.uk/fsldownloads/fsl-5.0.9-centos5_64.tar.gz | tar --no-same-owner -xzv -C /opt
COPY fsl_csh /opt/bin/fsl_csh

#FreeSurfer
RUN wget -qO- https://surfer.nmr.mgh.harvard.edu/pub/dist/freesurfer/6.0.1/freesurfer-Linux-centos6_x86_64-stable-pub-v6.0.1.tar.gz | tar zxv --no-same-owner -C /opt \
    --exclude='freesurfer/trctrain' \
    --exclude='freesurfer/subjects/fsaverage_sym' \
    --exclude='freesurfer/subjects/fsaverage3' \
    --exclude='freesurfer/subjects/fsaverage4' \
    --exclude='freesurfer/subjects/fsaverage5' \
    --exclude='freesurfer/subjects/fsaverage6' \
    --exclude='freesurfer/subjects/cvs_avg35' \
    --exclude='freesurfer/subjects/cvs_avg35_inMNI152' \
    --exclude='freesurfer/subjects/bert' \
    --exclude='freesurfer/subjects/V1_average' \
    --exclude='freesurfer/average/mult-comp-cor' \
    --exclude='freesurfer/lib/cuda' \
    --exclude='freesurfer/lib/qt'
ENV FS_HOME=/opt/freesurfer

# aa
RUN wget -qO- "https://files.osf.io/v1/resources/umhtq/providers/osfstorage/5b34eb7dd7f11e000efe8b02" | tar --no-same-owner -xv -C /opt
COPY aap_parameters_defaults.xml /opt/aap_parameters_defaults.xml
COPY aap_parameters_defaults_BIDS.xml /opt/aap_parameters_defaults_BIDS.xml

# MCR
ENV MATLAB_VERSION R2018a
ENV MCR_VERSION v94
RUN mkdir /opt/Download/mcr_install /opt/mcr && \
    wget --quiet -O /opt/Download/mcr_install.zip http://www.mathworks.com/supportfiles/downloads/${MATLAB_VERSION}/deployment_files/${MATLAB_VERSION}/installers/glnxa64/MCR_${MATLAB_VERSION}_glnxa64_installer.zip && \
    unzip -q /opt/Download/mcr_install.zip -d /opt/Download/mcr_install && \
    /opt/Download/mcr_install/install -destinationFolder /opt/mcr -agreeToLicense yes -mode silent && \
    rm -rf /opt/Download/mcr_install* /tmp/*
ENV MCR_INHIBIT_CTF_LOCK 1

# Default tasklist for dataset with structural, functional and diffusion data
COPY BIDS_tasklist.xml /opt/BIDS_tasklist.xml
COPY BIDS_aa.xml /opt/BIDS_aa.xml

# Cleanup
RUN rm -rf /opt/Download

# Test
COPY test /opt/test

# Entry
COPY run.sh /opt/bin/run.sh
COPY look_for_arg.sh /opt/bin/look_for_arg.sh
RUN chmod +x /opt/bin/*

COPY version /version

ENTRYPOINT ["/opt/bin/run.sh"]
