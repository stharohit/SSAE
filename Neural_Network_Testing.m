function [out] = Neural_Network_Testing (Y, model,training_samples, testing_samples)

% [results, Residuals] = testing model (Test Features, Model)
%
% DESCRIPTION:
%   For each instance of Y, this function returns a score based on the
%   Euclidean norm of the residual errors between the target features and
%   the output of the final layer.
%
%   In the context of damage detection, assuming the network is trained to
%   learn the correlations between the features from an undamaged system,
%   the predict errors will grow when features, which fed the network, come
%   from a potentially damaged system.
%
% OUTPUTS:
%   results (INSTANCES, 1) : column vector composed by n results
%
%   residuals(INSTANCES, FEATURES) : residual errors
%
% Check Parameters

if nargin < 2
    error('stats:scoreAANN_shm:TooFewInputs',...
        'At least two input arguments required.');
end

% Set parameters

Y=Y; % Y(m,n)
net=model;

% Validation of the network using test data Y
outputLayer=sim(net,Y);

%residuals=outputLayer-Y; % Residual errors
%residuals=residuals';

%results=sqrt(sum((residuals).^2,2)); % Euclidean distance
out =min(mean(outputLayer));

end