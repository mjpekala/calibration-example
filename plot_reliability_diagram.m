function plot_reliability_diagram(s, y, varargin)

p = inputParser;
p.addRequired('s', @isnumeric);
p.addRequired('y', @isnumeric);
p.addParameter('title', '');
p.addParameter('f_calibrate', @(x) NaN);
p.parse(s, y, varargin{:});
p = p.Results;


[bins, empProb, cnt] = reliability_diagram(s,y);

figure('Position', [100 100 600 400]);
ha = tight_subplot(1, 2, [.05 .05], .08, .08);
frac = .75;

%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
% The main part of the reliability diagram
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
axes(ha(1));
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
if length(p.title), title(p.title); end

p0 = get(gca, 'Position');
set(gca, 'Position', [p0(1) p0(2) frac-p0(1) p0(4)]);


% Show a histogram of normalized scores.
axes(ha(2));
hist(empProb);
p1 = get(gca, 'Position');
set(gca, 'Position', [frac+.01 p1(2)  (1 - frac - .03)  p1(4)]);
set(gca, 'XTick', [], 'YTick', []);
set(gca, 'view', [90 -90]);
