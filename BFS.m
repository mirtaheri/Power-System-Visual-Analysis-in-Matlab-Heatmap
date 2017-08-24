
clear 
clc
close all
%% Physical network structure --------------------------------
% It is conventional to represent grid configuration by its coincidence
% matrix, especially in case of radial network. Here we represent our grid
% using this convention, however the aim is to visualize it and one can
% easily adapt it with the way is desired, even reading from csv files.
node_num = 36;
L = - eye(node_num);

L(2,1)=1;
L(3,1)=1;
L(4,2)=1;
L(5,2)=1;
L(6,3)=1;
L(7,3)=1;
L(8,7)=1;
L(9,7)=1;
L(10,6)=1;
L(11,8)=1;
L(12,9)=1;
L(13,10)=1;
L(14,10)=1;
L(15,11)=1;
L(16,11)=1;
L(17,12)=1;
L(18,14)=1;
L(19,9)=1;
L(20,19)=1;
L(21,19)=1;
L(22,20)=1;
L(23,21)=1;
L(24,21)=1;
L(25,16)=1;
L(26,16)=1;
L(27,15)=1;
L(28,18)=1;
L(29,18)=1;
L(30,13)=1;
L(31,30)=1;
L(32,31)=1;
L(33,31)=1;
L(34,26)=1;
L(35,26)=1;
L(36,5)=1;

gamma = inv(L);

% Power line impedance
Zb=diag([0.00782+0.00212i, 0.01564+0.00424i, 0.01173+0.00318i, 0.01173+0.00318i, 0.013685+0.00371i, 0.01173+0.00318i...
    0.01173+0.00318i, 0.01173+0.00318i, 0.00782+0.00212i, 0.00782+0.00212i, 0.01564+0.00424i, 0.01173+0.00318i...
    0.01173+0.00318i, 0.013685+0.00371i, 0.01173+0.00318i, 0.01173+0.00318i, 0.01173+0.00318i, 0.00782+0.00212i...
    0.00782+0.00212i, 0.01564+0.00424i, 0.01173+0.00318i,0.01173+0.00318i, 0.013685+0.00371i, 0.01173+0.00318i...
    0.01173+0.00318i, 0.01173+0.00318i, 0.00782+0.00212i, 0.00782+0.00212i, 0.01564+0.00424i, 0.01173+0.00318i...
    0.01173+0.00318i, 0.013685+0.00371i, 0.01173+0.00318i, 0.01173+0.00318i, 0.01173+0.00318i, 0.00782+0.00212i]);

% Total power line admittance
Ysh=zeros(node_num,1);

% Slack bus
V0=1;
V0_vect=V0*ones(node_num,1);

% Admittance defined loads
Ycar=zeros(node_num,1);

%% Network Structure

% line aggregated admittance
Y_totNodes= zeros(node_num,1) ;
%%  Generation and Loads

hours= 1:1:24;
num_hours=length(hours);

% Load and generation profiles during 24 hours of simulation (step time =
% 1hour)
%%% Residential

peak_factor=0.12;

res = peak_factor*[0.4,0.25,0.2,0.25,0.40,  0.5,  0.65,0.7,0.65,0.65,...
    0.6,0.6,0.6,0.6,0.65,0.7,  0.8, 0.9, 1, 0.95, 0.9, 0.8, 0.65, 0.55];

% Industrial
ind=[0.2,0.2,0.2,0.2,0.2, 0.4, 0.6, 0.9,0.9,0.9,0.9,0.9, 0.7, ...
     0.9,0.9,0.9,0.9, 0.6, 0.4, 0.2,0.2,0.2,0.2,0.2];

 % Tertiary
ter=[0.35,0.3,0.3,0.35,0.4, 0.5, 0.6, 0.7, 0.8, 0.78, 0.76, 0.74, 0.72, 0.7,... 
     0.68, 0.66, 0.64, 0.52, 0.45,0.43,0.42,0.4,0.4,0.4];

% Photovoltaics
PV=[    0,    0,    0,   0,   0,   0, 0.4, 0.7, 0.88, 0.95, 0.988,  1, ... 
    0.988, 0.95, 0.88, 0.7, 0.4,   0,    0,   0,    0,  0,  0,  0];

% Wind Turbine
WT = -0.1 + rand(1, num_hours)*1.1; 

% Hydrauelectric power plant
hydr = ones(1,num_hours);

% Base amplitudes
S_base=1000; % kVA, Base apparent power
V_base=10; % kV, Base voltage
I_base=S_base/(sqrt(3)*V_base); % A, Base current

% Thermal limit
Ilim=60; % A
Ilim_pu=Ilim/I_base*ones(node_num,1);

% Nominal active power at nodes
% Each row represents a type of load or generator that exists in every
% node. The fisrt three rows represent loads in each node. The 4th and 5th
% rows are representing distributed generators (hydro power plant and
% photovoltaics) and as it can be seen generation values have been set to
% negative sign as convention.

P_nom =[ % kW
    400, 325, 280, 425, 80,200, 95, 275, 160 230,150,120,175,265,165, 160, 350, 360,150,120,350,220,45,120, 275, 160, 335, 220,110,180,70,120,120, 240, 160, 75;  % residential
      0, 0, 50, 50, 50, 75,150,50,150 0, 0, 0, 0, 0, 0, 60, 50, 60,0, 0, 0, 50, 0, 0,0,125,85, 35,0 , 0, 0 ,0,0, 200, 185, 75;  % industrial
      0,0,100,200, 0, 0,  0,  80,  0,0,25,0,150,65,0,  0,  0,  0,0,0,0,100,50,0 ,  0,  0,  0,0,100,100,75, 0, 40,  110,  0,  45;  % tertiary       
      0,  0,-80,  0,  -30,  0,-50,  0,  -75,0,  0,-80,  0,  0,  0,-50,  0,  0,0,  0,-80,  0,  0,  0,-50,  0,  0,0,  0,-80,  0,  -35,  0,-150,  -50,  -20;  % PV  
      0,  0,  0,  0,  0, 0, 0, 0, 0, 0,  0,  0,  0,0, 0, 0, 0, 0, 0,  0,  0,  0,0, 0, 0,-120, 0, 0,  0,  0,  0,0,-100, 0, 0, 0; % Hydro  
      0,  0,  0,  0,  0, 0, 0, 0, 0, 0,  0,  0,  0,0, 0, 0, 0, 0, 0,  0,  0,  0,0, 0, 0,0, 0, 0,  0,  0,  0,0,0, 0, 0, -100]; % WT  

