% Lab 2, Part A

clear; close all; clc;

% Motor params
tau = 0.023;
K1 = - 1.02/tau;

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
C = K*((s+p1)/(s+g0));

% Part b, emulation of C1(s) with trapzoidal rule
Tz = c2d(C, Ts,'tustin');
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

% Gains
r = 2.54;
L = 41.7;
R = 1.27; 
m = 0.064;
g = 9.81;
D = 0.5;
l = R - D;

K2 = r/L;
%K3 = (5*(l^2)*g)/(7*(R^2));
K3 = 7;