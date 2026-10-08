clc;
clear;
close all;

%% Plant
G = tf(1,[1 4 3]);

%% Root Locus
figure;
rlocus(G);
grid on;
title('Root Locus of the System');

%% Choose desired gain
K = 10;

%% Open-loop system with gain
L = K*G;

%% Closed-loop system
T = feedback(L,1);

%% Display closed-loop poles
poles = pole(T);

fprintf('Chosen gain K = %.2f\n',K);
fprintf('Closed-loop poles:\n');
disp(poles);

%% Step response
figure;
step(T);
grid on;
title('Closed-Loop Step Response');