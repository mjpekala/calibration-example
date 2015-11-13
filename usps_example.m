% USPS_EXAMPLE   Demonstrate SVM calibration via Platt scaling
%                using the USPS data set.
%
%   Before running this script, you must download the Matlab
%   versions of the USPS data set (see getUSPS.sh).


rng(1) % For reproducibility


%% Load data

load('zip.train');
train.X = zip(:,2:end);
train.y = zip(:,1);
clear zip;

load('zip.test');
test.X = zip(:,2:end);
test.y = zip(:,1);
clear zip;

% create an arbitrary binary classification problem
target = [9 5 2];
train.y = double(ismember(train.y, target));
test.y = double(ismember(test.y, target));

%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
% Address class asymmetry
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
if 0
    idx = rebalance(train.y, 900);
    train.X = train.X(idx,:);
    train.y = train.y(idx);
    
    idx = rebalance(test.y);
    test.X = test.X(idx,:);
    test.y = test.y(idx);
    
    C = [0 1 ; 1 0];
else
    C = [0  1  ;
         sum(train.y==0) / sum(train.y==1)  0]; 
end


%% Create and evaluate SVM

% Train SVM.
% The value for c was determined by a previous hyperparameter search. 
[csvm, f_calibrate, svm] = train_and_calibrate(train.X, train.y, 'c', 1e-2, 'Cost', C);


%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
% Evaluate performance on train and test data
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
[train.yHat, train.prob] = predict(csvm, train.X);
[~, train.rawProb] = predict(svm, train.X);

[test.yHat, test.prob] = predict(csvm, test.X);
[~, test.rawProb] = predict(svm, test.X);
confusionmat(test.y, test.yHat)

%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
% Show some reliability diagrams
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

a = min(train.rawProb(:,2));  b = max(train.rawProb(:,2));
xv = linspace(a, b, 100);    % space of raw scores
xn = (xv - a) / (b-a);       % normalized space of raw scores

% Show raw (i.e. not yet calibrated) scores along with 
% the calibrating sigmoid.
plot_reliability_diagram(train.rawProb(:,2), train.y);
hold on
plot(xn, f_calibrate(xv));
hold off;
title('Reliability Diagram : Raw Train Scores');

% The result of calibrating the training data.  This isn't
% particularly meaningful since this is training data - just for show.
plot_reliability_diagram(train.prob(:,2), train.y);
title('Reliability Diagram : Calibrated Train Scores');

% Same diagrams, but for test data.
plot_reliability_diagram(test.rawProb(:,2), test.y);
hold on
plot(xn, f_calibrate(xv));
hold off;
title('Reliability Diagram : Raw Test Scores');

plot_reliability_diagram(test.prob(:,2), test.y);
title('Reliability Diagram : Calibrated Test Scores');
