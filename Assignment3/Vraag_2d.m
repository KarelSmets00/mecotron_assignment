clear all


Q = 1e-11;
R = 1e-6;
A = 1;
C = -1;

rho = Q/R;

Pss = 0.5*Q*(sqrt(1+4/rho)-1)
Lss = -(1+sqrt(1+4/rho))/(1+sqrt(1+4/rho)+2/rho)

Llqe = dlqr(A',A'*C',Q,R)'
