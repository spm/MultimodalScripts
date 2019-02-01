%outpth = 'DATAPATH';

spm('defaults','eeg');
spm_jobman('initcfg');

figs = fullfile(outpth,'allfigures.ps');

% Figure 3
%==========================================================================
% dspmeeg_sub-15-ses-meg... is deleted to save space by default
%D = spm_eeg_load(fullfile(outpth,'sub-15','meg','dspmeeg_sub-15_ses-meg_task-facerecognition_run-01_proc-sss_meg.mat'));
%spm_eeg_review(D,1)
%spm_print(figs);


% Figure 4
%==========================================================================
D = spm_eeg_load(fullfile(outpth,'sub-15','meg','wmPaMceffdspmeeg_sub-15_ses-meg_task-facerecognition_run-01_proc-sss_meg.mat'));
spm_eeg_review(D,1)
% click on "scalp"
% click on <> twice
% select Trial 1, 2, 3
spm_print(figs);


% Figure 5
%==========================================================================
% click on + and select channel EEG070

% select Trial 4
% click on topography icon and move slider to 155ms


% Figure 6
%==========================================================================
D = spm_eeg_load(fullfile(outpth,'sub-15','meg','aMceffdspmeeg_sub-15_ses-meg_task-facerecognition_run-01_proc-sss_meg.mat'));
spm_eeg_inv_checkmeshes(D,1);
view([-170 20])
spm_print(figs);
spm_eeg_inv_checkdatareg(D,1,1); % EEG
spm_print(figs);
spm_eeg_inv_checkdatareg(D,1,2); % MEG
spm_print(figs);
spm_eeg_inv_checkforward(D,1,1); % EEG
spm_print(figs);
spm_eeg_inv_checkforward(D,1,2); % MEG
spm_print(figs);


% Figure 7
%==========================================================================
D = spm_eeg_load(fullfile(outpth,'sub-15','meg','aMceffdspmeeg_sub-15_ses-meg_task-facerecognition_run-01_proc-sss_meg.mat'));
D.val = 1; % inversion 1 (MNM)
D.con = 1; % condition 1
spm_eeg_invert_display(D,165);
spm_print(figs);


% Figure 8
%==========================================================================
clear matlabbatch
matlabbatch{1}.spm.stats.results.spmmat = {fullfile(outpth,'meg','IndMNMStats','SPM.mat')};
matlabbatch{1}.spm.stats.results.conspec.contrasts = 2;
matlabbatch{1}.spm.stats.results.conspec.threshdesc = 'FWE';
matlabbatch{1}.spm.stats.results.conspec.thresh = 0.05;
matlabbatch{1}.spm.stats.results.conspec.extent = 0;
matlabbatch{1}.spm.stats.results.conspec.mask.none = 1;
matlabbatch{1}.spm.stats.results.units = 1;
matlabbatch{1}.spm.stats.results.export = cell(1, 0);
spm_jobman('run',matlabbatch);
spm_mesh_render('View',get(findobj(spm_figure('GetWin','Graphics'),'Tag','SPMMeshRender'),'Parent'),'bottom')
spm_print(figs);

clear matlabbatch
matlabbatch{1}.spm.stats.results.spmmat = {fullfile(outpth,'meg','IndMSPStats','SPM.mat')};
matlabbatch{1}.spm.stats.results.conspec.contrasts = 2;
matlabbatch{1}.spm.stats.results.conspec.threshdesc = 'FWE';
matlabbatch{1}.spm.stats.results.conspec.thresh = 0.05;
matlabbatch{1}.spm.stats.results.conspec.extent = 0;
matlabbatch{1}.spm.stats.results.conspec.mask.none = 1;
matlabbatch{1}.spm.stats.results.units = 1;
matlabbatch{1}.spm.stats.results.export = cell(1, 0);
spm_jobman('run',matlabbatch);
spm_mesh_render('View',get(findobj(spm_figure('GetWin','Graphics'),'Tag','SPMMeshRender'),'Parent'),'bottom')
spm_print(figs);


% Figure 9
%==========================================================================
clear matlabbatch
matlabbatch{1}.spm.stats.results.spmmat = {fullfile(outpth,'meg','fMRIGrpMNMStats','SPM.mat')};
matlabbatch{1}.spm.stats.results.conspec.contrasts = 2;
matlabbatch{1}.spm.stats.results.conspec.threshdesc = 'FWE';
matlabbatch{1}.spm.stats.results.conspec.thresh = 0.05;
matlabbatch{1}.spm.stats.results.conspec.extent = 0;
matlabbatch{1}.spm.stats.results.conspec.mask.none = 1;
matlabbatch{1}.spm.stats.results.units = 1;
matlabbatch{1}.spm.stats.results.export = cell(1, 0);
spm_jobman('run',matlabbatch);
spm_mesh_render('View',get(findobj(spm_figure('GetWin','Graphics'),'Tag','SPMMeshRender'),'Parent'),'bottom')
spm_print(figs);

