%-----------------------------------------------------------------------
% Job saved on 27-Sep-2017 15:47:54 by cfg_util (rev $Rev: 37 $)
% spm SPM - SPM12 (12.3)
% cfg_basicio BasicIO - Unknown
%-----------------------------------------------------------------------
matlabbatch{1}.spm.meeg.tf.tf.D = '<UNDEFINED>';
matlabbatch{1}.spm.meeg.tf.tf.channels{1}.chan = 'EEG070';
matlabbatch{1}.spm.meeg.tf.tf.channels{2}.chan = 'MEG2121';
matlabbatch{1}.spm.meeg.tf.tf.channels{3}.chan = 'MEG2543';
matlabbatch{1}.spm.meeg.tf.tf.frequencies = [6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40];
matlabbatch{1}.spm.meeg.tf.tf.timewin = [-Inf Inf];
matlabbatch{1}.spm.meeg.tf.tf.method.morlet.ncycles = 5;
matlabbatch{1}.spm.meeg.tf.tf.method.morlet.timeres = 0;
matlabbatch{1}.spm.meeg.tf.tf.method.morlet.subsample = 1;
matlabbatch{1}.spm.meeg.tf.tf.phase = 1;
matlabbatch{1}.spm.meeg.tf.tf.prefix = '';
matlabbatch{2}.spm.meeg.preproc.epoch.D(1) = cfg_dep('Time-frequency analysis: M/EEG time-frequency power dataset', substruct('.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','Dtfname'));
matlabbatch{2}.spm.meeg.preproc.epoch.trialchoice.define.timewin = [-100 500];
matlabbatch{2}.spm.meeg.preproc.epoch.trialchoice.define.trialdef(1).conditionlabel = 'Famous';
matlabbatch{2}.spm.meeg.preproc.epoch.trialchoice.define.trialdef(1).eventtype = 'BIDS';
matlabbatch{2}.spm.meeg.preproc.epoch.trialchoice.define.trialdef(1).eventvalue = 'Famous';
matlabbatch{2}.spm.meeg.preproc.epoch.trialchoice.define.trialdef(1).trlshift = 0;
matlabbatch{2}.spm.meeg.preproc.epoch.trialchoice.define.trialdef(2).conditionlabel = 'Unfamiliar';
matlabbatch{2}.spm.meeg.preproc.epoch.trialchoice.define.trialdef(2).eventtype = 'BIDS';
matlabbatch{2}.spm.meeg.preproc.epoch.trialchoice.define.trialdef(2).eventvalue = 'Unfamiliar';
matlabbatch{2}.spm.meeg.preproc.epoch.trialchoice.define.trialdef(2).trlshift = 0;
matlabbatch{2}.spm.meeg.preproc.epoch.trialchoice.define.trialdef(3).conditionlabel = 'Scrambled';
matlabbatch{2}.spm.meeg.preproc.epoch.trialchoice.define.trialdef(3).eventtype = 'BIDS';
matlabbatch{2}.spm.meeg.preproc.epoch.trialchoice.define.trialdef(3).eventvalue = 'Scrambled';
matlabbatch{2}.spm.meeg.preproc.epoch.trialchoice.define.trialdef(3).trlshift = 0;
matlabbatch{2}.spm.meeg.preproc.epoch.bc = 0;
matlabbatch{2}.spm.meeg.preproc.epoch.eventpadding = 0;
matlabbatch{2}.spm.meeg.preproc.epoch.prefix = 'e';
matlabbatch{3}.spm.meeg.preproc.epoch.D(1) = cfg_dep('Time-frequency analysis: M/EEG time-frequency phase dataset', substruct('.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','Dtphname'));
matlabbatch{3}.spm.meeg.preproc.epoch.trialchoice.define.timewin = [-100 500];
matlabbatch{3}.spm.meeg.preproc.epoch.trialchoice.define.trialdef(1).conditionlabel = 'Famous';
matlabbatch{3}.spm.meeg.preproc.epoch.trialchoice.define.trialdef(1).eventtype = 'BIDS';
matlabbatch{3}.spm.meeg.preproc.epoch.trialchoice.define.trialdef(1).eventvalue = 'Famous';
matlabbatch{3}.spm.meeg.preproc.epoch.trialchoice.define.trialdef(1).trlshift = 0;
matlabbatch{3}.spm.meeg.preproc.epoch.trialchoice.define.trialdef(2).conditionlabel = 'Unfamiliar';
matlabbatch{3}.spm.meeg.preproc.epoch.trialchoice.define.trialdef(2).eventtype = 'BIDS';
matlabbatch{3}.spm.meeg.preproc.epoch.trialchoice.define.trialdef(2).eventvalue = 'Unfamiliar';
matlabbatch{3}.spm.meeg.preproc.epoch.trialchoice.define.trialdef(2).trlshift = 0;
matlabbatch{3}.spm.meeg.preproc.epoch.trialchoice.define.trialdef(3).conditionlabel = 'Scrambled';
matlabbatch{3}.spm.meeg.preproc.epoch.trialchoice.define.trialdef(3).eventtype = 'BIDS';
matlabbatch{3}.spm.meeg.preproc.epoch.trialchoice.define.trialdef(3).eventvalue = 'Scrambled';
matlabbatch{3}.spm.meeg.preproc.epoch.trialchoice.define.trialdef(3).trlshift = 0;
matlabbatch{3}.spm.meeg.preproc.epoch.bc = 0;
matlabbatch{3}.spm.meeg.preproc.epoch.eventpadding = 0;
matlabbatch{3}.spm.meeg.preproc.epoch.prefix = 'e';
