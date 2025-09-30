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

%productivity draw
A_ln_sd = 0.75;                
A_mu = -0.5 * A_ln_sd^2;       % ensures mean productivity = 1

% draw technology distribution
A = draw_productivity(nf, simnum, A_ln_sd, A_mu);

%%%%%%%%%%%%%%%%%%%% BENCHMARK SIMULATION %%%%%%%%%%%%%%%%%%%%%%%%%
fprintf('\n Performing Benchmark Simulation\n');

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

%%

