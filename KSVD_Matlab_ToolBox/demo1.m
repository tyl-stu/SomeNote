% KSVD running file
% in this file a synthetic test of the K-SVD algorithm is performed. First,
% a random dictionary with normalized columns is being generated, and then
% a set of data signals, each as a linear combination of 3 dictionary
% element is created, with noise level of 20SNR. this set is given as input
% to the K-SVD algorithm.

% a different mode for activating the K-SVD algorithm is until a fixed
% error is reached in the Sparse coding stage, instead until a fixed number of coefficients is found
% (it was used by us for the
% denoising experiments). in order to switch between those two modes just
% change the param.errorFlag (0 - for fixed number of coefficients, 1 -
% until a certain error is reached).



param.L = 4;   % number of elements in each linear combination.
param.K = 10; % number of dictionary elements
param.numIteration = 30; % number of iteration to execute the K-SVD algorithm.

param.errorFlag = 0; % decompose signals until a certain error is reached. do not use fix number of coefficients.
%param.errorGoal = sigma;
param.preserveDCAtom = 0;

%%%%%%% creating the data to train on %%%%%%%%
N = 20; % number of signals to generate
n = 4;   % dimension of each data
% SNRdB = 20; % level of noise to be added
% [param.TrueDictionary, D, x] = gererateSyntheticDictionaryAndData(N, param.L, n, param.K, SNRdB);
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%% initial dictionary: Dictionary elements %%%%%%%%
D=randn(1,20);
% D =[    0.9736    0.0777    0.2600    0.0620   -0.2304   -0.7423   -0.5626   -0.3611;
%    -1.6218   -1.4809   -1.3147    1.3018    2.1225   -0.4863   -1.4601    0.4708;
%     0.9989    0.6580    0.1184    0.3662   -1.4400   -0.3024    0.3116    1.0625;
%     1.5201    0.2445    0.8431   -0.9663    0.7049   -0.1089   -1.5096   -1.5038]
param.InitializationMethod =  'GivenMatrix';%不需要初始字典
 param.initialDictionary=ones(1,10);

param.displayProgress = 1;
disp('Starting to  train the dictionary');

[Dictionary,output]  = KSVD(D,param);
Psi = Dictionary;%1*10
N=20;M=10;
Phi = randn(M,M);

% disp(['The KSVD algorithm retrived ',num2str(output.ratio(end)),' atoms from the original dictionary']);

% [Dictionary,output]  = MOD(D,param);

% disp(['The MOD algorithm retrived ',num2str(output.ratio(end)),' atoms from the original dictionary']);
