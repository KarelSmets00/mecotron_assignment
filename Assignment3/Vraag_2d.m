clear all

Q = 9.5199e-7;
R = 9.5199e-7;
A = 1;
C = -1;

rho = Q/R;

Pss = 0.5*Q*(sqrt(1+4/rho)-1)
Lss = -(1+sqrt(1+4/rho))/(1+sqrt(1+4/rho)+2/rho)

Llqe = dlqr(A',A'*C',Q,R)'
