% version: Sept. 2025

function [figs] = figures();

global alpha f_e f_v lambda mu nf r rho theta w ...
       p y P_X P_Z P_M pm Omega;

X = mu*p.*y.*theta./P_X;                                                   % firm quantity of intermediate input: use s^Y_X
impspend = (1-(P_Z./P_X).^(rho/(rho-1))).*P_X.*X;                          % import expenditure
numimps = sum((Omega(:,1)>0));                                             % importing firms pre-shock     
dimpspend_firm2 = impspend(:,2)*pm(1,1)/pm(1,2)-impspend(:,1);             % change in import expenditure, deflated use price index
subintensive_firm2 = impspend(:,2)*pm(1,1)/pm(1,2)...                      % Sub-intensive margin(within-variety spending change), 
    -Omega(:,2)./Omega(:,1).*impspend(:,1);                                

subintensive_firm2(isnan(subintensive_firm2)) = 0;                         % incase the firrm doesn't import before-shock

extensive_firm2 = -impspend(:,1).*(Omega(:,2)==0);                         % decline in import spending if the firm stop importing post_shock
subextensive_firm2 = dimpspend_firm2-subintensive_firm2-extensive_firm2;   % picks up changes due to net variety change that isn't full exit
subintshare_firm2 = subintensive_firm2./dimpspend_firm2;                   % share of within-variety change
subextshare_firm2 = subextensive_firm2./dimpspend_firm2;                   % share of variety change

gamma = (P_Z./P_X).^(rho/(rho-1));                                         % share of domestic expenditure to total expenditure

% GENERATE FIGURE 11A: firm size and adjustment during price shock
f11A = figure;
hlines1 = scatter(log(impspend(1:numimps,1)),impspend(1:numimps,2).*pm(1,1)./pm(1,2)./impspend(1:numimps,1)-1,'k','LineWidth',2.5);
xlabel('Log Initial Import Spending');
ylabel('Percent Change in Import Spending');

% GENERATE FIGURE 11B: firm size and reduction share of different margin 
f11B = figure;
hlines1 = plot(log(impspend(1:numimps,1)),subintshare_firm2(1:numimps),'k^','LineWidth',2.5);
hold on;
hlines2 = plot(log(impspend(1:numimps,1)),subextshare_firm2(1:numimps),'bo','LineWidth',2.5);
hold off;
set(hlines1,'Displayname','Share Due to Sub-Intensive Adjustment');
set(hlines2,'Displayname','Share Due to Sub-Extensive Adjustment');
legend('Location','Best')
xlabel('Log Initial Import Spending');
ylabel('Percent of Reduction in Imports');


VA = p.*y-P_X.*X;                                                          % value added          
K = alpha*(1-mu)*P_X.*X/mu/r;                                              % capital input   
Lp = (1-alpha)*(1-mu)*P_X.*X/mu/w;                                         % production labor
Lf = f_e*(Omega>0) + f_v*Omega.^lambda;                                    % fixed cost labor
L = Lp+Lf;                                                                 % total labor
sK = r*K./VA;                                                              % share of capital expenditure to value-added
sL = w*L./VA;                                                              % share of labor expenditure to value_added
dlnVA = (log(y(:,2)./y(:,1))-mu*theta*log(X(:,2)./X(:,1)))/(1-mu*theta);   % change in value-added
dlnV = sK(:,1).*log(K(:,2)./K(:,1))+sL(:,1).*log(L(:,2)./L(:,1));          % change in primary input
dlnPR = dlnVA-dlnV;                                                        % change in productivity, eq6

% GENERATE FIGURE 12: firm size and changes in gamma and productivity
f12 = figure;
hlines1 = plot(log(impspend(1:numimps,1)),gamma(1:numimps,2)./gamma(1:numimps,1)-1,'k^','LineWidth',2.5);
hold on;
hlines2 = plot(log(impspend(1:numimps,1)),dlnPR(1:numimps),'bo','LineWidth',2.5);
hold off;
set(hlines1,'Displayname','Share of Input Spending on Domestic Goods ({\gamma})');
set(hlines2,'Displayname','Productivity');
legend('Location','Best')
xlabel('Log Initial Import Spending');
ylabel('Percent Change');

figs = [f11A, f11B, f12];

end








