%% Pressure Drop Analysis
%% Clear Variables and Command Window
clc
clear all
close all
%% Define Constants
P1 = 500000; % Pa
Q_Step = 1; % mL/min 
Q = (0:Q_Step:10)*(1.667*10^-8); % m^3/s
D1 = (1/8)*.0254; % m Entrance Pipe
D2 = 4*10^-3; % m Holder Inlet
D3 = 9*10^-3; % m Holder Fill Chamber
D4 = 147*10^-9;% m Membrane
D5 = 15*10^-3; % Holder Outlet
D6 = (1/8)*.0254; % m Entrance Pipe
L1 = 1*.0254; % m Entrance Pipe
L2 = 10*10^-3; % m Holder Inlet
L3 = 4*10^-3; % m Holder Fill Chamber
L4 = 58*10^-6; % m Membrane Thickness
L5 = 15*10^-3;% Holder Outlet
L6 = 1*.0254; % m Exit Pipe
mu = .999*10^-3; % Ns/m^2
N = 7.36*10^8; % Pores per membrane
Q_NTube = Q/N;
k = .5; % loss coeff
p = 998.2; % kgm/s^2


%% Find P Final
P_Final = ...
    -((Q*128*mu*L6)/(pi*D6^4))-(.5*k*p*(Q/(pi*D5^2)))...
    -((Q*128*mu*L5)/(pi*D5^4))...
    -((Q_NTube*128*mu*L4)/(pi*D4^4))-(.5*k*p*(Q/(pi*D3^2)))...
    -((Q*128*mu*L3)/(pi*D3^4))-(.5*k*p*(Q/(pi*D2^2)))...
    -((Q*128*mu*L2)/(pi*D2^4))-(.5*k*p*(Q/(pi*D1^2)))...
    -((Q*128*mu*L1)/(pi*D1^4))...
    +P1;

%% Find Delta_P and Q in Standard Units
Delta_P = -(P_Final-P1);
Q_Standard = (0:Q_Step:10);

%% Plot Delta_P
figure('Units','normalized','Position',[0 0 1 1])
subplot(2,3,1)
plot(Q_Standard,Delta_P/6894.76,'LineWidth',1.5)
title('(Constant Temperature 20°C)','fontsize',15,'fontweight','b')
xlabel('Flow Rate (mL/min)','fontsize',15,'fontweight','b')
ylabel('Pressure Drop (Psi)','fontsize',15,'fontweight','b')
grid on

%% Find Pressure Max and Min Increment
n = size(Q);
Delta_Max = Delta_P(n(2))/6894.76;
Delta_Min = Delta_P(2)/6894.76;
fprintf('Pressure Drop With Constant Temp, Changing Flow Rate\n\n')
fprintf('The maximum pressure drop is %g Psi\n\n',Delta_Max)
fprintf('The minimum pressure drop is %g Psi\n\n',Delta_Min)

%% Temperature Effects on Flow
Temp = 68:.01:73; % °F
Temp_C = (Temp - 32)*(5/9); % °C
B = 0.00021; % (m^3/m^3 °C) at 20°C
po = 998.2; % kg/m^3 at 20°C
to = 68; % intial temp °F
p_New = po./(1+(B*(to-Temp_C)));

%% Pressure Drop vs Temperature Change
Q_Constant = 5*1.667*10^-8; % m^3/s
Q_NTube_Constant = Q_Constant/N;
P_Temp = ...
    -((Q_Constant*128*mu*L6)/(pi*D6^4))-(.5*k*p_New*(Q_Constant/(pi*D5^2)))...
    -((Q_Constant*128*mu*L5)/(pi*D5^4))...
    -((Q_NTube_Constant*128*mu*L4)/(pi*D4^4))-(.5*k*p_New*(Q_Constant/(pi*D3^2)))...
    -((Q_Constant*128*mu*L3)/(pi*D3^4))-(.5*k*p_New*(Q_Constant/(pi*D2^2)))...
    -((Q_Constant*128*mu*L2)/(pi*D2^4))-(.5*k*p_New*(Q_Constant/(pi*D1^2)))...
    -((Q_Constant*128*mu*L1)/(pi*D1^4));

