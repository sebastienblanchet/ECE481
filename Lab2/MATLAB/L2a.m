% Lab 2, Part A

clear; close all; clc;

% Motor params
tau = 0.023;
K1 = - 1.02/tau;

% Place further into LHP, vary %OS
Tset = 0.5;
OS = 0:1:5;

% DT simlation parameters
ms = 1;
Ts = ms*1E-3;
ncyc = 2;
Nsamp = 10E3;
fhz = ncyc/(Nsamp*Ts);

% Pole placement for C1(s)
theta.rad = atan((-1/pi)*log(OS/100));
theta.deg = theta.rad*180/pi;
Re = 4/Tset;
Im = (4/Tset)./ tan(theta.rad);
p1 = 1/ tau;
p2 = complex(-Re,Im);
p3 = complex(-Re,-Im);
g0 = 2*Re;
K = (Re.^2 + Im.^2)/K1;
s = tf('s');
P = (K1)/(s*(s+p1));
C = K*((s+p1)/(s+g0));

%Plot varying pole locations
lgnd = cell(1,numel(OS));
hold all
figure(1)

for i=1:numel(OS)
    T(i) = feedback(P*C(i),1);
    [y_ct(:,:,i),t_ct(:,:,i)] = step(T(i), 1.5);
    %T_info = stepinfo(T(i));
    %zpk(C)
    %zpk(P)
end
for i=1:numel(OS)
    plot(t_ct(:,:,i),y_ct(:,:,i))
    lgnd{i} = sprintf('OS = %i , p = %.0f +- j %.1f', ...
        OS(i), -Re, Im(i));
end
xlabel('Time t [sec]')
ylabel('\theta [rad]')
title('Step Response')
legend(lgnd);
print(1,'-djpeg','Plots\Step_pvar');


% Simulate CT controller C1(s)
sim('Simulink\Model_2a');
ct.ref = ref;
ct.u = u;
ct.ang = ServoAng;
clear tout ref ThRef u ServoAng
save_system('Simulink\Model_2a');
close_system('Simulink\Model_2a');

% Part b, emulation of C1(s) with trapzoidal rule
Tz = c2d(C(2), Ts,'tustin');
format long
[num,den] = tfdata(Tz,'v');
% Controller coefficients for LabVIEW
a = num(1);
b = num(2);
c = den(1);
d = den(2);
c1 = -d/c;
c2 = a/c;
c3 = b/c;

% Simulate D1[z]
sim('Simulink\Model_2b');
dt.ref = ref;
dt.u = u;
dt.ang = ServoAng;
clear tout ref ThRef u ServoAng
% save_system('Simulink\Model_2b');
% close_system('Simulink\Model_2b');

% Experimental data
exp.ref = xlsread('N:\GitHub\ECE481\Lab2\Exp Data\06-22-17\ThRef.xlsx');
exp.u = xlsread('N:\GitHub\ECE481\Lab2\Exp Data\06-22-17\u.xlsx');
exp.ang = xlsread('N:\GitHub\ECE481\Lab2\Exp Data\06-22-17\ServoAng.xlsx');

% Tracking plots of CT vs DT, simulations
figure(2)
trackplot(ct.ref, ct.u, ct.ang, 'CT', dt.ref, dt.u, dt.ang, ...
    'DT', ms, 2);

% Tracking plots of DT Sim vs DT exp
figure(3)
trackplot(dt.ref, dt.u, dt.ang,'Sim',...
    exp.ref, exp.u, exp.ang, 'Exp', ms, 3);
