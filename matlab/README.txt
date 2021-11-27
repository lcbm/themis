======================================================
MATLAB Code for epidemic simulations with the SIDARTHE model
in the work

Modelling the COVID-19 epidemic and implementation of population-wide interventions in Italy
by Giulia Giordano, Franco Blanchini, Raffaele Bruno, Patrizio Colaneri, Alessandro Di Filippo, Angela Di Matteo, Marta Colaneri

Giulia Giordano, April 5, 2020
Contact: giulia.giordano@unitn.it
======================================================

This folder includes the following Matlab scripts that can be used to reproduce the results in the article.

* Sidarthe_Simulation.m
Matlab script to simulate the evolution of the SIDARTHE epidemic model, also compared to real data,
in the presence of containment/mitigation strategies (social distancing, lockdown, contact tracing and testing) that possibly vary over time.
The script contains the data and parameters to simulate the case study of COVID-19 epidemic in Italy, considered in the article,
but the parameters and the times at which they change can be adapted to suit any other case study.

* Sidarthe_scenario_weakened_lockdown.m
Matlab script to simulate the evolution of the SIDARTHE epidemic model, also compared to real data,
in the presence of containment/mitigation strategies (social distancing, lockdown, contact tracing and testing) that possibly vary over time.
The parameters and enforced measures correspond to the case in Fig. 3a,b in the article

* Sidarthe_scenario_strengthened_lockdown.m
Matlab script to simulate the evolution of the SIDARTHE epidemic model, also compared to real data,
in the presence of containment/mitigation strategies (social distancing, lockdown, contact tracing and testing) that possibly vary over time.
The parameters and enforced measures correspond to the case in Fig. 3c,d in the article

* Sidarthe_scenario_widespread_testing.m
Matlab script to simulate the evolution of the SIDARTHE epidemic model, also compared to real data,
in the presence of containment/mitigation strategies (social distancing, lockdown, contact tracing and testing) that possibly vary over time.
The parameters and enforced measures correspond to the case in Fig. 4a,b in the article

* Sidarthe_scenario_weakened_lockdown_with_widespread_testing.m
Matlab script to simulate the evolution of the SIDARTHE epidemic model, also compared to real data,
in the presence of containment/mitigation strategies (social distancing, lockdown, contact tracing and testing) that possibly vary over time.
The parameters and enforced measures correspond to the case in Fig. 4c,d in the article

* Sidarthe_SensitivityAnalysis.m
Matlab script to simulate the evolution of the SIDARTHE epidemic model,
performing a sensitivity analysis to see the effect of varying one or more parameters.
(To obtain plots where the curves with different parameters are overlapped,
comment the "close all" command and run the code again after having changed the parameters at will.)
