function plot_reliability_diagram(s, y, varargin)

p = inputParser;
p.addRequired('s', @isnumeric);
p.addRequired('y', @isnumeric);
p.addParameter('title', '');
p.addParameter('f_calibrate', @(x) NaN);
p.parse(s, y, varargin{:});
p = p.Results;


[bins, empProb, cnt] = reliability_diagram(s,y);

figure('Position', [100 100 500 600]);
ha = tight_subplot(2, 1, [.05 .05], .08, .08);
frac = .75;


%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
% Show a histogram of scores.
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
axes(ha(1));
hist(s);
p1 = get(gca, 'Position');
set(gca, 'Position', [p1(1) frac+.02  p1(3)  (1 - frac - .05)]);
set(gca, 'XTick', [], 'YTick', []);
%set(gca, 'view', [90 -90]);

if length(p.title), title(p.title); end

%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
% The main part of the reliability diagram
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
axes(ha(2));
% draw the points that comprise the reliability diagram
plot(0:.1:1, 0:.1:1, '--k', bins, empProb, 'bo');
% optionally also draw the calibration function
if isfinite(p.f_calibrate(.5))
    a = min(s); b = max(s);
    xv = linspace(a, b, 100);    % space of raw scores
    xn = (xv - a) / (b-a);       % normalized space of raw scores
    
    hold on;
    plot(xn, p.f_calibrate(xv));
    hold off;
end
% annotate the size of each bin
for ii = 1:length(bins)
    if bins(ii) <= .5, 
        offset = .025;
    else
        offset = -.055;
    end
    text(bins(ii)+offset, empProb(ii), num2str(cnt(ii)));
end
xlabel('scaled classifier score');
ylabel('fraction of positives');

p0 = get(gca, 'Position');
set(gca, 'Position', [p0(1) p0(2) p0(3)  (frac-.02 - p0(2))]);


