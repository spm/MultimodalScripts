% SPM12 script to analyse the multi-subject, multi-modal human neuroimaging
% dataset described in Henson et al. (2018) Special Issue in Frontiers
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


% Add SPM12 r7487 to the MATLAB path
addpath('/local/Frontiers/openneuro/MultisubjectMultimodalv1.0.2/code/spm12');

spm('asciiwelcome');

%% Input arguments
%==========================================================================
rawpth = '/local/Frontiers/openneuro/MultisubjectMultimodalv1.0.2/';              % Directory containing the raw data
scrpth = fullfile(rawpth,'code','scripted');          % Directory containing the SPM analysis scripts
outpth = fullfile(rawpth,'derivatives',spm('Ver'));   % Output directory

keepdata   = false; % If false, intermediate files will be deleted to save disk space

numworkers = 0; % Number of workers for distributed computing
if numworkers, parpool(numworkers); end

% Epoch boundaries around the visual stimuli
timewin    = [-100 500];

% The set of frequencies for time-frequency analysis
freqs      =  6:40;

%% Parse BIDS-formatted dataset
%==========================================================================
BIDS   = spm_BIDS(rawpth);

subs   = spm_BIDS(BIDS,'subjects', 'task','facerecognition');
nsub   = numel(subs);
subdir = cellfun(@(s) ['sub-' s], subs, 'UniformOutput',false);

%% Prepare output directory
%==========================================================================

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
    'CodeURL','https://www.fil.ion.ucl.ac.uk/spm/',...
    'License','Creative Commons Attribution 4.0 International Public License'),...
    struct('indent','  '));

%-Copy and gunzip T1 MPRAGE images
%--------------------------------------------------------------------------
for s = 1:nsub
    f = spm_BIDS(BIDS,'data','sub',subs{s},'modality','anat','type','T1w','acq','mprage');
    spm_copy(f, fullfile(outpth,subdir{s},'anat'), 'gunzip',true);
end

fprintf('%s%30s\n',repmat(sprintf('\b'),1,30),'...done')                %-#
fprintf('%-40s: %30s\n','Completed',spm('time'));                       %-#


%% Preprocessing M/EEG data 
%==========================================================================
spm_jobman('initcfg');
spm('defaults','EEG');
spm_get_defaults('cmdline',true);

tic
parfor (s = 1:nsub, numworkers)
    if numworkers > 0
        spm_jobman('initcfg');
        spm('defaults', 'EEG');
        spm_get_defaults('cmdline',true);
    end
    
    runs = spm_BIDS(BIDS,'runs', 'sub',subs{s}, 'modality','meg', 'type','meg');
    
    % Change to subject's directory
    cd(fullfile(outpth,subdir{s},'meg'));
    
    Dc = {};
    
    %% Convert, update channels and event times, downsample
    for r = 1:numel(runs)
         
        S = [];       
        % The sss maxfiltered .fif data files are in derivatives/meg_derivatives
        S.dataset = fullfile(rawpth,'derivatives','meg_derivatives',subdir{s},'ses-meg','meg',[subdir{s} '_ses-meg_task-facerecognition_run-' runs{r} '_proc-sss_meg.fif']);
        S.mode = 'continuous';
        S.channels = {'EEG', 'MEGMAG', 'MEGPLANAR'};
        S.checkboundary = 1;
        D = spm_eeg_convert(S);
        
        % Set channel types and bad channels
        S = [];
        S.D    = D;
        S.task = 'bidschantype';
        S.save = 1;
        S.filename = fullfile(rawpth,subdir{s},'ses-meg',[subdir{s} '_ses-meg_task-facerecognition_channels.tsv']);
        D = spm_eeg_prep(S);
             
        S.D    = D;
        S.task = 'bidschanstatus';
        D = spm_eeg_prep(S);
        
        % Load events stored in BIDS
        S = [];
        S.D        = D;
        S.task     = 'loadbidsevents';
        S.replace  = 1;
        S.filename = char(spm_BIDS(BIDS,'data','ses','meg','sub',subs{s},'run', runs{r},'type','events'));
        D = spm_eeg_prep(S);
        
        % Downsample the data
        S = [];
        S.D = D;
        S.method = 'resample';
        S.fsample_new = 200;
        D = spm_eeg_downsample(S);
        
        if ~keepdata, delete(S.D); end
        
        Dc{r} = D.save();        
    end

    
    De = {};
    for r = 1:numel(runs)
        % High-pass filter above 1 Hz
        S = [];
        S.D = Dc{r};
        S.type = 'butterworth';
        S.band = 'high';
        S.freq = 1; % Cutoff frequency
        S.dir = 'twopass';
        S.order = 5;
        S.prefix = 'f';
        D = spm_eeg_filter(S);
        
        % Low-pass filter below 40Hz
        S = [];
        S.D = D;
        S.type = 'butterworth';
        S.band = 'low';
        S.freq = 40; % Cutoff frequency
        S.dir = 'twopass';
        S.order = 5;
        S.prefix = 'f';
        D = spm_eeg_filter(S);
        
        if ~keepdata, delete(S.D); end
             
        % Epoch the data defining 3 trial types: Famous, Unfamiliar and
        % Scrambled faces
        S = [];
        S.D = D;
        S.timewin = timewin;
        S.trialdef(1).conditionlabel = 'Famous';
        S.trialdef(1).eventtype  = 'BIDS';
        S.trialdef(1).eventvalue = 'Famous';
        S.trialdef(2).conditionlabel = 'Unfamiliar';
        S.trialdef(2).eventtype  = 'BIDS';
        S.trialdef(2).eventvalue = 'Unfamiliar';
        S.trialdef(3).conditionlabel = 'Scrambled';
        S.trialdef(3).eventtype  = 'BIDS';
        S.trialdef(3).eventvalue = 'Scrambled';
        S.bc = 0;
        S.prefix = 'e';
        S.eventpadding = 0;
        D = spm_eeg_epochs(S);
        
        if ~keepdata, delete(S.D); end
        
        De{r} = D;
    end
    
    % Merge across runs
    S = [];
    S.D = De;
    S.prefix = 'c';
    D = spm_eeg_merge(S);
    
    if ~keepdata
        for i = 1:numel(De)
            delete(De{i});
        end
    end
    
    % Define average reference montage excluding bad channels
    eegchan = D.indchantype('EEG');
    goodind = D.indchantype('EEG', 'GOOD');
    
    goodind = find(ismember(eegchan, goodind));
    
    tra              =  eye(length(eegchan));
    tra(: ,goodind)  =  tra(:, goodind) - 1/length(goodind);
    
    montage          = [];
    montage.labelorg = D.chanlabels(eegchan);
    montage.labelnew = D.chanlabels(eegchan);
    montage.tra      = tra;
    
    % Apply montage
    S = [];
    S.D = D;
    S.mode = 'write';
    S.prefix = 'M';
    S.montage = montage;
    S.keepothers = 1;
    S.keepsensors = 1;
    D = spm_eeg_montage(S);
    
    if ~keepdata, delete(S.D); end
    
    % Artefact detection by thresholding the EOG channels
    S = [];
    S.D = D;
    S.mode = 'reject';
    S.badchanthresh = 0.2;
    S.methods.channels = {'EOG'};
    S.methods.fun = 'threshchan';
    S.methods.settings.threshold = 200; % Threshold value
    S.methods.settings.excwin = 1000;
    S.append = true;
    S.prefix = 'a';
    D = spm_eeg_artefact(S); 
    
    if ~keepdata, delete(S.D); end
    
    % Set condition order for the source reconstruction images
    D = condlist(D, {'Famous',  'Unfamiliar', 'Scrambled'});
    D.save;
    Dl = D; % Keep Dl for localisation (before combining grads)
    
    % Combine planar gradiometers for sensor-level analysis
    S = [];
    S.D = D;
    S.mode = 'append';
    S.prefix = 'P';
    D = spm_eeg_combineplanar(S);
    
    
    % Average
    S = [];
    S.D = D;
    S.robust = false;
    S.circularise = false;
    S.prefix = 'm';
    D = spm_eeg_average(S);
    
    % Contrast conditions
    S = [];
    S.D = D;
    S.c = [1 0 0; 0 1 0; 0 0 1; 0.5 0.5 -1; 1 -1 0];
    S.label = {
        'Famous'
        'Unfamiliar'
        'Scrambled'
        'Faces - Scrambled'
        'Famous - Unfamiliar'
        }';
    S.weighted = 0;
    S.prefix = 'w';
    spm_eeg_contrast(S);
    
    
    %% Source analysis (create forward model)
    mrifidfile = fullfile(rawpth,subdir{s},'ses-mri','anat', ['sub-' subs{s} '_ses-mri_acq-mprage_T1w.json']);

    jobfile = {fullfile(scrpth,'batch_forward_model_job.m')}; 
    inputs = cell(3,1);
    inputs{1} = {fullfile(Dl)};
    inputs{2} = {spm_select('FPList',fullfile(outpth,subdir{s},'anat'),'^sub-.*_T1w\.nii$')};
    inputs{3} = {mrifidfile};

    spm_jobman('run', jobfile, inputs{:});
    
    Dl = reload(Dl);
    
    %% MSP inversion of EEG, MEG, MEGPLANAR, ALL, then IID inversion of ALL and a time-freq contrast
    jobfile = {fullfile(scrpth,'batch_localise_meeg_job.m')}; 
    inputs = cell(8,1);
    inputs{1} = {fullfile(Dl)};
    inputs{2} = 1;
    inputs{3} = {''};  % No fMRI priors
    inputs{4} = {fullfile(Dl)};
    inputs{5} = 2;
    inputs{6} = {''};  % No fMRI priors
    inputs{7} = 1;
    inputs{8} = 2;
    spm_jobman('run', jobfile, inputs{:});
    
    Dl = reload(Dl);
 
    Dl.inv{1}.comment = 'MNM'; 
    Dl.inv{2}.comment = 'MSP';
    Dl.save;
