function SimFunction(pm_scale, state)

global tr_weight theta sigma epsilon alpha mu rho eta beta lambda w r C ...
       h P_N init_pm tol1 tol2 maxiter1 maxiter2 omega_max kappa
global nf simnum
global A Omega p y g z gamma P_X P_M P_Z P_G P C_N G pm

%get the single column, will write back at the end
A_state     = A(:,state);
p_state     = p(:,state);
omega_state = Omega(:, state);

P_v = alpha^-alpha*(1-alpha)^-(1-alpha)*r^alpha*w^(1-alpha);        
h   = mu^-mu*(1-mu)^-(1-mu)*P_v^(1-mu);                               
pm_state   = pm_scale * init_pm;                                        
P_Z_state  = sum(p_state.^(theta/(theta-1)))^((theta-1)/theta);         

omegachange = 1e8;                                                  
it_num1=0;  
while (omegachange > tol1 && it_num1 < maxiter1)
    it_num1 = it_num1 + 1;

    P_M_state = pm_state*omega_state.^((theta-1)/theta);                              
    P_X_state = (P_Z_state.^(rho/(rho-1))+(P_M_state).^(rho/(rho-1))).^((rho-1)/rho); 

    %% INNER LOOP: find optimal selling price, given variety choice
    it_num2 = 0;
    it_err1 = 1e8;
    while (it_err1 > tol2 && it_num2 < maxiter2)
        it_num2 = it_num2 + 1;

        p_new_state  = epsilon/(epsilon-1)*h*P_X_state.^mu./A_state;                             
        P_Z_new_state= sum(p_new_state.^(theta/(theta-1))).^((theta-1)/theta);             
        P_X_new_state= (P_Z_new_state.^(rho/(rho-1))+(P_M_state).^(rho/(rho-1))).^((rho-1)/rho); 
        P_Z_state    = P_Z_new_state;
        P_X_state    = P_X_new_state;

        it_err1 = max(abs(log(p_new_state./p_state)));                                     

        p_state = p_new_state;
    end

    p_state   = p_new_state;
    P_G_state = sum(p_state.^(sigma/(sigma-1)))^((sigma-1)/sigma);                           
    P_state   = (tr_weight^(1/(1-eta))*P_G_state^(eta/(eta-1))+(1-tr_weight)^(1/(1-eta))* ...
        P_N^(eta/(eta-1)))^((eta-1)/eta);                                        
    G_state   = (P_G_state/(tr_weight*P_state))^(-1/(1-eta))*C;                                      
    g_state   = (p_state/P_G_state).^(1/(sigma-1))*G_state;                                                
    gamma_state = (P_Z_state./P_X_state).^(rho/(rho-1)); 

    %% no roundabout production

    y_state = g_state;

    %% OUTER LOOP: find the optimal import scope
    omega_new = omega_state;
    for i = 1:nf
        if mod(100*i/nf,75)==0
            fprintf('.')
        end
        [omega_imp,negprof_imp] = fminbnd(@(omega_i)profits_imp(omega_i,pm_state,P_Z_state,A_state(i),y_state(i),p_state(i)),0,omega_max);
        negprof_noimp = profits_noimp(P_Z_state,A_state(i),y_state(i),p_state(i));
        if negprof_imp < negprof_noimp
            omega_new(i,1) = omega_imp;
        else
            omega_new(i,1) = 0;
        end
    end
    omegachange = max(abs(omega_new-omega_state));
    omega_state = omega_new;    
end

if it_num1==maxiter1 
    display('ERROR, NOT CONVERGING!')
    display('Press Control-C to Break Program and Start Again')
    pause;
end

C_N_state = (P_N/((1-tr_weight)*P_state))^-(1/(1-eta))*C;
z_state = 123456789*ones(size(y_state-g_state));                                                                            
 


% write back to data structure
% firm
A(:,state)      = A_state;
Omega(:, state) = omega_state;
p(:,state)      = p_state;
P_X(:,state)    = P_X_state;
g(:, state)     = g_state;
y(:, state)     = y_state;
z(:, state)     = z_state;
P_M(:,state)    = P_M_state;

% aggregate
P_Z(:,state)    = ones(nf,1)*P_Z_state;
P_G(:,state)    = ones(nf,1)*P_G_state;
P(:,state)      = ones(nf,1)*P_state;
C_N(:,state)    = ones(nf,1)*C_N_state;
G(:,state)      = ones(nf,1)*G_state;

% foreign price
pm(:,state)     = ones(nf,1)*pm_state;

end
