function [csvm, f_calibrate, svm] = train_and_calibrate(X, y, varargin)
% TRAIN_AND_CALIBRATE  Trains a SVM and calibrates using Platt scaling
%
%      csvm = train_and_calibrate(train.X, train.y, ...);
%
%   where:
%        train.X : an (n x d) matrix of n examples each having d dimensions
%        train.y : an (n x 1) vector of binary class labels.
%        csvm    : the trained svm model
%
%  For the time being, we assume a linear SVM.  Moving to a nonlinear
%  SVM just requires tuning an additional hyperparameter.

% November 2015, mjp

p = inputParser;
p.addRequired('X', @isnumeric);
p.addRequired('y', @isnumeric);
p.addParameter('c', NaN);
p.addParameter('cost', []);
p.addParameter('verbose', 1);
p.parse(X, y, varargin{:});
p = p.Results;

assert(size(X,1) == length(y));


if isempty(p.cost)
    % Use Matlab's default of a matrix c_{i,j} = ~ \delta_{i,j}
    n = length(unique(y));
    p.cost = ones(n);
    p.cost(1:(n+1):n*n) = 0;
end


%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
% Hyperparameter tuning (optional)
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
if ~isfinite(p.c)
    if p.verbose, 
        fprintf('[%s] Tuning hyperparameter c\n', mfilename); 
    end

    % for now, just do a simple grid search
    cVals = 10.^(-5:5);
    losses = zeros(size(cVals));
    
    for ii = 1:length(cVals)
        tic
        svm = fitcsvm(X, y, 'Standardize', true, 'BoxConstraint', cVals(ii), 'Cost', p.cost);
        csvm = crossval(svm);
        losses(ii) = kfoldLoss(csvm, 'Mode', 'average');
        runtime = toc;
        clear svm csvm;
        
        if p.verbose
            fprintf('  value c=%0.2e produced loss %0.2f (%0.2f sec)\n', ...
                    cVals(ii), losses(ii), runtime);
        end
    end
    
    [~,tmp] = min(losses);
    p.c = cVals(tmp);
end


%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
% Train and calibrate SVM
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
if p.verbose
    fprintf('[%s]: Training SVM using %d examples and c=%0.2e\n', mfilename, length(y), p.c);
end

tic
svm = fitcsvm(X, y, 'Standardize', true, 'BoxConstraint', p.c, 'Cost', p.cost);
runtime = toc;

if p.verbose
    fprintf('[%s]: Training took %0.2f sec.\n', mfilename, runtime);
    fprintf('[%s]: Calibrating...\n', mfilename);
end

%[csvm,xform] = fitSVMPosterior(svm, train.X, train.y);
[csvm,xform] = fitSVMPosterior(svm, 'KFold', 5);
runtime = toc;

sigmoid = @(x,a,b) 1 ./ (1 + exp(a*x + b));
f_calibrate = @(x) sigmoid(x, xform.Slope, xform.Intercept);

fprintf('[%s]: ...calibration complete.  Total runtime = %0.2f sec\n', mfilename, runtime);
