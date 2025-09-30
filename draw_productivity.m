function A = draw_productivity(nf, simnum, A_ln_sd, A_mu)
% Draw firm-level productivity from a lognormal distribution
% nf      : number of firms
% simnum  : number of simulations (pre/post shock)
% A_ln_sd : log standard deviation
% A_mu    : mean adjustment (ensures E[A]=1)

    % one draw per firm
    A_single = exp(A_mu + A_ln_sd * randn(nf,1));

    % replicate across simnum periods so A is constant over simulations
    A = repmat(A_single, 1, simnum);

end


