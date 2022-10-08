%% Práctica 2
%
clc
clear
close all
%
%% Cálculo de constanse solar
% Constante solar
%
rsv = 1.0820e+11; % 108200000000 [m] Sol-Venus
rse = 1.4960e+11; % 149597870700 [m] Sol-Tierra
rsm = 2.2794e+11; % 227940000000 [m] Sol-Marte
rsj = 5*rse; % Sol-Jupiter
radios = [rsv rse rsm rsj];
%
r = rsv:100000000:rsj;
%
sigma = 5.67e-8; % [W / (m^2 * K^4)]
Ts = 5772; % [K]
rs = 696e6; % [m] %radio de Sol
%
irradiancia = sigma*(Ts^4);
flujo = irradiancia*4*pi*(rs^2);
%
S_0 = flujo./(4.*pi.*(r.^2));
%
S_0_hartmann = [2632 1367 589 51];
%
%
plot(r, S_0, 'linewidth',4)
hold on
title('Constante solar')
xlabel('Radio de esfera [m]')
ylabel('Constante solar [W/m^2]')
plot(radios,S_0_hartmann,'or','linewidth',4)
axis tight
grid minor
set(gca,'FontSize',19)
legend('S_0','Valores obtenidos del Hartmann')
%
%% Temperaturas de emisión (sin efecto invernadero)
% Distancias a todos los planetas [m]: (Hartmann)
%
d_mercurio = 58e9;
d_venus    = 108e9;
d_tierra   = 150e9; %Tierra
d_marte    = 228e9;
d_jupiter  = 778e9;
d_saturno  = 1430e9;
d_urano    = 2878e9;
d_neptuno  = 4510e9;
des = [d_mercurio d_venus d_tierra d_marte d_jupiter d_saturno d_urano d_neptuno];
S_0_planetas = flujo./(4.*pi.*(des.^2));
I_d = S_0_planetas/4; %radiación solar incidente [W/m^2] 
%
% Albedos planetarios de todos los planetas [0-1]: (Hartmann)
alpha_mercurio = 0.1;
alpha_venus    = 0.65;
alpha_tierra   = 0.29;
alpha_marte    = 0.15;
alpha_jupiter  = 0.52;
alpha_saturno  = 0.47;
alpha_urano    = 0.50;
alpha_neptuno  = 0.40;
alphas = [alpha_mercurio alpha_venus alpha_tierra alpha_marte alpha_jupiter alpha_saturno alpha_urano alpha_neptuno];
%
E_planeta = I_d.*(1-alphas);
T_e_planeta = (E_planeta/sigma).^(1/4)-273.15;
%
% % % %  = 162.3243 %Mercurio
% % % %  = -21.1381 %Venus
% % % %  = -17.9475 %Tierra
% % % %  = -56.6274 %Marte
% % % %  = -171.5400 %Jupiter
% % % %  = -196.3225 %Saturno
% % % %  = -219.7781 %Urano
% % % %  = -228.5263 %Neptuno
%
%% radiancia espectral
%
h = 6.625*10^(-34); %cte de Planck [J s]
kb = 1.38*10^(-23); %cte de boltzmann [J K-1]
c = 3*10^8; %velocidad de la luz [m s-1]
T1 = 15+273.15; %temperatura de emisión K % Tierra
T2 = 5800; % Sol
%corrimiento de Wien
lmaxi1 = (2898*10^(-6))/T1 %en metros
lambda1 = linspace(lmaxi1*0.1,lmaxi1*10); %metros
lmaxi2 = (2898*10^(-6))/T2 %en metros
lambda2 = linspace(lmaxi2*0.1,lmaxi2*10); %metros
%Radiancia en función de la longitud de onda
radesp1 = (2*h*c^2)./((lambda1.^5).*(exp((h.*c)./(lambda1.*kb.*T1))-1)); %[W m-2 sr-1 m-1]
radesp2 = (2*h*c^2)./((lambda2.^5).*(exp((h.*c)./(lambda2.*kb.*T2))-1)); %[W m-2 sr-1 m-1]
%
figure()
plot(lambda2, radesp2, 'linewidth',2)
hold on
title('Radiancia espectral de un cuerpo negro (Sol)')
xlabel('Longitud de onda [m]')
ylabel('Radiancia espectral [W m^{-2} sr^{-1} m^{-1}]')
axis tight
grid minor
set(gca,'FontSize',19)
%
figure()
plot(lambda1, radesp1, 'linewidth',2)
hold on
title('Radiancia espectral de un cuerpo negro (Tierra)')
xlabel('Longitud de onda [m]')
ylabel('Radiancia espectral [W m^{-2} sr^{-1} m^{-1}]')
axis tight
grid minor
set(gca,'FontSize',19)
%
%% Efecto de los gases de efecto invernadero
%
% Jugar con los cambios del parámetro asociado al efecto invernadero
auxiliar = 0;
for beta_2 = [0:0.01:1]
sigma   = 5.67e-8; % cte de stefan-boltzmann [W/m^2K^4]
alpha_1 = 0.22; % albedo atmósfera (hacia arriba): factor reflejado por la atm
alpha_2 = 0.09; % albedo tierra (hacia arriba): factor reflejado por la tierra
beta_1  = 0.50; % factor transmitido hacia la tierra
% beta_2  = 0.23; % factor transmitido por la atm desde la tierra (gases)
% Ahora, los fenómenos físicos. En [W/m^2]
I  = 342; % RADIACIÓN SOLAR INCIDENTE % Hartmann = 340
R1 = alpha_1*I; % Reflejado por la ATM
T1 = beta_1*I; % Transmitido por la ATM hacia abajo
R2 = alpha_2*T1; % Reflejado por la superficie
T2 = beta_1*R2; % Transmitido por la ATM hacia arriba (del reflejado)
%
A1 = I-R1-T1+R2-T2; % Absorbido por la ATM
A2 = T1-R2; % Absorbido por la superficie
% Luego se pueden calcular E1 y E2, pero tienen interdependencia:
% E1 = A1+(1-beta_2)*E2; % Emitido por la ATM (1)
% E2 = A2+0.65*E1 % Emitido por la superficie (1)
% sistema de ecuaciones...
Q = 102; % Calor latente (cambio de fase) % Hartmann = 108 = 20+88
% reordenando el sistema de ecuaciones
X = [1 -1+beta_2;-0.65 1];
Y = [A1+Q;A2-Q];
C = X\Y; % resolución para los E
E1 = C(1); % Emitido por la ATM (2)
E2 = C(2); % Emitido por la superficie (2)
%
auxiliar = auxiliar+1;
T_s(auxiliar) = (E2/sigma)^(1/4)-273.15;
end
figure 
hold on
plot([0:0.01:1],T_s,'linewidth',2.5)
plot(0.23,T_s(24),'r*','linewidth',4)
title('Cambio de \it T_s \rm \bf respecto a los cambios de \it \beta_2')
xlabel('\it \beta_2')
ylabel('Temperatura de emisión \it T_s \rm [°C]')
axis tight
grid minor
  ax = gca;
  ax.FontSize = 16;
hold off