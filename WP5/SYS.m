%% Modello del sistema non lineare
%x1 concentrazione del glucosio
%x2 concentrazione di insulina nei liquidi interstiziali 


function xdot = SYS(x)
    p1 = 0.0151; %tasso base di rimozione del glucosio dal sangue
    p2 = 0.0313; %tasso rimozione del glucosio dovuto all'insulina
    p3 = 0.0097;
    ge = 0.97;
    ie = 0.003;
    u=x(3);
    x1dot = -(p1+x(2))*x(1)+p1*ge;
    x2dot = -(p2*x(2))+p3*(u-ie);
    xdot = [x1dot x2dot].'; %vettore colonna
end
