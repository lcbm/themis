%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% MATLAB Code for epidemic simulations with the SIDARTHE model in the work
%
% Modelling the COVID-19 epidemic and implementation of population-wide interventions in Italy
% by Giulia Giordano, Franco Blanchini, Raffaele Bruno, Patrizio Colaneri, Alessandro Di Filippo, Angela Di Matteo, Marta Colaneri
%
% Giulia Giordano, April 5, 2020
% Contact: giulia.giordano@unitn.it
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear all
close all
clc

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% DATA
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Pernambuco population
popolazione=9e5;

% Data 26 February - 11 April (46 days):
% Total Cases
% D+R+T+E+H_diagnosticati
CasiTotali=[201 223 352 401 555 684 816 960 1154 1284 1484 1683 2006 2193 2459 2690 2908 3298 3604 3999 4507 4898 5358 5724 6194 6876 7334 8145 8643 8863 9325 9881 10824 11587 12470 13275 13768 14309 14901 15588 16209 18488 19452 20094 21242 22560]/popolazione;

% Deaths
% E
Deceduti=[21 30 34 46 56 65 72 85 102 115 143 160 186 205 216 234 260 282 312 352 381 415 450 508 538 565 603 628 652 691 749 803 845 927 972 1047 1087 1157 1224 1298 1381 1461 1516 1640 1741 1834]/popolazione;

% Recovered
% H_diagnosticati
Guariti=[25 25 32 32 44 44 45 46 57 68 68 86 88 94 96 100 100 105 123 202 220 416 704 943 953 1074 1095 1193 1207 1235 1312 1370 1388 1456 1480 1522 1538 2466 2600 2752 2807 2924 2969 2991 3043 3158]/popolazione;

% Data 23 February - 5 April (from day 4 to day 46)
% Currently positive: isolated at home
% D
Isolamento_domiciliare=[87 101 166 189 246 359 443 548 708 773 942 1095 1359 1510 1749 1924 2101 2367 2591 1857 1988 1864 1684 1508 1552 1626 1748 1894 2028 2040 2091 2133 2307 2334 2412 2477 2499 2370 1566 1462 1508 1734 1788 1830 1917 1962]/popolazione;

% Currently positive: hospitalised
% R
Ricoverati_sintomi=[49 44 94 110 180 185 222 241 232 265 263 277 303 313 334 334 334 334 444 446 545 598 660 718 799 904 1027 1116 1237 1281 1368 1446 1542 1661 1763 1879 2008 2132 2249 2456 2622 2904 3188 3402 3558 3835]/popolazione;

% Currently positive: ICU
% T
Terapia_intensiva=[19 23 26 24 29 31 34 40 55 63 68 65 70 71 74 74 74 74 134 172 182 192 190 181 203 202 212 216 220 223 221 221 220 221 222 231 236 238 237 237 236 235 242 240 241 229]/popolazione;

% Currently Positive (RT-PCR)
% D+R+T
Positivi=[155 168 286 323 455 575 699 829 995 1101 1273 1437 1732 1894 2157 2332 2509 2775 3169 2475 2715 2654 2534 2407 2554 2732 2987 3226 3485 3544 3680 3800 4069 4216 4397 4587 4743 4740 4052 4155 4366 4873 5218 5472 5716 6026]/popolazione;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% PARAMETERS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Simulation horizon: CAN BE MODIFIED AT ONE'S WILL PROVIDED THAT IT IS AT
% LEAST EQUAL TO THE NUMBER OF DAYS FOR WHICH DATA ARE AVAILABLE
Orizzonte = 350;

% Plot yes/no: SET TO 1 IF PDF FIGURES MUST BE GENERATED, 0 OTHERWISE
plotPDF=0;

% Time-step for Euler discretisation of the continuous-time system
step=0.01;

% Transmission rate due to contacts with UNDETECTED asymptomatic infected
alfa=0.57;
% Transmission rate due to contacts with DETECTED asymptomatic infected
beta=0.0114;
% Transmission rate due to contacts with UNDETECTED symptomatic infected
gamma=0.456;
% Transmission rate due to contacts with DETECTED symptomatic infected
delta=0.0114;

