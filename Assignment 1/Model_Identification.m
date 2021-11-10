% -------------------------------------------------------------------------
% -- Description -- 
% Script for the model identification of the dc motor and cart, 
% part of the control theory exam assignement.
% -- Date -- 
% November 2021
% -- Authors -- 
% Schietecat Mathias
% Smets Karel
% -------------------------------------------------------------------------

clear all; close all;

%% data pre-processing

verbose = 0;        % ask for more output
location = "C:\Users\Karel\Documents\Leuven\Master\Regeltechniek\Mecotron\Assignment 1\Measured Data\StepInput\singleStep\";
length = 80;
shift = 10;
Ts = 0.01;
voltage = 3;


for i = 1:1
    for j = 1:5
        
        file = append(int2str(i*3),"_",int2str(j),".csv");
        filename = append(location,file);
        
        csvfile = filename;
        labels = strsplit(fileread(csvfile), '\n'); % Split file in lines
        labels = strsplit(labels{:, 2}, ', '); % Split and fetch the labels (they are in line 2 of every record)
        data_temp = dlmread(csvfile, ',', 2, 0); % Data follows the labels
        
        i_start = find(data_temp(:,4)>0,1);
        data(:,:,((i-1)*5+j)) = data_temp(((i_start-shift):(i_start+length-1-shift)),:);
        
        if verbose
            figure(((i-1)*5+j))
            hold on

            t = data(:,1,1)/1000;

            for k = 2:(length(data(1,:,((i-1)*5+j)))-1)
                plot(data(:,1,((i-1)*5+j)),data(:,k,((i-1)*5+j)))
            end
            xlabel('t [s]')
            title('3V step')

            legend(labels(2:end))
        end

    end
end

t = Ts*(0:1:(length-1));
th_mean = mean(data(:,2,:),3);
v_mean = mean(data(:,3,:),3);
u_mean = mean(data(:,4,:),3)*voltage;

figure(10)
hold on
box on
plot(t,th_mean)
plot(t,v_mean)
plot(t,u_mean)
xlabel('t [s]')
legend('th','v','u')
title('Measurements')


%% identification of the simple model



%% identification of the more realistic model

% -------------------------------------------------------------------------
% ---- model for speed output ---- 

% -- fft -- 
v_f = fft(v_mean);
u_f = fft(u_mean);

fs = 1/Ts;
f = [0:(length-1)]*(fs/length);

% frf opgesteld in fig3
figure(20)
subplot(2,1,1)
semilogx(f, 20*log10(abs(v_f./u_f)))
hold on
box on
ylabel('mag. [dB]')
xlabel('\omega [rad/s]')
title('magnitude')

subplot(2,1,2)
semilogx(f, unwrap(angle(v_f./u_f))*180/pi)
hold on
box on
ylabel('ang. [°]')
xlabel('\omega [rad/s]')
title('phase')

% -- least squ --
b = v_mean(6:end);
A = [-v_mean(5:(end-1)) -v_mean(4:(end-2)) -v_mean(3:(end-3)) -v_mean(2:(end-4)) u_mean(5:(end-1)) u_mean(4:(end-2)) u_mean(3:(end-3)) u_mean(2:(end-4)) u_mean(1:(end-5))];

x = A\b;

Num_1 = [0 x(5:end)'];
Den_1 = [1 x(1:4)' 0];

sys_1 = tf(Num_1,Den_1,Ts)

figure(30)
hold on
box on
steprp_1 = lsim(sys_1,u_mean,t);
plot(t,steprp_1)
plot(t,v_mean)
stairs(t,u_mean)
xlabel('t [s]')
legend('simulation','measurement','input')
title('Speed Step Response')

% vergelijk bode diagrammen

H1 = squeeze(freqresp(sys_1,2*pi*f));

figure(20)
subplot(2,1,1)
hold on
box on
semilogx(f, 20*log10(abs(H1)))

subplot(2,1,2)
hold on
box on
semilogx(f, unwrap(angle(H1))*180/pi)

% -------------------------------------------------------------------------
% -------------------------------------------------------------------------
% ---- model for position output ----

% -- fft -- 
th_f = fft(th_mean);
u_f = fft(u_mean);

fs = 1/Ts;
f = [0:(length-1)]*(fs/length);

% frf opgesteld in fig3
figure(40)
subplot(2,1,1)
semilogx(f, 20*log10(abs(th_f./u_f)))
hold on
box on
ylabel('mag. [dB]')
xlabel('\omega [rad/s]')
title('magnitude')

subplot(2,1,2)
semilogx(f, unwrap(angle(th_f./u_f))*180/pi)
hold on
box on
ylabel('ang. [°]')
xlabel('\omega [rad/s]')
title('phase')

% -- least squ --
b = th_mean(7:end);
A = [-th_mean(6:(end-1)) -th_mean(5:(end-2)) -th_mean(4:(end-3)) -th_mean(3:(end-4)) -th_mean(2:(end-5)) u_mean(6:(end-1)) u_mean(5:(end-2)) u_mean(4:(end-3)) u_mean(3:(end-4)) u_mean(2:(end-5)) u_mean(1:(end-6))];

x = A\b;

Num_2 = [0 x(6:end)'];
Den_2 = [1 x(1:5)' 0];

sys_2 = tf(Num_2,Den_2,Ts)

figure(50)
hold on
box on
steprp_2 = lsim(sys_2,u_mean,t);
plot(t,steprp_2)
plot(t,th_mean)
stairs(t,u_mean)
xlabel('t [s]')
legend('simulation','measurement','input')
title('Position Step Response')

% vergelijk bode diagrammen

H2 = squeeze(freqresp(sys_2,2*pi*f));

figure(40)
subplot(2,1,1)
hold on
box on
semilogx(f, 20*log10(abs(H2)))

subplot(2,1,2)
hold on
box on
semilogx(f, unwrap(angle(H2))*180/pi)


