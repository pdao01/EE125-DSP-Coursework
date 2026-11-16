clear
clc

t = -2:0.05:2;
t_conv = -0.5:0.1:1.5;
tn = [0, 0.5, 1];
T = 0.5;
x = [1, 3, -1.5];
xe = [1, 0, 0, 0, 0, 3, 0, 0, 0, 0, -1.5];
h = [0, 0.2, 0.4, 0.6, 0.8, 1.0, 0.8, 0.6, 0.4, 0.2, 0];
y_conv = conv(xe, h);

function y = sincInterp(x, T, t)
    y = zeros(size(t));
    for n = 0:length(x)-1
        for k = 1:length(t)
            u = (t(k)-n*T)/T;
            if u == 0
                sinc_val = 1;
            else
                sinc_val = sin(pi * u)/(pi * u);
            end
            y(k) = y(k) + x(n+1) * sinc_val;
        end
    end
end

h = sincInterp(1, T, t);

figure;
stem(t, h, 'filled');
xlabel('Time (s)');
ylabel('h(t)');
title('Sinc Interpolation of an Impulse');
grid on;

y_sinc = sincInterp(x, T, t);

figure;
hold on;
plot(tn, x, '-o', 'MarkerFaceColor', 'k');
plot(t_conv, y_conv, '-');
plot(t, y_sinc);
hold off;
grid on;
xlabel('Time (s)');
ylabel('Amplitude');
title('Comparing three signals');
legend('Original samples', 'Linear interp', 'Sinc interp', 'Location', 'southoutside');