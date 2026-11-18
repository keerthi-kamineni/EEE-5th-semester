clc;
clear;
close all;

s = tf('s');

% Given transfer function
G = 1/(s*(s+2));

% Bode plot
figure;
margin(G);
grid on;

% Required phase margin
PM_required = 50;

[GM, PM, Wcg, Wcp] = margin(G);

% Lag compensator parameters
phi = PM - PM_required + 5;
phi = max(phi, 1);

beta = (1+sind(phi))/(1-sind(phi));

wm = Wcp;
T = 10/wm;

% Lag compensator
Gc = (1+T*s)/(1+beta*T*s);

% Compensated system
Gnew = Gc*G;

disp('Lag Compensator:');
Gc

% Compensated Bode plot
figure;
margin(Gnew);
grid on;

% Root locus
figure;
rlocus(G);
hold on;
rlocus(Gnew);
grid on;
legend('Original','Compensated');