function [IOut,output,Coefs] = denoiseImageDCT(Image,sigma,K,varargin)
%==========================================================================
%   P E R F O R M   D E N O I S I N G   U S I N G   O V E R C O M P L E T E 
%                        D C T    D I C T I O N A R Y
%==========================================================================
% function IOut = denoiseImageDCT(Image,sigma,bb,K)
% denoise an image by sparsely representing each block with the
% overcomplete DCT Dictionary, and averaging the represented parts.
% Detailed description can be found in "Image Denoising Via Sparse and Redundant
% representations over Learned Dictionaries", (appeared in the 
% IEEE Trans. on Image Processing, Vol. 15, no. 12, December 2006).
% ===================================================================
% INPUT ARGUMENTS : Image - the noisy image (gray-level scale)
%                   sigma - the s.d. of the noise (assume to be white Gaussian).
%                   K - the number of atoms in the representing dictionary.
%    Optional argumeters:              
%                  'blockSize' - the size of the blocks the algorithm
%                       works. All blocks are squares, therefore the given
%                       parameter should be one number (width or height).
%                       Default value: 8.
%                  'errorFactor' - a factor that multiplies sigma in order
%                       to set the allowed representation error. In the
%                       experiments presented in the paper, it was set to 1.15
%                       (which is also the default value here).
%                  'maxBlocksToConsider' - maximal number of blocks that
%                       can be processed. This number is dependent on the memory
%                       capabilities of the machine, and performances?
%                       considerations. If the number of available blocks in the
%                       image is larger than 'maxBlocksToConsider', the sliding
%                       distance between the blocks increases. The default value
%                       is: 250000.
%                  'slidingFactor' - the sliding distance between processed
%                       blocks. Default value is 1. However, if the image is
%                       large, this number increases automatically (because of
%                       memory requirements). Larger values result faster
%                       performances (because of fewer processed blocks).
%                  'waitBarOn' - can be set to either 1 or 0. If
%                       waitBarOn==1 a waitbar, presenting the progress of the
%                       algorithm will be displayed.
% OUTPUT ARGUMENTS : IOut - a 2-dimensional array in the same size of the
%                   input image, that contains the cleaned image.
%                    output - a struct that contains that following field:
%                       D - the dictionary used for denoising
% =========================================================================

Reduce_DC = 1;
[NN1,NN2] = size(Image);
C = 1.15;%%%%%%%%%????????????????????????????????????
waitBarOn = 1;
maxBlocksToConsider = 260000;
slidingDis = 1;
bb = 8;

% for argI = 1:2:length(varargin)
%     if (strcmp(varargin{argI}, 'slidingFactor'))
%         slidingDis = varargin{argI+1};
%     end
%     if (strcmp(varargin{argI}, 'errorFactor'))
%         C = varargin{argI+1};
%     end
%     if (strcmp(varargin{argI}, 'maxBlocksToConsider'))
%         maxBlocksToConsider = varargin{argI+1};
%     end
%     if (strcmp(varargin{argI}, 'blockSize'))
%         bb = varargin{argI+1};
%     end
%     if (strcmp(varargin{argI}, 'waitBarOn'))
%         waitBarOn = varargin{argI+1};
%     end
%   
% end

errT = C*sigma;
%%
% Create a DCT dictionary from the DCT frame
Pn=ceil(sqrt(K));%%%Pn=16  bb=8  ????64*256??????
DCT=zeros(bb,Pn);  %8*16 ??????
for k=0:1:Pn-1,
    V=cos([0:1:bb-1]'*k*pi/Pn);  %bb*1????????  bb=8
    if k>0,
        V=V-mean(V);
    end;
    DCT(:,k+1)=V/norm(V);%norm(V)????????????????????????V????
end;
%????64*256??????
DCT=kron(DCT,DCT);%http://blog.sina.com.cn/s/blog_7671b3eb0101132y.html  ??Kronecker??????   
%for example : kron(X,Y) = [ X(1,1)*Y  X(1,2)*Y  X(1,3)*Y ; X(2,1)*Y  X(2,2)*Y  X(2,3)*Y ]
%%
%????????????????????????????block??????
while (prod(floor((size(Image)-bb)/slidingDis)+1)>maxBlocksToConsider)
    slidingDis = slidingDis+1;
% Default value is 1. However, if the image is
% large, this number increases automatically (because of
% memory requirements)
end
[blocks,idx] = my_im2col(Image,[bb,bb],slidingDis);
%%
%????DCT??????OMP????????????????????????????????????????????????patch
if (waitBarOn)
    counterForWaitBar = size(blocks,2);
    h = waitbar(0,'Denoising In Process ...');
end
% go with jumps of 10000
for jj = 1:10000:size(blocks,2)
    if (waitBarOn)
        waitbar(jj/counterForWaitBar);
    end
    jumpSize = min(jj+10000-1,size(blocks,2));
    if (Reduce_DC)%Reduce_DC??1
        vecOfMeans = mean(blocks(:,jj:jumpSize));%????10000??
        blocks(:,jj:jumpSize) = blocks(:,jj:jumpSize) - repmat(vecOfMeans,size(blocks,1),1);%repmat(vecOfMeans,size(blocks,1),1):??vecOfMeans????64??1??  ????3.12
    end
    %Coefs = mexOMPerrIterative(blocks(:,jj:jumpSize),DCT,errT);
    Coefs = OMPerr(DCT,blocks(:,jj:jumpSize),errT);  %????OMP??????DCT????????????????
    
    if (Reduce_DC)%Reduce_DC??1
        %DCT??64*256  Coefs256*10000         blocks??64*62001       vecOfMeans??1*10000  
        blocks(:,jj:jumpSize)= DCT*Coefs + ones(size(blocks,1),1) * vecOfMeans;%%%%blocks????????????????????  ????????????????????????????????     
    else
        blocks(:,jj:jumpSize)= DCT*Coefs ;
    end
end
%%
%??????????patch????????????????????????????
count = 1;
Weight= zeros(NN1,NN2);
IMout = zeros(NN1,NN2);
[rows,cols] = ind2sub(size(Image)-bb+1,idx);%idx=(size(Image)-bb+1)*(size(Image)-bb+1)
for i  = 1:length(cols)
    col = cols(i);
    row = rows(i);
    block =reshape(blocks(:,count),[bb,bb]);%block????????????8*8??????
   %block
    IMout(row:row+bb-1,col:col+bb-1)=IMout(row:row+bb-1,col:col+bb-1)+block;
    Weight(row:row+bb-1,col:col+bb-1)=Weight(row:row+bb-1,col:col+bb-1)+ones(bb);%%%??????????????block??????????????????????????
    count = count+1;
end;
if (waitBarOn)
    close(h);
end
C=100000;
IOut =(Image+C*sigma*IMout)./(1+C*sigma*Weight);%%%%%%%%%0.034,??????????????????  ??????C??????????????????????????????????????0??????????????????
output.D = DCT;
% IOut =  IMout./Weight;  %%%????????????????????????????????????????sigma????????????????????????(Image+C*sigma*IMout)./(1+C*sigma*Weight)
% IMout(100)
% Weight
%   blocks


