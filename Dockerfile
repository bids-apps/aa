FROM bids/base_validator

MAINTAINER Tibor Auer <tibor.auer@rhul.ac.uk>

# Prepare for downloads
RUN apt-get -qq update && apt-get -qq install -y \
    unzip xorg wget rsync && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* && \
    mkdir /opt/bin /opt/Download

# FSL
RUN wget --quiet -O /opt/Download/fsl.tar.gz http://fsl.fmrib.ox.ac.uk/fsldownloads/fsl-5.0.9-centos5_64.tar.gz && \
    tar --no-same-owner -xzf /opt/Download/fsl.tar.gz -C /opt
COPY fsl_csh /opt/bin/fsl_csh

# aa
RUN wget --quiet -c -O /opt/Download/aa.tar "https://files.osf.io/v1/resources/umhtq/providers/osfstorage/5b2da7a3daf8210012d50741" && \
    tar --no-same-owner -xf /opt/Download/aa.tar -C /opt
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
