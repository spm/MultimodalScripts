%-----------------------------------------------------------------------
% Job saved on 19-May-2017 14:30:44 by cfg_util (rev $Rev: 48 $)
% spm SPM - SPM12 (12.3)
% cfg_basicio BasicIO - Unknown
%-----------------------------------------------------------------------
matlabbatch{1}.spm.meeg.source.invert.D = '<UNDEFINED>';
matlabbatch{1}.spm.meeg.source.invert.val = '<UNDEFINED>';
matlabbatch{1}.spm.meeg.source.invert.whatconditions.all = 1;
matlabbatch{1}.spm.meeg.source.invert.isstandard.custom.invtype = 'IID';
matlabbatch{1}.spm.meeg.source.invert.isstandard.custom.woi = [0 500];
matlabbatch{1}.spm.meeg.source.invert.isstandard.custom.foi = [6 40];
matlabbatch{1}.spm.meeg.source.invert.isstandard.custom.hanning = 1;
matlabbatch{1}.spm.meeg.source.invert.isstandard.custom.priors.priorsmask = '<UNDEFINED>';
matlabbatch{1}.spm.meeg.source.invert.isstandard.custom.priors.space = 1;
matlabbatch{1}.spm.meeg.source.invert.isstandard.custom.restrict.locs = zeros(0, 3);
matlabbatch{1}.spm.meeg.source.invert.isstandard.custom.restrict.radius = 32;
matlabbatch{1}.spm.meeg.source.invert.isstandard.custom.restrict.mask = {''};
matlabbatch{1}.spm.meeg.source.invert.modality = {
                                                  'EEG'
                                                  'MEG'
                                                  'MEGPLANAR'
                                                  }';
matlabbatch{2}.spm.meeg.source.invert.D = '<UNDEFINED>';
matlabbatch{2}.spm.meeg.source.invert.val = '<UNDEFINED>';
matlabbatch{2}.spm.meeg.source.invert.whatconditions.all = 1;
matlabbatch{2}.spm.meeg.source.invert.isstandard.custom.invtype = 'GS';
matlabbatch{2}.spm.meeg.source.invert.isstandard.custom.woi = [0 500];
matlabbatch{2}.spm.meeg.source.invert.isstandard.custom.foi = [6 40];
matlabbatch{2}.spm.meeg.source.invert.isstandard.custom.hanning = 1;
matlabbatch{2}.spm.meeg.source.invert.isstandard.custom.priors.priorsmask = '<UNDEFINED>';
matlabbatch{2}.spm.meeg.source.invert.isstandard.custom.priors.space = 1;
matlabbatch{2}.spm.meeg.source.invert.isstandard.custom.restrict.locs = zeros(0, 3);
matlabbatch{2}.spm.meeg.source.invert.isstandard.custom.restrict.radius = 32;
matlabbatch{2}.spm.meeg.source.invert.isstandard.custom.restrict.mask = {''};
matlabbatch{2}.spm.meeg.source.invert.modality = {
                                                  'EEG'
                                                  'MEG'
                                                  'MEGPLANAR'
                                                  }';
matlabbatch{3}.spm.meeg.source.results.D(1) = cfg_dep('Source inversion: M/EEG dataset(s) after imaging source reconstruction', substruct('.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','D'));
matlabbatch{3}.spm.meeg.source.results.val = '<UNDEFINED>';
matlabbatch{3}.spm.meeg.source.results.woi = [100 250];
matlabbatch{3}.spm.meeg.source.results.foi = [10 20];
matlabbatch{3}.spm.meeg.source.results.ctype = 'evoked';
matlabbatch{3}.spm.meeg.source.results.space = 1;
matlabbatch{3}.spm.meeg.source.results.format = 'mesh';
matlabbatch{3}.spm.meeg.source.results.smoothing = 8;
matlabbatch{4}.spm.meeg.source.results.D(1) = cfg_dep('Source inversion: M/EEG dataset(s) after imaging source reconstruction', substruct('.','val', '{}',{2}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','D'));
matlabbatch{4}.spm.meeg.source.results.val = '<UNDEFINED>';
matlabbatch{4}.spm.meeg.source.results.woi = [100 250];
matlabbatch{4}.spm.meeg.source.results.foi = [10 20];
matlabbatch{4}.spm.meeg.source.results.ctype = 'evoked';
matlabbatch{4}.spm.meeg.source.results.space = 1;
matlabbatch{4}.spm.meeg.source.results.format = 'mesh';
matlabbatch{4}.spm.meeg.source.results.smoothing = 8;