% Detection rate for ASYMPTOMATIC
epsilon=0.171;
% Detection rate for SYMPTOMATIC
theta=0.3705;

% Worsening rate: UNDETECTED asymptomatic infected becomes symptomatic
zeta=0.1254;
% Worsening rate: DETECTED asymptomatic infected becomes symptomatic
eta=0.1254;

% Worsening rate: UNDETECTED symptomatic infected develop life-threatening
% symptoms
mu=0.0171;
% Worsening rate: DETECTED symptomatic infected develop life-threatening
% symptoms
nu=0.0274;

% Mortality rate for infected with life-threatening symptoms
tau=0.01;

% Recovery rate for undetected asymptomatic infected
lambda=0.0342;
% Recovery rate for detected asymptomatic infected
rho=0.0342;
% Recovery rate for undetected symptomatic infected
kappa=0.0171;
% Recovery rate for detected symptomatic infected
xi=0.0171;
% Recovery rate for life-threatened symptomatic infected
sigma=0.0171;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% DEFINITIONS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Parameters
r1=epsilon+zeta+lambda;
r2=eta+rho;
r3=theta+mu+kappa;
r4=nu+xi;
r5=sigma+tau;

% Initial R0
R0_iniziale=alfa/r1+beta*epsilon/(r1*r2)+gamma*zeta/(r1*r3)+delta*eta*epsilon/(r1*r2*r4)+delta*zeta*theta/(r1*r3*r4)

% Time horizon
t=1:step:Orizzonte;

% Vectors for time evolution of variables
S=zeros(1,length(t));
I=zeros(1,length(t));
D=zeros(1,length(t));
A=zeros(1,length(t));
R=zeros(1,length(t));
T=zeros(1,length(t));
H=zeros(1,length(t));
H_diagnosticati=zeros(1,length(t)); % DIAGNOSED recovered only!
E=zeros(1,length(t));

% Vectors for time evolution of actual/perceived Case Fatality Rate
M=zeros(1,length(t));
P=zeros(1,length(t));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% INITIAL CONDITIONS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

I(1)=200/popolazione;
D(1)=20/popolazione;
A(1)=1/popolazione;
R(1)=2/popolazione;
T(1)=0.00;
H(1)=0.00;
E(1)=0.00;
S(1)=1-I(1)-D(1)-A(1)-R(1)-T(1)-H(1)-E(1);

% DIAGNOSED recovered only
H_diagnosticati(1) = 0.00;
% Actual currently infected
Infetti_reali(1)=I(1)+D(1)+A(1)+R(1)+T(1);

M(1)=0;
P(1)=0;

% Whole state vector
x=[S(1);I(1);D(1);A(1);R(1);T(1);H(1);E(1);H_diagnosticati(1);Infetti_reali(1)];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% SIMULATION
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% "Control" binary variables to compute the new R0 every time a policy has
% changed the parameters
plottato=0;
plottato1=0;
plottato_bis=0;
plottato_tris=0;
plottato_quat=0;

