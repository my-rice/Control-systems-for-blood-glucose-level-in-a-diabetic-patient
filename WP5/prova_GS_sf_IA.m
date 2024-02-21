clear all 
clc

p1 = 0.0151; %tasso base di rimozione del glucosio dal sangue
p2 = 0.0313; %tasso rimozione del glucosio dovuto all'insulina
p3 = 0.0097;
ge = 0.97;
ie = 0.003;

%% Controllore state feedback e sigma=r (sigma=x1)
%Consideriamo il sistema non lineare % -k1*x1-k2*x2+ki*z + kr*r
syms x1 x2 z ki k1 k2 kr u sigma; 
dx1 = -(p1+x2)*x1+p1*ge;
dx2 = -(p2*x2)+p3*(u-ie);
dz = x1 - sigma;

sol = solve([dx1==0, dx2==0, dz == 0],[x1, x2, u]);

%Poniamo sigma=r.
%Noi vogliamo che y_eq = r -> x1_eq = r = sigma

x1_eq = sol.x1
x2_eq = sol.x2
u_eq = sol.u

syms z k1 k2 ki kr
dx1 = -(p1+x2)*x1+p1*ge;
dx2 = -(p2*x2)+p3*(u-ie);

J_A=jacobian([dx1, dx2],[x1, x2]);
J_B=jacobian([dx1, dx2], u);
A = subs(J_A,{'x1','x2'}, [x1_eq, x2_eq]);
B = J_B;
C = [1 0];

K = [k1,k2];
A_CC = [A-B*K, -B*ki; C,0]
B_CC = [B;0];

Wr = [B A*B A^2*B; 0 C*B C*A*B];
rank(Wr)

% Equipollenza dei polinomi
syms s zita w_n p
pol_coeff=charpoly(A_CC); 
desired_pol=(s^2 + 2*zita*w_n*s + w_n^2)*(s-p);
desired_pol_coeff = fliplr(coeffs(desired_pol, s));

sol = solve(pol_coeff==desired_pol_coeff,[k1,k2,ki],"ReturnConditions",true);
k1 = sol.k1
k2 = sol.k2
ki = sol.ki
