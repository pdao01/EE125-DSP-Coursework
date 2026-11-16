clear
clc

load('NerveData_Project3.mat');

whos 

Fs = 10000; 

t = linspace(0,12,120);
cleanSnap_uV = cleanSnap_uV(:);
contamSnapBaseline_uV = contamSnapBaseline_uV(:);
contamSnapPowerline_uV = contamSnapPowerline_uV(:);


%QUESTION 1:
figure;
plot(t, cleanSnap_uV, "blue")
grid on;
xlabel('Time (ms)')
ylabel('Amplitude')
title('Graph of 3 SNAP signals, measured in microvolts (μV)')
hold on;
plot(t, contamSnapBaseline_uV);
plot(t, contamSnapPowerline_uV, "red");
legend('Clean signal', 'Baseline contamination', 'Powerline contamination');


%QUESTION 2:
figure();
[H1,F] = freqz(cleanSnap_uV,1,512,Fs);
[H2,~] = freqz(contamSnapBaseline_uV,1,512,Fs);
[H3,~] = freqz(contamSnapPowerline_uV,1,512,Fs);
Pall = 20*log10(abs([H1 H2 H3]));
semilogx(F,Pall);
axis([10, 1000, 10, 80]);
grid on;
legend('Clean','PowerLine Corrupted','Baseline Corrupted')
xlabel('Frequency (Hz)'); ylabel('dB');
title('SNAP Signals in Frequency Domain')


%Question 3:
function [ampl,latency,amax,amin,tmin]=analyzeSNAP(x,Fs)
    [amax, iMax] = max(x);
    [amin, iMin] = min(x);
    ampl = amax - amin;
    latency = (iMax - 1) / Fs * 1000;
    tmin = (iMin - 1) / Fs * 1000;
end


%Question 4:
figure;
plot(t, cleanSnap_uV, "blue")
grid on;
xlabel('Time (ms)')
ylabel('Amplitude')

[ampl, latency, amax, amin, tmin] = analyzeSNAP(cleanSnap_uV, Fs);
hold on;
plot(latency, amax, 'ko', 'MarkerFaceColor', 'g');
plot(tmin, amin, 'ko', 'MarkerFaceColor', 'r');
plot([latency latency], [amin amax], 'k--');
title('Graph for Clean SNAP Signal with Amplitude and Latency annotated')
legend('Clean signal', 'Maximum', 'Minimum');

legend('Clean signal', 'Maximum', 'Minimum', 'Peak-to-peak amplitude');

text(latency, amax, sprintf(' Max = %.2f \\muV', amax), ...
    'VerticalAlignment', 'bottom');
text(tmin, amin, sprintf(' Min = %.2f \\muV', amin), ...
    'VerticalAlignment', 'top');

text(0.65, 0.10, ...
    sprintf('Amplitude = %.2f \\muV\nLatency = %.2f ms', ampl, latency), ...
    'Units', 'normalized', ...
    'VerticalAlignment', 'bottom', ...
    'HorizontalAlignment','left',...
    'BackgroundColor', 'white', ...
    'EdgeColor', 'black');


fprintf('Amplitude: %.2f uV\nLatency: %.2f ms\n', ampl, latency);
fprintf('Maximum: %.2f uV\nMinimum: %.2f uV\nMinimum time: %.2f ms\n', ...
    amax, amin, tmin);

hold off;

%Question 5:
[b_iir,a_iir] = butter(6,100/(Fs/2),'high');
[H_iir,F_iir] = freqz(b_iir,a_iir,2048,Fs);
[gd,F_gd] = grpdelay(b_iir,a_iir,2048,Fs);
magH = 20*log10(abs(H_iir));
%a is poles, b is zeros
figure;
yyaxis left
semilogx(F_iir,magH);
ylabel('Magnitude (dB)');

yyaxis right
semilogx(F_gd,gd);
ylabel('Group delay (samples)');

grid on;
xlim([10 1000]);
xlabel('Frequency (Hz)');
title('IIR Highpass Filter Magnitude Response and Group Delay');
legend('Magnitude Response', 'Group Delay');


%Question 6:
b_fir = fir1(52,100/(Fs/2),'high');
a_fir = 1;

[H_fir,F_fir] = freqz(b_fir,a_fir,2048,Fs);
[gd,F_gd] = grpdelay(b_fir,a_fir,2048,Fs);
magH = 20*log10(abs(H_fir));