% Active and reactive power correlation
tg_phi=[
    0.1,0.1,0.1,0.1,0.1,0.1,0.1,0.1,0.1, 0.1,0.1,0.1,0.1,0.1,0.1,0.1,0.1,0.1,  0.1,0.1,0.1,0.1,0.1,0.1,0.1,0.1,0.1 ,0.1,0.1,0.1,0.1,0.1,0.1,0.1,0.1,0.1;  % residenziali
    0.5,0.5,0.5,0.5,0.5,0.5,0.5,0.5,0.5, 0.5,0.5,0.5,0.5,0.5,0.5,0.5,0.5,0.5,  0.5,0.5,0.5,0.5,0.5,0.5,0.5,0.5,0.5,0.5,0.5,0.5,0.5,0.5,0.5,0.5,0.5,0.5;  % industriali
    0.4,0.4,0.4,0.4,0.4,0.4,0.4,0.4,0.4, 0.4,0.4,0.4,0.4,0.4,0.4,0.4,0.4,0.4,  0.4,0.4,0.4,0.4,0.4,0.4,0.4,0.4,0.4, 0.4,0.4,0.4,0.4,0.4,0.4,0.4,0.4,0.4;  % terziario
      0,  0,  0,  0,  0,  0,  0,  0,  0, 0,  0,  0,  0,  0,  0,  0,  0,  0,0,  0,  0,  0,  0,  0,  0,  0,  0,0,  0,  0,  0,  0,  0,  0,  0,  0;  % PV
      0,  0,  0,  0,  0,  0,  0,  0,  0, 0,  0,  0,  0,  0,  0,  0,  0,  0,0,  0,  0,  0,  0,  0,  0,  0,  0 ,0,  0,  0,  0,  0,  0,  0,  0,  0; % idro
      0,  0,  0,  0,  0,  0,  0,  0,  0, 0,  0,  0,  0,  0,  0,  0,  0,  0,0,  0,  0,  0,  0,  0,  0,  0,  0 ,0,  0,  0,  0,  0,  0,  0,  0,  0]; % Wind turbine

Q_nom = P_nom.*tg_phi; % Reactive power

%% Load flow initialization
profiles = [res;ind;ter;PV;hydr;WT];
P_loads = zeros(node_num,num_hours); 
Q_loads = zeros(node_num,num_hours); 

P_load = zeros(node_num,num_hours);
P_gen = zeros(node_num,num_hours); 
l_idx = P_nom >= 0;
l_mat = zeros(size(P_nom));
l_mat(l_idx) = P_nom(l_idx);
g_idx = ~l_idx;
g_mat = zeros(size(P_nom));
g_mat(g_idx) = P_nom(g_idx); 

for k = 1:node_num   
   Ptemp = repmat(P_nom(:,k),1,num_hours).*profiles;
   P_loads(k,:)=sum(Ptemp,1);
   Qtemp=repmat(Q_nom(:,k),1,num_hours).*profiles;
   Q_loads(k,:)=sum(Qtemp,1);

   Ptemp_load = repmat(l_mat(:,k),1,num_hours).*profiles;
   P_load(k,:) = sum(Ptemp_load,1);
   Ptemp_gen = repmat(g_mat(:,k),1,num_hours).*profiles;
   P_gen(k,:) = sum(Ptemp_gen,1);
end

% Complex power in nodes(rows) for simulation hours(columns)
S_car = (P_loads + 1i * Q_loads)/S_base; 

% V and I output matrix initialization 
v = zeros(node_num,num_hours);
i_s = zeros(node_num,num_hours);
i_b = zeros(node_num,num_hours);
losses = zeros(node_num,num_hours);
loading_of_lines = zeros(node_num,num_hours);

error_tollerance = 10^-6;

for h=1:num_hours
    
    i_s(:,h)= zeros(node_num,1);
    i_b(:,h)= zeros(node_num,1);
    v(:,h)= V0_vect; 
    it = 0; %iterations
    error = inf;
    
while (error > error_tollerance)
it = it+1;
V_prec(:,h) = v(:,h);
i_s(:,h) = conj(S_car(:,h))./conj(v(:,h))+Ycar.*v(:,h)+Y_totNodes.*v(:,h);
i_b(:,h) = gamma'*i_s(:,h); 
v(:,h) = V0_vect - gamma * Zb * i_b(:,h);

error = max(abs(v(:,h)-V_prec(:,h))./abs(v(:,h)));
end

loading_of_lines(:,h) = abs(i_b(:,h))./Ilim_pu;
losses(:,h) = real(Zb)*abs(i_b(:,h)).^2;

minus_ib(:,h)=-i_b(:,h);

end

total_loss = sum(losses);

vmax=max(max(abs(v)));
vmin=min(min(abs(v)));

pmax=max(max(abs(total_loss)));
pmin=min(min(abs(total_loss)));

%% Result 
plot_script_p;
pause(1)
plot_script_v;
pause(1)
visualize(L, P_load, P_gen, loading_of_lines, v);

