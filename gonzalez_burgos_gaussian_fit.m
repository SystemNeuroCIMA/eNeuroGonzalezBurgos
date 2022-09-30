% Load parameters of the fitted gaussians
% Adjust Kernel Density Estimate (KDE)

% load csv with the parameters
example = readtable('example_gaussian_fit.csv');

% use the log of the frequency
values = log10(example.freq);

% Parameter for the KDE
kernel_name = 'normal';
N = 100;
fmin = 0.1;
fmax = 190;
width = 0.05;
log_freq = linspace(log10(fmin),log10(fmax),N);
lin_freq = 10.^(log_freq);

% 1. Kernel fit of the gaussians
pd = fitdist(values,'Kernel','Kernel',kernel_name,'Width',width);
y = pdf(pd,log_freq);

% 2. Find the inflextion points of the resulting KDE that will delimite the
% frequency bands
d1y = gradient(y,lin_freq);      % first derivative
d2y = gradient(-d1y,lin_freq);   %second derivative
ind = find(diff(sign(diff(d2y))) == 2) + 1;

p = lin_freq(ind);
lims = p(6:11);


% Generate figure
f5 = figure; f5.Units = 'centimeters'; f5.Position = [0 15 19 12];
plot(lin_freq,y*4,'color',[0.5 0.5 0.5],'LineWidth',0.05)
hold on

set(gca,'XScale','log','ylim',[0 17],'xlim',[1 190],'FontSize', 8)
xlabel('Frequency (Hz)'); ylabel('Amplitude');
xticks([5 10 20 40 70 100 150]); xtickangle(90)
grid on

xline(lims)

for i=1:height(example)
    if example.freq(i) < lims(1)
        plot(example.freq(i),example.amp(i),'.','color',[0.9294    0.6941    0.1255],'MarkerSize',12)
    elseif example.freq(i) > lims(1) && example.freq(i) < lims(2)
        plot(example.freq(i),example.amp(i),'g.','MarkerSize',12)
    elseif example.freq(i) > lims(2) && example.freq(i) < lims(3)
        plot(example.freq(i),example.amp(i),'b.','MarkerSize',12)
    elseif example.freq(i) > lims(3) && example.freq(i) < lims(4)
        plot(example.freq(i),example.amp(i),'r.','MarkerSize',12)
    elseif example.freq(i) > lims(4) && example.freq(i) < lims(5)
        plot(example.freq(i),example.amp(i),'m.','MarkerSize',12)
    elseif example.freq(i) > lims(5) && example.freq(i) < lims(6)
        plot(example.freq(i),example.amp(i),'c.','MarkerSize',12)
    elseif example.freq(i) > lims(6)
        plot(example.freq(i),example.amp(i),'.','color',[0.6350 0.0780 0.1840],'MarkerSize',12)
    end
end