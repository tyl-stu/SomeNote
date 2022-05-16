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
    x=X(:,k);%������x���ھ���X�ĵ�K�е�Ԫ�س���Ϊn*1  
    residual=x;%n*1  
    indx=zeros(L,1);%L*1��0����  
    for j=1:1:L,  
        proj=D'*residual;%K*n n*1 ���K*1  
        [maxVal,pos]=max(abs(proj));%  ���ͶӰϵ����Ӧ��λ��  
        pos=pos(1);  
        indx(j)=pos;   
        a=pinv(D(:,indx(1:j)))*x; %��α����� 
        residual=x-D(:,indx(1:j))*a;  
        if sum(residual.^2) < 1e-6  
            break;  
        end  
    end;  
    temp=zeros(K,1);  
    temp(indx(1:j))=a;  
    A(:,k)=sparse(temp);%AΪ����ΪK*P�ľ���  
end;  
return;  

