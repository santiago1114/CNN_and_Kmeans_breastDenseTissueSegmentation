%% Load tested data

load('.\data\workspace\proposed.mat')
load('.\data\workspace\libra.mat')
load('.\data\workspace\mag.mat')

%% Compare Dice Similarity Coefficient Distributions

varNames = {'LIBRA','MAG','UNET','PROPOSED'};
T = table(libra.FGTMask,mag.FGTMask,proposed.UNETMask,proposed.FGTMask,'VariableNames',varNames);
[M, ~, pvalues, iq, dsc] = compareDSC(proposed.FGTGTMask, T, proposed.imgSource);

%% Bland Altman plot compared PD

blandaltman(proposed.PD,proposed.PDgt)
%% Evaluate PD error

% Normality test
[h,Pproposed] = kstest(proposed.PD);
[~,Pgt] = kstest(proposed.PDgt);
[~,Plibra] = kstest(libra.PD);
[~,Pmag] = kstest(mag.PD);

% Evaluate PD error and IQR of proposed method
PDerror_proposed = abs(proposed.PD-proposed.PDgt);
medianPDerror_proposed = median(PDerror_proposed);
iqrPD = iqr(PDerror_proposed);

% Evaluate differences in function of source
D1 = PDerror_proposed; D1 = D1(proposed.imgSource == "Philips Medical Systems");
N1 = length(D1);
D2 = PDerror_proposed; D2 = D2(proposed.imgSource == "GE MEDICAL SYSTEMS");
N2 = length(D2);
[Pvalue_sources,~] = ranksum(D1,D2);

% Evaluate PD error and IQR of LIBRA method
PDerror_libra = abs(libra.PD-proposed.PDgt);
medianPDerror_libra = median(PDerror_libra);
[PDerror_libra_proposed,~] = ranksum(PDerror_libra,PDerror_proposed);

% Perform non parametrical Wilcoxon Rank Sum Test
[Pvalue_unet,~] = ranksum(proposed.PDUnet,proposed.PDgt);  
[Pvalue_proposed,~] = ranksum(proposed.PD,proposed.PDgt);  
[Pvalue_libra,~] = ranksum(libra.PD,proposed.PDgt); 
[Pvalue_mag,~] = ranksum(mag.PD,proposed.PDgt); 

%% Perform correlation test

[rho1, pval1] = PDcorrel(libra.FullName, cell2mat(libra.PD), 'LIBRA', proposed.PDgt);
[rho2, pval2] = PDcorrel(mag.FullName, cell2mat(mag.PD), 'MAG', proposed.PDgt);
[rho4, pval4] = PDcorrel(proposed.FullName, proposed.PD, 'Proposed', proposed.PDgt);