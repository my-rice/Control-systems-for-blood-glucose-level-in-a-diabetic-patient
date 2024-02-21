clear all 
clc

p1 = 0.0151; %tasso base di rimozione del glucosio dal sangue
p2 = 0.0313; %tasso rimozione del glucosio dovuto all'insulina
p3 = 0.0097;
ge = 0.97;
ie = 0.003;
u_eq=1.003;

%x1 concentrazione del glucosio
%x2 concentrazione di insulina nei liquidi interstiziali 

%% Controllore LQI con sigma=r (il codice vale anche per sigma=x1)
% Consideriamo il sistema non lineare a ciclo aperto
syms x1 x2 u
dx1 = -(p1+x2)*x1+p1*ge;
dx2 = -(p2*x2)+p3*(u-ie);
% Troviamone i punti di equilibrio al variare di u_eq
sol = solve([dx1==0, dx2==0],[x1, x2],"ReturnConditions",true);

% Scegliamo come variabile di scheduling sigma=r.
% Il nostro obiettivo è che y_eq = r. Siccome y=x1 linearizziamo il sistema
% attorno a (x1_eq,x2_eq,u_eq) ponendo x1_eq = r = sigma e trovando x2_eq e 
% u_eq in funzione di sigma.
syms sigma 
%Qui poinamo x1_eq==sigma e troviamo x2_eq e u_eq in funzione di sigma
sol = solve([x1==sol.x1(1), x2==sol.x2(1), x1==sigma],[x1, x2, u],"ReturnConditions",true); 
x1_eq = sol.x1(1);
x2_eq = sol.x2(1);
u_eq = sol.u(1);

% Troviamo le matrici del sistema linearizzato in funzione di sigma,
% calcolando le Jacobiane e sostituendoci la condizione operativa che
% corrisponde al punto di equilibrio (x1_eq,x2_eq,u_eq)
J_A=jacobian([dx1, dx2],[x1, x2]);
J_B=jacobian([dx1, dx2], u);
A = subs(J_A,{'x1','x2'}, [x1_eq, x2_eq]);
B = double(J_B);
C = [1 0];
D=0;

% Adesso andiamo a calcolare i parametri K del controllore LQR nei trim
% points.
sigma = [0.01:0.02:2];
K_sigma = [];

