function [] = blandaltman(proposedMeasure,groundTruth)

% BLAND-ALTMAN
width=6; x0=5;
height=5; y0=5;
avg = zeros(length(groundTruth),1); dif = zeros(length(groundTruth),1);

avg(:) = .5*(proposedMeasure(:)+groundTruth(:));
dif(:) = (groundTruth(:)-proposedMeasure(:));
sigma = std(dif(:));
d = mean(dif(:));
fprintf('2SD: %f and d: %f \n',1.96*sigma,d)
ax = [0 1 -1 1];
xT = 0:.2:1; yT = -1:0.5:1;
xlab = 'PD Mean';
ylab = {'Radiologist - Proposed'};

figure('Units','centimeters',...
    'Position',[x0 y0 width height],...
    'PaperPositionMode','auto');
scatter(avg,dif,5,'k','filled')
hold on
plot([0 1], [d d], 'r',[0 1], d+1.96*[sigma sigma], 'b',...
    [0 1], d-1.96*[sigma sigma], 'b')
str = {'$d$','$d+2\sigma$','$d-2\sigma$'};
xt = [1 1 1]*.97;
yt = [d d+1.96*sigma d-1.96*sigma]+0.12;
text(xt,yt,str,'FontSize',8,'FontName','Times',...
    'Interpreter','latex','HorizontalAlignment','right')
paperPlotSet(ax, xlab, xT, ylab, yT)
goodplot(5, 0, 10)
print(gcf, '-dpdf', '-r150', 'papersaved/bland.pdf');