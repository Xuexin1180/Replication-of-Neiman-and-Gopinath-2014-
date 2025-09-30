function [out1] = profits_imp(omega_i, pm_state, P_Z, A_i, y0, p0)

global tr_weight theta sigma epsilon alpha mu rho eta beta lambda w r C
global h f_v f_e

P_M_i = pm_state*omega_i^((theta-1)/theta);
P_X_i = (P_Z^(rho/(rho-1))+(P_M_i)^(rho/(rho-1)))^((rho-1)/rho);
p1 = epsilon/(epsilon-1)*h*P_X_i^mu/A_i;
y1 = y0*(p1/p0)^(1/(sigma-1));
profit_i = (p1-h*P_X_i^mu/A_i).*y1 - w*f_e - w*f_v*omega_i^lambda;

out1 = - profit_i;
end
