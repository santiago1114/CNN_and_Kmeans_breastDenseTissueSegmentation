function [outMask] = BAprocess(inMask)
% Breast area mask process after resize

outMask = imfill(inMask,'holes');
outMask = bwareafilt(outMask,1);
se = strel('disk',2);
outMask = imclose(outMask,se);