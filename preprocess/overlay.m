function [B,cmap] = overlay(I,C,className)

% Define the colormap used
if strcmp(className,"fgt")
    cmap = [
    192 192 192   % Background
    128 0 0       % FGT
    ];

else
cmap = [
    192 192 192   % Background
    0 128 192     % Breast
    ];
end
% Normalize between [0 1].
cmap = cmap./255;
B = labeloverlay(I,C,'Colormap',cmap,'Transparency',0.4);