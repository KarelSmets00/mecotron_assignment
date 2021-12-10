clear all;
%% design
%
K = 55;
Ts = 0.01;
R = 0.0325;

A = 1;
C = -1;
L = acker(A, A*C, exp(-Ts*R*K/10))


%% plots

