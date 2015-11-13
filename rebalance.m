function indices = rebalance(y, nMax)
% REBALANCE  Balances a data set so that each class is represented
%            in equal quantities.
%
%       indices = rebalance(y)
%
%   where:
%       y : an (n x 1) vector of class labels (integers)
%       indices : an (m x 1) vector of indices into y corresponding
%                 to the rebalanced subset. (so m <= n)

% November 2015, mjp


shuffle = @(x) x(randperm(length(x)));

if nargin < 2, nMax = Inf; end

yAll = sort(unique(y));

% count how many objects are in each class
cnt = zeros(numel(yAll), 1);
for ii = 1:length(yAll)
    cnt = sum(y == yAll(ii));
end

% n := the number of objects to take from each class.
n = min([nMax ; cnt]);

% randomly select n objects from each class
bits = logical(zeros(size(y)));
for ii = 1:length(yAll)
    idx = shuffle(find(y == yAll(ii)));
    idx = idx(1:n);
    bits(idx) = 1;
end

indices = shuffle(find(bits));

