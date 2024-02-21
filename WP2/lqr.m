p1 = 0.0151; %tasso base di rimozione del glucosio dal sangue
p2 = 0.0313; %tasso rimozione del glucosio dovuto all'insulina
p3 = 0.0097;
ge = 0.97;
ie = 0.003;
u_eq = 1.003;

[x1_eq,x2_eq] = get_equilibrium(u_eq);
x1_eq,x2_eq

%
% b = 1;
% a = -b*x2_eq/x1_eq;
% d = 1;
% c = -d*x2_eq/x1_eq;
% T = [a b;c d];
% 
% ze = [0;0];
% xe = [0.0451; 0.3099]
% ze = T.*xe

%Linearizzazione attorno al punto di equilibrio
A = [-p1-x2_eq -x1_eq; 0 -p2];
B = [0; p3];
C = [1 0];
D = [0];

equilibrium = [x1_eq,x2_eq].';

% A_tilde = [A f;0 0 0];
% B_tilde = [B;0];
% C_tilde = [C g];
% D_tilde = D;
%Matrice di raggiungibilità
%WR = [B_tilde A_tilde*B_tilde A_tilde*A_tilde*B_tilde];

WR = [B A*B]
rank(WR) %il sistema è raggiungibile.
Qu = 0.0001;
Qx = [10 0;0 1];

sys = ss(A,B,C,D)
K = lqr(sys, Qx, Qu)

%Kr = -1/(C*inv(A-B*K)*B)

