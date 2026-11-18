
clc;
clear;
close all;

s = tf('s');

% Given transfer function
G = 1/(s*(s+2));

% Required PM
PM_required = 50;

% Original PM
[GM,PM,Wcg,Wcp] = margin(G);

% Lead parameters
phi1 = PM_required - PM + 10;
alpha = (1-sind(phi1))/(1+sind(phi1));

wm = Wcp;
T1 = 1/(wm*sqrt(alpha));

% Lead compensator
Glead = (1+T1*s)/(1+alpha*T1*s);

% Lag parameters
phi2 = 5;
beta = (1+sind(phi2))/(1-sind(phi2));

T2 = 10/(wm);

% Lag compensator
Glag = (1+T2*s)/(1+beta*T2*s);

% Lead-Lag compensator
Gc = Glead*Glag;

% Compensated system
Gnew = Gc*G;

disp('Lead-Lag Compensator:');
Gc

[GM,PMnew,Wcg,Wcp] = margin(Gnew);
fprintf('Final PM = %.2f degrees\n',PMnew);

% Bode plot
figure;
margin(Gnew);
grid on;

% Root locus
figure;
rlocus(G);
hold on;
rlocus(Gnew);
grid on;
legend('Original','Lead-Lag');
