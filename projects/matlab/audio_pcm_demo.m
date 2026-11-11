% Synthetic audio demonstration inspired by INTEC coursework, 2017.
fs = 8000;
n = fs;
t = (0:n-1)' / fs;
x = 0.65*sin(2*pi*440*t) + 0.28*sin(2*pi*2600*t);

% Second-order Butterworth low-pass via a prewarped bilinear transform.
fc = 1500;
k = tan(pi*fc/fs);
g = 1/(1 + sqrt(2)*k + k^2);
b = g*k^2*[1 2 1];
a = [1, 2*g*(k^2-1), g*(1-sqrt(2)*k+k^2)];
y = filter(b, a, x);

% Uniform mid-rise PCM over [-1, 1], with saturated code indices.
levels = 2^8;
step = 2/levels;
codes = min(max(floor((y+1)/step), 0), levels-1);
q = -1 + (codes+0.5)*step;
q_error = y-q;

x_fft = abs(fft(x))/n;
y_fft = abs(fft(y))/n;
ratio_low = y_fft(441)/x_fft(441);
ratio_high = y_fft(2601)/x_fft(2601);
assert(max(abs(y)) < 1, 'Filtered signal clipped.');
assert(ratio_low > 0.95, 'Low-frequency component was attenuated too much.');
assert(ratio_high < 0.2, 'High-frequency component was not sufficiently attenuated.');
assert(all(codes >= 0 & codes < levels), 'PCM code out of range.');
assert(max(abs(q_error)) <= step/2 + 1e-12, 'Unexpected quantization error.');
fprintf('440 Hz gain: %.2f dB | 2600 Hz gain: %.2f dB | RMS error: %.6f\n', ...
    20*log10(ratio_low), 20*log10(ratio_high), sqrt(mean(q_error.^2)));

if ~strcmp(getenv('PORTFOLIO_HEADLESS'), '1')
    samples = 1:160;
    bins = 1:(n/2+1);
    f = (bins-1)*fs/n;
    figure;
    subplot(3,1,1);
    plot(t(samples), x(samples), t(samples), y(samples), t(samples), q(samples));
    xlabel('Time (s)'); ylabel('Amplitude');
    legend('Input', 'Filtered', 'PCM reconstruction'); grid on;
    subplot(3,1,2);
    plot(f, x_fft(bins), f, y_fft(bins));
    xlabel('Frequency (Hz)'); ylabel('FFT magnitude');
    legend('Input', 'Filtered'); grid on;
    subplot(3,1,3);
    plot(t(samples), q_error(samples));
    xlabel('Time (s)'); ylabel('Quantization error'); grid on;
end
