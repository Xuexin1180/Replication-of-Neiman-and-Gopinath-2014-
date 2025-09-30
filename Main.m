clear all
close all
clc

fprintf('\n***************************************************************\n')
fprintf('\n Replicate Neiman and Gopinath(2014) \n')
fprintf('\n \tXuexin 09/2025')
fprintf('\n \t"Trade Adjustment and Productivity in Large Crises"')
fprintf('\n***************************************************************\n')

% KEY PARAMETERS
run('Par.m'); 

% ---------- ADD: declare globals shared with functions ----------
global nf simnum tol1 tol2 maxiter1 maxiter2 omega_max
global P_N f_v f_e init_pm
global A Omega p y g z gamma P_X P_M P_Z P_G P C_N G pm
% ---------------------------------------------------------------

%  KEY VALUES FOR SIMULATION
nf = 1000;                     % number of firms
simnum = 2;                    % pre-shock = 1, post-shock = 2
simstep = 0.1535;              % increase in foreign price
errors = 0;
tol1 = 1e-4;
tol2 = 1e-8;
maxiter1 = 1000;
maxiter2 = 1000;
omega_max = 1000;              % total number of availabor imported varieties

run('Initialization.m');

% %productivity draw
% A_ln_sd = 0.75;                
% A_mu = -0.5 * A_ln_sd^2;       % ensures mean productivity = 1
% 
% % draw technology distribution
% A = draw_productivity(nf, simnum, A_ln_sd, A_mu);

load('productivities.mat','A');
A = repmat(A,1,simnum);


%%

%%%%%%%%%%%%%%%%%%%% BENCHMARK SIMULATION %%%%%%%%%%%%%%%%%%%%%%%%%
fprintf('\n Performing Benchmark Simulation\n');

run('Initialization.m');            % <— resets all globals (Omega,p,y,...)
load('productivities.mat','A');     % keep A identical across scenarios
A = repmat(A,1,simnum);

%   INITIALIZE ECONOMIC VALUES
P_N = 0.96;                     % non-tradable goods price index
f_v = 0.0075;                   % fixed cost per variety import
f_e = 0;                        % fixed cost exporting
init_pm = 1.6976;               % initial foreign prices

for state = 1:simnum
    pm_scale = 1 + (state-1)*simstep;
    SimFunction(pm_scale, state);
end

fprintf('\n Benchmark Simulation DONE ✅\n');

% calculate productivity
[dlnPR1,Feenstra1,dlnPRtilde1] = calc_PR();

fprintf('\n Benchmark simulation: productivity change is %.6f\n', dlnPR1);
fprintf('\n Benchmark simulation: Feenstra variety effect is %.6f\n', Feenstra1);
fprintf('\n Benchmark simulation: mismeasured productivity change is %.6f\n', dlnPRtilde1);

%%%%%%%%%%%%%%%%%% GENERATE FIGURES 11 AND 12 %%%%%%%%%%%%%%%%%%%%%%
fprintf('\n \n Generating Figures 11 and 12.....')

figs = figures();
fprintf('\t\t\t \t\t\t\tDone.\n')

fileNames = {"Figure11A.png", "Figure11B.png", "Figure12.png"};

for k = 1:numel(figs)
    exportgraphics(figs(k), fileNames{k}, 'Resolution', 300);
end

%%
%%%%%%%%%%%%%%%%%%%% NO FIXED COSTS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

fprintf('\n Performing "No Fixed Costs" Simulation')

run('Initialization.m');            % <— resets all globals (Omega,p,y,...)
load('productivities.mat','A');     % keep A identical across scenarios
A = repmat(A,1,simnum);

% % control
% P_N = 0.96;                     % non-tradable goods price index
% f_v = 0;                   % fixed cost per variety import
% f_e = 0;                        % fixed cost exporting
% init_pm = 1.6976;               % initial foreign prices

% paper's replication file:
P_N = 0.965;
f_v = 0;
init_pm = 3.82;


for state = 1:simnum
    pm_scale = 1 + (state-1)*simstep;
    SimFunction(pm_scale, state);
end

fprintf('\n No fixed costs analysis DONE ✅\n');

% calculate productivity
[dlnPR2,Feenstra2,dlnPRtilde2] = calc_PR();

fprintf('\n No fixed costs: productivity change is %.6f\n', dlnPR2);
fprintf('\n No fixed costs: Feenstra variety effect is %.6f\n', Feenstra2);
fprintf('\n No fixed costs: mismeasured productivity change is %.6f\n', dlnPRtilde2);



%%


%%%%%%%%%%%%%%%%%%%% NO ROUNDABOUT PRODUCTION %%%%%%%%%%%%%%%%%%%%%%
fprintf('\n Performing "No Roundabout Prod." Simulation')

run('Initialization.m');            % <— resets all globals (Omega,p,y,...)
load('productivities.mat','A');     % keep A identical across scenarios
A = repmat(A,1,simnum);

%   INITIALIZE ECONOMIC VALUES
P_N = 0.96;                     % non-tradable goods price index
f_v = 0.0075;                   % fixed cost per variety import
f_e = 0;                        % fixed cost exporting
init_pm = 1.6976;               % initial foreign prices

for state = 1:simnum
    pm_scale = 1 + (state-1)*simstep;
    SimFunction_no_roundabout(pm_scale, state);
end

fprintf('\n No roundabout analysis DONE ✅\n');

% calculate productivity
[dlnPR3,Feenstra3,dlnPRtilde3] = calc_PR();

fprintf('\n No roundabout: productivity change is %.6f\n', dlnPR3);
fprintf('\n No roundabout: Feenstra variety effect is %.6f\n', Feenstra3);
fprintf('\n No roundabout: mismeasured productivity change is %.6f\n', dlnPRtilde3);