%% Plot Pressure Drop vs Temperature
subplot(2,3,2)
plot(Temp_C,-P_Temp/6894.76,'LineWidth',1.5) 
title('(Constant Flow Rate 5mL/min)','fontsize',15,'fontweight','b')
xlabel('Temperature °C','fontsize',15,'fontweight','b')
ylabel('Pressure Drop (Psi)','fontsize',15,'fontweight','b')
grid on

%% Find Pressure Max and Min Increment
j = size(Temp);
Delta_TMax = -P_Temp(j(2))/6894.76;
Delta_TMin = -P_Temp(2)/6894.76;
fprintf('Pressure Drop With Changing Temp, Constant Flow Rate\n\n')
fprintf('The maximum pressure drop is %g Psi\n\n',Delta_TMax)
fprintf('The minimum pressure drop is %g Psi\n\n',Delta_TMin)

%% Multiple Lines of Constant Q
P_Matrix = zeros(j(2),10);
subplot(2,3,3)
for step = 1:1:4;
    Q_Multi = (4:.001:4.003)*1.667*10^-8;
    Q_NTube_Multi = Q_Multi/N;
    P_Multi = ...
    -((Q_Multi(step)*128*mu*L6)/(pi*D6^4))-(.5*k*p_New*(Q_Multi(step)/(pi*D5^2)))...
    -((Q_Multi(step)*128*mu*L5)/(pi*D5^4))...
    -((Q_NTube_Multi(step)*128*mu*L4)/(pi*D4^4))-(.5*k*p_New*(Q_Multi(step)/(pi*D3^2)))...
    -((Q_Multi(step)*128*mu*L3)/(pi*D3^4))-(.5*k*p_New*(Q_Multi(step)/(pi*D2^2)))...
    -((Q_Multi(step)*128*mu*L2)/(pi*D2^4))-(.5*k*p_New*(Q_Multi(step)/(pi*D1^2)))...
    -((Q_Multi(step)*128*mu*L1)/(pi*D1^4));
    P_Matrix(:,step) = -P_Multi;
    hold on
    Line_Color = ['b' 'r' 'c' 'g'];
    plot(Temp_C,P_Matrix(:,step)/6894.76,Line_Color(step),'LineWidth',1.5)
    
end
hold off

title('(Lines of Constant Flow)','fontsize',15,'fontweight','b')
xlabel('Temperature °C','fontsize',15,'fontweight','b')
ylabel('Pressure Drop (Psi)','fontsize',15,'fontweight','b')
grid on
legend('4.000 mL/min','4.001 mL/min','4.002 mL/min','4.003 mL/min','Location','NorthWest')

%% Changes in Pressure Drop as a Function of Diameter and Flow Rate
fprintf('Pressure Drop as a Function of Diameter\n\n')
fprintf('Pipe Diameter \t\tSlope(dPdrop/dQ)\n\n')
subplot(2,3,4)
Slope_Vector = zeros(1,6);
for step = 1:1:6;
    D_Step = [(1/8) (3/16) (1/4) (3/8) (1/2) (3/4)]*.0254;
    Q_Multi = (0:1:10)*(1.667*10^-8);
    Q_NTube_Multi = Q_Multi/N;
    P_Multi = ...
    -((Q_Multi*128*mu*L6)/(pi*D_Step(step)^4))-(.5*k*p*(Q_Multi/(pi*D5^2)))...
    -((Q_Multi*128*mu*L5)/(pi*D5^4))...
    -((Q_NTube_Multi*128*mu*L4)/(pi*D4^4))-(.5*k*p*(Q_Multi/(pi*D3^2)))...
    -((Q_Multi*128*mu*L3)/(pi*D3^4))-(.5*k*p*(Q_Multi/(pi*D2^2)))...
    -((Q_Multi*128*mu*L2)/(pi*D2^4))-(.5*k*p*(Q_Multi/(pi*D_Step(step)^2)))...
    -((Q_Multi*128*mu*L1)/(pi*D_Step(step)^4));
    Slope = (-(P_Multi(11)-P_Multi(2))/6894.76)/((Q_Multi(11)-Q_Multi(2))/(1.667*10^-8));
    Slope_Vector(:,step) = Slope; 
    fprintf('  %f \t\t  %f\n\n',D_Step(step)/.0254,Slope)
    hold on
    Line_Shape = ['o','x','+','s','d','v'];
    Line_Color = ['r' 'm' 'b' 'c' 'k' 'g'];
    plot(Q_Multi/(1.667*10^-8),-P_Multi/6894.76,Line_Color(step),'Marker',Line_Shape(step),'LineWidth',1.5)
    
