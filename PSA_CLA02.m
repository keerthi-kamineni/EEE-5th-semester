clc;
clear;
format short;

%% CLA-2: THREE-BUS POWER FLOW
% Base power = 100 MVA
% Methods: Gauss-Seidel, Newton-Raphson, Fast Decoupled

Sbase = 100;

%% 1. Line data
% Columns: From bus, To bus, R, X

line = [1 2 0.0200 0.0400;
        1 3 0.0100 0.0300;
        3 2 0.0125 0.0250];

nbus = 3;
nline = size(line,1);

%% 2. Form Ybus using Direct Inspection Method

Z12 = 0.02 + 1i*0.04;
Z13 = 0.01 + 1i*0.03;
Z23 = 0.0125 + 1i*0.025;

y12 = 1/Z12;
y13 = 1/Z13;
y23 = 1/Z23;

Ybus = [ y12+y13    -y12       -y13;
         -y12       y12+y23    -y23;
         -y13       -y23       y13+y23 ];

disp('Ybus = ');
disp(Ybus);

%% 3. Bus specifications (per unit)

% Bus 1: Slack bus
% Bus 2: PQ bus
% Bus 3: PV bus

Psp = [0; -4.0; 2.0];
Qsp = [0; -2.5; 0];

Vspec = [1.05; 0; 1.04];

tol = 1e-4;
maxIter = 1000;

%% 4. GAUSS-SEIDEL METHOD

Vgs = [1.05; 1.0; 1.04];

for iterGS = 1:maxIter

    Vold = Vgs;

    % Update bus 2: PQ bus
    i = 2;

    sumYV = 0;
    for j = 1:nbus
        if j ~= i
            sumYV = sumYV + Ybus(i,j)*Vgs(j);
        end
    end

    Vgs(i) = (1/Ybus(i,i))* ...
        ((Psp(i)-1i*Qsp(i))/conj(Vgs(i))-sumYV);

    % Calculate reactive power at bus 3
    i = 3;

    I3 = Ybus(i,:)*Vgs;
    Q3 = imag(Vgs(i)*conj(I3));

    % Update PV bus voltage
    sumYV = 0;
    for j = 1:nbus
        if j ~= i
            sumYV = sumYV + Ybus(i,j)*Vgs(j);
        end
    end

    Vtemp = (1/Ybus(i,i))* ...
        ((Psp(i)-1i*Q3)/conj(Vgs(i))-sumYV);

    Vgs(i) = Vspec(i)*Vtemp/abs(Vtemp);

    % Convergence test
    if max(abs(Vgs-Vold)) < tol
        break;
    end
end

%% 5. NEWTON-RAPHSON METHOD

% Unknowns: theta2, theta3, magnitude V2
x = [0; 0; 1.0];

for iterNR = 1:maxIter

    F = NRmismatch(x,Ybus,Psp,Qsp);

    if max(abs(F)) < tol
        break;
    end

    % Numerical Jacobian
    h = 1e-6;
    J = zeros(3,3);

    for k = 1:3
        xp = x;
        xm = x;

        xp(k) = xp(k) + h;
        xm(k) = xm(k) - h;

        J(:,k) = ...
            (NRmismatch(xp,Ybus,Psp,Qsp) - ...
             NRmismatch(xm,Ybus,Psp,Qsp))/(2*h);
    end

    dx = -J\F;
    x = x + dx;
end

Vnr = [1.05;
       x(3)*exp(1i*x(1));
       1.04*exp(1i*x(2))];

%% 6. FAST DECOUPLED LOAD FLOW METHOD

Vfd = [1.05; 1.0; 1.04];

% B-prime and B-double-prime matrices
Bp = -imag(Ybus([2 3],[2 3]));
Bpp = -imag(Ybus(2,2));

for iterFD = 1:maxIter

    Vold = Vfd;

    % Calculate injected powers
    S = Vfd .* conj(Ybus*Vfd);
    Pcalc = real(S);
    Qcalc = imag(S);

    % Active power mismatch: buses 2 and 3
    dP = Psp([2 3]) - Pcalc([2 3]);

    % Angle correction
    dTheta = Bp \ (dP ./ abs(Vfd([2 3])));

    theta = angle(Vfd);
    theta([2 3]) = theta([2 3]) + dTheta;

    Vfd = abs(Vfd).*exp(1i*theta);
    Vfd(1) = 1.05;

    % Calculate updated powers
    S = Vfd .* conj(Ybus*Vfd);
    Qcalc = imag(S);

    % Reactive power mismatch at PQ bus 2
    dQ = Qsp(2) - Qcalc(2);

    % Voltage magnitude correction
    dV = (dQ/abs(Vfd(2)))/Bpp;

    Vfd(2) = Vfd(2) + dV;
    Vfd(1) = 1.05;

    % Restore specified magnitude at PV bus
    Vfd(3) = 1.04*exp(1i*angle(Vfd(3)));

    if max(abs(Vfd-Vold)) < tol
        break;
    end
end

%% 7. DISPLAY BUS VOLTAGES

methods = {'Gauss-Seidel'; 'Newton-Raphson'; ...
           'Fast Decoupled'};

Vall = [Vgs Vnr Vfd];

fprintf('\n========== BUS VOLTAGE RESULTS ==========\n');

for m = 1:3
    fprintf('\n%s method\n',methods{m});
    fprintf('Bus       Voltage(pu)       Angle(deg)\n');

    for i = 1:nbus
        fprintf('%2d        %10.6f        %10.6f\n', ...
            i,abs(Vall(i,m)),angle(Vall(i,m))*180/pi);
    end
end

fprintf('\nIterations: GS=%d, NR=%d, FD=%d\n', ...
    iterGS,iterNR,iterFD);



%% LOCAL FUNCTION: NEWTON-RAPHSON MISMATCH

function F = NRmismatch(x,Ybus,Psp,Qsp)



    theta2 = x(1);
    theta3 = x(2);
    V2 = x(3);

    V = [1.05;
         V2*exp(1i*theta2);
         1.04*exp(1i*theta3)];

    S = V .* conj(Ybus*V);

    Pcalc = real(S);
    Qcalc = imag(S);

    F = [Psp(2)-Pcalc(2);
         Psp(3)-Pcalc(3);
         Qsp(2)-Qcalc(2)];
end