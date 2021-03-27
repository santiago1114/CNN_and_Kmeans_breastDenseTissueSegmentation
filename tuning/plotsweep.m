function [] = plotsweep(T)
% Perform DSC(th) DSC(PD) sweep on validation partition with GLT
% Sintax:
%     plotsweep(validationSweep)
% Inputs:
%     sweepTable,  table with sweep values on validation set
% Outputs:
%

M = width(T);
fth = T.(3){1};
N = length(fth);
mseDsc = zeros(length(5:2:M - 1),N); 
mseDscAvg = zeros(N,1);
msePd = zeros(length(6:2:M),N); 
msePdAvg = zeros(N,1);

%Assessing Mean Signed Error for DSC (odd)
for i=1:N
    count = 1;
    for j = 5:2:M - 1

    mseDsc(count,i) = mean(T.(j){1}(:,i));
    count = count + 1;
    
    end
    mseDscAvg(i) = mean(mseDsc(:,i));
end

%Assessing Mean Signed Error for PD (even)
for i=1:N
    count = 1;
    for j = 6:2:M
        
%   mse(i)   = mean(pd4(:,i) - pdGT(:));
    msePd(count,i) = mean(T.(j){1}(:,i) - T.(4){1}(:));
    count = count + 1;
    
    end
    msePdAvg(i) = mean(msePd(:,i));
end

% Colors
% blue   = [0, 0.4470, 0.7410];
% orange = [0.8500, 0.3250, 0.0980];
% yellow = [0.9290, 0.6940, 0.1250];

% Plot size
width_=6; x0=5;
height=5; y0=5;

figure('Units','centimeters','Position',[x0 y0 width_ height],...
'PaperPositionMode','auto');

ax = [0.2 0.8 -0.5 0.5];
xMeasure   = 0.2:0.1:0.8;  yMeasure = -0.5:.25:0.5;
xlab = '$f_{th}$'; ylab = 'MSE';

% Plot MSE_PD
for k = 1:length(6:2:M)
    plot(fth,msePd(k,:))
    if k == 1
       hold on
    end
end
plot(fth,zeros(size(fth)),'--k','LineWidth',1)
h1 = plot(0.45,0,'-ok'); % Modify intersection dot
set(h1, 'markerfacecolor', get(h1, 'color'));
paperPlotSet(ax, xlab, xMeasure, ylab, yMeasure)
legend('K=6','Location','best','fontsize',7)
legend('boxoff')
goodplot(5, 0, 10)
print(gcf, '-dpdf', '-r150', 'papersaved/mse.pdf');
hold off

% Plot MSE_DSC
figure
for k = 1:length(5:2:M - 1)
    plot(fth,mseDsc(k,:))
    if k == 1
       hold on
    end
end
legend('boxoff')
plot(fth,zeros(size(fth)),'--k','LineWidth',1)
legend('K=4','K=6','K=8','Location','best','fontsize',7)
legend('boxoff')