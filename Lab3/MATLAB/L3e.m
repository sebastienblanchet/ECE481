clear; close all; clc;

%% Lab 1
% Motor params
tau = 0.023;
K1 = -1.02/tau;


%% Lab 2
% Place further into LHP, vary %OS
c1.Tset = 0.5;
c1.OS = 1;

% DT simlation parameters
ms = 1;
Ts = ms*1E-3;
ncyc = 2;
Nsamp = 40E3;
fhz = ncyc/(Nsamp*Ts);
tsim = 40;


% Wave form
wave.max = 0.29;
wave.min = 0.14;
wave.amp = 0.5*(wave.max-wave.min);
wave.offset = wave.min+wave.amp;

% Pole placement for C1(s)
[c1.Re, c1.Im, c1.theta] = zone(c1.OS, c1.Tset);
c1.p1 = 1/ tau;
c1.p2 = complex(-c1.Re,c1.Im);
c1.p3 = complex(-c1.Re,-c1.Im);
c1.g0 = 2*c1.Re;
c1.K = (c1.Re^2 + c1.Im^2)/K1;
s = tf('s');
P = (K1)/(s*(s+c1.p1));
C1 = c1.K*((s+c1.p1)/(s+c1.g0));

% Inside loop

Ps = (zpk(C1)*zpk(P))/(1+zpk(C1)*zpk(P));

% Lab 2 Part b, emulation of C1(s) with trapzoidal rule
D1 = c2d(C1, Ts,'tustin');
format long
[c1.num,c1.den] = tfdata(D1,'v');


% Controller coefficients for LabVIEW
c1.a = c1.num(1);
c1.b = c1.num(2);
c1.c = c1.den(1);
c1.d = c1.den(2);
c1.c1 = -c1.d/c1.c;
c1.c2 = c1.a/c1.c;
c1.c3 = c1.b/c1.c;

% Gains
r = 2.54;
L = 41.7;
R = 1.27; 
m = 0.064;
g = 9.81;
D = 0.5;
l = R - D;
K2 = r/L;
K3 = 4.55;
Kbb = K2*K3;

% Ball pson scale
x1 = R/100;
x2 = (L-R)/100;
y1 = 3.22;
y2 = 7.29;
m = (x2-x1)/(y2-y1);
b = x1-m*y1;

%% Lab 3
% Design controller 2
c2.tset =10.4;
c2.os = 48;

[c2.Re, c2.Im, c2.ang] = zone(c2.os,c2.tset);

c2.p1 = 1;
c2.p2 = 2.5;
c2.p3 = 5;

c2.eps = 1/(c2.p1+c2.p2+c2.p3);
c2.Kd = (c2.eps*(c2.p1*c2.p2+c2.p3*(c2.p1+c2.p2)))/Kbb;
c2.Kp =(c2.eps*(c2.p1*c2.p2*c2.p3))/Kbb;
C2 = (c2.Kd*s+c2.Kp)/(1+c2.eps*s);

D2 = c2d(C2, Ts,'tustin');
[c2.num,c2.den] = tfdata(D2,'v');

% Controller coefficients for LabVIEW
c2.a = c2.num(1);
c2.b = c2.num(2);
c2.c = c2.den(1);
c2.d = c2.den(2);
c2.c1 = -c2.d/c2.c;
c2.c2 = c2.a/c2.c;
c2.c3 = c2.b/c2.c;

Pry = Ps*zpk(K2*K3/s^2);
[c2.y, c2.t] = step(feedback(C2*Pry,1),15);


% Step response
fig = figure(1);
plot(c2.t, 0.29*c2.y)
title('Step Response');
xlabel('Time [sec]');
ylabel('y [m]');
print(1,'-djpeg','3f_Step');

% Simulate DT controller C2(s)
sim('Simulink\Model_3ac_2015a');
sim.ThRef = ThRef;
sim.ref = ref;
sim.u = u;
sim.ServoAng = ServoAng;
sim.yref = yref;
sim.BallPosn = BallPosn;
sim.txt = 'Sim3f';
clear tout ThRef u ServoAng yref BallPosn ref BeamAng

% Check if specs are met
C2step = stepinfo(feedback(C2*Pry,1));

if(C2step.Overshoot <= c2.os)
    display('Overshoot met with:')
    C2step.Overshoot
else
    display('Overshoot NOT met')
end

%Setteling time
if(C2step.SettlingTime <= c2.tset)
    display('SettlingTime met:')
    C2step.SettlingTime 
else
    display('SettlingTime NOT met')
end

% Saturation
display('ThRef Max')
max(abs(sim.ref(5000:end,2)))

% Import experimental data
exp.data = xlsread('N:\GitHub\ECE481\Lab3\Data\170720_3f.xlsx');
exp.t = exp.data(:,1);
exp.yref = exp.data(:,2);
exp.ServoAng = exp.data(:,3);
exp.BallPosn = exp.data(:,4);
exp.u = exp.data(:,5);
exp.ThRef = exp.data(:,6);
exp.txt = 'Exp3f';

% Tracking plot
trackplot3(sim, exp, ms, 2);