figure;
yyaxis left
semilogx(F_fir,magH);
ylabel('Magnitude (dB)');

yyaxis right
semilogx(F_gd,gd);
ylabel('Group delay (samples)');

grid on;
xlim([10 1000]);
xlabel('Frequency (Hz)');
title('IIR Highpass Filter Magnitude Response and Group Delay');
legend('Magnitude Response', 'Group Delay');


% QUESTION 8: 
fir_filtered = filter(b_fir,a_fir,cleanSnap_uV);
iir_filtered = filter(b_iir, a_iir, cleanSnap_uV);

[ampl_clean, latency_clean, amax_clean, amin_clean, tmin_clean] = analyzeSNAP(cleanSnap_uV, Fs);
[ampl_fir, latency_fir, amax_fir, amin_fir, tmin_fir] = analyzeSNAP(fir_filtered, Fs);
[ampl_iir, latency_iir, amax_iir, amin_iir, tmin_iir] = analyzeSNAP(iir_filtered, Fs);

fprintf('\nOriginal clean SNAP:\n');
fprintf('Amplitude = %.2f uV, Latency = %.2f ms\n', ampl_clean, latency_clean);

fprintf('\nFIR-filtered SNAP:\n');
fprintf('Amplitude = %.2f uV, Latency = %.2f ms\n', ampl_fir, latency_fir);

fprintf('\nIIR-filtered SNAP:\n');
fprintf('Amplitude = %.2f uV, Latency = %.2f ms\n', ampl_iir, latency_iir);

fprintf('\nFIR observed latency shift = %.2f ms\n', latency_fir - latency_clean);

fprintf('IIR observed latency shift = %.2f ms\n', latency_iir - latency_clean);

figure;
plot(t, cleanSnap_uV, 'k', 'DisplayName', 'Original signal');
hold on;
plot(t, fir_filtered, 'b', 'DisplayName', 'FIR filtered');
plot(t, iir_filtered, 'r', 'DisplayName', 'IIR filtered');

plot(latency_fir, amax_fir, 'ko', 'MarkerFaceColor', 'g');
plot(tmin_fir, amin_fir, 'ko', 'MarkerFaceColor', 'r');
plot([latency_fir latency_fir], [amin_fir amax_fir], 'k--');

plot(latency_iir, amax_iir, 'ko', 'MarkerFaceColor', 'g');
plot(tmin_iir, amin_iir, 'ko', 'MarkerFaceColor', 'r');
plot([latency_iir latency_iir], [amin_iir amax_iir], 'k--');

legend('Original signal', 'FIR filtered', 'IIR filtered');

info = sprintf(['Original: Amp = %.2f uV, Latency = %.2f ms\n' ...
    'IIR: Amp = %.2f uV, Latency = %.2f ms\n' ...
    'FIR: Amp = %.2f uV, Latency = %.2f ms'], ...
    ampl_clean, latency_clean, ...
    ampl_iir, latency_iir, ...
    ampl_fir, latency_fir);

text(0.55, 0.1, info, 'Units', 'normalized', ...
    'VerticalAlignment', 'top', ...
    'BackgroundColor', 'white', ...
    'EdgeColor', 'black', ...
    'FontSize', 9);

hold off;


%Question 9:
contamSnapBaseline_IIR = filter(b_iir, a_iir,contamSnapBaseline_uV);
contamSnapPowerline_IIR = filter(b_iir, a_iir, contamSnapPowerline_uV);
contamSnapBaseline_FIR = filter(b_fir, a_fir, contamSnapBaseline_uV);
contamSnapPowerline_FIR = filter(b_fir, a_fir, contamSnapPowerline_uV);

[ampl_base_iir, latency_base_iir, amax_base_iir, amin_base_iir, tmin_base_iir] = analyzeSNAP(contamSnapBaseline_IIR, Fs);
[ampl_power_iir, latency_power_iir, amax_power_iir, amin_power_iir, tmin_power_iir] = analyzeSNAP(contamSnapPowerline_IIR, Fs);
[ampl_base_fir, latency_base_fir, amax_base_fir, amin_base_fir, tmin_base_fir] = analyzeSNAP(contamSnapBaseline_FIR, Fs);
[ampl_power_fir, latency_power_fir, amax_power_fir, amin_power_fir, tmin_power_fir] = analyzeSNAP(contamSnapPowerline_FIR, Fs);

