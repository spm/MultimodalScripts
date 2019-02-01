%-----------------------------------------------------------------------
% Job saved on 07-Sep-2017 14:17:12 by cfg_util (rev $Rev: 37 $)
% spm SPM - SPM12 (12.3)
% cfg_basicio BasicIO - Unknown
%-----------------------------------------------------------------------
matlabbatch{1}.spm.meeg.preproc.merge.D = '<UNDEFINED>'
matlabbatch{1}.spm.meeg.preproc.merge.recode.file = '.*';
matlabbatch{1}.spm.meeg.preproc.merge.recode.labelorg = '.*';
matlabbatch{1}.spm.meeg.preproc.merge.recode.labelnew = '#labelorg#';
matlabbatch{1}.spm.meeg.preproc.merge.prefix = 'c';
matlabbatch{2}.spm.meeg.preproc.merge.D = '<UNDEFINED>'
matlabbatch{2}.spm.meeg.preproc.merge.recode.file = '.*';
matlabbatch{2}.spm.meeg.preproc.merge.recode.labelorg = '.*';
matlabbatch{2}.spm.meeg.preproc.merge.recode.labelnew = '#labelorg#';
matlabbatch{2}.spm.meeg.preproc.merge.prefix = 'c';
matlabbatch{3}.spm.meeg.preproc.prepare.D(1) = cfg_dep('Merging: Merged Datafile', substruct('.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','Dfname'));
matlabbatch{3}.spm.meeg.preproc.prepare.task{1}.sortconditions.label = {
                                                                        'Famous'
                                                                        'Unfamiliar'
                                                                        'Scrambled'
                                                                        }';
