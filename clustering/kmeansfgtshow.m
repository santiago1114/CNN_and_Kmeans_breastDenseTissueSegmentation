
function [outMask, colorClusters, partialMasks] = kmeansfgtshow(inMask,I,K,th)
% Use Intensity-based clustering
% Sintax:
%     [outMask, imClusters, partialMasks] = kmeansfgt(inMask,I,K,th)
% Inputs:
%     inMask,         Binary mask of density segmentation
%     I,              NxN mammography image in grayscale
%     K,              Integer value for K clusters
%     th,             Float value for Intensity Threshold
% Outputs:
%     outMask,        Binary mask of dense tissue segmentation
%     imClusters,     Para efectos de graficar los diferentes clusters
%     partialMasks,   Para graficar los pixeles dentro de cada cluster
%
I = double(I);
C = linspace(min(I(:)),max(I(:)),K)';
idx = kmeans(I(:),K,'Start',C,'MaxIter',1000);
%idx = kmedoids(I(:),K,'Start','cluster');
outClusters = reshape(idx,size(I));
colorClusters = label2rgb(outClusters,'bone');
partialMasks = cell(K,1);
%outMask = zeros(size(I));
outMask = outClusters == K;
for i=3:K-1
    group = outClusters == i;
    partialMask = inMask & group;
    partialMasks{i} = partialMask;
    measure = sum(partialMask(:))/sum(group(:));
    if measure > th
        outMask = outMask | group;
    end   
end
outMask = inMask & outMask;