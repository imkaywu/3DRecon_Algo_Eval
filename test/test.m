% run algorithm and compute the accuracy and completeness
% for the test objects
clear, clc, close all;
addpath('../io');
addpath(genpath('../include'));

obj_names = {'knight'};
algs = {'ps', 'mvs', 'sl'};
props = {'tex', 'alb', 'spec', 'rough'}; 
% alg_prop = logical([1, 1, 1, 0; 0, 1, 1, 1; 1, 0, 1, 1]); % order: mvs, ps, sl
val_prop = [2, 8, 2, 8; 2, 8, 5, 2; 8, 8, 2, 8; 8, 8, 5, 2];
ref_dir = '../../ref_obj';
gt_dir = '../../groundtruth';
run_alg = 0;
run_eval = 1;
run_eval_ps = 0;

for oo = 1 : numel(obj_names)

for aa = 1 : numel(algs)

for pp = 1 : size(val_prop, 1)

rdir = sprintf('C:/Users/Admin/Documents/3D_Recon/Data/synthetic_data/testing/%s', obj_names{oo});

switch algs{aa}
%% Run MVS
case 'mvs'
obj_name = obj_names{oo};
dir = sprintf('%s/mvs/%02d%02d%02d%02d', rdir, val_prop(pp, 1), val_prop(pp, 2), val_prop(pp, 3), val_prop(pp, 4));
copyfile('../../copy2mvs', dir);
foption = [obj_names{oo}, '_', algs{aa}];
movefile([dir, '/option'], [dir, '/', foption]);
cmd = sprintf('pmvs2 %s/ %s', dir, foption);
wait_for_existence(sprintf('%s/visualize/0040.jpg', dir), 'file', 10, 3600);
if run_alg || ~exist([dir, '/models/', obj_names{oo}, '_', algs{aa}, '.ply'], 'file')
    cd ../include, system(cmd), cd ../test;
end
if(run_eval || ~exist(sprintf('%s/result.txt', dir), 'file'))
    eval_acc_cmplt;
end
rmdir(sprintf('%s/txt/', dir), 's');
delete(sprintf('%s/%s', dir, foption));
delete(sprintf('%s/vis.dat', dir));

%% Run SL
case 'sl'
dir_sl = 'C:/Users/Admin/Documents/3D_Recon/kwStructuredLight';
addpath (genpath(dir_sl));
% change objName
objDir = sprintf('%s/sl/%02d%02d%02d%02d', rdir, val_prop(pp, 1), val_prop(pp, 2), val_prop(pp, 3), val_prop(pp, 4)); % used in slProcess_syn
objName = obj_names{oo};
obj_name = objName;
alg_type = algs{aa};
wait_for_existence(sprintf('%s/0041.jpg', objDir), 'file', 10, 3600);
if(run_alg || ~exist(sprintf('%s/%s_sl.ply', objDir, obj_names{oo}), 'file'))
    slProcess_syn;
end
if(run_eval || ~exist(sprintf('%s/result.txt', objDir), 'file'))
    eval_acc_cmplt;
end

%% Run PS
case 'ps'
dir_ps = 'C:/Users/Admin/Documents/3D_Recon/Photometric Stereo';
addpath(genpath(dir_ps));
data.dir = sprintf('%s/ps/%02d%02d%02d%02d', rdir, val_prop(pp, 1), val_prop(pp, 2), val_prop(pp, 3), val_prop(pp, 4));
data.rdir = rdir;
data.ref_dir = ref_dir;
data.obj_name = obj_names{oo};
wait_for_existence(sprintf('%s/0023.jpg', data.dir), 'file', 10, 3600);
if(run_alg || ~exist(sprintf('%s/normal.png', data.dir), 'file'))
    main_ps;
end
if(run_eval_ps || ~exist(sprintf('%s/result.txt', data.dir), 'file'))
    eval_angle;
end

end % end of switch statement

end % end of val_prop

end % end of alg

end % end of obj 