matlabbatch{4}.spm.meeg.preproc.prepare.D(1) = cfg_dep('Merging: Merged Datafile', substruct('.','val', '{}',{2}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','Dfname'));
matlabbatch{4}.spm.meeg.preproc.prepare.task{1}.sortconditions.label = {
                                                                        'Famous'
                                                                        'Unfamiliar'
                                                                        'Scrambled'
                                                                        }';
matlabbatch{5}.spm.meeg.averaging.average.D(1) = cfg_dep('Prepare: Prepared Datafile', substruct('.','val', '{}',{3}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','Dfname'));
matlabbatch{5}.spm.meeg.averaging.average.userobust.standard = false;
matlabbatch{5}.spm.meeg.averaging.average.plv = false;
matlabbatch{5}.spm.meeg.averaging.average.prefix = 'm';
matlabbatch{6}.spm.meeg.averaging.average.D(1) = cfg_dep('Prepare: Prepared Datafile', substruct('.','val', '{}',{4}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','Dfname'));
matlabbatch{6}.spm.meeg.averaging.average.userobust.standard = false;
matlabbatch{6}.spm.meeg.averaging.average.plv = true;
matlabbatch{6}.spm.meeg.averaging.average.prefix = 'm';
matlabbatch{7}.spm.meeg.tf.rescale.D(1) = cfg_dep('Averaging: Averaged Datafile', substruct('.','val', '{}',{5}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','Dfname'));
matlabbatch{7}.spm.meeg.tf.rescale.method.LogR.baseline.timewin = [-100 0];
matlabbatch{7}.spm.meeg.tf.rescale.method.LogR.baseline.pooledbaseline = 0;
matlabbatch{7}.spm.meeg.tf.rescale.method.LogR.baseline.Db = [];
matlabbatch{7}.spm.meeg.tf.rescale.prefix = 'r';
matlabbatch{8}.spm.meeg.averaging.contrast.D(1) = cfg_dep('Time-frequency rescale: Rescaled TF Datafile', substruct('.','val', '{}',{7}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','Dfname'));
matlabbatch{8}.spm.meeg.averaging.contrast.contrast(1).c = [0.5 0.5 -1];
matlabbatch{8}.spm.meeg.averaging.contrast.contrast(1).label = 'Faces-Scrambled';
matlabbatch{8}.spm.meeg.averaging.contrast.contrast(2).c = [1 -1 0];
matlabbatch{8}.spm.meeg.averaging.contrast.contrast(2).label = 'Famous-Unfamiliar';
matlabbatch{8}.spm.meeg.averaging.contrast.weighted = 0;
matlabbatch{8}.spm.meeg.averaging.contrast.prefix = 'w';
matlabbatch{9}.spm.meeg.averaging.contrast.D(1) = cfg_dep('Averaging: Averaged Datafile', substruct('.','val', '{}',{6}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','Dfname'));
matlabbatch{9}.spm.meeg.averaging.contrast.contrast(1).c = [0.5 0.5 -1];
matlabbatch{9}.spm.meeg.averaging.contrast.contrast(1).label = 'Faces-Scrambled';
matlabbatch{9}.spm.meeg.averaging.contrast.contrast(2).c = [1 -1 0];
matlabbatch{9}.spm.meeg.averaging.contrast.contrast(2).label = 'Famous-Unfamiliar';
matlabbatch{9}.spm.meeg.averaging.contrast.weighted = 0;
matlabbatch{9}.spm.meeg.averaging.contrast.prefix = 'w';
matlabbatch{10}.spm.meeg.images.convert2images.D(1) = cfg_dep('Time-frequency rescale: Rescaled TF Datafile', substruct('.','val', '{}',{7}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','Dfname'));
matlabbatch{10}.spm.meeg.images.convert2images.mode = 'time x frequency';
matlabbatch{10}.spm.meeg.images.convert2images.conditions = {
                                                             'Famous'
                                                             'Unfamiliar'
                                                             'Scrambled'
                                                             }';
matlabbatch{10}.spm.meeg.images.convert2images.channels{1}.type = 'EEG';
matlabbatch{10}.spm.meeg.images.convert2images.timewin = [-Inf Inf];
matlabbatch{10}.spm.meeg.images.convert2images.freqwin = [-Inf Inf];
matlabbatch{10}.spm.meeg.images.convert2images.prefix = 'eeg_img_pow_';
matlabbatch{11}.spm.meeg.images.convert2images.D(1) = cfg_dep('Averaging: Averaged Datafile', substruct('.','val', '{}',{6}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','Dfname'));
matlabbatch{11}.spm.meeg.images.convert2images.mode = 'time x frequency';
matlabbatch{11}.spm.meeg.images.convert2images.conditions = {
                                                             'Famous'
                                                             'Unfamiliar'
                                                             'Scrambled'
                                                             }';
matlabbatch{11}.spm.meeg.images.convert2images.channels{1}.type = 'EEG';
matlabbatch{11}.spm.meeg.images.convert2images.timewin = [-Inf Inf];
matlabbatch{11}.spm.meeg.images.convert2images.freqwin = [-Inf Inf];
matlabbatch{11}.spm.meeg.images.convert2images.prefix = 'eeg_img_phs_';
matlabbatch{12}.spm.meeg.images.convert2images.D(1) = cfg_dep('Time-frequency rescale: Rescaled TF Datafile', substruct('.','val', '{}',{7}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','Dfname'));
matlabbatch{12}.spm.meeg.images.convert2images.mode = 'time x frequency';
matlabbatch{12}.spm.meeg.images.convert2images.conditions = {
                                                             'Famous'
                                                             'Unfamiliar'
                                                             'Scrambled'
                                                             }';
matlabbatch{12}.spm.meeg.images.convert2images.channels{1}.type = 'MEGMAG';
matlabbatch{12}.spm.meeg.images.convert2images.timewin = [-Inf Inf];
matlabbatch{12}.spm.meeg.images.convert2images.freqwin = [-Inf Inf];
matlabbatch{12}.spm.meeg.images.convert2images.prefix = 'mag_img_pow_';
matlabbatch{13}.spm.meeg.images.convert2images.D(1) = cfg_dep('Averaging: Averaged Datafile', substruct('.','val', '{}',{6}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','Dfname'));
matlabbatch{13}.spm.meeg.images.convert2images.mode = 'time x frequency';
matlabbatch{13}.spm.meeg.images.convert2images.conditions = {
                                                             'Famous'
                                                             'Unfamiliar'
                                                             'Scrambled'
                                                             }';
matlabbatch{13}.spm.meeg.images.convert2images.channels{1}.type = 'MEGMAG';
matlabbatch{13}.spm.meeg.images.convert2images.timewin = [-Inf Inf];
matlabbatch{13}.spm.meeg.images.convert2images.freqwin = [-Inf Inf];
matlabbatch{13}.spm.meeg.images.convert2images.prefix = 'mag_img_phs_';
matlabbatch{14}.spm.meeg.images.convert2images.D(1) = cfg_dep('Time-frequency rescale: Rescaled TF Datafile', substruct('.','val', '{}',{7}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','Dfname'));
matlabbatch{14}.spm.meeg.images.convert2images.mode = 'time x frequency';
matlabbatch{14}.spm.meeg.images.convert2images.conditions = {
                                                             'Famous'
                                                             'Unfamiliar'
                                                             'Scrambled'
                                                             }';
matlabbatch{14}.spm.meeg.images.convert2images.channels{1}.type = 'MEGPLANAR';
matlabbatch{14}.spm.meeg.images.convert2images.timewin = [-Inf Inf];
matlabbatch{14}.spm.meeg.images.convert2images.freqwin = [-Inf Inf];
matlabbatch{14}.spm.meeg.images.convert2images.prefix = 'grd_img_pow_';
matlabbatch{15}.spm.meeg.images.convert2images.D(1) = cfg_dep('Averaging: Averaged Datafile', substruct('.','val', '{}',{6}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','Dfname'));
matlabbatch{15}.spm.meeg.images.convert2images.mode = 'time x frequency';
matlabbatch{15}.spm.meeg.images.convert2images.conditions = {
                                                             'Famous'
                                                             'Unfamiliar'
                                                             'Scrambled'
                                                             }';
matlabbatch{15}.spm.meeg.images.convert2images.channels{1}.type = 'MEGPLANAR';
matlabbatch{15}.spm.meeg.images.convert2images.timewin = [-Inf Inf];
matlabbatch{15}.spm.meeg.images.convert2images.freqwin = [-Inf Inf];
matlabbatch{15}.spm.meeg.images.convert2images.prefix = 'grd_img_phs_';
