%ѹ����֪�ع��㷨����
% ѹ����֪�ع��㷨֮����ƥ��׷��(OMP)��������������������������������������������
%%%% �ָ��вans = 3.0390 ̫�󣡣�������������������������������
clear all;close all;clc;

% bit_seq1 = load('E:\�о�����\��-my_topic\���û�NOMA-OFDMA-SIM - 1\create_x');
% seq = bit_seq1.x;
% 
% x = seq;
% M = 52*4;%�۲�ֵ����
% N = length(x);%�ź�x�ĳ���
% K = 52;%�ź�x��ϡ���

N = 80;
for i = 0.3:0.1:0.5
M = floor(N*i);
% M=80;
K= floor(M/8);
% K = 12;
x = zeros(N,1);
Index_K = randperm(N);
% x(Index_K(1:K)) = 5*randn(K,1);%xΪKϡ��ģ���λ���������
x(Index_K(1:K)) = 1;


Psi = eye(N);%x������ϡ��ģ�����ϡ�����Ϊ��λ��x=Psi*theta
Phi = randn(M,N);%��������Ϊ��˹����
A = Phi * Psi;%���о���
y = Phi * x;%�õ��۲�����y
s = inv(Psi)*x;
% y = A * s;

%% ͨ��ԭ�ź���ϡ������ϡ���ź��Ƿ�ϡ��  x = Psi*s
s_beg = inv(Psi)*x;
sum(s_beg~=0);

%% �ָ��ع��ź�x
tic
theta = CS_OMP(y,A,K);
x_r = Psi * theta;% x=Psi * theta
toc
%% ��ͼ
figure;
plot(x_r,'k.-');%���x�Ļָ��ź�
hold on;
plot(x,'r');%���ԭ�ź�x
hold off;
legend('Recovery','Original')
fprintf('\n�ָ��в');
norm(x_r-x)%�ָ��в�
% [n1,r1] = biterr(x,round(x_r));
end