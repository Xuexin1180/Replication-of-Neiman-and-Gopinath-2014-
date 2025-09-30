function [figs] = figures();

global alpha f_e f_v lambda mu nf r rho theta w ...
       p y P_X P_Z P_M pm Omega;

X = mu*p.*y.*theta./P_X;                                                   % firm quantity of intermediate input: use s^Y_X
impspend = (1-(P_Z./P_X).^(rho/(rho-1))).*P_X.*X;                          % import expenditure
numimps = sum((Omega(:,1)>0));                                             % importing firms pre-shock     
dimpspend_firm2 = impspend(:,2)*pm(1,1)/pm(1,2)-impspend(:,1);             % change in import expenditure, deflated use price index
subintensive_firm2 = impspend(:,2)*pm(1,1)/pm(1,2)...                      % Sub-intensive margin(within-variety spending change)
    -Omega(:,2)./Omega(:,1).*impspend(:,1);                                

k = find(isnan(subintensive_firm2));                                       % deal with nan
subintensive_firm2(k) = 0; 

extensive_firm2 = -impspend(:,1).*[imported(:,2)==0];
subextensive_firm2 = dimpspend_firm2-subintensive_firm2-extensive_firm2;
subintshare_firm2 = subintensive_firm2./dimpspend_firm2;
subextshare_firm2 = subextensive_firm2./dimpspend_firm2;
gamma = (P_Z./P_X).^(rho/(rho-1));
