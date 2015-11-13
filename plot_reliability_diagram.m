function plot_reliability_diagram(s, y, varargin)

[bins, empProb, cnt] = reliability_diagram(s,y,varargin{:});

figure;
plot(0:.1:1, 0:.1:1, '--k', bins, empProb, 'bo');
for ii = 1:length(bins)
    text(bins(ii)+.025, empProb(ii), num2str(cnt(ii)));
end

xlabel('normalized classifier score');
ylabel('empirical probability');

