% Skript: CDF graf pre porovnanie RSRP - Palubovka vs Glovebox
clear; clc; close all;

% 1. Názvy súborov
% filename_normal = 'Zilina-Brno_normal'; 
% filename_tlmeny = 'Zilina-Brno_tlmeny';

 filename_normal = 'brno_zilina_normal';
 filename_tlmeny = 'Brno-Zilina_tlmeny';

% 2. Import
opts = detectImportOptions(filename_normal, 'Delimiter', '\t');

data_normal = readtable(filename_normal, opts);
data_tlmeny = readtable(filename_tlmeny, opts);

% 3. Filtrovanie - Palubovka
lat_n        = data_normal.Latitude;
lon_n        = data_normal.Longitude;
level_normal = data_normal.Level;
valid_n      = (lat_n ~= 0) & (lon_n ~= 0) & ~isnan(level_normal);
level_normal = level_normal(valid_n);

% 4. Filtrovanie - Glovebox
lat_t        = data_tlmeny.Latitude;
lon_t        = data_tlmeny.Longitude;
level_tlmeny = data_tlmeny.Level;
valid_t      = (lat_t ~= 0) & (lon_t ~= 0) & ~isnan(level_tlmeny);
level_tlmeny = level_tlmeny(valid_t);

% 5. Výpočet CDF
% Zoradíme hodnoty od najmenšej po najväčšiu
sorted_n = sort(level_normal);
sorted_t = sort(level_tlmeny);

% CDF = poradie / celkový počet vzoriek (od 0 do 1)
cdf_n = (1:length(sorted_n))' / length(sorted_n);
cdf_t = (1:length(sorted_t))' / length(sorted_t);

% 6. Farby
color_normal = [0.20, 0.47, 0.75];
color_tlmeny = [0.85, 0.33, 0.10];

% 7. Vykreslenie
figure('Name', 'CDF - RSRP', ...
       'Position', [200, 200, 850, 600], ...
       'Color', 'white');

ax = axes('Color', 'white');
hold(ax, 'on');

plot(sorted_n, cdf_n, '-', ...
    'Color', color_normal, 'LineWidth', 2.5, ...
    'DisplayName', 'Palubovka (Normálny)');

plot(sorted_t, cdf_t, '-', ...
    'Color', color_tlmeny, 'LineWidth', 2.5, ...
    'DisplayName', 'Glovebox (Tlmený)');

% 8. Referenčné horizontálne čiary na 10%, 50%, 90%
yline(0.10, '--', 'Color', [0.5 0.5 0.5], 'LineWidth', 1.2, ...
    'Label', '10 %', 'LabelHorizontalAlignment', 'left', ...
    'HandleVisibility', 'off');
yline(0.50, '--', 'Color', [0.5 0.5 0.5], 'LineWidth', 1.2, ...
    'Label', '50 %', 'LabelHorizontalAlignment', 'left', ...
    'HandleVisibility', 'off');
yline(0.90, '--', 'Color', [0.5 0.5 0.5], 'LineWidth', 1.2, ...
    'Label', '90 %', 'LabelHorizontalAlignment', 'left', ...
    'HandleVisibility', 'off');

% 9. Popisky
title('Kumulatívna distribučná funkcia (CDF) – RSRP (Trasa Brno – Žilina)', ...
    'FontSize', 14, 'FontWeight', 'bold', 'Color', 'black');
xlabel('RSRP (dBm)', 'FontSize', 12, 'Color', 'black');
ylabel('Kumulatívna pravdepodobnosť  P(X ≤ x)', 'FontSize', 12, 'Color', 'black');

xlim([-125, -60]);
% set(ax, 'XDir', 'reverse');
ylim([0, 1]);

legend('Location', 'northwest', 'FontSize', 15, 'Box', 'on');

grid on;
set(ax, 'GridAlpha', 0.5, 'FontSize', 11, 'Color', 'white', ...
    'XColor', 'black', 'YColor', 'black');
ax.GridColor = [0 0 0];

% 10. Štatistika do Command Window
fprintf('--- CDF ŠTATISTIKA (RSRP) ---\n');

% Hodnoty RSRP pri 10%, 50%, 90% percentile
p = [0.10, 0.50, 0.90];
for i = 1:length(p)
    val_n = sorted_n(round(p(i) * length(sorted_n)));
    val_t = sorted_t(round(p(i) * length(sorted_t)));
    fprintf('%2.0f%% meraní malo RSRP ≤  Palubovka: %5.1f dBm  |  Glovebox: %5.1f dBm\n', ...
        p(i)*100, val_n, val_t);
end

% Percento meraní pod hranicou -100 dBm (slabý signál)
thr = -100;
pct_n = sum(level_normal <= thr) / length(level_normal) * 100;
pct_t = sum(level_tlmeny <= thr) / length(level_tlmeny) * 100;
fprintf('\nPodiel meraní so slabým signálom (RSRP ≤ %d dBm):\n', thr);
fprintf('  Palubovka: %.1f %%\n', pct_n);
fprintf('  Glovebox:  %.1f %%\n', pct_t);