function [] = sourcediff(source,dsc)

% Source differences
D1 = dsc; D1 = D1(source == "Philips Medical Systems");
N1 = length(D1);
fprintf('Philips Medical Systems DSC median: %f\n',median(D1));
disp('iqr1')
disp(iqr(D1))
D2 = dsc; D2 = D2(source == "GE MEDICAL SYSTEMS");
N2 = length(D2);
fprintf('GE MEDICAL SYSTEMS DSC median: %f\n',median(D2));
disp('iqr2')
disp(iqr(D2))
[p,~] = ranksum(D1,D2);
fprintf('Philips Medical Systems: %d | GE MEDICAL SYSTEMS: %d. Mann-Whitney test p-val: %f8\n',...
    N1,N2,p);