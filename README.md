# diabetes_controllers
## Introduction
This is a simple project where we are going to implement a few controllers to control the blood glucose level in a diabetic patient, given a mathematical model of the glucose-insulin system. 

## Mathematical model
The mathematical model is given by the following differential equations:

![alt text](./img/glucose-insulin-dynamics.png)

Where:
- p1 = 0.0151 min^-1 is the rate of glucose removal from the blood indipendently of the level of insulin;
- p2 = 0.0313 min^-1 the rate of glucose removal given by the action of insulin; 
- p3 = 0.0097l/(min/U) the uptake capacity given by insulin, 
- ge = 0.97g/l the equilibrium values of glucose;
- ie = 0.003U/l the equilibrium values of insulin;

- [$x_1$]: **Blood glucose concentration**; [$g/l$].
- [$x_2$]: **Insulin concentration in interstitial fluids**; [$min^{-1}$]. The concentration of insulin in the interstitial fluids influences the concentration of glucose in the blood [$x_1$] because thanks to insulin, the cells recall glucose into the blood and thus [$x_1$] is lowered.
- [$u(t)$]: **Insulin present in the blood** (control input) [$U/l$]. The concentration of insulin in the blood influences the concentration of insulin in the interstitial fluids [$x_2$]. Insulin is injected into the blood and then passes to the interstitial fluids (in fact having [$u>0$] means increasing insulin in the interstitial fluids [$\dot x_2$]).


## Controllers
The controllers we are going to implement are: