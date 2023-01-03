FROM centos:6.6

# Prepare for downloads
RUN yum -y install wget unzip tar
RUN mkdir /usr/local/software
RUN mkdir /opt/Download

# aa - compile with dependecies
RUN yum -y install libXext libXt libXmu
RUN wget -O /opt/Download/mcr.zip http://uk.mathworks.com/supportfiles/MCR_Runtime/R2012b/MCR_R2012b_glnxa64_installer.zip
RUN mkdir /opt/Download/mcr
RUN unzip /opt/Download/mcr.zip -d /opt/Download/mcr
RUN wget -O /opt/Download/MCR_installer_input.txt https://googledrive.com/host/0B9T4a0ktPmB1R2FJRjVNa19JVTQ/MCR_installer_input.txt # https://ndownloader.figshare.com/files/5588213?private_link=025fa9f2e33725713eb0
RUN /opt/Download/mcr/install -inputFile /opt/Download/MCR_installer_input.txt

RUN wget -O /opt/Download/aa.tar.gz https://googledrive.com/host/0B9T4a0ktPmB1R2FJRjVNa19JVTQ/automaticanalysis5.tar.gz #https://ndownloader.figshare.com/files/5590577?private_link=eee1c8631ce8697f7133
RUN tar -xzf /opt/Download/aa.tar.gz -C /opt

COPY aap_parameters_defaults.xml /opt/aap_parameters_defaults.xml
COPY aap_parameters_defaults_CRN.xml /opt/aap_parameters_defaults_CRN.xml

RUN yum -y install raptor
RUN wget -O /etc/yum.repos.d/graphviz-rhel.repo http://www.graphviz.org/graphviz-rhel.repo
RUN yum -y install epel-release
RUN yum -y install graphviz

# FSL
RUN wget -O /opt/Download/fsl.tar.gz http://fsl.fmrib.ox.ac.uk/fsldownloads/fsl-5.0.9-centos6_64.tar.gz
RUN tar -xzf /opt/Download/fsl.tar.gz -C /opt
RUN echo 'setenv FSLDIR /opt/fsl' > /opt/bin/fsl_csh
RUN echo 'source ${FSLDIR}/etc/fslconf/fsl.sh' >> /opt/bin/fsl_csh
RUN echo 'setenv PATH ${FSLDIR}/bin:${PATH}' >> /opt/bin/fsl_csh

# FreeSurfer
RUN wget -O /opt/Download/freesurfer.tar.gz ftp://surfer.nmr.mgh.harvard.edu/pub/dist/freesurfer/5.3.0/freesurfer-Linux-centos6_x86_64-stable-pub-v5.3.0.tar.gz
RUN tar -xzf /opt/Download/freesurfer.tar.gz -C /opt
RUN echo "krzysztof.gorgolewski@gmail.com\n5172\n *CvumvEV3zTfg" > /opt/freesurfer/.license
RUN echo 'export FSL_DIR=$FSLDIR' > /opt/bin/freesurfer_bash
RUN echo 'export FSF_OUTPUT_FORMAT=nii' >> /opt/bin/freesurfer_bash
RUN echo 'export FREESURFER_HOME=/opt/freesurfer' >> /opt/bin/freesurfer_bash
RUN echo 'source $FREESURFER_HOME/FreeSurferEnv.sh' >> /opt/bin/freesurfer_bash
RUN yum -y install tcsh bc libjpeg

# Cleanup
RUN rm -rf /opt/Download

# Test
COPY test /opt/test

# CRN
RUN mkdir /oasis
RUN mkdir /projects
RUN mkdir /scratch
RUN mkdir /local-scratch

# Entry
RUN mkdir /opt/bin
COPY run.sh /opt/bin/run.sh
COPY look_for_arg.sh /opt/bin/look_for_arg.sh
RUN chmod +x /opt/bin/*

ENTRYPOINT ["/opt/bin/run.sh"]
