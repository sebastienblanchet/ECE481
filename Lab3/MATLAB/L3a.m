clear; close all; clc;

%% Lab 1
% Motor params
tau = 0.023;
K1 = -1.02/tau;


%% Lab 2
% Place further into LHP, vary %OS
Tset = 0.5;
OS = 1;

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
C1 = K*((s+p1)/(s+g0));

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

% Ball pson scale
x1 = R;
x2 = L-R;
y1 = 3.22;
y2 = 7.29;
m = (x2-x1)/(y2-y1);
b = x1-m*y1;

%% Lab 3
% Design controller 2
C2 = 7*((s+0.35)/(s+2.5));
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

% Wave form
wave.max = 0.24;
wave.min = 0.14;
wave.amp = 0.5*(wave.max-wave.min);
wave.offset = wave.min+wave.amp;

% Simulate DT controller C2(s)
sim('Simulink\Model_3a_2012');
sim.ThRef = ThRef;
sim.u = u;
sim.ServoAng = ServoAng;
sim.yref = yref;
sim.BallPosn = BallPosn;
sim.txt = 'Sim';
clear tout ThRef u ServoAng yref BallPosn

% Import experimental data
exp.data = xlsread('N:\GitHub\ECE481\Lab3\Data\170711.xlsx');
exp.t = exp.data(:,1);
exp.yref = exp.data(:,2);
exp.ServoAng = exp.data(:,3);
exp.BallPosn = exp.data(:,4);
exp.u = exp.data(:,5);
exp.ThRef = exp.data(:,6);
exp.txt = 'Exp';

% Convert from cm to m
exp.BallPosn = exp.BallPosn/100;

% Tracking plot
trackplot3(sim, exp, ms, 1);

