function [outMask] = kmeansfgt(inMask,I,K,th)
% Use Intensity-based clustering
% Sintax:
%     [outMask, imClusters, partialMasks] = kmeansfgt(inMask,I,K,th)
% Inputs:
%     inMask,         512x512 Binary mask of density segmentation
%     I,              NxM mammography image
%     K,              Integer value for K clusters
%     th,             Float value for Intensity Threshold
% Outputs:
%     outMask,        Binary mask of dense tissue segmentation
%     imClusters,     Para efectos de graficar los diferentes clusters
%     partialMasks,   Para graficar los pixeles dentro de cada cluster
%

I = mat2gray(I);

C = linspace(0,1,K)';
idx = kmeans(I(:),K,'Start',C,'MaxIter',1000);

outC = reshape(idx,size(I));

outMask = zeros(size(I));

for i=2:K
    group = outC == i;
    partialMask = inMask & group;
    measure = sum(partialMask(:))/sum(group(:));
    if measure >= th
        %outMask = outMask | outC == i;
        outMask = outMask | partialMask;
    end
end
%outMask = outMask.*inMask;

