
%main.m
% ================================
% Convert single-pol SAR images to full-pol images
% by Qian Song Aug. 20 2019
% ================================

%% Load data -> C 
load('./data/C_SH.mat');
[~,~,row, col] = size(C);

% display the image
fg = figure();
pos = get(fg, 'position');
set(fg, 'position', [pos(1) pos(2) col/3 row/3]);
set(gca, 'units', 'pixel');
set(gca, 'position', [0 0 col/3 row/3]);
my_imrgb(C(1,1,:,:),C(2,2,:,:),C(3,3,:,:));

%% C -> full-pol features
% load  ./data/C_SH.mat
[data,data_H,const_array, num_row, num_col, num_total] = pre_data_tf(C);
save('./data/data_SH.mat', 'data', 'data_H', 'num_row', 'num_col', 'num_total','-v7.3');
save('./data/const_array.mat', 'const_array');

%% 
% =============================
% =    Train and test your model in Python      =
% =============================

%% Reconstructed full-pol features -> C_r
filename = './data/test_sh.mat';  % reconstructed features
C_r = Recons_from_feature(filename, './data/data_SH.mat');
[~,~,row, col] = size(C_r);

% display the recovered image
fg = figure();
pos = get(fg, 'position');
set(fg, 'position', [pos(1) pos(2) col/10 row/10]);
set(gca, 'units', 'pixel');
set(gca, 'position', [0 0 col/10 row/10]);
my_imrgb(C_r(1,1,:,:),C_r(2,2,:,:),C_r(3,3,:,:));

%% Test results
load('./data/C_NJ.mat');
[~,~,row, col] = size(C);

% display the image
fg = figure();
pos = get(fg, 'position');
set(fg, 'position', [pos(1) pos(2) col/3 row/3]);
set(gca, 'units', 'pixel');
set(gca, 'position', [0 0 col/3 row/3]);
my_imrgb(C(1,1,:,:),C(2,2,:,:),C(3,3,:,:));

[data_H, num_row, num_col, num_total] = pre_test_data_tf(C);
save('./data/data_NJ.mat', 'data_H', 'num_row', 'num_col', 'num_total');

%% 
% =============================
% =           Test your model in Python              =
% =============================

%% Reconstructed full-pol features -> C_r
filename = './data/test_nj.mat';
C_r = Recons_from_feature(filename, './data/data_NJ.mat');
[~,~,row, col] = size(C_r);

% display the recovered image
fg = figure();
pos = get(fg, 'position');
set(fg, 'position', [pos(1) pos(2) col/3 row/3]);
set(gca, 'units', 'pixel');
set(gca, 'position', [0 0 col/3 row/3]);
my_imrgb(C_r(1,1,:,:),C_r(2,2,:,:),C_r(3,3,:,:));