for i=2:length(t)

    % Day 4
    if (i>4/step)
        % Basic social distancing (awareness, schools closed)
        alfa=0.4218;
        gamma=0.285;
        beta=0.0057;
        delta=0.0057;

        % Compute the new R0
        if plottato == 0
            r1=epsilon+zeta+lambda;
            r2=eta+rho;
            r3=theta+mu+kappa;
            r4=nu+xi;
            r5=sigma+tau;
            R0_primemisure=alfa/r1+beta*epsilon/(r1*r2)+gamma*zeta/(r1*r3)+delta*eta*epsilon/(r1*r2*r4)+delta*zeta*theta/(r1*r3*r4)
            plottato = 1;
        end
    end

    % Day 12
    if (i>12/step)
        % Screening limited to / focused on symptomatic subjects
        epsilon=0.1425;

        if plottato1 == 0
            r1=epsilon+zeta+lambda;
            r2=eta+rho;
            r3=theta+mu+kappa;
            r4=nu+xi;
            r5=sigma+tau;
            R0_primemisureeps=alfa/r1+beta*epsilon/(r1*r2)+gamma*zeta/(r1*r3)+delta*eta*epsilon/(r1*r2*r4)+delta*zeta*theta/(r1*r3*r4)
            plottato1 = 1;
        end
    end

    % Day 22
    if (i>22/step)

        % Social distancing: lockdown, mild effect
        alfa=0.36;
        beta=0.005;
        gamma=0.2;
        delta=0.005;

        mu=0.008;
        nu=0.015;

        zeta=0.034;
        eta=0.034;

        lambda=0.08;
        rho=0.0171;
        kappa=0.0171;
        xi=0.0171;
        sigma=0.0171;

        % Compute the new R0
        if plottato_bis == 0
            r1=epsilon+zeta+lambda;
            r2=eta+rho;
            r3=theta+mu+kappa;
            r4=nu+xi;
            r5=sigma+tau;
            R0_secondemisure=(alfa*r2*r3*r4+epsilon*beta*r3*r4+gamma*zeta*r2*r4+delta*eta*epsilon*r3+delta*zeta*theta*r2)/(r1*r2*r3*r4)
            plottato_bis = 1;
        end
    end

    % Day 28
    if (i>28/step)
        % Social distancing: lockdown, strong effect
        alfa=0.21;
        gamma=0.11;

        % Compute the new R0
        if plottato_tris == 0
            r1=epsilon+zeta+lambda;
            r2=eta+rho;
            r3=theta+mu+kappa;
            r4=nu+xi;
            r5=sigma+tau;
            R0_terzemisure=(alfa*r2*r3*r4+epsilon*beta*r3*r4+gamma*zeta*r2*r4+delta*eta*epsilon*r3+delta*zeta*theta*r2)/(r1*r2*r3*r4)
            plottato_tris = 1;
        end
    end

    % Day 38
    if (i>38/step)
        % Broader diagnosis campaign
        epsilon=0.2;
        rho=0.02;
        kappa=0.02;
        xi=0.02;
        sigma=0.01;

        zeta=0.025;
        eta=0.025;

        % Compute the new R0
        if plottato_quat == 0
            r1=epsilon+zeta+lambda;
            r2=eta+rho;
            r3=theta+mu+kappa;
            r4=nu+xi;
            r5=sigma+tau;
            R0_quartemisure=(alfa*r2*r3*r4+epsilon*beta*r3*r4+gamma*zeta*r2*r4+delta*eta*epsilon*r3+delta*zeta*theta*r2)/(r1*r2*r3*r4)
            plottato_quat = 1;
        end
    end

    % Compute the system evolution
    B=[-alfa*x(2)-beta*x(3)-gamma*x(4)-delta*x(5) 0 0 0 0 0 0 0 0 0;
        alfa*x(2)+beta*x(3)+gamma*x(4)+delta*x(5) -(epsilon+zeta+lambda) 0 0 0 0 0 0 0 0;
        0 epsilon  -(eta+rho) 0 0 0 0 0 0 0;
        0 zeta 0 -(theta+mu+kappa) 0 0 0 0 0 0;
        0 0 eta theta -(nu+xi) 0 0 0 0 0;
        0 0 0 mu nu  -(sigma+tau) 0 0 0 0;
        0 lambda rho kappa xi sigma 0 0 0 0;
        0 0 0 0 0 tau 0 0 0 0;
        0 0 rho 0 xi sigma 0 0 0 0;
        alfa*x(2)+beta*x(3)+gamma*x(4)+delta*x(5) 0 0 0 0 0 0 0 0 0];
    x=x+B*x*step;

    % Update variables
    S(i)=x(1);
    I(i)=x(2);
    D(i)=x(3);
    A(i)=x(4);
    R(i)=x(5);
    T(i)=x(6);
    H(i)=x(7);
    E(i)=x(8);

    H_diagnosticati(i)=x(9);
    Infetti_reali(i)=x(10);

    % Update Case Fatality Rate
    M(i)=E(i)/(S(1)-S(i));
    P(i)=E(i)/((epsilon*r3+(theta+mu)*zeta)*(I(1)+S(1)-I(i)-S(i))/(r1*r3)+(theta+mu)*(A(1)-A(i))/r3);

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FINAL VALUES
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Variables
Sbar=S(length(t));
Ibar=I(length(t));
Dbar=D(length(t));
Abar=A(length(t));
Rbar=R(length(t));
Tbar=T(length(t));
Hbar=H(length(t));
Ebar=E(length(t));

