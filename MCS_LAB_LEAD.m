clc;
clear;
close all;

s = tf('s');

% Given transfer function
G = 1/(s*(s+2));

% BODE PLOT
figure;
margin(G);
grid on;

% Lead compensator parameters
PM_required = 50;
[GM, PM, Wcg, Wcp] = margin(G);

phi = PM_required - PM + 5;
phi = max(phi, 1);

alpha = (1-sind(phi))/(1+sind(phi));

wm = Wcp;
T = 1/(wm*sqrt(alpha));

% Lead compensator
Gc = (1+T*s)/(1+alpha*T*s);

% Compensated system
Gnew = Gc*G;

% Display compensator
disp('Lead Compensator:');
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