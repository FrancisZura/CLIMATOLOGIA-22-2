%% Práctica 1
%
clc
clear
close all
%
%% Parte 1: frecuencias fundamentales
% Frecuencia inercial o parámetro de Coriolis
%
omega = 7.27e-5; % velocidad angular de la Tierra [rad/s]
phi = -90:90; % latitud [°]
f = 2*omega*sind(phi); % [1/s]
figure % Ejercicio 1
hold on
plot(phi,f,'linewidth',2)
line([0 0],[min(f) max(f)],'color','r','linewidth',2)
xlabel('Latitud [°]')
ylabel('Frecuencia [1/s]')
axis tight
grid minor
title('\it f \rm \bf respecto a la latitud')
  ax = gca;
  ax.FontSize = 16;
hold off
%
%% Efecto beta y frecuencia planetaria P
% a = 6.37e6; %radio medio de la Tierra [m]
%
beta = 2*omega*cosd(phi);% /a;
figure % Ejercicio 2
hold on
plot(phi,beta,'linewidth',2)
line([0 0],[min(beta) max(beta)],'color','r','linewidth',2)
xlabel('Latitud [°]')
ylabel('Beta')
axis tight
grid minor
title('Variación de \it f \rm \bf respecto a la latitud (\beta)')
  ax = gca;
  ax.FontSize = 16;
hold off
% Figura
figure
subplot(1,2,1)
hold on
plot(phi,f,'linewidth',2)
line([0 0],[min(f) max(f)],'color','r','linewidth',2)
xlabel('Latitud [°]')
ylabel('Frecuencia [1/s]')
axis tight
grid minor
title('\it f \rm \bf respecto a la latitud')
  ax = gca;
  ax.FontSize = 16;
hold off
subplot(1,2,2)
hold on
plot(phi,beta,'linewidth',2)
line([0 0],[min(beta) max(beta)],'color','r','linewidth',2)
xlabel('Latitud [°]')
ylabel('Beta')
axis tight
grid minor
title('Variación de \it f \rm \bf respecto a la latitud (\beta)')
  ax = gca;
  ax.FontSize = 16;
hold off
%
%EXTRA
%
a = 6.37e6; % radio medio de la Tierra [m]
radio_movil = a*cosd(phi); % radio del disco para latitud fija [m]
v_tangencial = radio_movil*omega; % [m/s]
figure % EXTRA
plot(phi,v_tangencial,'linewidth',2)
title('Magnitud de la velocidad tangencial respecto a la latitud')
xlabel('Latitud [°]')
ylabel('Velocidad tangencial [m/s]')
axis tight
grid minor
  ax = gca;
  ax.FontSize = 16;
%
%% Parte 2: propiedades de la atmósfera
%
% Considerando atm isotérmica T=cte
% 
R = 287; % constante de gas de aire seco [J/kgK]
T0 = 237.1; % temperatura promedio [K]
g = 9.8; % [m/s^2]
%
H = R*T0/g; % escala de altura [m]
%
z = 0:110000; % altura [m]
p0 = 1013.23; % presión al nivel del mar [hPa]
p = p0*exp(-z/H);
%
figure
% plot(p,z/1000,'linewidth',2)
semilogx(p,z/1000,'linewidth',2)
ylabel('Altura geométrica [km]')
xlabel('Presión [hPa]')
title('Perfil de presiones')
grid minor
  ax = gca;
  ax.FontSize = 16;
%
% Hasta aquí, luego considera la geopotencial
%
a = 6.37e6; % radio medio de la Tierra [m]
z_geopotencial = (a./(a+z)).*z;
yyaxis right
semilogx(p,z_geopotencial/1000,'linewidth',2) %(1:98458)
ylabel('Altura geopotencial [km]')
%
%%
% rho = (p0./R*T0)*exp(-z/H); %[g/m^3] (!!)
rho = (p/(R*T0))*100; % [kg/m^3]
figure % Ejercicio 4
subplot(1,2,1)
plot(rho,z/1000,'linewidth',2)
title('Densidad respecto a la altitud')
xlabel('Densidad [kg/m^3]')
ylabel('Altitud [km]')
axis tight
grid minor
  ax = gca;
  ax.FontSize = 16;
%  
subplot(1,2,2) % Ejercicio 5
plot(cumsum(rho)./max(cumsum(rho)),z/1000,'linewidth',2)
title('Acumulado de masa respecto a la altitud')
xlabel('Masa bajo la altitud [% del total]')
ylabel('Altitud [km]')
axis tight
grid minor
  ax = gca;
  ax.FontSize = 16;