% Case fatality rate
Mbar=M(length(t));
Pbar=P(length(t));

% Case fatality rate from formulas
Mbar1=Ebar/(S(1)-Sbar);
Pbar1=Ebar/((epsilon*r3+(theta+mu)*zeta)*(I(1)+S(1)-Sbar-Ibar)/(r1*r3)+(theta+mu)*(A(1)-Abar)/r3);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FIGURES
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

figure
plot(t,Infetti_reali,'b',t,I+D+A+R+T,'r',t,H,'g',t,E,'k')
hold on
plot(t,D+R+T+E+H_diagnosticati,'--b',t,D+R+T,'--r',t,H_diagnosticati,'--g')
xlim([t(1) t(end)])
ylim([0 0.015])
title('Actual vs. Diagnosed Epidemic Evolution')
xlabel('Time (days)')
ylabel('Cases (fraction of the population)')
legend({'Cumulative Infected','Current Total Infected', 'Recovered', 'Deaths','Diagnosed Cumulative Infected','Diagnosed Current Total Infected', 'Diagnosed Recovered'},'Location','northwest')
grid

if plotPDF==1
    set(gcf, 'PaperUnits', 'centimeters');
    set(gcf, 'PaperPosition', [0 0 24 16]);
    set(gcf, 'PaperSize', [24 16]); % dimension on x axis and y axis resp.
    print(gcf,'-dpdf', ['PanoramicaEpidemiaRealevsPercepita.pdf'])
end
%

figure
plot(t,I,'b',t,D,'c',t,A,'g',t,R,'m',t,T,'r')
xlim([t(1) t(end)])
ylim([0 1.1e-3])
title('Infected, different stages, Diagnosed vs. Non Diagnosed')
xlabel('Time (days)')
ylabel('Cases (fraction of the population)')
legend({'Infected ND AS', 'Infected D AS', 'Infected ND S', 'Infected D S', 'Infected D IC'},'Location','northeast')
grid

if plotPDF==1
    set(gcf, 'PaperUnits', 'centimeters');
    set(gcf, 'PaperPosition', [0 0 24 16]);
    set(gcf, 'PaperSize', [24 16]); % dimension on x axis and y axis resp.
    print(gcf,'-dpdf', ['SuddivisioneInfetti.pdf'])
end

%

figure
plot(t,D+R+T+E+H_diagnosticati)
hold on
stem(t(1:1/step:size(CasiTotali,2)/step),CasiTotali)
xlim([t(1) t(end)])
ylim([0 2.5e-3])
title('Cumulative Diagnosed Cases: Model vs. Data')
xlabel('Time (days)')
ylabel('Cases (fraction of the population)')
grid

if plotPDF==1
    set(gcf, 'PaperUnits', 'centimeters');
    set(gcf, 'PaperPosition', [0 0 16 10]);
    % dimension on x axis and y axis resp.
    set(gcf, 'PaperSize', [16 10]);
    print(gcf,'-dpdf', ['CasiTotali.pdf'])
end
%

figure
plot(t,H_diagnosticati)
hold on
stem(t(1:1/step:size(CasiTotali,2)/step),Guariti)
xlim([t(1) t(end)])
ylim([0 2.5e-3])
title('Recovered: Model vs. Data')
xlabel('Time (days)')
ylabel('Cases (fraction of the population)')
grid

if plotPDF==1
    set(gcf, 'PaperUnits', 'centimeters');
    set(gcf, 'PaperPosition', [0 0 16 10]);
    % dimension on x axis and y axis resp.
    set(gcf, 'PaperSize', [16 10]);
    print(gcf,'-dpdf', ['Guariti_diagnosticati.pdf'])
end
%

figure
plot(t,E)
hold on
stem(t(1:1/step:size(CasiTotali,2)/step),Deceduti)
xlim([t(1) t(end)])
ylim([0 2.5e-3])
title('Deaths: Model vs. Data - NOTE: EXCLUDED FROM FITTING')
xlabel('Time (days)')
ylabel('Cases (fraction of the population)')
grid

