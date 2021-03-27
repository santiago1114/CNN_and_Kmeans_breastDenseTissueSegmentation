function [outMask] = clusteredfgt(inMask,I,th)

outMask = zeros(size(I));
for i=0:17:255
    group = I == i;
    partialMask = inMask & group;
    measure = sum(partialMask(:))/sum(group(:));
    if measure>th
        outMask = outMask|group;
    end
end