fprintf('\nIIR-filtered Contaminated Baseline SNAP:\n');
fprintf('Amplitude = %.2f uV, Latency = %.2f ms\n', ampl_base_iir, latency_base_iir);

fprintf('\nIIR-filtered Contaminated Powerline SNAP:\n');
fprintf('Amplitude = %.2f uV, Latency = %.2f ms\n', ampl_power_iir, latency_power_iir);

fprintf('\nFIR-filtered Contaminated Baseline SNAP:\n');
fprintf('Amplitude = %.2f uV, Latency = %.2f ms\n', ampl_base_fir, latency_base_fir);

fprintf('\nFIR-filtered Contaminated Powerline SNAP:\n');
fprintf('Amplitude = %.2f uV, Latency = %.2f ms\n', ampl_power_fir, latency_power_fir);

figure;
subplot(2,2,1)
plot(t, contamSnapBaseline_IIR);
hold on;
plot(t,contamSnapBaseline_uV);
hold off;
title('Baseline Contamination: IIR Filtering');
xlabel('Time (ms)');
ylabel('Amplitude (\muV)');
legend('IIR filtered','Original','Location','southeast');
grid on;

subplot(2,2,2)
plot(t, contamSnapPowerline_IIR);
hold on;
plot(t, contamSnapPowerline_uV);
hold off;
title('Powerline Contamination: IIR Filtering');
xlabel('Time (ms)');
ylabel('Amplitude (\muV)');
legend('IIR filtered','Original','Location','northeast');
grid on;

subplot(2,2,3)
plot(t, contamSnapBaseline_FIR);
hold on;
plot(t, contamSnapBaseline_uV);
hold off;
title('Baseline Contamination: FIR Filtering');
xlabel('Time (ms)');
ylabel('Amplitude (\muV)');
legend('FIR filtered','Original','Location','southeast');
grid on;

subplot(2,2,4)
plot(t, contamSnapPowerline_FIR);
hold on;
plot(t, contamSnapPowerline_uV);
hold off;
title('Powerline Contamination: FIR Filtering');
xlabel('Time (ms)');
ylabel('Amplitude (\muV)');
legend('FIR filtered','Original','Location','northeast');
grid on;


%Question 10:
baselineSnap = contamSnapBaseline_uV - contamSnapBaseline_uV(1);
powerlineSnap = contamSnapPowerline_uV - contamSnapPowerline_uV(1);

baselineSnap_IIR = filter(b_iir, a_iir,baselineSnap);
powerlineSnap_IIR = filter(b_iir, a_iir, powerlineSnap);
baselineSnap_FIR = filter(b_fir, a_fir,baselineSnap);
powerlineSnap_FIR = filter(b_fir, a_fir, powerlineSnap);

[ampl_base_iir, latency_base_iir, amax_base_iir, amin_base_iir, tmin_base_iir] = analyzeSNAP(baselineSnap_IIR, Fs);
[ampl_power_iir, latency_power_iir, amax_power_iir, amin_power_iir, tmin_power_iir] = analyzeSNAP(powerlineSnap_IIR, Fs);
[ampl_base_fir, latency_base_fir, amax_base_fir, amin_base_fir, tmin_base_fir] = analyzeSNAP(baselineSnap_FIR, Fs);
[ampl_power_fir, latency_power_fir, amax_power_fir, amin_power_fir, tmin_power_fir] = analyzeSNAP(powerlineSnap_FIR, Fs);

fprintf('\nIIR-filtered Contaminated Baseline SNAP:\n');
fprintf('Amplitude = %.2f uV, Latency = %.2f ms\n', ampl_base_iir, latency_base_iir);

fprintf('\nIIR-filtered Contaminated Powerline SNAP:\n');
fprintf('Amplitude = %.2f uV, Latency = %.2f ms\n', ampl_power_iir, latency_power_iir);

fprintf('\nFIR-filtered Contaminated Baseline SNAP:\n');
fprintf('Amplitude = %.2f uV, Latency = %.2f ms\n', ampl_base_fir, latency_base_fir);

fprintf('\nFIR-filtered Contaminated Powerline SNAP:\n');
fprintf('Amplitude = %.2f uV, Latency = %.2f ms\n', ampl_power_fir, latency_power_fir);

