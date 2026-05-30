% Skript: Priebeh presnosti GNSS pocas trasy (kĺzavý priemer)
clear; clc; close all;

% 1. Názvy súborov
  filename_normal = 'Zilina-Brno_normal'; 
  filename_tlmeny = 'Zilina-Brno_tlmeny';

 % filename_normal = 'brno_zilina_normal';
 % filename_tlmeny = 'Brno-Zilina_tlmeny';

% 2. Import
opts_n = detectImportOptions(filename_normal, 'Delimiter', '\t');
opts_t = detectImportOptions(filename_tlmeny,  'Delimiter', '\t');

data_normal = readtable(filename_normal, opts_n);
data_tlmeny = readtable(filename_tlmeny, opts_t);

% 3. Filtrovanie - Palubovka
lat_n    = data_normal.Latitude;
lon_n    = data_normal.Longitude;
acc_n    = data_normal.Accuracy;
valid_n  = (lat_n ~= 0) & (lon_n ~= 0) & ~isnan(acc_n) & (acc_n > 0);
acc_n    = acc_n(valid_n);
idx_n    = linspace(0, 100, length(acc_n))';   % os X v percentách (0-100%)

% 4. Filtrovanie - Glovebox
lat_t    = data_tlmeny.Latitude;
lon_t    = data_tlmeny.Longitude;
acc_t    = data_tlmeny.Accuracy;
valid_t  = (lat_t ~= 0) & (lon_t ~= 0) & ~isnan(acc_t) & (acc_t > 0);
acc_t    = acc_t(valid_t);
idx_t    = linspace(0, 100, length(acc_t))';

% 5. Farby
color_normal = [0.20, 0.47, 0.75];
color_tlmeny = [0.85, 0.33, 0.10];

% 6. Plot (iba kĺzavý priemer)
figure('Name', 'GNSS Accuracy - Priebeh', ...
       'Position', [200, 200, 950, 550], ...
       'Color', 'white');
ax = axes('Color', 'white');
hold(ax, 'on');

% Priebežný kĺzavý priemer (okno 50 vzoriek) pre lepšiu čitateľnosť trendu
win = 50;
acc_n_smooth = movmean(acc_n, win);
acc_t_smooth = movmean(acc_t, win);

% Vykreslenie iba trendových čiar (scatter body boli odstránené)
plot(idx_n, acc_n_smooth, '-', 'Color', color_normal, ...
    'LineWidth', 2, 'DisplayName', 'Palubovka – kĺzavý priemer');

plot(idx_t, acc_t_smooth, '-', 'Color', color_tlmeny, ...
    'LineWidth', 2, 'DisplayName', 'Glovebox – kĺzavý priemer');

% 7. Popisky
title('Presnosť GNSS počas trasy Žilina – Brno', ...
    'FontSize', 14, 'FontWeight', 'bold', 'Color', 'black');
xlabel('Priebeh trasy (%)', 'FontSize', 12, 'Color', 'black');
ylabel('Presnosť GNSS (m)  —  nižšia = lepšia', 'FontSize', 12, 'Color', 'black');

legend('Location', 'northeast', 'FontSize', 15, 'Box', 'on');
grid on;

set(ax, 'GridAlpha', 0.5, 'FontSize', 11, 'Color', 'white', ...
    'XColor', 'black', 'YColor', 'black');
ax.GridColor = [0 0 0];

% Obmedzenie Y osi na maximum
ylim([0, 30]);

% 8. Štatistika
fprintf('--- ŠTATISTIKA GNSS ACCURACY ---\n');
fprintf('Palubovka -> Medián: %.1f m | Priemer: %.1f m | Max: %.0f m | Vzorky: %d\n', ...
    median(acc_n), mean(acc_n), max(acc_n), length(acc_n));

fprintf('Glovebox  -> Medián: %.1f m | Priemer: %.1f m | Max: %.0f m | Vzorky: %d\n', ...
    median(acc_t), mean(acc_t), max(acc_t), length(acc_t));

% Percento vzoriek s presnosťou lepšou ako 10m
pct_n = sum(acc_n <= 10) / length(acc_n) * 100;
pct_t = sum(acc_t <= 10) / length(acc_t) * 100;

fprintf('Vzorky s presnosťou <= 10m:  Palubovka: %.1f %%  |  Glovebox: %.1f %%\n', pct_n, pct_t);