end
hold off
title('(Constant Lines of Inlet/Outlet Pipe Diameter)','fontsize',15,'fontweight','b')
xlabel('Flow Rate (mL/min)','fontsize',15,'fontweight','b')
ylabel('Pressure Drop (Psi)','fontsize',15,'fontweight','b')
grid on
legend('1/8 in','3/16 in','1/4 in','3/8 in','1/2 in','3/4 in','Location','NorthWest')
subplot(2,3,5)

for step = 1:1:10;
    D_Step = [(1/8):.001:.75]*.0254;
    Q_Multi = (1:1:10)*(1.667*10^-8);
    Q_NTube_Multi = Q_Multi/N;
    P_Multi = ...
    -((Q_Multi(step)*128*mu*L6)./(pi*D_Step.^4))-(.5*k*p*(Q_Multi(step)/(pi*D5^2)))...
    -((Q_Multi(step)*128*mu*L5)/(pi*D5^4))...
    -((Q_NTube_Multi(step)*128*mu*L4)/(pi*D4^4))-(.5*k*p*(Q_Multi(step)/(pi*D3^2)))...
    -((Q_Multi(step)*128*mu*L3)/(pi*D3^4))-(.5*k*p*(Q_Multi(step)/(pi*D2^2)))...
    -((Q_Multi(step)*128*mu*L2)/(pi*D2^4))-(.5*k*p*(Q_Multi(step)./(pi*D_Step.^2)))...
    -((Q_Multi(step)*128*mu*L1)./(pi*D_Step.^4));

   
    hold on
    Line_Color = ['r','m','b','c','k','g','r','m','b','k'];
    Line_Shape = ['-','-','-','-','-','-',':',':',':',':'];
    plot(D_Step/.0254,-P_Multi/6894.76,Line_Color(step),'LineStyle',Line_Shape(step),'LineWidth',1.5)
    
end
hold off
title('(Constant Lines of Flow Rate)','fontsize',15,'fontweight','b')
xlabel('Inlet/Outlet Diameter (in)','fontsize',15,'fontweight','b')
ylabel('Pressure Drop (Psi)','fontsize',15,'fontweight','b')
grid on
legend('1 mL/min','2 mL/min','3 mL/min','4 mL/min','5 mL/min','6 mL/min','7 mL/min'...
    ,'8 mL/min','9 mL/min','10 mL/min','Location','NorthWest')

%% Pressure Resolution

Flow_Gauge_Acc = .0025; % +/- .25% full scale
PerFullScale = 10*Flow_Gauge_Acc; % mL/min
Pressure_Res = PerFullScale*Slope;
fprintf('Recommended Minimun Pressure Resolution: %g psi\n\n',Pressure_Res);

%% Vary Effective Area: D = 9 mm

