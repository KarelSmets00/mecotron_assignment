clear all

vraag3c = 1             %if==1, calculations for 3c are done, otherwise calc for 2d

if ~vraag3c
    Q = 0.1;
    R = 9.5199e-7;
    A = 1;
    C = -1;
    
    rho = Q/R;
    
    Pss = 0.5*Q*(sqrt(1+4/rho)-1)
    Lss = -(1+sqrt(1+4/rho))/(1+sqrt(1+4/rho)+2/rho)
    
    Llqe = dlqr(A',A'*C',Q,R)'
else
    format long
    R = 9.5199e-7;
    Q = [1e-1 1e-3 1e-5 1e-7 1e-8 1e-9 1e-11]';
    rho = Q./R;

    Pss = 0.5*Q.*(sqrt(1+4./rho)-1)
    Lss = -(1+sqrt(1+4./rho))./(1+sqrt(1+4./rho)+2./rho)
end

