#!/usr/bin/env octave-cli

data = [
%                      Total      Avail.
%   Machine Cores GHz  RAM_GB SSD RAM_GB Image_s SDK_s
    1       4     3.0  16     0   10     14315   6784
    2       4     2.0  16     1   14     15404   10638
    3.1     4     2.2  8      1   7.2    15133   10079
    3.2     4     2.2  8      0   7.2    15735   10613
    4       4     1.6  8      0   7.2    16002   10662
];

cores = data(:,2);
ghz = data(:,3);
total_ram = data(:,4);
ssd = data(:,5);
avail_ram = data(:,6);
time_image = data(:,7) / 3600;
time_sdk = data(:,8) / 3600;

core_ghz = cores .* ghz;
ram = total_ram;
time = time_image + time_sdk;

figure(1),clf
hold on

stem3(core_ghz, ram, time, 'o')
xlabel('Cores \times GHz')
ylabel('RAM [GB]')
zlabel('Build time [h]')
grid on
az = 180 - 37.5;
el = 30;
view(az, el)

% Best plane fit to the points
% https://www.mathworks.com/matlabcentral/answers/448708-plane-fitting-a-3d-scatter-plot
x = core_ghz;
y = ram;
z = time;
B = [x(:) y(:) ones(size(x(:)))] \ z(:);
xv = linspace(min(x), max(x), 5)';
yv = linspace(min(y), max(y), 5)';
[X,Y] = meshgrid(xv, yv);
Z = reshape([X(:), Y(:), ones(size(X(:)))] * B, numel(xv), []);
mesh(X, Y, Z, 'FaceAlpha', 0.6)
title(sprintf('Z =  %+.3g\\cdotX  %+.3g\\cdotY  %+.3g', B))

hold off

print images/figure1.svg

figure(2),clf

subplot(2,1,1)
hold on

stem(core_ghz, time, 'o')
xlabel('Cores \times GHz')
ylabel('Build time [h]')
grid on

% Best line fit to the points
% https://www.mathworks.com/matlabcentral/answers/377139-how-to-plot-best-fit-line
x = core_ghz;
y = time;
B = polyfit(x, y, 1);
X = linspace(min(x), max(x), 2);
Z = polyval(B , X);
plot(X, Z, 'r-');
title(sprintf('Z =  %+.3g\\cdotX  %+.3g', B))

hold off

subplot(2,1,2)
hold on
stem(ram, time, 'o')
xlabel('RAM [GB]')
ylabel('Build time [h]')
grid on

% Best line fit to the points
x = ram;
y = time;
B = polyfit(x, y, 1);
Y = linspace(min(x), max(x), 2);
Z = polyval(B , Y);
plot(Y, Z, 'r-');
title(sprintf('Z =  %+.3g\\cdotY  %+.3g', B))

hold off

print images/figure2.svg
