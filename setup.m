clear, clc, close all

% Add files paths
addpath(fullfile(pwd,'groundtruth'))
addpath(fullfile(pwd,'preprocess'))
addpath(fullfile(pwd,'clustering'))
addpath(fullfile(pwd,'statistics'))
addpath(fullfile(pwd,'tuning'))
addpath(fullfile(pwd,'demos'))
addpath(fullfile(pwd,'cnn'))


% Run openbreast setup:
run '.\..\openbreast\setup.m'
