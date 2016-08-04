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
RUN wget -O /opt/Download/MCR_installer_input.txt https://ndownloader.figshare.com/files/5588213?private_link=025fa9f2e33725713eb0
RUN wget -O /opt/Download/aa.tar.gz https://ndownloader.figshare.com/files/5590577?private_link=eee1c8631ce8697f7133

RUN cd /opt/Download/mcr
RUN ./install -inputFile ../MCR_installer_input.txt
RUN cd /opt
RUN tar -xzf /opt/Download/aa.tar.gz

# RUN yum -y install raptor 
# RUN wget -O /etc/yum.repos.d/graphviz-rhel.repo http://www.graphviz.org/graphviz-rhel.repo
# RUN yum -y install epel-release
# RUN yum -y install graphviz

# # FSL
# RUN wget -O /root/Download/fsl.tar.gz http://fsl.fmrib.ox.ac.uk/fsldownloads/fsl-5.0.9-centos6_64.tar.gz
# RUN cd /usr/local/software
# RUN tar -xzf /root/Download/fsl.tar.gz
# RUN echo 'FSLDIR=/usr/local/software/fsl' > /root/Download/fsl_bash
# RUN echo '. ${FSLDIR}/etc/fslconf/fsl.sh' >> /root/Download/fsl_bash
# RUN echo 'PATH=${FSLDIR}/bin:${PATH}' >> /root/Download/fsl_bash
# RUN echo 'export FSLDIR PATH' >> /root/Download/fsl_bash
# RUN chmod +x /root/Download/fsl_bash

# # FreeSurfer
# RUN wget -O /root/Download/freesurfer.tar.gz ftp://surfer.nmr.mgh.harvard.edu/pub/dist/freesurfer/5.3.0/freesurfer-Linux-centos6_x86_64-stable-pub-v5.3.0.tar.gz
# RUN tar -xzf --directory=/usr/local/software /root/Download/freesurfer.tar.gz
# RUN echo "krzysztof.gorgolewski@gmail.com\n5172\n *CvumvEV3zTfg" > /usr/local/freesurfer/.license
# RUN echo 'export FSL_DIR=$FSLDIR' > /root/Download/freesurfer_bash
# RUN echo 'export FSF_OUTPUT_FORMAT=nii' >> /root/Download/freesurfer_bash
# RUN echo 'export FREESURFER_HOME=/usr/local/freesurfer' >> /root/Download/freesurfer_bash 
# RUN echo 'source $FREESURFER_HOME/FreeSurferEnv.sh' >> /root/Download/freesurfer_bash
# RUN chmod +x /root/Download/freesurfer_bash
# RUN yum -y install tcsh bc libjpeg

RUN mkdir /oasis
RUN mkdir /projects
RUN mkdir /scratch
RUN mkdir /local-scratch

RUN mkdir /opt/bin
ADD run.sh /opt/bin/run.sh
ADD look_for_arg.sh /opt/bin/look_for_arg.sh

ENTRYPOINT ["/opt/bin/run.sh"]