figure('Units','normalized','Position',[0 0 1 1])
for step = 1:1:7;
    D4 = [100 120 130 147 150 170 200]*10^-9;
    Q = (0:Q_Step:5)*(1.667*10^-8); % m^3/s
    Q_NTube_Multi = Q/N;
    P_Multi = ((Q_NTube_Multi*128*mu*L4)/(pi*D4(step)^4));
 
    hold on
    Line_Shape = ['-','-','-','-','-',':',':',':',':',':'];
    Line_Color = ['b','r','c','g','k','b','r','c','g','k'];
    plot(Q/(1.667*10^-8),P_Multi/6894.76,Line_Color(step),...
        'LineStyle',Line_Shape(step),'LineWidth',1.5)
    
end
hold off

title('P vs Flow Rate with Lines of Constant Pore Diameter and 9 mm Effective Diameter','fontsize',15,'fontweight','b')
xlabel('Flow Rate (mL/min)','fontsize',15,'fontweight','b')
ylabel('Pressure Drop (Psi)','fontsize',15,'fontweight','b')
grid on
legend('100 nm','120 nm','130 nm','147 nm (Current)','150 nm','170 nm','200 nm','Location','NorthWest');
%% Vary Effective Area: D = 8 mm
Pore_Den = N/(9*10^-3); % pores/m
Effective_Diameters = 8*10^-3; % m
N_New = Effective_Diameters*Pore_Den;
figure('Units','normalized','Position',[0 0 1 1])
for step = 1:1:7;
    D4 =[100 120 130 147 150 170 200]*10^-9;
    Q = (0:Q_Step:5)*(1.667*10^-8); % m^3/s
    Q_NTube_Multi = Q/N_New;
    P_Multi = ((Q_NTube_Multi*128*mu*L4)/(pi*D4(step)^4));
 
    hold on
    Line_Shape = ['-','-','-','-','-',':',':',':',':',':'];
    Line_Color = ['b','r','c','g','k','b','r','c','g','k'];
    plot(Q/(1.667*10^-8),P_Multi/6894.76,Line_Color(step),...
        'LineStyle',Line_Shape(step),'LineWidth',1.5)
    
end
hold off

title('P vs Flow Rate with Lines of Constant Pore Diameter at 8 mm Effective Diameter','fontsize',15,'fontweight','b')
xlabel('Flow Rate (mL/min)','fontsize',15,'fontweight','b')
ylabel('Pressure Drop (Psi)','fontsize',15,'fontweight','b')
grid on
legend('100 nm','120 nm','130 nm','147 nm (Current)','150 nm','170 nm','200 nm','Location','NorthWest');
%% Vary Effective Area: D = 10 mm
Pore_Den = N/(9*10^-3); % pores/m
Effective_Diameters = 10*10^-3; % m
N_New = Effective_Diameters*Pore_Den;
figure('Units','normalized','Position',[0 0 1 1])
for step = 1:1:7;
    D4 = [100 120 130 147 150 170 200]*10^-9;
    Q = (0:Q_Step:5)*(1.667*10^-8); % m^3/s
    Q_NTube_Multi = Q/N_New;
    P_Multi = ((Q_NTube_Multi*128*mu*L4)/(pi*D4(step)^4));
 
    hold on
    Line_Shape = ['-','-','-','-','-',':',':',':',':',':'];
    Line_Color = ['b','r','c','g','k','b','r','c','g','k'];
    plot(Q/(1.667*10^-8),P_Multi/6894.76,Line_Color(step),...
        'LineStyle',Line_Shape(step),'LineWidth',1.5)
    
end
hold off

title('P vs Flow Rate with Lines of Constant Pore Diameter at 10 mm Effective Diameter','fontsize',15,'fontweight','b')
xlabel('Flow Rate (mL/min)','fontsize',15,'fontweight','b')
ylabel('Pressure Drop (Psi)','fontsize',15,'fontweight','b')
grid on
legend('100 nm','120 nm','130 nm','147 nm (Current)','150 nm','170 nm','200 nm','Location','NorthWest');