if plotPDF==1
    set(gcf, 'PaperUnits', 'centimeters');
    set(gcf, 'PaperPosition', [0 0 16 10]);
    % dimension on x axis and y axis resp.
    set(gcf, 'PaperSize', [16 10]);
    print(gcf,'-dpdf', ['Morti.pdf'])
end
%

figure
plot(t,D+R+T)
hold on
stem(t(1:1/step:size(CasiTotali,2)/step),Positivi)
xlim([t(1) t(end)])
ylim([0 2.5e-3])
title('Infected: Model vs. Data')
xlabel('Time (days)')
ylabel('Cases (fraction of the population)')
grid

if plotPDF==1
    set(gcf, 'PaperUnits', 'centimeters');
    set(gcf, 'PaperPosition', [0 0 16 10]);
    % dimension on x axis and y axis resp.
    set(gcf, 'PaperSize', [16 10]);
    print(gcf,'-dpdf', ['Positivi_diagnosticati.pdf'])
end
%

figure
plot(t,D)
hold on
stem(t(1+3/step:1/step:1+(size(Ricoverati_sintomi,2)+2)/step),Isolamento_domiciliare)
xlim([t(1) t(end)])
ylim([0 2.5e-3])
title('Infected, No Symptoms: Model vs. Data')
xlabel('Time (days)')
ylabel('Cases (fraction of the population)')
grid

if plotPDF==1
    set(gcf, 'PaperUnits', 'centimeters');
    set(gcf, 'PaperPosition', [0 0 16 10]);
    % dimension on x axis and y axis resp.
    set(gcf, 'PaperSize', [16 10]);
    print(gcf,'-dpdf', ['InfettiAsintomatici_diagnosticati.pdf'])
end
%

figure
plot(t,R)
hold on
stem(t(1+3/step:1/step:1+(size(Ricoverati_sintomi,2)+2)/step),Ricoverati_sintomi)
xlim([t(1) t(end)])
ylim([0 2.5e-3])
title('Infected, Symptoms: Model vs. Data')
xlabel('Time (days)')
ylabel('Cases (fraction of the population)')
grid

if plotPDF==1
    set(gcf, 'PaperUnits', 'centimeters');
    set(gcf, 'PaperPosition', [0 0 16 10]);
    % dimension on x axis and y axis resp.
    set(gcf, 'PaperSize', [16 10]);
    print(gcf,'-dpdf', ['InfettiSintomatici_diagnosticati_ricoverati.pdf'])
end
%

figure
plot(t,D+R)
hold on
stem(t(1+3/step:1/step:1+(size(Ricoverati_sintomi,2)+2)/step),Isolamento_domiciliare+Ricoverati_sintomi)
xlim([t(1) t(end)])
ylim([0 2.5e-3])
title('Infected, No or Mild Symptoms: Model vs. Data')
xlabel('Time (days)')
ylabel('Cases (fraction of the population)')
grid

if plotPDF==1
    set(gcf, 'PaperUnits', 'centimeters');
    set(gcf, 'PaperPosition', [0 0 16 10]);
    % dimension on x axis and y axis resp.
    set(gcf, 'PaperSize', [16 10]);
    print(gcf,'-dpdf', ['InfettiNonGravi_diagnosticati.pdf'])
end

%

figure
plot(t,T)
hold on
stem(t(1+3/step:1/step:1+(size(Ricoverati_sintomi,2)+2)/step),Terapia_intensiva)
xlim([t(1) t(end)])
ylim([0 2.5e-3])
title('Infected, Life-Threatening Symptoms: Model vs. Data')
xlabel('Time (days)')
ylabel('Cases (fraction of the population)')
grid

if plotPDF==1
    set(gcf, 'PaperUnits', 'centimeters');
    set(gcf, 'PaperPosition', [0 0 16 10]);
    % dimension on x axis and y axis resp.
    set(gcf, 'PaperSize', [16 10]);
    print(gcf,'-dpdf', ['InfettiSintomatici_diagnosticati_terapiaintensiva.pdf'])
end
