# diabetes_controllers
This is a simple project where we are going to implement a few controllers to control the blood glucose level in a diabetic patient, given a mathematical model of the glucose-insulin system. The mathematical model is given by the following differential equations:

![Alt text](./glucose-insulin-dynamics.svg)
<img src="./glucose-insulin-dynamics.svg">


Let p1 = 0.0151min-1
the rate of glucose removal from the
blood independently of insulin, p2 = 0.0313min-1
the rate of glucose removal given by the action
of insulin, p3 = 0.0097l/(min2U) the uptake capacity given by insulin, ge = 0.97g/l and ie = 0.003U/l
the equilibrium values of glucose and insulin, respectively. The plant to be controlled assigned to the
project is captured by the following mathematical model: