clear all, clc;
%x1 concentrazione del glucosio
%x2 concentrazione di insulina nei liquidi interstiziali 

p1 = 0.0151; %tasso base di rimozione del glucosio dal sangue
p2 = 0.0313; %tasso rimozione del glucosio dovuto all'insulina
p3 = 0.0097;
ge = 0.97;
ie = 0.003;
u_eq=1.003;

%% Linearizzazione attorno al punto di equilibrio per u=1.003
%Punto di equilibrio per u=1.003
[x1_eq, x2_eq] = get_equilibrium(u_eq);
%Linearizzazione attorno al punto di equilibrio
A = [-p1-x2_eq -x1_eq; 0 -p2];
B = [0; p3];
C = [1 0];
D = [0];

x_eq = [x1_eq; x2_eq];

%% Progettazione v1 con LQR
% Abbiamo scelto di utilizzare LQR perché, oltre a cancellare le
% oscillazioni, il nostro obiettivo è quello di ridurre lo sforzo di
% controllo.


sys = ss(A,B,C,D);
WR = [B A*B]
rank(WR) %il sistema è raggiungibile.
Qu = 3e-6; %0.0001;
Qx = [10 0;0 0.1];
K = lqr(sys, Qx, Qu);
%L'LQR stabilizza il sistema linearizzato attorno a (0,0).
%La legge di controllo per il sistema originale sarà u=-K(x-x_eq)+u_eq


simout = sim('v1_lqr.slx');
t = simout.t;
t = t.Time;
y = simout.y;
u = simout.u;
y_stepinfo = stepinfo(y,t,x1_eq) %Tempo di assestamento di 12.97min e undershoot dello 0.46%
u_stepinfo = stepinfo(u,t,u(end)) %Picco di 34.45
min(u)

% Qu = 1e-4; %0.0001;
% Qx = [10 0;0 0.1];

% y_stepinfo = 
% 
%   struct with fields:
% 
%          RiseTime: 0
%     TransientTime: 10.2588
%      SettlingTime: 10.6199
%       SettlingMin: 0.0449
%       SettlingMax: 0.1052
%         Overshoot: 133.4937
%        Undershoot: 0
%              Peak: 0.1052
%          PeakTime: 0.8130
% 
% 
% u_stepinfo = 
% 
%   struct with fields:
% 
%          RiseTime: 0
%     TransientTime: 10.4011
%      SettlingTime: 18.0200
%       SettlingMin: 0.5804
%       SettlingMax: 17.8011
%         Overshoot: 1.6748e+03
%        Undershoot: 0
%              Peak: 17.8011
%          PeakTime: 0

% Qu = 5e-5; %0.0001;
% Qx = [10 0;0 0.1];

% y_stepinfo = 
% 
%   struct with fields:
% 
%          RiseTime: 0
%     TransientTime: 8.7786
%      SettlingTime: 9.0864
%       SettlingMin: 0.0449
%       SettlingMax: 0.1037
%         Overshoot: 130.1402
%        Undershoot: 0
%              Peak: 0.1037
%          PeakTime: 0.5862
% 
% 
% u_stepinfo = 
% 
%   struct with fields:
% 
%          RiseTime: 0
%     TransientTime: 9.0302
%      SettlingTime: 15.4960
%       SettlingMin: 0.1666
%       SettlingMax: 25.3692
%         Overshoot: 2.4257e+03
%        Undershoot: 0
%              Peak: 25.3692
%          PeakTime: 0

% Qu = 1e-4; %0.0001;
% Qx = [10 0;0 1];

% y_stepinfo = 
%          RiseTime: 0
%     TransientTime: 12.2732
%      SettlingTime: 12.9659
%       SettlingMin: 0.0451
%       SettlingMax: 0.1029
%         Overshoot: 128.3237
%        Undershoot: 0
%              Peak: 0.1029
%          PeakTime: 0.4832
% 
% u_stepinfo = 
%          RiseTime: 0
%     TransientTime: 3.4206
%      SettlingTime: 13.3783
%       SettlingMin: 0.8228
%       SettlingMax: 34.4520
%         Overshoot: 3.3349e+03
%        Undershoot: 0
%              Peak: 34.4520
%          PeakTime: 0
% ans =
% 
%     0.8228

%% Progettazione v1 con pole placement
syms zita omega_n k1 k2
K = [k1 k2];
zita=1;
ts=10;
omega_n = 5.8/ts;
charpol = charpoly(A-B*K);
desired_pol = [1, 2*zita*omega_n, omega_n^2];
sol = solve(charpol == desired_pol, [k1, k2], ReturnConditions=true)
K = [double(sol.k1) double(sol.k2)];
simout = sim('v1_pole_placement.slx');
t = simout.t;
t = t.Time;
y = simout.y;
u = simout.u;
y_stepinfo = stepinfo(y,t,x1_eq)
u_stepinfo = stepinfo(u,t,u(end))
min(u)

%% Progettazione con LQI
sys = ss(A,B,C,D);

Qu = 6e-6; %0.0001;
Qx = [10 0 0;0 0.1 0;0 0 1];
[K,S,e] = lqi(sys,Qx,Qu,0)

simout = sim('v1_lqi.slx');
t = simout.t;
t = t.Time;
y = simout.y;
u = simout.u;
y_stepinfo = stepinfo(y,t,x1_eq) %Tempo di assestamento di 12.97min e undershoot dello 0.46%
u_stepinfo = stepinfo(u,t,u(end)) %Picco di 34.45
min(u)


plot(t, y)
xlim([0,20])
title('Controller v1 - Output')
hold on
plot(t,ones(size(t))*0.045102)
ylabel('y [g/l]')
xlabel('t [min]')
legend('y','r')

plot(t, u)
xlim([0,20])
title('Controller v1 - Control Input')
ylabel('u [U/l]')
xlabel('t [min]')
legend('u')