figure;
subplot(2,2,1)
plot(t, baselineSnap_IIR);
hold on;
plot(t,baselineSnap);
hold off;
title('Baseline Contamination: IIR Filtering');
xlabel('Time (ms)');
ylabel('Amplitude (\muV)');
legend('IIR filtered','Baseline Removed','Location','best');
grid on;

subplot(2,2,2)
plot(t, powerlineSnap_IIR);
hold on;
plot(t, powerlineSnap);
hold off;
title('Powerline Contamination: IIR Filtering');
xlabel('Time (ms)');
ylabel('Amplitude (\muV)');
legend('IIR filtered','Baseline Removed','Location','best');
grid on;

subplot(2,2,3)
plot(t, baselineSnap_FIR);
hold on;
plot(t, baselineSnap);
hold off;
title('Baseline Contamination: FIR Filtering');
xlabel('Time (ms)');
ylabel('Amplitude (\muV)');
legend('FIR filtered','Baseline Removed','Location','best');
grid on;

subplot(2,2,4)
plot(t, powerlineSnap_FIR);
hold on;
plot(t, powerlineSnap);
hold off;
title('Powerline Contamination: FIR Filtering');
xlabel('Time (ms)');
ylabel('Amplitude (\muV)');
legend('FIR filtered','Baseline Removed','Location','best');
grid on;


%Question 11:
filtfiltBaseline = filtfilt(b_iir, a_iir,contamSnapBaseline_uV);
filtfiltPowerline = filtfilt(b_iir, a_iir, contamSnapPowerline_uV);

[ampl_clean, latency_clean, amax_clean, amin_clean, tmin_clean] = analyzeSNAP(cleanSnap_uV, Fs);
[ampl_base, latency_base, amax_base, amin_base, tmin_base] = analyzeSNAP(filtfiltBaseline, Fs);
[ampl_power, latency_power, amax_power, amin_power, tmin_power] = analyzeSNAP(filtfiltPowerline, Fs);

fprintf('\nOriginal clean SNAP:\n');
fprintf('Amplitude = %.2f uV, Latency = %.2f ms\n', ampl_clean, latency_clean);

fprintf('\nIIR-filtfilt Contaminated Baseline SNAP:\n');
fprintf('Amplitude = %.2f uV, Latency = %.2f ms\n', ampl_base, latency_base);

fprintf('\nIIR-filtfilt Contaminated Powerline SNAP:\n');
fprintf('Amplitude = %.2f uV, Latency = %.2f ms\n', ampl_power, latency_power);

figure;
plot(t, cleanSnap_uV, 'k', 'DisplayName', 'Original signal');
hold on;
plot(t, filtfiltBaseline, 'b', 'DisplayName', 'filtfilt Baseline IIR filtered');
plot(t, filtfiltPowerline, 'r', 'DisplayName', 'filtfilt Powerline IIR filtered');

plot(latency_base, amax_base, 'ko', 'MarkerFaceColor', 'g');
plot(tmin_base, amin_base, 'ko', 'MarkerFaceColor', 'r');
plot([latency_base latency_base], [amin_base amax_base], 'k--');

plot(latency_power, amax_power, 'ko', 'MarkerFaceColor', 'g');
plot(tmin_power, amin_power, 'ko', 'MarkerFaceColor', 'r');
plot([latency_power latency_power], [amin_power amax_power], 'k--');

grid on;
xlabel('Time (ms)');
ylabel('Amplitude (\muV)');
title('SNAP Signals After Forward-Backward IIR Filtering');
legend('Original clean reference', ...
       'Baseline contamination: filtfilt', ...
       'Powerline contamination: filtfilt', ...
       'Location', 'best');

info = sprintf(['Original: Amp = %.2f uV, Latency = %.2f ms\n' ...
    'IIR: Amp = %.2f uV, Latency = %.2f ms\n' ...
    'FIR: Amp = %.2f uV, Latency = %.2f ms'], ...
    ampl_clean, latency_clean, ...
    ampl_base, latency_base, ...
    ampl_power, latency_power);

text(0.50, 0.3, info, 'Units', 'normalized', ...
    'VerticalAlignment', 'top', ...
    'BackgroundColor', 'white', ...
    'EdgeColor', 'black', ...
    'FontSize', 9);

hold off;