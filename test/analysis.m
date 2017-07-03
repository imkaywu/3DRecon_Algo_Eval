% compare the performance of the training object and test object
clear, clc, close all;
addpath(genpath('../include'));
obj_name = {'cup', 'vase', 'pot'};
algs = {'ps', 'mvs', 'sl'};
props = {'tex', 'alb', 'spec', 'rough'}; 
% alg_prop = logical([1, 1, 1, 0; 0, 1, 1, 1; 1, 0, 1, 1]); % order: mvs, ps, sl
ind_prop = [2, 5, 8];
in_prop = [2, 2, 2, 5; 2, 2, 8, 2; 2, 8, 2, 5; 8, 2, 2, 5];
acc_cmplt_mat = zeros(2);

color = [241, 90, 90;
         240, 196, 25;
         78, 186, 111;
         34, 53, 122;
         67, 43, 32;
         75, 124, 45];
     
for oo = 1 : numel(obj_name)

for pp = 1 : size(in_prop, 1)

rdir = sprintf('C:/Users/Admin/Documents/3D_Recon/Data/synthetic_data/%s', obj_name{oo});

for aa = 1 : numel(algs)

switch algs{aa}

case 'mvs'
dir = sprintf('%s/mvs/%02d%02d%02d%02d', rdir, in_prop(pp, 1), in_prop(pp, 2), in_prop(pp, 3), in_prop(pp, 4));
fid = fopen([dir, '/result.txt']);
fscanf(fid, '%s', 1); acc_cmplt_mat(1, 1) = fscanf(fid, '%f', 1);
fscanf(fid, '%s', 1); acc_cmplt_mat(2, 1) = fscanf(fid, '%f', 1);

case 'ps'
dir = sprintf('%s/ps/%02d%02d%02d%02d', rdir, in_prop(pp, 1), in_prop(pp, 2), in_prop(pp, 3), in_prop(pp, 4));
data.rdir = rdir;
data.dir = dir;
eval_angle;
angle_mat{2} = angle;
clear norm_map

case 'sl'
dir = sprintf('%s/sl_1024x768/%02d%02d%02d%02d', rdir, in_prop(pp, 1), in_prop(pp, 2), in_prop(pp, 3), in_prop(pp, 4));
fid = fopen([dir, '/result.txt']);
fscanf(fid, '%s', 1); acc_cmplt_mat(1, 2) = fscanf(fid, '%f', 1);
fscanf(fid, '%s', 1); acc_cmplt_mat(2, 2) = fscanf(fid, '%f', 1);

end % end of switch

end % end of alg

% plot
fig = figure;
subplot(1, 2, 1);
bar(acc_cmplt_mat');
legend('accuracy', 'completeness');
set(gca,'XTickLabel',{'mvs', 'sl'})
% for ii = 2
%     % accuracy
%     eval(['p' num2str(2 * ii - 1)]) = semilogy(ind_prop ./ 10, acc_mat(:, ii), 'ro-'); hold on;
%     set(eval(['p' num2str(2 * ii - 1)]), 'LineWidth', 3, 'Color', color(2 * ii - 1, :)/255);
% 
%     % completeness
%     eval(['p' num2str(2 * ii)]) = semilogy(ind_prop ./ 10, cmplt_mat(:, ii), 'ro--'); hold on;
%     set(eval(['p' num2str(2 * ii)]), 'LineWidth', 3, 'Color', color(2 * ii - 1, :)/255);
% end
%     xlabel(prop_name{1});
ylabel('accuracy/completeness');
xlim([0, 3]);
ylim([0, 1.0]);
%     title(sprintf('%s: %s and %s', alg_type, prop_name{1}, prop_name{2}));
subplot(1, 2, 2);
aboxplot([angle_mat{2}, zeros(numel(angle_mat{2}), 1)], 'label', [1, 2]);
xlim([0.5, 1.5]);
ylim([0, 90]);
ylabel('angle difference');
suptitle(sprintf('%s: %02d%02d%02d%02d', obj_name{oo}, in_prop(pp, 1), in_prop(pp, 2), in_prop(pp, 3), in_prop(pp, 4)));

odir = sprintf('%s/result', rdir);
if ~exist(odir, 'dir')
    mkdir(odir);
end
saveas(fig, sprintf('%s/%s_%02d%02d%02d%02d.eps', odir, obj_name{oo}, in_prop(pp, 1), in_prop(pp, 2), in_prop(pp, 3), in_prop(pp, 4)), 'epsc2');
close(fig);

end % end of prop

end % end of obj
