function [x1eq,x2eq] = get_equilibrium(u)
    p1 = 0.0151; %tasso base di rimozione del glucosio dal sangue
    p2 = 0.0313; %tasso rimozione del glucosio dovuto all'insulina
    p3 = 0.0097; 
    ge = 0.97;
    ie = 0.003;

    x2eq = (p3*(u-ie))/p2;
    x1eq = (p1*ge)./(p1+x2eq);
end