FROM bids/base_validator

MAINTAINER Tibor Auer <tibor.auer@rhul.ac.uk>

# Prepare for downloads
RUN apt-get -qq update && apt-get -qq install -y \
    unzip xorg wget && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* && \
    mkdir /opt/bin /opt/Download

# FSL
RUN wget --quiet -O /opt/Download/fsl.tar.gz http://fsl.fmrib.ox.ac.uk/fsldownloads/fsl-5.0.9-centos5_64.tar.gz
RUN tar --no-same-owner -xzf /opt/Download/fsl.tar.gz -C /opt
COPY fsl_csh /opt/bin/fsl_csh

# MCR
RUN mkdir /opt/Download/mcr_install /opt/mcr && \
    wget --quiet -P /opt/Download/mcr_install http://www.mathworks.com/supportfiles/MCR_Runtime/R2012b/MCR_R2012b_glnxa64_installer.zip && \
    unzip -q /opt/Download/mcr_install/MCR_R2012b_glnxa64_installer.zip -d /opt/Download/mcr_install && \
    /opt/Download/mcr_install/install -destinationFolder /opt/mcr -agreeToLicense yes -mode silent && \
    rm -rf /opt/Download/mcr_install /tmp/*

# ENV MATLAB_VERSION R2015b
ENV MCR_VERSION v80
# RUN mkdir /opt/Download/mcr_install /opt/mcr && \
#    wget --quiet -P /opt/Download/mcr_install http://www.mathworks.com/supportfiles/downloads/${MATLAB_VERSION}/deployment_files/${MATLAB_VERSION}/installers/glnxa64/MCR_${MATLAB_VERSION}_glnxa64_installer.zip && \
#   unzip -q /opt/Download/mcr_install/MCR_${MATLAB_VERSION}_glnxa64_installer.zip -d /opt/Download/mcr_install && \
#    /opt/Download/mcr_install/install -destinationFolder /opt/mcr -agreeToLicense yes -mode silent && \
#    rm -rf /opt/Download/mcr_install /tmp/*
ENV LD_LIBRARY_PATH /opt/mcr/${MCR_VERSION}/runtime/glnxa64:/opt/mcr/${MCR_VERSION}/bin/glnxa64:/opt/mcr/${MCR_VERSION}/sys/os/glnxa64:/opt/mcr/${MCR_VERSION}/sys/opengl/lib/glnxa64
ENV MCR_INHIBIT_CTF_LOCK 1

# aa
RUN wget --quiet -O /opt/Download/aa.tar.gz "https://rhul-my.sharepoint.com/personal/tibor_auer_rhul_ac_uk/_layouts/15/download.aspx?guestaccesstoken=pxVLzoJCCPuPEe2rhU8aD5PYVERCg1FWMm1BapVeASo%3d&SourceUrl=https://rhul-my.sharepoint.com/personal/tibor_auer_rhul_ac_uk/_layouts/15/guestaccess.aspx?guestaccesstoken=pxVLzoJCCPuPEe2rhU8aD5PYVERCg1FWMm1BapVeASo%3d&docid=1fbd84bc53c5b47edb640fb83c9e8e068&rev=1"
RUN tar --no-same-owner -xzf /opt/Download/aa.tar.gz -C /opt

# Configuration
COPY aap_parameters_defaults.xml /opt/aap_parameters_defaults.xml
COPY aap_parameters_defaults_CRN.xml /opt/aap_parameters_defaults_CRN.xml

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