end
checkp1=toc;




%% Group stats of individual inversions of IID and GS
%==========================================================================

prefix = 'aMceffdspmeeg';

srcstatsdir{1} = fullfile(outpth,'meg','IndMNMStats');
srcstatsdir{2} = fullfile(outpth,'meg','IndMSPStats');

jobfile = {fullfile(scrpth,'batch_stats_rmANOVA_job.m')};

for val = 1:length(srcstatsdir)
    
    inputs  = cell(nsub+1, 1);
    inputs{1} = {srcstatsdir{val}};
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
%fmriprior = fullfile(outpth,'func','spmT_0002_05cor.nii');% fMRI priors after running Appendix 2 below
fmriprior = fullfile(scrpth,'..','spmT_0002_05cor.nii');
inputs = cell(8,1);
inputs{1} = tmp;
inputs{2} = 3;
inputs{3} = {fmriprior};
inputs{4} = tmp;
inputs{5} = 4;
inputs{6} = {fmriprior};
inputs{7} = 3;
inputs{8} = 4;
spm_jobman('run', jobfile, inputs{:});


% Group stats of group inversions of IID and GS with fMRI

srcstatsdir{3} = fullfile(outpth,'meg','fMRIGrpMNMStats');
srcstatsdir{4} = fullfile(outpth,'meg','fMRIGrpMSPStats');

jobfile = {fullfile(scrpth,'batch_stats_rmANOVA_job.m')};

