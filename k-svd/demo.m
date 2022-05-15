%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  
% the K-SVD basis is selected as the sparse representation dictionary  
% the OMP  algorithm is used to recover the image  
% Author: zhang ben, ncuzhangben@qq.com  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  
clear;clc;
%***************************** read in the image **************************  
img=imread('lena.bmp'); 
img=rgb2gray(img);% read in the image "lena.bmp"  
img=double(img);  
[N,n]=size(img);   
img0 = img;  % keep an original copy of the input signal  
%****************form the measurement matrix and Dictionary ***************  
%form the measurement matrix Phi  
Phi=randn(N,n);     
Phi = Phi./repmat(sqrt(sum(Phi.^2,1)),[N,1]); % normalize each column  
y=Phi*img;
%fix the parameters  
param.L =20;   % number of elements in each linear combination.  每个线性组合中的元素数。
param.K =150; %number of dictionary elements  字典元素数 -- 稀疏基行列维度中小的那个维度的值
param.numIteration = 40; % number of iteration to execute the K-SVD algorithm.  执行K-SVD算法的迭代次数
param.errorFlag = 0; % decompose signals until a certain error is reached.   分解信号，直到达到一定的误差。
                     %do not use fix number of coefficients.   不要使用固定数量的系数。
%param.errorGoal = sigma;  
param.preserveDCAtom = 0;  
param.InitializationMethod ='DataElements';%initialization by the signals themselves  由信号本身初始化
param.displayProgress = 1; % progress information is displyed.  显示进度信息。
[Dictionary,output]= KSVD(img,param);%Dictionary is N*param.K   
%************************ projection **************************************  
% y=Phi*img;          % treat each column as a independent signal  将每列视为独立的信号
y0=y;  % keep an original copy of the measurements  
%********************* recover using OMP *********************************  
D=Phi*Dictionary;  
A=OMP(D,y,20);  %图像的OMP
% A=CS_OMP(D,y,20);  %一维信号的OMP
imgr=Dictionary*A;    
%***********************  show the results  ********************************   
figure(1)  
subplot(2,2,1),imagesc(img0),title('original image')  
subplot(2,2,2),imagesc(y0),title('measurement image')  
subplot(2,2,3),imagesc(Dictionary),title('Dictionary')  
psnr=20*log10(255/sqrt(mean((img(:)-imgr(:)).^2)));  
subplot(2,2,4),imagesc(imgr),title(strcat('recover image （',num2str(psnr),'dB）'))  
disp('over')  