% Processing of data
% From a PSD generated with pspectrum
% The data is fitted with decaying function and consecutive gaussians
% Various gaussians are used to define the frequency peaks


% Load example PSD
example = readtable('example_PSD.csv');

% Fit the PSD
[aperiodic, periodic, rmse, resid] = fit_psd(example.freq,10*log10(example.PSD),4); %Chose a function to fit the PSD to

sprintf('The fitting has a RSME of %f', rmse)

% Generate figure of fitted PSD
f10 = figure;
subplot(2,3,[1 4]); plot(example.freq,10*log10(example.PSD),'LineWidth',1.5,'Color','k');
xlim([0 200]); xticks([0.1 1 5 10 50 200]); xtickangle(90)
set(gca,'xscale','log'); xlabel ('Frequency (Hz)'); ylabel('10log_{10}(PSD)')

subplot(2,3,2); plot(example.freq,10*log10(example.PSD),'LineWidth',1,'Color','k'); hold on
plot(example.freq,aperiodic(example.freq),'LineWidth',1,'Color',[0.4667    0.6745    0.1882])
xlim([0 200]); xticks([0.1 1 5 10 50 200]); xtickangle(90)
set(gca,'xscale','log'); xlabel ('Frequency (Hz)'); ylabel('10log_{10}(PSD)')

subplot(2,3,3); plot(example.freq,aperiodic(example.freq),'LineWidth',1.5,'Color',[0.4667    0.6745    0.1882])
xlim([0 200]); xticks([0.1 1 5 10 50 200]); xtickangle(90)
set(gca,'xscale','log'); xlabel ('Frequency (Hz)'); ylabel('10log_{10}(PSD), aperiodic')

subplot(2,3,5); plot(example.freq,resid,'LineWidth',1,'Color','k'); hold on
for ii = 1:length(periodic.amp)
    plot(example.freq,periodic.amp(ii).*exp(-(example.freq -periodic.freq(ii)).^2/(2*periodic.BW(ii)^2)),'LineWidth',0.5,'Color','b')
    hold on
end
xlim([0 200]); xticks([1 5 10 50 200]); xtickangle(90)
ylim([-0.5 10])
set(gca,'xscale','log');
xlabel ('Frequency (Hz)'); ylabel('10log_{10}(PSD)')

osc = 0; fitted = 0;
for i = 1:length(periodic.amp)
    osc = osc + periodic.amp(i).*exp(-(example.freq -periodic.freq(i)).^2/(2*periodic.BW(i)^2));
    fitted  = fitted + periodic.amp(i).*exp(-(example.freq-periodic.freq(i)).^2/(2*periodic.BW(i)^2));
    plot(example.freq,periodic.amp(i).*exp(-(example.freq-periodic.freq(i)).^2/(2*periodic.BW(i)^2)));
end
subplot(2,3,6); plot(example.freq,osc,'LineWidth',1.5,'Color','b')
xlim([0 200]); xticks([0.1 1 5 10 50 200]); xtickangle(90)
ylim([-0.5 10])
set(gca,'xscale','log'); xlabel ('Frequency (Hz)'); ylabel('10log_{10}(PSD), periodic')






