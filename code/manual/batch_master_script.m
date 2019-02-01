% SPM12 script to analyse the multi-subject, multi-modal human neuroimaging
% dataset described in Henson et al. (2018) Special Issue in Frontiers
%
% This version uses SPM batch jobs, rather than the direct calls to spm*.m
% functions in the corresponding spm_master_script.m
%
% Note that you will need to have latest version of SPM12 on your MATLAB
% path, which you can download from here:
%       https://www.fil.ion.ucl.ac.uk/spm/
%
% plus the data, available from the OpenNeuro database in BIDS format: 
%      https://openneuro.org/datasets/ds000117.
%
% (A non-BIDS version is available here: 
%      ftp://ftp.mrc-cbu.cam.ac.uk/personal/rik.henson/wakemandg_hensonrn/
% but the BIDS-specific parts of code below will need changing)
%
% rik.henson@mrc-cbu.cam.ac.uk                              May 2018
% with help from Guillaume Flandin and Vladimir Litvak

clear;

% Add SPM12 r7487 to the MATLAB path
%addpath('SPM12PATH');

spm('asciiwelcome');

%% Input arguments
%==========================================================================
rawpth = 'C:\Data\MultisubjectMultimodalv1.0.2';      % Directory containing the raw data
scrpth = fullfile(rawpth,'code');                     % Directory containing the SPM analysis scripts
outpth = fullfile(rawpth,'derivatives',spm('Ver'));   % Output directory

keepdata   = false; % If false, intermediate files will be deleted to save disk space

numworkers = 0; % Number of workers for distributed computing
if numworkers, parpool(numworkers); end


%% Parse BIDS-formatted dataset (no need to repeat if used spm_master_script)
%==========================================================================
BIDS   = spm_BIDS(rawpth);

subs   = spm_BIDS(BIDS,'subjects', 'task','facerecognition');
nsub   = numel(subs);
subdir = cellfun(@(s) ['sub-' s], subs, 'UniformOutput',false);

fprintf('%-40s: %30s', 'Copy files in derivatives','...');              %-#

%-Create output directory tree if necessary
%--------------------------------------------------------------------------
spm_mkdir(outpth,{'meg','func'});
spm_mkdir(outpth,subdir,{'meg','anat','func'});

%-Pipeline description
%--------------------------------------------------------------------------
spm_jsonwrite(fullfile(outpth,'pipeline_description.json'),struct(...
    'Name',spm('Ver'),...
    'Version',spm('Version'),...
    'CodeURL','http://www.fil.ion.ucl.ac.uk/spm/',...
    'License','Creative Commons Attribution 4.0 International Public License'),...
    struct('indent','  '));

%-Copy FIF files
%--------------------------------------------------------------------------
for s = 1:nsub
    runs = spm_BIDS(BIDS,'runs', 'sub',subs{s}, 'modality','meg', 'type','meg');
    for r = 1:numel(runs)
        f = fullfile(rawpth,'derivatives','meg_derivatives',subdir{s},'ses-meg','meg',[subdir{s} '_ses-meg_task-facerecognition_run-' runs{r} '_proc-sss_meg.fif']);
        spm_copy(f, fullfile(outpth,subdir{s},'meg'));
    end
end

%-Copy and gunzip T1 MPRAGE images
%--------------------------------------------------------------------------
for s = 1:nsub
    f = spm_BIDS(BIDS,'data','sub',subs{s},'modality','anat','type','T1w','acq','mprage');
    spm_copy(f, fullfile(outpth,subdir{s},'anat'), 'gunzip',true);
end

fprintf('%-40s: %30s\n','Completed',spm('time'));                       %-#


%% MEEG Preprocessing
%==========================================================================

tic
parfor (s = [1:nsub], numworkers)
%for (s = 1:nsub)    
    if numworkers > 0
        spm_jobman('initcfg');
        spm('defaults', 'EEG');
        spm_get_defaults('cmdline',true);
    end
    
    %% Change to subject's directory
    swd = fullfile(outpth,subdir{s},'meg');
    cd(swd);
    
    runs = spm_BIDS(BIDS,'runs', 'sub', subs{s}, 'modality','meg', 'type','meg');
    nrun = numel(runs);
    
    jobs_er_convert = repmat({fullfile(scrpth,'batch_er_convert_epoch_job.m')}, 1, nrun);
    jobs_er_merge =          {fullfile(scrpth,'batch_er_merge_contrast_job.m')};

    % Convert to epoching
    inputs = cell(4, nrun);    
    for r = 1:nrun
        inputs{1, r} = cellstr(char(spm_BIDS(BIDS,'data','sub',subs{s},'type','meg','run', runs{r}, 'proc', 'sss')));
        inputs{2, r} = cellstr(char(spm_BIDS(BIDS,'data','ses','meg','sub',subs{s},'run', runs{r},'type','channels')));
        inputs{3, r} = cellstr(char(spm_BIDS(BIDS,'data','ses','meg','sub',subs{s},'run', runs{r},'type','channels')));        
        inputs{4, r} = cellstr(char(spm_BIDS(BIDS,'data','sub',subs{s},'modality','meg','type','events','run',runs{r})));        
    end
    spm_jobman('serial', jobs_er_convert,'', inputs{:});
 
    % Merge to contrast
    inputs  = cell(1, 1);
    inputs{1} = cellstr(spm_select('FPList',fullfile(swd),'effdspmeeg.*\.mat$'));
    spm_jobman('serial', jobs_er_merge, '', inputs{:});
