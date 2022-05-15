function [A]=OMP(D,X,L) 
%=============================================  
% Sparse coding of a group of signals based on a given   
% dictionary and specified number of atoms to use.   
% input arguments:   
%       D - the dictionary (its columns MUST be normalized).  
%       X - the signals to represent  
%       L - the max. number of coefficients for each signal.  
% output arguments:   
%       A - sparse coefficient matrix.  
%=============================================  
[n,K]=size(D);  
[n,P]=size(X);  
for k=1:1:P
    a=[];  
    x=X(:,k);%令向量x等于矩阵X的第K列的元素长度为n*1  
    residual=x;%n*1  
    indx=zeros(L,1);%L*1的0矩阵  
    for j=1:1:L,  
        proj=D'*residual;%K*n n*1 变成K*1  
        [maxVal,pos]=max(abs(proj));%  最大投影系数对应的位置  
        pos=pos(1);  
        indx(j)=pos;   
        a=pinv(D(:,indx(1:j)))*x; %求伪逆矩阵 
        residual=x-D(:,indx(1:j))*a;  
        if sum(residual.^2) < 1e-6  
            break;  
        end  
    end;  
    temp=zeros(K,1);  
    temp(indx(1:j))=a;  
    A(:,k)=sparse(temp);%A为返回为K*P的矩阵  
end;  
return;  