for val = 3:length(srcstatsdir)
    inputs  = cell(nsub+1, 1);
    inputs{1} = {srcstatsdir{val}};
    for s = 1:nsub
        inputs{s+1,1} =  cellstr(spm_select('FPList',fullfile(outpth,subdir{s},'meg'),sprintf('^%s.*%s_.*_meg_%d.*\\.gii$', prefix, subdir{s}, val)));    % Contrasts 1-3 assumed to be Famous, Unfamiliar, Scrambled
    end
    
    spm_jobman('run', jobfile, inputs{:});
end

return


%% Appendix 1: Time-Frequency analysis of M/EEG
% (Assumes main code above has been run already)
%==========================================================================

tic
parfor (s = 1:nsub, numworkers)
    if numworkers > 0
        spm_jobman('initcfg');
        spm('defaults', 'EEG');
        spm_get_defaults('cmdline',true);
    end
    
    runs = spm_BIDS(BIDS,'runs', 'sub',subs{s}, 'modality','meg', 'type','meg');
    
    % Change to subject's directory
    cd(fullfile(outpth,subdir{s},'meg'));
    
    De = {};
    
    %% Convert, update channels and event times, downsample
    for r = 1:numel(runs)
        
        % Wavelet decomposition
        D = {};
        S = [];
        S.D = spm_eeg_load(sprintf('dspmeeg_sub-%02d_ses-meg_task-facerecognition_run-%02d_proc-sss_meg.mat',s,r));
        S.channels = {'EEG070','MEG2121','MEG2543'}; % Some sensors over right posterior cortex
        S.frequencies = freqs;
        S.timewin = [-Inf Inf];
        S.phase = 1;
        S.method = 'morlet';
        S.settings.ncycles = 5;  % This parameter determnines time vs. frequency resolution tradeoff. 3 and 7 could be good values to compare
        S.settings.timeres = 0;
        S.settings.subsample = 1; % This can be increased to reduce the data size
        S.prefix = '';
        [D{1}, D{2}] = spm_eeg_tf(S);
        
        if ~keepdata, delete(S.D); end
        
        for tf = 1:2
            % Epoch continuous time-frequency data
            S = [];
            S.D = D{tf};
            S.timewin = timewin;
            S.trialdef(1).conditionlabel = 'Famous';
            S.trialdef(1).eventtype  = 'BIDS';
            S.trialdef(1).eventvalue = 'Famous';
            S.trialdef(2).conditionlabel = 'Unfamiliar';
            S.trialdef(2).eventtype  = 'BIDS';
            S.trialdef(2).eventvalue = 'Unfamiliar';
            S.trialdef(3).conditionlabel = 'Scrambled';
            S.trialdef(3).eventtype  = 'BIDS';
            S.trialdef(3).eventvalue = 'Scrambled';
            S.bc = 0;
            S.prefix = 'e';
            S.eventpadding = 0;
            De{tf}{r} = spm_eeg_epochs(S);
            
            if ~keepdata, delete(S.D); end
        end
    end      
    
    % Merge across runs
    S = [];
    S.prefix = 'c';
    Df = {};
    for tf=1:2
        S.D = De{tf};
        Df{tf} = spm_eeg_merge(S);
        
        Df{tf} = condlist(Df{tf}, {'Famous',  'Unfamiliar', 'Scrambled'});
    end
    
    if ~keepdata
        for r=1:6
            delete(De{1}{r});
            delete(De{2}{r});
        end
    end
    De = [];
        
    % Average power and phase separately    
    S = [];
    S.robust = false;
    S.prefix = 'm';
    
    S.D = Df{1};
    S.circularise = false;
    Dpw = spm_eeg_average(S);
    
    if ~keepdata, delete(S.D); end
    
    S.D = Df{2};
    S.circularise = true;
    Dph = spm_eeg_average(S);
    
    if ~keepdata, delete(S.D); end
    Df = [];
    
    % Baseline correct (scale) the power
    S = [];
    S.method = 'LogR';
    S.prefix = 'r';
    S.timewin = [-100 0];
    
    S.D = Dpw;
    Dpw = spm_eeg_tf_rescale(S);
    
    if ~keepdata, delete(S.D); end
    
    % Contrast conditions    
    S = [];
    S.c = [0.5 0.5 -1; 1 -1 0];
    S.label = {
        'Faces - Scrambled'
        'Famous - Unfamiliar'
        }';
    S.weighted = 0;
    S.prefix = 'w';
    
    S.D = Dpw;
    spm_eeg_contrast(S);
    
    S.D = Dph;
    spm_eeg_contrast(S);
    
    %% Write out power and phase images for each modality
    S = [];
    S.mode = 'time x frequency';
    
    S.D = Dpw;
    
    S.channels = 'EEG';
    S.prefix   = 'eeg_img_pow_';
    spm_eeg_convert2images(S);
    
    S.channels = 'MEGMAG';
    S.prefix   = 'mag_img_pow_';
    spm_eeg_convert2images(S);
    
    S.channels = 'MEGPLANAR';
    S.prefix   = 'grd_img_pow_';
    spm_eeg_convert2images(S);
    
    S.D = Dph;
    
    S.channels = 'EEG';
    S.prefix   = 'eeg_img_phs_';
    spm_eeg_convert2images(S);
    
    S.channels = 'MEGMAG';
    S.prefix   = 'mag_img_phs_';
    spm_eeg_convert2images(S);
    
    S.channels = 'MEGPLANAR';
    S.prefix   = 'grd_img_phs_';
    spm_eeg_convert2images(S);
