function [] = prev(pxdsDense, classNamesDense, imds, imageNum)
% Previsualize training data
% Sintax:
%     prev(pxdsArea, classNamesDense, pxdsDense, classNamesArea, imds, imageNum)
% Inputs:
%     pxdsDense,        FGT Pixel Label object
%     classNamesDense,  Names for dense categorical images
%     imds,             Images data object
%     imageNum,         Image number of image data object
%
% Outputs:
%
I = readimage(imds,imageNum);
CD = readimage(pxdsDense,imageNum);
[BD,cmapD] = overlay(I,CD,classNamesDense(2));

figure
imshow(BD), title('FGT')
viewcolorbar(classNamesDense,cmapD);

sgtitle(['Ground Truth: ', num2str(imageNum)])