% Lab 2, Part A

clear; close all; clc;

tau = 0.023;
K1 = -1.02;
s = tf('s');

Ts = 0.55;
OS = 5;

theta_rad = atan((-1/pi)*log(OS/100));

Re = -4/Ts;
Im = -Re / tan(theta_rad);

% Cancel stable pole
p1 = -1/tau;

% Place pole at other edges of S
p2 = complex(Re,Im);
p3 = complex(Re,-Im);

g0 = 2*Re;
K = Re^2 + Im^2;

P = (K1)/(s*(tau*s+1));
C = K*((s-p1)/(s+g0));

T = feedback(P*C,1);

y = step(T);
plot(y)