clear matlabbatch
matlabbatch{1}.spm.stats.results.spmmat = {fullfile(outpth,'meg','fMRIGrpMSPStats','SPM.mat')};
matlabbatch{1}.spm.stats.results.conspec.contrasts = 2;
matlabbatch{1}.spm.stats.results.conspec.threshdesc = 'none';
matlabbatch{1}.spm.stats.results.conspec.thresh = 0.001;
matlabbatch{1}.spm.stats.results.conspec.extent = 0;
matlabbatch{1}.spm.stats.results.conspec.mask.none = 1;
matlabbatch{1}.spm.stats.results.units = 1;
matlabbatch{1}.spm.stats.results.export = cell(1, 0);
spm_jobman('run',matlabbatch);
spm_mesh_render('View',get(findobj(spm_figure('GetWin','Graphics'),'Tag','SPMMeshRender'),'Parent'),'bottom')
spm_print(figs);



% Figure A1.1
%==========================================================================
D = spm_eeg_load(fullfile(outpth,'sub-15','meg','wrmcetf_dspmeeg_sub-15_ses-meg_task-facerecognition_run-01_proc-sss_meg.mat'));
spm_eeg_review(D,1)
% click on +
spm_print(figs);
D = spm_eeg_load(fullfile(outpth,'sub-15','meg','wmcetph_dspmeeg_sub-15_ses-meg_task-facerecognition_run-01_proc-sss_meg.mat'));
spm_eeg_review(D,1)
% click on +
spm_print(figs);


% Figure A1.2
%==========================================================================
clear matlabbatch
matlabbatch{1}.spm.stats.results.spmmat = {fullfile(outpth,'meg','TFStats','PowStats','eeg','SPM.mat')};
matlabbatch{1}.spm.stats.results.conspec.titlestr = '';
matlabbatch{1}.spm.stats.results.conspec.contrasts = 2;
matlabbatch{1}.spm.stats.results.conspec.threshdesc = 'none';
matlabbatch{1}.spm.stats.results.conspec.thresh = 0.001;
matlabbatch{1}.spm.stats.results.conspec.extent = 0;
matlabbatch{1}.spm.stats.results.conspec.conjunction = 1;
matlabbatch{1}.spm.stats.results.conspec.mask.none = 1;
matlabbatch{1}.spm.stats.results.units = 4;
matlabbatch{1}.spm.stats.results.export = cell(1, 0);
spm_jobman('run',matlabbatch);
XYZmm = [12 165 1];
XYZmm = spm_XYZreg('SetCoords',XYZmm,hReg);
spm_print(figs);


% Figure A1.3
%==========================================================================
clear matlabbatch
matlabbatch{1}.spm.stats.results.spmmat = {fullfile(outpth,'meg','TFStats','PhsStats','eeg','SPM.mat')};
matlabbatch{1}.spm.stats.results.conspec.contrasts = 2;
matlabbatch{1}.spm.stats.results.conspec.threshdesc = 'none';
matlabbatch{1}.spm.stats.results.conspec.thresh = 0.001;
matlabbatch{1}.spm.stats.results.conspec.extent = 0;
matlabbatch{1}.spm.stats.results.conspec.mask.none = 1;
matlabbatch{1}.spm.stats.results.units = 4;
matlabbatch{1}.spm.stats.results.export = cell(1, 0);
spm_jobman('run',matlabbatch);
XYZmm = [17 170 1];
XYZmm = spm_XYZreg('SetCoords',XYZmm,hReg);
spm_print(figs);


% Figure A2.1
%==========================================================================
clear matlabbatch
matlabbatch{1}.spm.stats.results.spmmat = {fullfile(outpth,'func','SPM.mat')};
matlabbatch{1}.spm.stats.results.conspec.contrasts = 2;
matlabbatch{1}.spm.stats.results.conspec.threshdesc = 'FWE';
matlabbatch{1}.spm.stats.results.conspec.thresh = 0.05;
matlabbatch{1}.spm.stats.results.conspec.extent = 30;
matlabbatch{1}.spm.stats.results.conspec.mask.none = 1;
matlabbatch{1}.spm.stats.results.units = 1;
matlabbatch{1}.spm.stats.results.export = cell(1, 0);
spm_jobman('run',matlabbatch);
spm_print(figs);

