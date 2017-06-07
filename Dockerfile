FROM bids/base_freesurfer

# Prepare for downloads
RUN apt-get update -y && apt-get install -y wget unzip
RUN mkdir /opt/bin
RUN mkdir /opt/Download

# FSL
# RUN apt-get update && \
#    curl -sSL http://neuro.debian.net/lists/trusty.us-tn.full >> /etc/apt/sources.list.d/neurodebian.sources.list && \
#    apt-key adv --recv-keys --keyserver hkp://pgp.mit.edu:80 0xA5D32F012649A5A9 && \
#    apt-get update && \
#    apt-get remove -y curl && \
#    apt-get install -y fsl-complete && \
#    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
RUN wget --quiet -O /opt/Download/fsl.tar.gz http://fsl.fmrib.ox.ac.uk/fsldownloads/fsl-5.0.9-centos5_64.tar.gz
RUN tar -xzf /opt/Download/fsl.tar.gz -C /opt

# Configuration files for FSL and FS0
ADD fsl_csh /opt/bin/fsl_csh
ADD freesurfer_bash /opt/bin/freesurfer_bash

# aa - compile with dependecies
RUN wget --quiet -O /opt/Download/mcr.zip http://uk.mathworks.com/supportfiles/MCR_Runtime/R2012b/MCR_R2012b_glnxa64_installer.zip
RUN mkdir /opt/Download/mcr
RUN unzip /opt/Download/mcr.zip -d /opt/Download/mcr
RUN wget --quiet -O /opt/Download/MCR_installer_input.txt "https://rhul-my.sharepoint.com/personal/tibor_auer_rhul_ac_uk/_layouts/15/download.aspx?guestaccesstoken=ZfbRLo%2fPDkbwAJ0AAwSyvIKk9dBkieKKvc3Yu%2bduGQs%3d&SourceUrl=https://rhul-my.sharepoint.com/personal/tibor_auer_rhul_ac_uk/_layouts/15/guestaccess.aspx?guestaccesstoken=ZfbRLo%2fPDkbwAJ0AAwSyvIKk9dBkieKKvc3Yu%2bduGQs%3d&docid=193b86deb1da14cdb9ff24ee45e423fa8&rev=1"
RUN /opt/Download/mcr/install -inputFile /opt/Download/MCR_installer_input.txt

RUN echo "deb http://download.librdf.org/binaries/ubuntu/hoary ./" >> /etc/apt/sources.list
RUN echo "deb-src http://download.librdf.org/binaries/ubuntu/hoary ./" >> /etc/apt/sources.list
RUN wget --quiet -O /opt/Download/gnup.asc http://purl.org/net/dajobe/gnupg.asc && apt-key add - < /opt/Download/gnup.asc
RUN apt-get update -y && apt-get install -y rsync raptor-utils graphviz

RUN wget --quiet -O /opt/Download/aa.tar.gz "https://rhul-my.sharepoint.com/personal/tibor_auer_rhul_ac_uk/_layouts/15/download.aspx?guestaccesstoken=pxVLzoJCCPuPEe2rhU8aD5PYVERCg1FWMm1BapVeASo%3d&SourceUrl=https://rhul-my.sharepoint.com/personal/tibor_auer_rhul_ac_uk/_layouts/15/guestaccess.aspx?guestaccesstoken=pxVLzoJCCPuPEe2rhU8aD5PYVERCg1FWMm1BapVeASo%3d&docid=1fbd84bc53c5b47edb640fb83c9e8e068&rev=1"
RUN tar -xzf /opt/Download/aa.tar.gz -C /opt

# Configuration
ADD aap_parameters_defaults.xml /opt/aap_parameters_defaults.xml
ADD aap_parameters_defaults_CRN.xml /opt/aap_parameters_defaults_CRN.xml

# Default tasklist for dataset with structural, functional and diffusion data
ADD BIDS_tasklist.xml /opt/BIDS_tasklist.xml
ADD BIDS_aa.xml /opt/BIDS_aa.xml

# Cleanup
RUN rm -rf /opt/Download

# Test
ADD test /opt/test

# Entry
ADD run.sh /opt/bin/run.sh
ADD look_for_arg.sh /opt/bin/look_for_arg.sh
RUN chmod +x /opt/bin/*

COPY version /version

# CRN
RUN mkdir /oasis
RUN mkdir /projects
RUN mkdir /scratch
RUN mkdir /local-scratch

ENTRYPOINT ["/opt/bin/run.sh"]
