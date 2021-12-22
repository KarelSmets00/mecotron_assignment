clear all; close all;

% -- Parameters --
theta_max = 30;         % [°]
theta_max = theta_max*2*pi/360;
omega = 4;              % [rad/s]
load('..\Assignment 1\sys_31zf_cart.mat') % motor models
load('..\Assignment2\C_I.mat')           % controller models
Ts = motor_A.Ts;        % [s] sample time 

dwell = 2;              % [s] duration of dwell

R = 0.0325;             % [m] wheel radius
W = 0.1660;             % [m] wheelbase

% -- Basic calc --

dt = (theta_max*W/2)/(omega*R)
samples = round(dt/Ts);

motion_profile = repmat(omega,1,samples);

samples = dwell/Ts;

motion_profile = [motion_profile, repmat(0,1,samples)];


% -- simulate --
t = 0:0.01:((length(motion_profile)-1)*0.01);

response_A = lsim(feedback(motor_A*model_A,1),motion_profile,t);
response_B = lsim(feedback(motor_B*model_B,1),-motion_profile,t);

cart_motion(:,1) = R*(response_A-response_B)/(W);  % [rad/s] rotational velocity

figure()
plot(t,cart_motion(:,1))

% - integrate cart angular velocity -

cart_motion(:,2) = cumsum(cart_motion(:,1))*Ts;

figure()
plot(t,cart_motion(:,2)*360/(2*pi))

figure()
plot(t,motion_profile)

cart_motion(:,3) = R*(response_A+response_B)/(2);  % [rad/s] rotational velocity

% -- recreate states -- 

xc_init = -0.3;
yc_init = -0.2;
th_init = 0;

states(:,1) = cumsum(cart_motion(:,3).*cos(cart_motion(:,2)))*Ts + xc_init;    % xc
states(:,2) = cumsum(cart_motion(:,3).*sin(cart_motion(:,2)))*Ts + yc_init;    % yc
states(:,3) = cart_motion(:,2) + th_init;                                     % theta

alpha = 0.09;
gamma = 0.075;
beta = 0.07;

measurements = [-states(:,1)'./(cos(states(:,3)')) - alpha
                (beta*sin(states(:,3)')-states(:,1)')./(cos(states(:,3)')) - gamma];
    
measurements_noisy(1,:) = awgn(measurements(1,:),45,'measured');
measurements_noisy(2,:) = awgn(measurements(2,:),45,'measured');

figure()
plot(t,measurements_noisy')
%plot(t,measurements')

%% Kalman filter

u = [zeros(size(motio_profile))
     motio_profile             ];
     
y = measurements_noisy;

xhat = zeros(3,length(u(1,:)));

% - init state estimate -

xhat(1,1) = -20;
xhat(2,1) = -30;
xhat(3,1) = 0;

% - stochastiek -

for i = 1:length(u(1,:))
    
    % filter implementeren
    
end

