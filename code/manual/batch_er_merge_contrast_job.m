%-----------------------------------------------------------------------
% Job saved on 13-Jul-2017 16:31:27 by cfg_util (rev $Rev: 37 $)
% spm SPM - SPM12 (12.3)
% cfg_basicio BasicIO - Unknown
%-----------------------------------------------------------------------
matlabbatch{1}.spm.meeg.preproc.merge.D = '<UNDEFINED>'
matlabbatch{1}.spm.meeg.preproc.merge.recode.file = '.*';
matlabbatch{1}.spm.meeg.preproc.merge.recode.labelorg = '.*';
matlabbatch{1}.spm.meeg.preproc.merge.recode.labelnew = '#labelorg#';
matlabbatch{1}.spm.meeg.preproc.merge.prefix = 'c';
matlabbatch{2}.spm.meeg.preproc.prepare.D(1) = cfg_dep('Merging: Merged Datafile', substruct('.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','Dfname'));
matlabbatch{2}.spm.meeg.preproc.prepare.task{1}.avref.fname = 'avref_montage.mat';
matlabbatch{3}.spm.meeg.preproc.montage.D(1) = cfg_dep('Merging: Merged Datafile', substruct('.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','Dfname'));
matlabbatch{3}.spm.meeg.preproc.montage.mode.write.montspec.montage.montagefile(1) = cfg_dep('Prepare: Average reference montage', substruct('.','val', '{}',{2}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','avrefname'));
matlabbatch{3}.spm.meeg.preproc.montage.mode.write.montspec.montage.keepothers = 1;
matlabbatch{3}.spm.meeg.preproc.montage.mode.write.blocksize = 655360;
matlabbatch{3}.spm.meeg.preproc.montage.mode.write.prefix = 'M';
matlabbatch{4}.spm.meeg.preproc.artefact.D(1) = cfg_dep('Montage: Montaged Datafile', substruct('.','val', '{}',{3}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','Dfname'));
matlabbatch{4}.spm.meeg.preproc.artefact.mode = 'reject';
matlabbatch{4}.spm.meeg.preproc.artefact.badchanthresh = 0.2;
matlabbatch{4}.spm.meeg.preproc.artefact.append = true;
matlabbatch{4}.spm.meeg.preproc.artefact.methods.channels{1}.type = 'EOG';
matlabbatch{4}.spm.meeg.preproc.artefact.methods.fun.threshchan.threshold = 200;
matlabbatch{4}.spm.meeg.preproc.artefact.methods.fun.threshchan.excwin = 1000;
matlabbatch{4}.spm.meeg.preproc.artefact.prefix = 'a';
matlabbatch{5}.spm.meeg.preproc.prepare.D(1) = cfg_dep('Artefact detection: Artefact-detected Datafile', substruct('.','val', '{}',{4}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','Dfname'));
matlabbatch{5}.spm.meeg.preproc.prepare.task{1}.sortconditions.label = {
                                                                        'Famous'
                                                                        'Unfamiliar'
                                                                        'Scrambled'
                                                                        }';
matlabbatch{6}.spm.meeg.preproc.combineplanar.D(1) = cfg_dep('Prepare: Prepared Datafile', substruct('.','val', '{}',{5}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','Dfname'));
matlabbatch{6}.spm.meeg.preproc.combineplanar.mode = 'append';
matlabbatch{6}.spm.meeg.preproc.combineplanar.prefix = 'P';
matlabbatch{7}.spm.meeg.images.convert2images.D(1) = cfg_dep('Combine planar: Planar-combined MEG datafile', substruct('.','val', '{}',{6}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','Dfname'));
matlabbatch{7}.spm.meeg.images.convert2images.mode = 'scalp x time';
matlabbatch{7}.spm.meeg.images.convert2images.conditions = cell(1, 0);
matlabbatch{7}.spm.meeg.images.convert2images.channels{1}.type = 'EEG';
matlabbatch{7}.spm.meeg.images.convert2images.timewin = [-Inf Inf];
matlabbatch{7}.spm.meeg.images.convert2images.freqwin = [-Inf Inf];
matlabbatch{7}.spm.meeg.images.convert2images.prefix = 'eeg_img_st_';
matlabbatch{8}.spm.meeg.images.convert2images.D(1) = cfg_dep('Prepare: Prepared Datafile', substruct('.','val', '{}',{6}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','Dfname'));
matlabbatch{8}.spm.meeg.images.convert2images.mode = 'scalp x time';
matlabbatch{8}.spm.meeg.images.convert2images.conditions = cell(1, 0);
matlabbatch{8}.spm.meeg.images.convert2images.channels{1}.type = 'MEGMAG';
matlabbatch{8}.spm.meeg.images.convert2images.timewin = [-Inf Inf];
matlabbatch{8}.spm.meeg.images.convert2images.freqwin = [-Inf Inf];
matlabbatch{8}.spm.meeg.images.convert2images.prefix = 'mag_img_st_';
matlabbatch{9}.spm.meeg.images.convert2images.D(1) = cfg_dep('Prepare: Prepared Datafile', substruct('.','val', '{}',{6}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','Dfname'));
matlabbatch{9}.spm.meeg.images.convert2images.mode = 'scalp x time';
matlabbatch{9}.spm.meeg.images.convert2images.conditions = cell(1, 0);
matlabbatch{9}.spm.meeg.images.convert2images.channels{1}.type = 'MEGCOMB';
matlabbatch{9}.spm.meeg.images.convert2images.timewin = [-Inf Inf];
matlabbatch{9}.spm.meeg.images.convert2images.freqwin = [-Inf Inf];
matlabbatch{9}.spm.meeg.images.convert2images.prefix = 'grd_img_st_';
matlabbatch{10}.spm.meeg.averaging.average.D(1) = cfg_dep('Prepare: Prepared Datafile', substruct('.','val', '{}',{6}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','Dfname'));
matlabbatch{10}.spm.meeg.averaging.average.userobust.standard = false;
matlabbatch{10}.spm.meeg.averaging.average.plv = false;
matlabbatch{10}.spm.meeg.averaging.average.prefix = 'm';
matlabbatch{11}.spm.meeg.averaging.contrast.D(1) = cfg_dep('Averaging: Averaged Datafile', substruct('.','val', '{}',{10}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','Dfname'));
matlabbatch{11}.spm.meeg.averaging.contrast.contrast(1).c = [1 0 0];
matlabbatch{11}.spm.meeg.averaging.contrast.contrast(1).label = 'Famous';
matlabbatch{11}.spm.meeg.averaging.contrast.contrast(2).c = [0 1 0];
matlabbatch{11}.spm.meeg.averaging.contrast.contrast(2).label = 'Unfamiliar';
matlabbatch{11}.spm.meeg.averaging.contrast.contrast(3).c = [0 0 1];
matlabbatch{11}.spm.meeg.averaging.contrast.contrast(3).label = 'Scrambled';
matlabbatch{11}.spm.meeg.averaging.contrast.contrast(4).c = [0.5 0.5 -1];
matlabbatch{11}.spm.meeg.averaging.contrast.contrast(4).label = 'Faces-Scrambled';
matlabbatch{11}.spm.meeg.averaging.contrast.contrast(5).c = [1 -1 0];
matlabbatch{11}.spm.meeg.averaging.contrast.contrast(5).label = 'Famous-Unfamiliar';
matlabbatch{11}.spm.meeg.averaging.contrast.weighted = 0;
matlabbatch{11}.spm.meeg.averaging.contrast.prefix = 'w';