end

%% Time-freq power stats across subjects

cons = {'Famous','Unfamiliar','Scrambled'};
ncon = numel(cons);

mods = {'eeg', 'mag', 'grd'};
nmod = numel(mods);

spm_mkdir(outpth,'meg','TFStats','PowStats',mods);

jobfile = {fullfile(scrpth,'batch_stats_rmANOVA_job.m')};
jobs    = repmat(jobfile, 1, nmod);
inputs  = cell(nsub+1, nmod);

for m = 1:nmod
    inputs{1,m} = {fullfile(outpth,'meg','TFStats','PowStats',mods{m})};
    
    for s = 1:nsub
        imgdir = spm_select('FPList',fullfile(outpth,subdir{s},'meg'), 'dir', sprintf('%s_img_pow_.*', mods{m}));
        
        condfiles = cell(ncon,1);
        for c = 1:ncon
            condfiles{c} = fullfile(imgdir,sprintf('condition_%s.nii',cons{c}));
        end
        inputs{s+1,m} = condfiles;
    end
end

spm_jobman('run', jobs, inputs{:});


%% Time-freq phase stats across subjects

spm_mkdir(outpth,'meg','TFStats','PhsStats',mods);

jobfile = {fullfile(scrpth,'batch_stats_rmANOVA_job.m')};
jobs    = repmat(jobfile, 1, nmod);
inputs  = cell(nsub+1, nmod);

for m = 1:nmod
    inputs{1,m} = {fullfile(outpth,'meg','TFStats','PhsStats',mods{m})};
    
    for s = 1:nsub
        imgdir = spm_select('FPList',fullfile(outpth,subdir{s},'meg'), 'dir', sprintf('%s_img_phs_.*', mods{m}));
        
        condfiles = cell(ncon,1);
        for c = 1:ncon
            condfiles{c} = fullfile(imgdir,sprintf('condition_%s.nii',cons{c}));
        end
        inputs{s+1,m} = condfiles;
    end
end

spm_jobman('run', jobs, inputs{:});


        

%% Appendix 2: fMRI preprocessing and group analysis
%==========================================================================

runs = spm_BIDS(BIDS,'runs', 'modality','func', 'type','bold', 'task','facerecognition'); % across subjects
nrun = numel(runs);

%-Copy and gunzip fMRI images
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