for i = sigma
    temp_A = double(subs(A,{'sigma'},i));
    sys = ss(temp_A,B,C,D);
    %I parametri dell'LQI sono gli stessi trovati nel WP2
    Qu = 6e-6; %0.0001;
    Qx = [10 0 0;0 0.1 0;0 0 1];
    [K,S,e] = lqi(sys,Qx,Qu,0);
    K_sigma = [K_sigma, K.'];
    % K_sigma contiene su ogni colonna j il valore dei parametri associati 
    % alla condizione operativa sigma(j).
    % La prima riga contiene il parametro k1,la seconda il parametro k2, e
    % la terza il parametro ki
end

%% Controllore LQR con sigma=r
% Consideriamo il sistema non lineare a ciclo aperto
syms x1 x2 u
dx1 = -(p1+x2)*x1+p1*ge;
dx2 = -(p2*x2)+p3*(u-ie);
% Troviamone i punti di equilibrio al variare di u_eq
sol = solve([dx1==0, dx2==0],[x1, x2],"ReturnConditions",true);

% Scegliamo come variabile di scheduling sigma=r.
% Il nostro obiettivo è che y_eq = r. Siccome y=x1 linearizziamo il sistema
% attorno a (x1_eq,x2_eq,u_eq) ponendo x1_eq = r = sigma e trovando x2_eq e 
% u_eq in funzione di sigma.
syms sigma 
%Qui poinamo x1_eq==sigma e troviamo x2_eq e u_eq in funzione di sigma
sol = solve([x1==sol.x1(1), x2==sol.x2(1), x1==sigma],[x1, x2, u],"ReturnConditions",true); 
x1_eq = sol.x1(1);
x2_eq = sol.x2(1);
u_eq = sol.u(1);

% Troviamo le matrici del sistema linearizzato in funzione di sigma,
% calcolando le Jacobiane e sostituendoci la condizione operativa che
% corrisponde al punto di equilibrio (x1_eq,x2_eq,u_eq)
J_A=jacobian([dx1, dx2],[x1, x2]);
J_B=jacobian([dx1, dx2], u);
A = subs(J_A,{'x1','x2'}, [x1_eq, x2_eq]);
B = double(J_B);
C = [1 0];
D=0;

% Adesso andiamo a calcolare i parametri K del controllore LQR nei trim
% points.
sigma = [0.01:0.02:2];
K_sigma = [];

for i = sigma
    temp_A = double(subs(A,{'sigma'},i));
    sys = ss(temp_A,B,C,D);
    % I parametri dell'LQR sono gli stessi di quelli trovati nel WP2
    Qu = 1e-4;
    Qx = [10 0;0 0.1];
    [K,S,P] = lqr(sys, Qx, Qu);
    K_sigma = [K_sigma, K.'];
    % K_sigma contiene su ogni colonna j il valore dei parametri associati 
    % alla condizione operativa sigma(j).
    % La prima riga contiene il parametro k1 e la seconda il parametro k2.
end


%% Controllore state feedback con sigma=r (il codice vale anche per sigma=x1)
% Consideriamo il sistema non lineare a ciclo aperto
syms x1 x2 u
dx1 = -(p1+x2)*x1+p1*ge;
dx2 = -(p2*x2)+p3*(u-ie);

sol = solve([dx1==0, dx2==0],[x1, x2]);

% Scegliamo come variabile di scheduling sigma=r.
% Il nostro obiettivo è che y_eq = r. Siccome y=x1 linearizziamo il sistema
% attorno a (x1_eq,x2_eq,u_eq) ponendo x1_eq = r = sigma e trovando x2_eq e 
% u_eq in funzione di sigma.
syms sigma 
%Qui poinamo x1_eq==sigma e troviamo x2_eq e u_eq in funzione di sigma
sol = solve([x1==sol.x1(1), x2==sol.x2(1), x1==sigma],[x1, x2, u]);
x1_eq = sol.x1(1);
x2_eq = sol.x2(1);
u_eq = sol.u(1);

% Troviamo le matrici del sistema linearizzato in funzione di sigma,
% calcolando le Jacobiane e sostituendoci la condizione operativa che
% corrisponde al punto di equilibrio (x1_eq,x2_eq,u_eq)
J_A=jacobian([dx1, dx2],[x1, x2]);
J_B=jacobian([dx1, dx2], u);
A = subs(J_A,{'x1','x2'}, [x1_eq, x2_eq]);
B = J_B;
C = [1 0];

% Adesso dobbiamo calcolare i parametri del controllore in funzione di
% sigma. Utilizziamo il metodo del pole placement, calcolando il polinomio
% caratteristico della matrice dinamica del sistema linearizzato
% retroazionato A-B*K
syms k1 k2
K = [k1 k2];
A_CC = A-B*K; %Matrice dinamica a ciclo chiuso

% Per trovare i valori di K utilizziamo il principio di uguaglianza dei
% polinomi imponendo una dinamica del secondo ordine con un certo zita e
% omega_n.

% In questo caso troviamo i parametri K in funzione di sigma, zita e omega_n.
syms s zita w_n
pol_coeff=charpoly(A_CC); 
desired_pol=(s^2 + 2*zita*w_n*s + w_n^2);
desired_pol_coeff = fliplr(coeffs(desired_pol, s));
sol = solve(pol_coeff==desired_pol_coeff,[k1, k2],"ReturnConditions",true);

% Analisi delle prestazioni
simout = sim('v3_sim_sf_sigma_r.slx'); %Nel file simulink sono specificati i valori di zita e omega_n
y = simout.y;
t = simout.t;
u = simout.u(1,:);

y_stepinfo = stepinfo(y,t,y(end))
u_stepinfo = stepinfo(u,t,u(end))

%% Controllore PI con sigma=r
%Consideriamo il sistema non lineare a ciclo aperto
syms x1 x2 u
dx1 = -(p1+x2)*x1+p1*ge;
dx2 = -(p2*x2)+p3*(u-ie);

sol = solve([dx1==0, dx2==0],[x1, x2]);

% Scegliamo come variabile di scheduling sigma=r.
% Il nostro obiettivo è che y_eq = r. Siccome y=x1 linearizziamo il sistema
% attorno a (x1_eq,x2_eq,u_eq) ponendo x1_eq = r = sigma e trovando x2_eq e 
% u_eq in funzione di sigma.
syms sigma 
sol = solve([x1==sol.x1(1), x2==sol.x2(1), x1==sigma],[x1, x2, u]); %Qui poinamo x1_eq==sigma e troviamo x1_eq, x2_eq e u_eq in funzione di sigma
x1_eq = sol.x1(1);
x2_eq = sol.x2(1);
u_eq = sol.u(1);

% Troviamo le matrici del sistema linearizzato in funzione di sigma,
% calcolando le Jacobiane e sostituendoci la condizione operativa che
% corrisponde al punto di equilibrio (x1_eq,x2_eq,u_eq)
J_A=jacobian([dx1, dx2],[x1, x2]);
J_B=jacobian([dx1, dx2], u);
A = subs(J_A,{'x1','x2'}, [x1_eq, x2_eq]);
B = J_B;
C = [1 0];

% Progettiamo un PI per il sistema linearizzato. In questo caso utilizzamo
% una progettazione diretta nel dominio del tempo con la tecnica del pole
% placement.
syms kp ki
A_CC = [A-B*kp*C B*ki; C 0]; % Matrice dinamica a ciclo chiuso del sistema linearizzato con controllore

% Per trovare i valori di K utilizziamo il principio di uguaglianza dei
% polinomi imponendo una dinamica del secondo ordine con un certo zita e
% omega_n.
syms s zita w_n p
pol_coeff=charpoly(A_CC); 
desired_pol=(s^2 + 2*zita*w_n*s + w_n^2)*(s-p);
desired_pol_coeff = fliplr(coeffs(desired_pol, s));

sol = solve(pol_coeff==desired_pol_coeff,[kp, ki],"ReturnConditions",true);

% Risultato: Non c'è soluzione perché il secondo coefficiente del polinomio
% caratteristico non dipende dai parametri del controllore, allora non possiamo
% imporre una qualsiasi dinamica desiderata a ciclo chiuso utilizzando un PI.
% Tuttavia possiamo trovare i parametri del controllore che ci permettono di stabilizzare il sistema.
% Per farlo dobbiamo imporre che non ci siano variazioni di segno nei coefficienti
% del polinomio caratteristico:
assume(sigma>0);
sol = solve(pol_coeff>[0 0 0 0], [kp, ki],"ReturnConditions",true);

% Risultato: ki>0 kp<0.0473/sigma^2.
% Ad esempio scegliendo ki = 1, kp = 0.03/sigma^2 si otterrebbe un sistema
% stabile a ciclo chiuso.
% Non avendo potuto imporre una dinamica desiderata scartiamo questo controllore.


%% Tentativo con controllore P --- DA CANCELLARE
%Consideriamo il sistema a ciclo chiuso
syms kp x1 x2 sigma
dx1 = -(p1+x2)*x1+p1*ge;
dx2 = -(p2*x2)+p3*(kp*(sigma-x1)-ie);

sol = solve([dx1==0, dx2==0],[x1, x2],"ReturnConditions",true) % Ottengo due soluzioni -> due punti di equilibrio
x1_eq=sol.x1
x2_eq=sol.x2

% Linearizzazione intorno ai trim point

J_a=jacobian([dx1, dx2],[x1, x2])
J_b=jacobian([dx1, dx2], sigma)

A=subs(J_a,{'x1','x2'}, [x1_eq(2), x2_eq(2)]) % Vado a sostituire con il primo punto di eq.

% Sintesi dei controllori per ogni trim point
syms zita omega_n
charpol = charpoly(A);

desired_pol = [1, 2*zita*omega_n, omega_n^2];
sol = solve(charpol == desired_pol, kp, ReturnConditions=true)

%sol contiene i guadagni parametrizzati in zita e omega_n
zita = 1;
ts = 10; % 10 minuti
omega_n = 5.8/ts;

% omega_n = 5.8/ts;
% ki = simplify(subs(sol.ki,{'omega_n'},[omega_n]))
kp = subs(sol,{'omega_n','zita'},[omega_n, zita])


% Proviamo un particolare valore di Kp
r= 0.0451;
Kp_sigma=double(subs(kp.kp, 'sigma', r));

% Simulare con il sistema linearizzato per vedere se funziona con quel Kp
syms u x1 x2
dx1 = -(p1+x2)*x1+p1*ge;
dx2 = -(p2*x2)+p3*(u-ie);

A_lin = jacobian([dx1 dx2],[x1 x2]);
B_lin = jacobian([dx1 dx2],[u]);
C_lin = [1 0];
D_lin = 0;

x1_eq = subs(x1_eq(2),{'sigma','kp'},[r, Kp_sigma]);
x2_eq = subs(x2_eq(2),{'sigma','kp'},[r, Kp_sigma]);

x1_eq = double(x1_eq);
x2_eq = double(x2_eq);

A_lin = subs(A_lin,{'x1','x2'},[x1_eq, x2_eq]);
A_lin = double(A_lin);
B_lin = double(B_lin);

