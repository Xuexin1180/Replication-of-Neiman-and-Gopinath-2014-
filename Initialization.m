% version: Sept. 2025

% Optimal decision rule arrays
% nf: number of firms
% simnum: status, pre-shock = 1, post-shock = 2

A      = zeros(nf, simnum);   % productivity (filled by draw_productivity)
Omega  = zeros(nf, simnum);   % imported variety measure
p      = ones(nf, simnum);    % firm selling price
y      = zeros(nf, simnum);   % total output
g      = zeros(nf, simnum);   % final-goods portion
z      = zeros(nf, simnum);   % intermediate-use portion
gamma  = zeros(nf, simnum);   % domestic share of intermediate value
P_X    = zeros(nf, simnum);   % firm composite input price (D+F)
P_M    = zeros(nf, simnum);   % firm foreign input price index

% aggregate (store as nf x simnum for your current pattern)
P_Z = zeros(nf, simnum);      % domestic input price index
P_G = zeros(nf, simnum);      % tradable final-good price index
P   = zeros(nf, simnum);      % aggregate CPI (tradable + non-tradable)
C_N = zeros(nf, simnum);      % non-tradable consumption
G   = zeros(nf, simnum);      % tradable consumption

% exogenous foreign price tracker
pm  = zeros(nf, simnum);      % foreign input price level (same for all firms)


