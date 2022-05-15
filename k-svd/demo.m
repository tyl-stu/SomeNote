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
param.L =20;   % number of elements in each linear combination.  ÿ����������е�Ԫ������
param.K =150; %number of dictionary elements  �ֵ�Ԫ���� -- ϡ�������ά����С���Ǹ�ά�ȵ�ֵ
param.numIteration = 40; % number of iteration to execute the K-SVD algorithm.  ִ��K-SVD�㷨�ĵ�������
param.errorFlag = 0; % decompose signals until a certain error is reached.   �ֽ��źţ�ֱ���ﵽһ������
                     %do not use fix number of coefficients.   ��Ҫʹ�ù̶�������ϵ����
%param.errorGoal = sigma;  
param.preserveDCAtom = 0;  
param.InitializationMethod ='DataElements';%initialization by the signals themselves  ���źű����ʼ��
param.displayProgress = 1; % progress information is displyed.  ��ʾ������Ϣ��
[Dictionary,output]= KSVD(img,param);%Dictionary is N*param.K   
%************************ projection **************************************  
% y=Phi*img;          % treat each column as a independent signal  ��ÿ����Ϊ�������ź�
y0=y;  % keep an original copy of the measurements  
%********************* recover using OMP *********************************  
D=Phi*Dictionary;  
A=OMP(D,y,20);  %ͼ���OMP
% A=CS_OMP(D,y,20);  %һά�źŵ�OMP
imgr=Dictionary*A;    
%***********************  show the results  ********************************   
figure(1)  
subplot(2,2,1),imagesc(img0),title('original image')  
subplot(2,2,2),imagesc(y0),title('measurement image')  
subplot(2,2,3),imagesc(Dictionary),title('Dictionary')  
psnr=20*log10(255/sqrt(mean((img(:)-imgr(:)).^2)));  
subplot(2,2,4),imagesc(imgr),title(strcat('recover image ��',num2str(psnr),'dB��'))  
disp('over')  