# Control system for blood glucose level in a diabetic patient
## Introduction
This is a simple project where we are going to implement a few controllers to control the blood glucose level in a diabetic patient, given a mathematical model of the glucose-insulin system. 

The project involves the implementation of different controllers and the comparison of their performance. In particular, the controllers are designed with the following techniques:
- Linear control with and without state observer. 
- Feedback linearization;
- Gain scheduling.
Other techniques, such as Linear Quadratic Regulator (LQR), Linear Quadratic Integral (LQI), root locus, and pole placement, are used to tune the controllers gains.

For each controller, the performance is evaluated in terms of settling time, overshoot, and tracking of references.

The project is part of the course "Advanced Control" at University of Salerno, Italy.

## Mathematical model
The mathematical model is given by the following differential equations:

![plot](./img/glucose-insulin-dynamics.png)

Where the parameters are given by the following values
- p_1 = 0.0151 min^{-1} is the rate of glucose removal from the blood indipendently of the level of insulin;
- p_2 = 0.0313 min^{-1} the rate of glucose removal given by the action of insulin; 
- p_3 = 0.0097 l/(min^2 U) the uptake capacity given by insulin, 
- g_e = 0.97 g/l the equilibrium values of glucose;
- i_e = 0.003 U/l the equilibrium values of insulin;

The state variables are:
- x_1: Blood glucose concentration; g/l.
- x_2: Insulin concentration in interstitial fluids; min^{-1}. The concentration of insulin in the interstitial fluids influences the concentration of glucose in the blood x_1 because thanks to insulin, the cells recall glucose into the blood and thus x_1 is lowered.

The control input is:
- u(t): Insulin present in the blood (control input) U/l. The concentration of insulin in the blood influences the concentration of insulin in the interstitial fluids x_2. Insulin is injected into the blood and then passes to the interstitial fluids (in fact having u>0 means increasing insulin in the interstitial fluids \dot x_2).

## Project structure and guidelines
The project is divided into work packages, each of them representing a different task. Specifically:
- WP1: Anlysis of the system and identification of the limitations of the given controller v0. The controller v0 is in the form u(t) = -K*x(t) + k_r*r(t), where K =[-1651800, 2200] and k_r = -1636751 (r(t) = 0.0451). The controller was obtained on the linearized system around x_e = [0.0451, 0.3099]^T (with u = 1.003). Evaluate the performance of v0 on the nonlinear system. Identify, in particular, the (possible) limitations of this controller by supporting the results with the analysis/diagrams you consider appropriate (highlighting, among others, rise time, settling time, over-elongation); 

- WP2: Design a new controller, v1, which is still linear but improves the performance of the closed loop (highlighting rise time, settling time, over-elongation). Then evaluate the controller obtained (r(t) = 0.0451);

- WP3: The previous controllers use the state variables x1(t) and x2(t) to compute the control input u(t).
 Now, assume that x2(t) is difficult to measure. Design, therefore, a state observer assuming that only x1(t) can be measured. Introduce the observer into the control loop and reassess the performance of the closed-loop system (for this WP, use controller v1);

- WP4: Design a new controller, v2, based on feedback linearization (r(t) = 0.0451). Evaluate the controller and compare its performance with v1. Discuss how to modify the controller to chase time-varying references;

- WP5: Design a new controller, v3, based on gain scheduling (r(t) = 0.0451). Evaluate the controller and compare its performance with v2. Also provide simulation diagrams for time-varying references;

## Project implementation
The project is implemented in Matlab and Simulink. The choice of Matlab is due to the fact that it is a widely used tool for control systems and it provides a lot of useful functions and tools to implement the controllers and to analyze the system. 
Several controllers are implemented and compared to each other. The controllers are implemented in the form of Simulink blocks, so that they can be easily integrated into the simulation environment.
Each folder contains the implementation of a specific Work Package (WP) as described in the previous section.
For each WP, the following files are provided:
- WPX.m: The main script that runs the simulation and plots the results;
- XXX.slx: The Simulink model of the controllers. 
- WPX.mlx: The live script that contains the code of the WPX.m script and the comments (the comments are available only in Italian);

Note that more controllers are implemented for each WP, so that the performance of the different controllers can be compared within the same WP, and the best controller of each WP can be compared with the best controller of the other WPs.
