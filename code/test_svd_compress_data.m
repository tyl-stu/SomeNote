%% svd压缩图像
 
% img1 = imread('E:\研究生活\研-my_topic\CS_all\CS_code\erwei_new code\lena.bmp');
% imwrite(img1,'E:\研究生活\研-my_topic\CS_all\CS_code\erwei_new code\lena.jpg');
img = imread('E:\研究生活\研-my_topic\CS_all\CS_code\erwei_new code\netlena.jpeg');
R = img(:,:,1);
G = img(:,:,2);
B = img(:,:,3);
k = 20;
[rebuildImgR,imgSizeR] = svdImg(R,k);
[rebuildImgG,imgSizeG] = svdImg(G,k);
[rebuildImgB,imgSizeB] = svdImg(B,k);
 
rebuildImg = cat(3,rebuildImgR,rebuildImgG,rebuildImgB);
oriS = numel(img);
rebuildS = imgSizeR+imgSizeG+imgSizeB;
 
%% show
% imtile(filenames)
pairImg = imtile({img,rebuildImg});%%%%!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
imshow(pairImg)
fprintf('origin image size:%d, rebuild image size:%d,compress ratio:%.2f\n',...
oriS,rebuildS,oriS/rebuildS);
 
 
function [rebuildImg,imgSize] = svdImg(oriImg,k)
img = im2double(oriImg);
[U,S,V] = svd(img);
 
U_ = U(:,1:k);
S_ = S(1:k,1:k);
V_ = V(:,1:k);
rebuildImg = U_*S_*V_';
imgSize = numel(U_)+k+numel(V_);
end