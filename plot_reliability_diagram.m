function plot_reliability_diagram(s, y, varargin)

[bins, empProb, cnt] = reliability_diagram(s,y,varargin{:});

figure('Position', [100 100 600 400]);
ha = tight_subplot(1, 2, [.05 .05], .08, .08);
frac = .75;

% The main part of the reliability diagram
axes(ha(1));
plot(0:.1:1, 0:.1:1, '--k', bins, empProb, 'bo');
for ii = 1:length(bins)
    if bins(ii) <= .5, 
        offset = .025;
    else
        offset = -.055;
    end
    text(bins(ii)+offset, empProb(ii), num2str(cnt(ii)));
end
xlabel('scaled classifier score');
ylabel('empirical probability');

p0 = get(gca, 'Position');
set(gca, 'Position', [p0(1) p0(2) frac-p0(1) p0(4)]);


% Show a histogram of normalized scores.
axes(ha(2));
hist(empProb);
p1 = get(gca, 'Position');
set(gca, 'Position', [frac+.01 p1(2)  (1 - frac - .03)  p1(4)]);
set(gca, 'XTick', [], 'YTick', []);
set(gca, 'view', [90 -90]);
