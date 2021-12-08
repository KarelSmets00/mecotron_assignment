clear all

Q = 0.1;
R = 100;
A = 1;
C = -1;

rho = Q/R;

Pss = 0.5*Q*(sqrt(1+4/rho)-1)
Lss = -(1+sqrt(1+4/rho))/(1+sqrt(1+4/rho)+2/rho)

Llqe = dlqr(A',A'*C',Q,R)'