end


%% Source analysis 
%==========================================================================

%-Copy T1 MPRAGE images (so don't alter contents of BIDS)
%--------------------------------------------------------------------------
for s = 1:nsub
    f = spm_BIDS(BIDS,'data','sub',subs{s},'modality','anat','type','T1w','acq','mprage');
    spm_copy(f, fullfile(outpth,subdir{s},'anat'), 'gunzip',true);
end

job_forward_model = {fullfile(scrpth,'batch_forward_model_job.m')};
job_inverse_model = {fullfile(scrpth,'batch_localise_meeg_job.m')};

parfor (s = [1:nsub], numworkers)
%for (s = 1:nsub)    
        
    % Create forward models for each modality
    inputs  = cell(3, 1);
    inputs{1} = cellstr(spm_select('FPList',fullfile(outpth,subdir{s},'meg'),'^aMceffdspmeeg.*\.mat'));
    inputs{2} = cellstr(spm_select('FPList',fullfile(outpth,subdir{s},'anat'),'^sub-.*_T1w\.nii$'));
    inputs{3} = cellstr(spm_select('FPList',fullfile(outpth,subdir{s},'anat'),'^sub-.*_T1w\.json')); 
    spm_jobman('serial', job_forward_model, '', inputs{:});  

    % Invert combined models using MMN and MSP, followed by time-freq contrast 
    inputs = cell(8,1);
    inputs{1} = cellstr(spm_select('FPList',fullfile(outpth,subdir{s},'meg'),'^aMceffdspmeeg.*\.mat'));
    inputs{2} = 1;
    inputs{3} = {''};  % No fMRI priors
    inputs{4} = cellstr(spm_select('FPList',fullfile(outpth,subdir{s},'meg'),'^aMceffdspmeeg.*\.mat'));
    inputs{5} = 2;
    inputs{6} = {''};  % No fMRI priors
    inputs{7} = 1;
    inputs{8} = 2;
    spm_jobman('serial', job_inverse_model, '', inputs{:});
end
 

%% Group stats of individual inversions of IID and GS
%==========================================================================

prefix = 'aMceffdspmeeg';
invtypes = {'IndMMN','IndMSP'};

jobfile = {fullfile(scrpth,'batch_stats_rmANOVA_job.m')};

for val = 1:length(invtypes)
    spm_mkdir(fullfile(outpth,'meg',sprintf('%sStats',invtypes{val})));  
    
    inputs  = cell(nsub+1, 1);
    inputs{1} = cellstr(fullfile(outpth,'meg',sprintf('%sStats',invtypes{val})));
    for s = 1:nsub
        inputs{s+1,1} = cellstr(spm_select('FPList',fullfile(outpth,subdir{s},'meg'),sprintf('^%s.*%s_.*_meg_%d.*\\.gii$', prefix, subdir{s}, val)));   % Contrasts 1-3 assumed to be Famous, Unfamiliar, Scrambled
    end
    
    spm_jobman('run', jobfile, inputs{:});
end


%% Group inversion with fMRI priors
%==========================================================================

jobfile = {fullfile(scrpth,'batch_localise_meeg_job.m')};
tmp = cell(nsub,1);
for s = 1:nsub
    tmp{s} = spm_select('FPList',fullfile(outpth,subdir{s},'meg'),sprintf('^%s.*\\.mat$',prefix));
end
inputs = cell(8,1);
inputs{1} = tmp;
inputs{2} = 3;
inputs{3} = {fullfile(outpth,'func','spmT_0002_05cor.nii')};  % fMRI priors (this file needs to be copied from somewhere if fMRI analyses not run above)
inputs{4} = tmp;
inputs{5} = 4;
inputs{6} = {fullfile(outpth,'func','spmT_0002_05cor.nii')};  % fMRI priors
inputs{7} = 3;
inputs{8} = 4;
spm_jobman('run', jobfile, inputs{:});


%% Group stats of group inversions of IID and GS with fMRI
%==========================================================================

invtypes = {'GrpfMRIMMN','GrpfMRIMSP'};

jobfile = {fullfile(scrpth,'batch_stats_rmANOVA_job.m')};

for val = 1:length(invtypes)

    spm_mkdir(fullfile(outpth,'meg',sprintf('%sStats',invtypes{val})));  
    
    inputs  = cell(nsub+1, 1);
    inputs{1} = cellstr(fullfile(outpth,'meg',sprintf('%sStats',invtypes{val})));
    for s = 1:nsub
        inputs{s+1,1} = cellstr(spm_select('FPList',fullfile(outpth,subdir{s},'meg'),sprintf('^%s.*%s_.*_meg_%d.*\\.gii$', prefix, subdir{s}, val+2)));   % +2 because inversion indices 3 and 4. Contrasts 1-3 assumed to be Famous, Unfamiliar, Scrambled
    end
    
    spm_jobman('run', jobfile, inputs{:});
end


return


%% Appendix 1: Time-freq power stats across subjects
%==========================================================================
parfor (s = [1:nsub], numworkers)
%for (s = 1:nsub)    
    if numworkers > 0
        spm_jobman('initcfg');
        spm('defaults', 'EEG');
        spm_get_defaults('cmdline',true);
    end
    
    % Change to subject's directory
    swd = fullfile(outpth,subdir{s},'meg');
    cd(swd);
    
    runs = spm_BIDS(BIDS,'runs', 'sub',subs{s}, 'modality','meg', 'type','meg');
    nrun = numel(runs);
    
    jobs_tf_wavelet = repmat({fullfile(scrpth,'batch_tf_wavelet_epoch_job.m')}, 1, nrun);
    jobs_tf_merge =          {fullfile(scrpth,'batch_tf_merge_contrast_job.m')};

    % Wavelets and epoching
    inputs = cell(1, nrun);    
    for r = 1:nrun
        inputs{1, r} = cellstr(fullfile(swd,sprintf('dspmeeg_sub-%02d_ses-meg_task-facerecognition_run-%02d_proc-sss_meg.mat',s,r)));
    end
    spm_jobman('serial', jobs_tf_wavelet,'', inputs{:});
    
    % Merge to contrast
    inputs  = cell(2, 1);
    inputs{1} = cellstr(spm_select('FPList',fullfile(swd),'etf_dspmeeg.*\.mat$'));
    inputs{2} = cellstr(spm_select('FPList',fullfile(swd),'etph_dspmeeg.*\.mat$'));

    spm_jobman('serial', jobs_tf_merge, '', inputs{:});
end



%% Time-freq power stats across subjects

datatypes = {'pow','phs'};

jobfile = {fullfile(scrpth,'batch_stats_rmANOVA_job.m')};
jobs    = repmat(jobfile, 1, nmod);

for p=1:length(datatypes)
    spm_mkdir(outpth,'meg',sprintf('%sStats',datatypes{p}),mods);
    
    inputs  = cell(nsub+1, nmod);
    
    for m = 1:nmod
        inputs{1,m} = {fullfile(outpth,'meg',sprintf('%sStats', datatypes{p}), mods{m})};
        
        for s = 1:nsub
            imgdir = spm_select('FPList',fullfile(outpth,subdir{s},'meg'), 'dir', sprintf('%s_img_%s_.*', mods{m}, datatypes{p}));
            
            condfiles = cell(ncon,1);
            for c = 1:ncon
                condfiles{c} = fullfile(imgdir,sprintf('condition_%s.nii',cons{c}));
            end
            inputs{s+1,m} = condfiles;
        end
    end
    spm_jobman('run', jobs, inputs{:});
end


%% Appendix 2: fMRI preprocessing and group analysis
%==========================================================================

runs = spm_BIDS(BIDS,'runs', 'modality','func', 'type','bold', 'task','facerecognition'); % across subjects
nrun = numel(runs);

%-Copy and gunzip fMRI images (no need if done in spm_master_script)
%--------------------------------------------------------------------------
for s = 1:nsub
    f = spm_BIDS(BIDS,'data','sub',subs{s},'modality','func','type','bold');
    spm_copy(f, fullfile(outpth,subdir{s},'func'), 'gunzip',true);
end


spm_jobman('initcfg');
spm('defaults', 'fmri');
spm_get_defaults('cmdline',true);

% Create SPM's multiple conditions files
%--------------------------------------------------------------------------
trialtypes = {'Famous','Unfamiliar','Scrambled'}; % impose order
for s = 1:nsub
    for r = 1:nrun
        d = spm_load(char(spm_BIDS(BIDS,'data','modality','func','type','events','sub',subs{s},'run',runs{r})));
        clear conds
        for t = 1:numel(trialtypes)
            conds.names{t} = trialtypes{t};
            conds.durations{t} = 0;
            conds.onsets{t} = d.onset(strcmpi(d.stim_type,trialtypes{t})); 
        end
        save(fullfile(outpth,subdir{s},'func',sprintf('sub-%s_run-%s_spmdef.mat',subs{s},runs{r})),'-struct','conds');
    end
end


tic;
parfor (s = 1:nsub, numworkers)
    
    if numworkers > 0
        spm_jobman('initcfg');
        spm('defaults', 'fmri');
        spm_get_defaults('cmdline',true);
    end
    
    % Change to subject's directory
    cd(fullfile(outpth,subdir{s},'func'));
    
    % Preprocessing
    %----------------------------------------------------------------------
    jobfile = {fullfile(scrpth,'batch_preproc_fmri_job.m')};
    inputs  = cell(nrun+2,1);
    for r = 1:nrun
        inputs{r} = cellstr(spm_select('FPList',fullfile(outpth,subdir{s},'func'),sprintf('^sub-.*run-%s_bold\\.nii',runs{r})));
    end
    inputs{nrun+1} = cellstr(spm_select('FPList',fullfile(outpth,subdir{s},'anat'),'^sub-.*_T1w\.nii$'));
    inputs{nrun+2} = cellstr(spm_select('FPList',fullfile(outpth,subdir{s},'anat'),'^sub-.*_T1w\.nii$'));
    spm_jobman('run', jobfile, inputs{:});
    
    % First-level statistics
    %----------------------------------------------------------------------
    jobfile = {fullfile(scrpth,'batch_stats_fmri_job.m')};
    inputs  = {}; %cell(nrun*3+1,1);
    inputs{1} = {fullfile(outpth,subdir{s},'func','Stats')};
    for r = 1:nrun
        inputs{end+1} = cellstr(spm_select('FPList',fullfile(outpth,subdir{s},'func'),sprintf('^swsub-.*run-%s_bold\\.nii$',runs{r})));
        inputs{end+1} = cellstr(fullfile(outpth,subdir{s},'func',sprintf('sub-%s_run-%s_spmdef.mat',subs{s},runs{r})));
        inputs{end+1} = cellstr(spm_select('FPList',fullfile(outpth,subdir{s},'func'),sprintf('^rp.*run-%s.*\\.txt$',runs{r})));
    end
    spm_jobman('run', jobfile, inputs{:});
    
    if ~keepdata
        f = cellstr(spm_select('FPList',fullfile(outpth,subdir{s},'func'),'^sub-.*_bold.*'));
        spm_unlink(f{:});
        f = cellstr(spm_select('FPList',fullfile(outpth,subdir{s},'func'),'^w.*_bold.*'));
        spm_unlink(f{:});
    end
end
checkp2=toc;


% fMRI stats across subjects
%--------------------------------------------------------------------------
jobfile = {fullfile(scrpth,'batch_stats_rmANOVA_job.m')};
inputs  = cell(nsub+1, 1);
inputs{1} = {fullfile(outpth,'func')};
for s = 1:nsub
    inputs{s+1,1} = cellstr(spm_select('FPList',fullfile(outpth,subdir{s},'func','Stats'),'^con_000[345]\.nii$'));   % Assumes that these T-contrasts in fMRI 1st-level models are famous, unfamiliar, scrambled (averaged across sessions)
end
spm_jobman('run', jobfile, inputs{:});

% Save masks of "faces > scrambled", p<0.05 FWE
%--------------------------------------------------------------------------
clear matlabbatch
matlabbatch{1}.spm.stats.results.spmmat = {fullfile(outpth,'func','SPM.mat')};
matlabbatch{1}.spm.stats.results.conspec.contrasts = 2;
matlabbatch{1}.spm.stats.results.conspec.threshdesc = 'FWE';
matlabbatch{1}.spm.stats.results.conspec.thresh = 0.05;
matlabbatch{1}.spm.stats.results.conspec.extent = 30;
matlabbatch{1}.spm.stats.results.export{1}.binary.basename = '05cor';
spm_jobman('run', matlabbatch);

% The resulting thresholded maskimage "spmT_0002_05cor.nii" can then be 
% used in the fMRI-constrained source localisation above 
