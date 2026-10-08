clc;
clear;
close all;

%% Plant
G = tf(1,[1 4 3]);

%% Required additional phase
phi_required = 35;    % degrees

%% Convert to radians
phi = deg2rad(phi_required);

%% Calculate alpha
alpha = (1-sin(phi))/(1+sin(phi));

fprintf('alpha = %.5f\n',alpha);

%% Choose desired crossover frequency
wc = 2;    % rad/s

%% Calculate T
T = 1/(wc*sqrt(alpha));

fprintf('T = %.5f sec\n',T);

%% Lead compensator
Clead0 = tf([T 1],[alpha*T 1]);

%% Calculate gain so that |CG| = 1 at wc
mag = abs(squeeze(freqresp(Clead0*G,wc)));

K = 1/mag;

fprintf('Lead gain K = %.5f\n',K);

%% Final compensator
Clead = K*Clead0;

%% Compensated open loop
Llead = Clead*G;

%% Bode plot
figure;
margin(Llead);
grid on;
title('Bode Plot - Lead Compensated System');

%% Closed-loop system
Tlead = feedback(Llead,1);

%% Step response
figure;
step(Tlead);
grid on;
title('Lead Compensated Closed-Loop Response');