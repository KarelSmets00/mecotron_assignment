%% calculate pi controller first

PI_controller

%% determine FF addition

% yss on unit ramp = L(s),s->0
yss = evalfr(sys_L,0);

Np = 1/yss

% add to controller
sys_FF = Np*sys_CL
sys_L_FF = Np*sys_L

% evaluate result

figure()
step(sys_FF)

