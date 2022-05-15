%压缩感知重构算法测试
% 压缩感知重构算法之正交匹配追踪(OMP)！！！！！！！！！！！！！！！！！！！！！！
%%%% 恢复残差：ans = 3.0390 太大！！！！！！！！！！！！！！！！！
clear all;close all;clc;

% bit_seq1 = load('E:\研究生活\研-my_topic\两用户NOMA-OFDMA-SIM - 1\create_x');
% seq = bit_seq1.x;
% 
% x = seq;
% M = 52*4;%观测值个数
% N = length(x);%信号x的长度
% K = 52;%信号x的稀疏度

N = 80;
for i = 0.3:0.1:0.5
M = floor(N*i);
% M=80;
K= floor(M/8);
% K = 12;
x = zeros(N,1);
Index_K = randperm(N);
% x(Index_K(1:K)) = 5*randn(K,1);%x为K稀疏的，且位置是随机的
x(Index_K(1:K)) = 1;


Psi = eye(N);%x本身是稀疏的，定义稀疏矩阵为单位阵x=Psi*theta
Phi = randn(M,N);%测量矩阵为高斯矩阵
A = Phi * Psi;%传感矩阵
y = Phi * x;%得到观测向量y
s = inv(Psi)*x;
% y = A * s;

%% 通过原信号与稀疏基检查稀疏信号是否稀疏  x = Psi*s
s_beg = inv(Psi)*x;
sum(s_beg~=0);

%% 恢复重构信号x
tic
theta = CS_OMP(y,A,K);
x_r = Psi * theta;% x=Psi * theta
toc
%% 绘图
figure;
plot(x_r,'k.-');%绘出x的恢复信号
hold on;
plot(x,'r');%绘出原信号x
hold off;
legend('Recovery','Original')
fprintf('\n恢复残差：');
norm(x_r-x)%恢复残差
% [n1,r1] = biterr(x,round(x_r));
end