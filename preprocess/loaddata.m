function [pxdsFGT, imds, pixelLabelID] = loaddata(imageNum)
% Load data training and visualize
% Sintax:
%     [pxdsFGT, imds, numClasses] = pretrain(view,imageNum)
% Inputs:
%     view,           View of mammography images required
%     imageNum,       Image number for visualize pixels labeled
% Outputs:
%     pxdsFGT,        Pixel Label Datastore object
%     imds,           Images Datastore object
%     pixelLabelID,   IDs of labeled pixels
%

srcdir = pwd;
% Initialize directory of masks data
labelDirFGT = [srcdir filesep 'data' filesep 'target' filesep 'fgt_resized'];
imageDir = [srcdir filesep 'data' filesep 'input' filesep 'images_resized'];

% Declare internal variables (Labels)
classNamesFGT = ["background" "fgt"];
pixelLabelID = [0 1];

% Load label categorical and images data stores
% For dense segmentation
pxdsFGT = pixelLabelDatastore(labelDirFGT,classNamesFGT,pixelLabelID);

% Images on grayscale
imds = imageDatastore(imageDir);

% Visualize training view
prev(pxdsFGT, classNamesFGT, imds, imageNum);