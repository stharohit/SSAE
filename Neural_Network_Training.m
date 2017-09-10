function [net]=Neural_Network_Training (X, b, M1, M2, P1, P2)

% CALL METHODS:
%   [model] = Neural_Network_Training(X, b, M1 ,M2, P1, P2)
%
% DESCRIPTION:
%   Learn the correlation among the features to reveal the unobserved
%   variables, which drives any changes in the data. This correlation is
%   represented at the bottleneck layer, where the number of nodes depends
%   on the number of unobserved variables expected. (Currently, M1 is taken
%   equal to M2.)
%
%   In the context of damage detection, assuming the network is trained to
%   learn the correlations between the features from an undamaged system,
%   the predict errors will grow when features, which fed the network, come
%   from a potential damaged system.
%
% OUTPUTS:
%   net : parameters of the model, the fields are as follows:
%      .net (object) : neural network object defining the basic features of
%      the trained network
%


X=X'; % X(m,n)
[m n]=size(X);


% Check Parameters

if nargin < 1 || isempty(X)==1
    error('stats:learnAANN_shm:TooFewInputs',...
        'At least one input arguments required.');
end

if nargin <2 || isempty(b)==1
    b=1;
end

if nargin <3 || isempty(M1)==1
    aux=floor(m*(n-b)/(2*(m+b+1)));
    if aux>5; M1=5; else M1=aux; end
end

if nargin <4 || isempty(M2)==1
    M2=M1;
end

if nargin <5 || isempty(P1)==1
    P1=50;
end

if nargin <6 || isempty(P2)==1
    P2=1e-10;
end

if M1+M2<=b, error('Error: number of nodes in the mapping and de-mapping layers must be higher than number of nodes in the bottleneck layer.'); end

if M1+M2>m*(n-b)/(m+b+1), error(['Error: for b=',num2str(b),' the number of nodes M1+M2 must be < than ',num2str(floor(m*(n-b)/(m+b+1)))]); end


net=newff(X,X,[M1 b M2],{'tansig','purelin','tansig'});
net.performFcn='mse';
net.trainParam.epochs=P1;
net.trainParam.goal=P2;

% Training the algorithm using NN

[net] = train(net,X,X);

Y = sim(net,X);

e=X-Y;

E=mse(e);

% Store as a structure array
save net net;
end