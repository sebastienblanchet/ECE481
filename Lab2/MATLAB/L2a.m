% Lab 2, Part A

clear; close all; clc;

tau = 0.023;
K1 = - 1.02/tau;
Tset = 0.25;
OS = 0:1:5;

theta.rad = atan((-1/pi)*log(OS/100));
theta.deg = theta.rad*180/pi;
% Place further into LHP 
% When discretizing, will be less ideal
% Meet settling time
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


lgnd = cell(1,numel(OS));
hold all

for i=1:numel(OS)
    T(i) = feedback(P*C(i),1);
    [y_ct(:,:,i),t_ct(:,:,i)] = step(T(i), 1.5);
    %T_info = stepinfo(T(i));
    %zpk(C)
    %zpk(P)
end    

for i=1:numel(OS)
    figure(1)
    plot(t_ct(:,:,i),y_ct(:,:,i))
    lgnd{i} = sprintf('OS = %i p = %f +- j %.1f', OS(i), -Re, Im(i));
end
xlabel('Time t [sec]')
ylabel('\theta [rad]')
title('Step Response')
legend(lgnd);

% Part b
%c2d tunstin
Ts = 100E-3;
Tz = c2d(C, Ts,'tustin');
format long
[num,den] = tfdata(Tz,'v');
a = num(1);
b = num(2);
c = den(1);
d = den(2);


%fig = trackplot();