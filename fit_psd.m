function [aperiodic, periodic, rmse, resid] = fit_psd(f,psd_data,fitnum)


warning off
% decay fit functions
types_of_fits = {fittype( @(b, X, k, f) b - log10(k + f.^X), 'independent', {'f'}),% Lorenztian function
    fittype( @(b, X, f) b - log10( f.^X), 'independent', {'f'}), % Power law function
    fittype( @(b, X, X1,  f) b - X1.*f - log10(f.^X), 'independent', {'f'}), % Power law + exponential function
    fittype( @(b, X, X1, k,  f) b - X1.*f - log10(k + f.^X), 'independent', {'f'})}; % Lorenztian + exponential function

decay_fit = types_of_fits{fitnum};


% gaussian fit function
gauss_fit = fittype(@(B,mu,sigma,x) B.*exp(-(x-mu).^2/(2*sigma^2)));


data = psd_data;

% 1. Fit the data to the decay
if fitnum == 1
    fitobject = fit(f, data, decay_fit, 'Lower',[-Inf,0,1],'Upper',[Inf,Inf,9]);
elseif fitnum == 2
    fitobject = fit(f, data, decay_fit, 'Lower',[-Inf,0],'Upper',[Inf,Inf]);
elseif fitnum == 3
    fitobject = fit(f, data, decay_fit, 'Lower',[-Inf,0,0],'Upper',[Inf,Inf,Inf]);
elseif fitnum == 4
    fitobject = fit(f, data, decay_fit, 'Lower',[-Inf,0,0,0],'Upper',[Inf,Inf,Inf,9]);
end
% 2. Remove the decay to obtain the residual
resid = data-fitobject(f);


% 3. Fit gaussians to the residual
B =[]; mu = []; sigma = [];
for n_gauss =1:6

    
    if fitnum == 1
        decay_fitted = fit(f, data, decay_fit, 'weights',(resid<0)/2 + 0.5, 'Lower',[-Inf,0,1],'Upper',[Inf,Inf,9]);
    elseif fitnum == 2
        decay_fitted = fit(f, data, decay_fit, 'weights',(resid<0)/2 + 0.5, 'Lower',[-Inf,0],'Upper',[Inf,Inf]);
    elseif fitnum == 3
        decay_fitted = fit(f, data, decay_fit, 'weights',(resid<0)/2 + 0.5, 'Lower',[-Inf,0,0],'Upper',[Inf,Inf,Inf]);
    elseif fitnum == 4
        decay_fitted = fit(f, data, decay_fit, 'weights',(resid<0)/2 + 0.5, 'Lower',[-Inf,0,0,0],'Upper',[Inf,Inf,Inf,9]);
    end
    
    resid = data-decay_fitted(f);


    % iteratively eliminate gaussians
    [B0,idx] = max((resid));
    gauss_fitted = fit(f,resid,gauss_fit,...
        'start',[B0, f(idx), f(idx)/10],...
        'Weights',B0.*exp(-(f-f(idx)).^2/(2* (f(idx)/8)^2)),'Lower',[0 f(1) 0]);


    data = data - gauss_fitted(f);
    resid = data- decay_fitted(f);

    B(n_gauss) = gauss_fitted.B;
    mu(n_gauss) = gauss_fitted.mu;
    sigma(n_gauss) = gauss_fitted.sigma;
end


% 4. Clean data from gaussians, to obtain a more precise fitting
data = psd_data;
for i = 1:length(B)
    data = data - B(i).*exp(-(f-mu(i)).^2/(2*sigma(i)^2));
end
if fitnum == 1
    aperiodic = fit(f, data, decay_fit, 'Lower',[-Inf,0,1]);
elseif fitnum == 2
    aperiodic = fit(f, data, decay_fit, 'Lower',[-Inf,0]);
elseif fitnum == 3
    aperiodic = fit(f, data, decay_fit, 'Lower',[-Inf,0,0]);
elseif fitnum == 4
    aperiodic = fit(f, data, decay_fit, 'Lower',[-Inf,0,0,0]);
end
fitted = aperiodic(f);
resid = psd_data-fitted;


% 5. Fit to the obtained resid the gaussians
B =[]; mu = []; sigma = [];
for g_i = 1:n_gauss
    [B0,idx] = max((resid));
    gauss_fitted = fit(f, resid, gauss_fit,...
        'start',[B0, f(idx), f(idx)/10],...
        'Weights',B0.*exp(-(f -f(idx)).^2/(2* (f(idx)/8)^2)),...
        'Lower',[0 f(1) 0]);

    B(g_i) = gauss_fitted.B;
    mu(g_i) = gauss_fitted.mu;
    sigma(g_i) = gauss_fitted.sigma;
    resid = resid - gauss_fitted(f);

end

% 6. Organize the periodic gaussians
params = sortrows([mu(:),B(:),sigma(:)]);
periodic.amp = params(:,2)';
periodic.freq = params(:,1)';
periodic.BW = params(:,3)';


rmse = sqrt(mean((psd_data - fitted).^2));

resid = psd_data-aperiodic(f);
warning on
end