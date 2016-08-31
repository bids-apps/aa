aap = aas_configforSPM12(aap);

% Modify standard recipe module selection here if you'd like
aap.options.wheretoprocess = 'matlab_pct'; % queuing system			% typical value qsub | localsingle
aap.options.aaparallel.numberofworkers = 4;
aap.options.NIFTI4D = 1;										% typical value 0
aap.options.email='tibor.auer@mrc-cbu.cam.ac.uk';

aap.tasksettings.aamod_dartel_norm_write.vox = 1;
aap.tasksettings.aamod_diffusion_bet.bet_f_parameter = 0.4;
aap.tasksettings.aamod_slicetiming.autodetectSO = 1;
aap.tasksettings.aamod_slicetiming.refslice = 16;
aap.tasksettings.aamod_norm_write_dartel.vox = [3 3 3];
aap.tasksettings.aamod_smooth.FWHM = 5;
aap.tasksettings.aamod_firstlevel_model.includemovementpars = 1; % Include/exclude Moco params in/from DM, typical value 1
aap.tasksettings.aamod_firstlevel_threshold.overlay.nth_slice = 9;

%% STUDY
% Data
aap.acq_details.numdummies = 0;
aap.acq_details.input.combinemultiple = 1;
aap.options.autoidentifystructural_choosefirst = 1;
aap = aas_processBIDS(aap);

% Contrast for test1
aap = aas_addcontrast(aap,'aamod_firstlevel_contrasts','*','singlesession:fingerfootlips',[1 0 0],'Loc:Finger','T');
aap = aas_addcontrast(aap,'aamod_firstlevel_contrasts','*','singlesession:fingerfootlips',[0 1 0],'Loc:Foot','T');
aap = aas_addcontrast(aap,'aamod_firstlevel_contrasts','*','singlesession:fingerfootlips',[0 0 1],'Loc:Lips','T');
aap = aas_addcontrast(aap,'aamod_firstlevel_contrasts','*','singlesession:linebisection',[1 0 0 -1 0],'LB:Task:Resp-NoResp','T');
aap = aas_addcontrast(aap,'aamod_firstlevel_contrasts','*','singlesession:linebisection',[-1 0 0 1 0],'LB:Task:NoResp-Resp','T');
aap = aas_addcontrast(aap,'aamod_firstlevel_contrasts','*','singlesession:linebisection',[0 0 -1 0 1],'LB:Control:Resp-NoResp','T');
aap = aas_addcontrast(aap,'aamod_firstlevel_contrasts','*','singlesession:linebisection',[0 0 1 0 -1],'LB:Control:NoResp-Resp','T');

% % Contrast for test2
% aap = aas_addcontrast(aap,'aamod_firstlevel_contrasts','*','singlesession:fingerfootlips_test',[1 0 0],'Loc_T:Finger','T');
% aap = aas_addcontrast(aap,'aamod_firstlevel_contrasts','*','singlesession:fingerfootlips_test',[0 1 0],'Loc_T:Foot','T');
% aap = aas_addcontrast(aap,'aamod_firstlevel_contrasts','*','singlesession:fingerfootlips_test',[0 0 1],'Loc_T:Lips','T');
% aap = aas_addcontrast(aap,'aamod_firstlevel_contrasts','*','singlesession:linebisection_test',[1 0 0 -1 0],'LB_T:Task:Resp-NoResp','T');
% aap = aas_addcontrast(aap,'aamod_firstlevel_contrasts','*','singlesession:linebisection_test',[-1 0 0 1 0],'LB_T:Task:NoResp-Resp','T');
% aap = aas_addcontrast(aap,'aamod_firstlevel_contrasts','*','singlesession:linebisection_test',[0 0 -1 0 1],'LB_T:Control:Resp-NoResp','T');
% aap = aas_addcontrast(aap,'aamod_firstlevel_contrasts','*','singlesession:linebisection_test',[0 0 1 0 -1],'LB_T:Control:NoResp-Resp','T');
% 
% aap = aas_addcontrast(aap,'aamod_firstlevel_contrasts','*','singlesession:fingerfootlips_retest',[1 0 0],'Loc_RT:Finger','T');
% aap = aas_addcontrast(aap,'aamod_firstlevel_contrasts','*','singlesession:fingerfootlips_retest',[0 1 0],'Loc_T:Foot','T');
% aap = aas_addcontrast(aap,'aamod_firstlevel_contrasts','*','singlesession:fingerfootlips_retest',[0 0 1],'Loc_T:Lips','T');
% aap = aas_addcontrast(aap,'aamod_firstlevel_contrasts','*','singlesession:linebisection_retest',[1 0 0 -1 0],'LB_RT:Task:Resp-NoResp','T');
% aap = aas_addcontrast(aap,'aamod_firstlevel_contrasts','*','singlesession:linebisection_retest',[-1 0 0 1 0],'LB_RT:Task:NoResp-Resp','T');
% aap = aas_addcontrast(aap,'aamod_firstlevel_contrasts','*','singlesession:linebisection_retest',[0 0 -1 0 1],'LB_RT:Control:Resp-NoResp','T');
% aap = aas_addcontrast(aap,'aamod_firstlevel_contrasts','*','singlesession:linebisection_retest',[0 0 1 0 -1],'LB_RT:Control:NoResp-Resp','T');
