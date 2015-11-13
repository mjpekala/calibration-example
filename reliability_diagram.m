function [bins, empProb, cnt] = reliability_diagram(s, y, varargin)
% RELIABILITY_DIAGRAM  Generates a reliability diagram for binary 
%                      classification problems.
%
%   reliability_diagram(s, y)
%       s :=  (nx1) vector of binary classifier scores; each s_i \in [a,b]
%       y :=  (nx1) vector of class labels.
%             Assumes elements of s are in {0,1} or {-1,+1}.
%       
%   reliability_diagram(s, y, 'range', [a,b], 'bins', linspace(.05, .95, 10))
%       range := a length 2 vector corresponding to [a,b], the complete range
%                of possible values for the binary classifier scores.
%       bins  := bin centers used to compute empirical probabilities
%
%
%  References
%   o Zadrozny and Elkan "Transforming Classifier Scores into 
%     Accurate Multiclass Probability Estimates" 2002.

%  July 2015, mjp

ip = inputParser();
ip.addRequired('s', @isvector);
ip.addRequired('y', @isvector);
ip.addParameter('range', [], @isscalar);
ip.addParameter('bins', [], @isscalar);

ip.parse(s, y, varargin{:});
s = ip.Results.s;
y = ip.Results.y;
range = ip.Results.range;
bins = ip.Results.bins;

if isempty(range)
    % no explicit score range was provided; use available scores to
    % approximate this range.
    range = [min(s) max(s)];
end

yAll = sort(unique(y));

assert(length(yAll) == 2);     % assume binary classification
assert(range(1) < range(2));   % otherwise score range is invalid
assert(length(s) == length(y));


% rescale scores to live in [0,1]
sHat = (s - range(1)) / (range(2) - range(1));

% sort scores.
[sHat, idx] = sort(sHat);
y = y(idx);

% remove duplicate scores (they screw up interpolation)
isSame = logical([0 ; sHat(1:end-1) == sHat(2:end)]);
sHat(isSame) = [];
y(isSame) = [];
if any(isSame)
    warning(sprintf('[%s] %d duplicate values detected!  dropping...', mfilename, sum(isSame)));
end


% map scores to bins
if isempty(bins)
    %bins = linspace(.05, .95, 10);
    bins = quantile(sHat, linspace(.02, .98, 10));
end
binId = interp1(bins, bins, sHat, 'nearest', 'extrap');

% count empirical probability for each bin
empProb = zeros(size(bins));
cnt = zeros(size(bins));
for ii = 1:length(bins), bId = bins(ii);
    inBin = (bId == binId);
    cnt(ii) = sum(inBin);
    empProb(ii) = sum(inBin & (y == yAll(2))) / cnt(ii);
end
