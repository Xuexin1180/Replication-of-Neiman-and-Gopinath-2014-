% version: Sept. 2025

function [out1] = profits_noimp(P_Z,A_i,y0,p0)

global tr_weight theta sigma epsilon alpha mu rho eta beta lambda w r C
global h

P_X_i = P_Z;
p1 = epsilon/(epsilon-1)*h*P_X_i^mu/A_i;
y1 = y0*(p1/p0)^(1/(sigma-1));
profit_i = (p1-h*P_X_i^mu/A_i).*y1;

out1 = - profit_i;
end
