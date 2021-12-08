clear all

Q = 10;
R = 1;
A = 1;
C = -1;

Pss = 0.5*(sqrt(Q*(Q-4*R))-3*Q)
Lss = (sqrt(Q*(Q-4*R))-Q)/(sqrt(Q*(Q-4*R))-Q+2*R)

Llqe = dlqr(A',A'*C',Q,R)'
