clear all, clc;
%x1 concentrazione del glucosio
%x2 concentrazione di insulina nei liquidi interstiziali 

p1 = 0.0151; %tasso base di rimozione del glucosio dal sangue
p2 = 0.0313; %tasso rimozione del glucosio dovuto all'insulina
p3 = 0.0097;
ge = 0.97;
ie = 0.003;
u_eq=1.003;
x_eq = [0.0451; 0.3099];
x1_eq = x_eq(1);
x2_eq = x_eq(2);
% Il K è il risultato del WP2
%K = [-138.0306 54.1580]; 
%K = [-49.7747 99.1105];
K = [-1272.43538878761    165.594962781475    408.248290463863];
A = [-p1-x_eq(2) -x_eq(1); 0 -p2];
B = [0; p3];
C = [1 0];
D = [0];

%% Osservatore
% matrice di osservabilità
W0 = [C;C*A];
rank(W0);

% matrice di osservabilità in forma canonica
syms x
polyA = charpoly(A,x)
polyA = coeffs(polyA)
a1 = polyA(2);
a2 = polyA(1);
W0_tilde = inv([1,0;a1,1]); %in alternativa W0_tilde = [1 0;-a1 1];

% calcolo dei coefficienti del polinomio desiderato
Sett_time = 2.2;
zeta = 1;
w0 = 5.8/Sett_time;
pd1 = 2*zeta*w0;
pd2 = w0^2;

L = inv(W0)*W0_tilde*[pd1-a1;pd2-a2];
L = eval(L);

simout = sim('v1_lqi_observer.slx');
t = simout.t;
t = t.Time;
y = simout.y;
u = simout.u;

x_hat = simout.x_hat.Data;

%x_tilde = x - x_hat
%stepinfo(x_tilde(:,1),t,0)
%stepinfo(x_tilde(:,2),t,0)

x_hat_1_stepinfo = stepinfo(x_hat(:,1),t,x1_eq) % Tempo di assestamento 12.91
x_hat_2_stepinfo = stepinfo(x_hat(:,2),t,x2_eq) % Tempo di assestamento 6.3369. Overshoot: 394.6826

y_stepinfo = stepinfo(y,t,y(end)) %Tempo di assestamento di 12.97min e overshoot del 46%
u_stepinfo = stepinfo(u,t,u(end)) %Picco di 189
u_min = min(u)


figure
plot(t,y)
title("Controller v1. LQI with observer")
xlabel("t [min]")
ylabel("y [g/l]")


figure
plot(t,u)
title("Controller v1. LQI with observer")
xlabel("t [min]")
ylabel("u [U/l]")


% Sett_time = 1;
% w0 = 5.8/Sett_time;
% zeta =1;
% y_stepinfo = 
%          RiseTime: 1.4121
%     TransientTime: 12.7872
%      SettlingTime: 12.7272
%       SettlingMin: 0.0449
%       SettlingMax: 0.0659
%         Overshoot: 46.1649
%        Undershoot: 0
%              Peak: 0.0659
%          PeakTime: 3.1894
% 
% 
% u_stepinfo = 
%          RiseTime: 0.0088
%     TransientTime: 4.1841
%      SettlingTime: 11.4610
%       SettlingMin: 0.9383
%       SettlingMax: 47.8568
%         Overshoot: 4.7213e+03
%        Undershoot: 1.9093e+04
%              Peak: 189.5179
%          PeakTime: 0.1651

% Sett_time = 1.5;
% y_stepinfo = 
%          RiseTime: 1.4813
%     TransientTime: 13.0552
%      SettlingTime: 12.9933
%       SettlingMin: 0.0413
%       SettlingMax: 0.0683
%         Overshoot: 51.3979
%        Undershoot: 0
%              Peak: 0.0683
%          PeakTime: 3.2388
% 
% 
% u_stepinfo = 
%          RiseTime: 0.0107
%     TransientTime: 4.5370
%      SettlingTime: 11.5940
%       SettlingMin: 0.7800
%       SettlingMax: 42.4907
%         Overshoot: 4.1842e+03
%        Undershoot: 1.1805e+04
%              Peak: 117.0774
%          PeakTime: 0.2722

% Sett_time = 2;
% y_stepinfo = 
%          RiseTime: 1.5523
%     TransientTime: 13.3080
%      SettlingTime: 13.2433
%       SettlingMin: 0.0413
%       SettlingMax: 0.0706
%         Overshoot: 56.6516
%        Undershoot: 0
%              Peak: 0.0706
%          PeakTime: 3.6155
% 
% 
% u_stepinfo = 
%          RiseTime: 0.0114
%     TransientTime: 4.8165
%      SettlingTime: 11.6587
%       SettlingMin: 0.2865
%       SettlingMax: 37.5991
%         Overshoot: 3.6940e+03
%        Undershoot: 8.5971e+03
%              Peak: 85.1991
%          PeakTime: 0.2303

% è possibile controllare che i coefficienti del polinomio caratteristico dell'osservatore siano
% quelli desiderati
syms x
polyObs = charpoly(A-L*C,x);
coeffs_obs = eval(coeffs(polyObs))


%% soluzione con il comando place
% syms x
% polyA = charpoly(A-L*C,x)
% polyA = coeffs(polyA)
% 
% syms s;
% f = s^2+pd1*s+pd2 == 0
% res = solve(f,[s])
% pole1 = eval(res(1));
% pole2 = eval(res(2));
% L_check = place(A.', C.',[pole1 pole2]);
% L_check = L_check.'



%TODO:
%- piazzare meglio i poli dell'osservatore
%- valutare tempo di salita, sovraelongazione ecc della risposta come fatto
% per WP precedenti


