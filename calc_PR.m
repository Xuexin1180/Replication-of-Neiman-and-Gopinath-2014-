% version: Sept. 2025

function [dlnPR,Feenstra,dlnPRtilde] = calc_PR()

global alpha f_e f_v lambda mu nf r rho theta w ...
       p y P_X P_Z P_M pm Omega;

% necessary variables
X = mu*p.*y.*theta./P_X;                                                   % firm quantity of intermediate input: use s^Y_X
VA = p.*y-P_X.*X;                                                          % firm value added: revenue - value of intermediate input
K = alpha*(1-mu)*P_X.*X/mu/r;                                              % firm capital input: from firm foc
Lp = (1-alpha)*(1-mu)*P_X.*X/mu/w;                                         % firm production labor: from firm foc
Lf = f_e*(Omega > 0) + f_v*Omega.^lambda;                                  % firm labor for fixed cost of importing: exporting and importing varieties
L = Lp+Lf;                                                                 % firm total labor input
sK = r*K./VA;                                                              % capital expenditure share in value-added
sL = w*L./VA;                                                              % labor expenditure share in value-added
gamma = (P_Z./P_X).^(rho/(rho-1));                                         % domestic expenditure to total intermediate expenditure
omega = VA./(repmat(sum(VA),nf,1));                                        % firm share of value-added to total manufacturing value-added
dlnVA = (log(y(:,2)./y(:,1))-mu*theta*log(X(:,2)./X(:,1)))/(1-mu*theta);   % firm value-added growth: section IV A
dlnV = sK(:,1).*log(K(:,2)./K(:,1))+sL(:,1).*log(L(:,2)./L(:,1));          % firm primary input grwoth: under eq(8)
onemgamma = ones(nf,2)-gamma;                                              % 1-\gamma: foreign expenditure to total intermediate expenditure
trwt = onemgamma.*P_X.*X ./ repmat(sum(onemgamma.*P_X.*X),nf,1);           % trade weights (firm's imported input share in total imported expenditure).

% for mismeasured productivity
PXtilde = [P_X(:,1) (P_Z(:,2).^(rho/(rho-1))+ ...                          % mismeasured price index: dont account for the variety change
    (P_M(:,1).*pm(:,2)./pm(:,1)).^(rho/(rho-1))).^((rho-1)/rho)];
PXtilderatio = P_X./PXtilde;                                               % capture the relative correlation
dlnPXtildeterm = log(PXtilderatio(:,2)./PXtilderatio(:,1));                % change in mismeasured price index


% Feenstra (1994): captures the "variety effect" on the import price index.
Feenstra_firm = (theta-1)/theta*log(Omega(:,2)./Omega(:,1));               % firm-level Feenstra residual (variety effect)
Feenstra = sum(trwt(:,1).*Feenstra_firm);                                  % weighted aggregate of Feenstra residual

% aggergate productivity
dlnPR = sum(omega(:,1).*(dlnVA-dlnV));
dlnPRtilde = dlnPR-mu/(1-mu)*(1-theta)/(1-mu*theta)*sum(omega(:,1).*dlnPXtildeterm);

end