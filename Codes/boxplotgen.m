% Skript na zobrazenie Boxplotu (krabicového grafu) pre porovnanie umiestnenia
clear; clc; close all;

% 1. Názvy súborov
filename_normal = 'Brno_osobak'; 
filename_tlmeny = 'Brno_rychlik';
% Zilina-Brno_tlmeny
% Zilina-Brno_normal
% brno_zilina_normal
% Brno-Zilina_tlmeny



% 2. Nastavenie importu
opts = detectImportOptions(filename_normal, 'Delimiter', '\t');

% 3. Načítanie dát
data_normal = readtable(filename_normal, opts);
data_tlmeny = readtable(filename_tlmeny, opts);

% 4. Čistenie dát - Palubovka
lat_n     = data_normal.Latitude;
lon_n     = data_normal.Longitude;
level_normal = data_normal.Level;
valid_idx_n  = (lat_n ~= 0) & (lon_n ~= 0) & ~isnan(level_normal);
level_normal = level_normal(valid_idx_n);

% 5. Čistenie dát - Glovebox
lat_t     = data_tlmeny.Latitude;
lon_t     = data_tlmeny.Longitude;
level_tlmeny = data_tlmeny.Level;
valid_idx_t  = (lat_t ~= 0) & (lon_t ~= 0) & ~isnan(level_tlmeny);
level_tlmeny = level_tlmeny(valid_idx_t);

% 6. Príprava dát pre boxplot
all_levels   = [level_normal; level_tlmeny];
group_normal = repmat({'Palubovka (Normálny)'}, length(level_normal), 1);
group_tlmeny = repmat({'Glovebox (Tlmený)'},    length(level_tlmeny), 1);
groups       = [group_normal; group_tlmeny];

% 7. Farby pre jednotlivé skupiny
color_normal = [0.20, 0.47, 0.75];  % modrá
color_tlmeny = [0.85, 0.33, 0.10];  % oranžovo-červená

% 8. Vykreslenie
figure('Name', 'Statisticke porovnanie RSRP', ...
       'Position', [200, 200, 750, 600], ...
       'Color', 'white');

ax = axes('Color', 'white');
hold(ax, 'on');

bp = boxplot(all_levels, groups, ...
    'Widths', 0.45, ...
    'Colors', [color_normal; color_tlmeny], ...
    'Symbol', '+');          % outliers ako +

% Hrúbka čiar boxplotu
set(bp, 'LineWidth', 1.6);

% Vyplnenie krabíc farbou
h = findobj(gca, 'Tag', 'Box');
% h(1) = druhá skupina, h(2) = prvá skupina (boxplot radí od konca)
patch(get(h(1), 'XData'), get(h(1), 'YData'), color_tlmeny, ...
    'FaceAlpha', 0.35, 'EdgeColor', 'none');
patch(get(h(2), 'XData'), get(h(2), 'YData'), color_normal, ...
    'FaceAlpha', 0.35, 'EdgeColor', 'none');

% 9. Priemery (zelené hviezdičky)
mean_normal = mean(level_normal);
mean_tlmeny = mean(level_tlmeny);
h_mean1 = plot(1, mean_normal, 'g*', 'MarkerSize', 11, 'LineWidth', 1.8);
h_mean2 = plot(2, mean_tlmeny, 'g*', 'MarkerSize', 11, 'LineWidth', 1.8);

% 10. Manuálna legenda (boxplot nativne nepodporuje legendu)
h_leg1 = patch(nan, nan, color_normal, 'FaceAlpha', 0.35, 'EdgeColor', color_normal, 'LineWidth', 1.6);
h_leg2 = patch(nan, nan, color_tlmeny, 'FaceAlpha', 0.35, 'EdgeColor', color_tlmeny, 'LineWidth', 1.6);
h_leg3 = plot(nan, nan, 'g*', 'MarkerSize', 11, 'LineWidth', 1.8);

legend([h_leg1, h_leg2, h_leg3], ...
    {'Palubovka (Normálny)', 'Glovebox (Tlmený)', 'Priemerná hodnota'}, ...
    'Location', 'southwest', ...
    'FontSize', 15, ...
    'Box', 'on');

% 11. Popisky a estetika
title('Vplyv umiestnenia zariadenia na silu signálu (Trasa Brno – Žilina)', ...
    'FontSize', 14, 'FontWeight', 'bold', 'Color', 'black');
ylabel('Sila signálu – RSRP (dBm)', 'FontSize', 12, 'Color', 'black');
ylim([-125, -60]);
grid on;
set(gca, 'GridAlpha', 0.6, 'FontSize', 11, 'Color', 'white', 'XColor', 'black', 'YColor', 'black');
ax.GridColor = [0 0 0];

% 12. Štatistika do Command Window
fprintf('--- ŠTATISTIKA MERANIA ---\n');
fprintf('Palubovka (Normal) -> Medián: %.1f dBm | Priemer: %.1f dBm | Počet vzoriek: %d\n', ...
    median(level_normal), mean_normal, length(level_normal));
fprintf('Glovebox (Tlmený)  -> Medián: %.1f dBm | Priemer: %.1f dBm | Počet vzoriek: %d\n', ...
    median(level_tlmeny), mean_tlmeny, length(level_tlmeny));
fprintf('Rozdiel mediánov (Útlm): %.1f dB\n', median(level_normal) - median(level_tlmeny));



% ========== GRAF 2: SINR ==========

% Extrakcia SNR - Palubovka
sinr_normal = data_normal.SNR;
valid_sinr_n = (lat_n ~= 0) & (lon_n ~= 0) & ~isnan(sinr_normal);
sinr_normal = sinr_normal(valid_sinr_n);

% Extrakcia SNR - Glovebox
sinr_tlmeny = data_tlmeny.SNR;
valid_sinr_t = (lat_t ~= 0) & (lon_t ~= 0) & ~isnan(sinr_tlmeny);
sinr_tlmeny = sinr_tlmeny(valid_sinr_t);

% Príprava dát
all_sinr     = [sinr_normal; sinr_tlmeny];
group_sinr_n = repmat({'Palubovka (Normálny)'}, length(sinr_normal), 1);
group_sinr_t = repmat({'Glovebox (Tlmený)'},    length(sinr_tlmeny), 1);
groups_sinr  = [group_sinr_n; group_sinr_t];

% Vykreslenie
figure('Name', 'Statisticke porovnanie SINR', ...
       'Position', [250, 250, 750, 600], ...
       'Color', 'white');

ax2 = axes('Color', 'white');
hold(ax2, 'on');

bp2 = boxplot(all_sinr, groups_sinr, ...
    'Widths', 0.45, ...
    'Colors', [color_normal; color_tlmeny], ...
    'Symbol', '+');

set(bp2, 'LineWidth', 1.6);

h2 = findobj(ax2, 'Tag', 'Box');
patch(get(h2(1), 'XData'), get(h2(1), 'YData'), color_tlmeny, ...
    'FaceAlpha', 0.35, 'EdgeColor', 'none');
patch(get(h2(2), 'XData'), get(h2(2), 'YData'), color_normal, ...
    'FaceAlpha', 0.35, 'EdgeColor', 'none');

% Priemery
mean_sinr_n = mean(sinr_normal);
mean_sinr_t = mean(sinr_tlmeny);
plot(1, mean_sinr_n, 'g*', 'MarkerSize', 11, 'LineWidth', 1.8);
plot(2, mean_sinr_t, 'g*', 'MarkerSize', 11, 'LineWidth', 1.8);

% Legenda
h_leg1 = patch(nan, nan, color_normal, 'FaceAlpha', 0.35, 'EdgeColor', color_normal, 'LineWidth', 1.6);
h_leg2 = patch(nan, nan, color_tlmeny, 'FaceAlpha', 0.35, 'EdgeColor', color_tlmeny, 'LineWidth', 1.6);
h_leg3 = plot(nan, nan, 'g*', 'MarkerSize', 15, 'LineWidth', 1.8);

legend([h_leg1, h_leg2, h_leg3], ...
    {'Palubovka (Normálny)', 'Glovebox (Tlmený)', 'Priemerná hodnota'}, ...
    'Location', 'southwest', 'FontSize', 15, 'Box', 'on');

% Popisky
title('Vplyv umiestnenia zariadenia na SINR (Trasa Brno – Žilina)', ...
    'FontSize', 14, 'FontWeight', 'bold', 'Color', 'black');
ylabel('SINR (dB)', 'FontSize', 12, 'Color', 'black');
grid on;
set(ax2, 'GridAlpha', 0.6, 'FontSize', 11, 'Color', 'white', ...
    'XColor', 'black', 'YColor', 'black');
ax2.GridColor = [0 0 0];

% Štatistika
fprintf('\n--- ŠTATISTIKA SINR ---\n');
fprintf('Palubovka (Normal) -> Medián: %.1f dB | Priemer: %.1f dB | Počet vzoriek: %d\n', ...
    median(sinr_normal), mean_sinr_n, length(sinr_normal));
fprintf('Glovebox (Tlmený)  -> Medián: %.1f dB | Priemer: %.1f dB | Počet vzoriek: %d\n', ...
    median(sinr_tlmeny), mean_sinr_t, length(sinr_tlmeny));
fprintf('Rozdiel mediánov (Útlm): %.1f dB\n', median(sinr_normal) - median(sinr_tlmeny));


% ========== GRAF 3: PRESNOSŤ GPS (Accuracy) ==========

% Extrakcia Accuracy - Palubovka
acc_normal = data_normal.Accuracy;
valid_acc_n = (lat_n ~= 0) & (lon_n ~= 0) & ~isnan(acc_normal) & (acc_normal > 0);
acc_normal = acc_normal(valid_acc_n);

% Extrakcia Accuracy - Glovebox
acc_tlmeny = data_tlmeny.Accuracy;
valid_acc_t = (lat_t ~= 0) & (lon_t ~= 0) & ~isnan(acc_tlmeny) & (acc_tlmeny > 0);
acc_tlmeny = acc_tlmeny(valid_acc_t);

% Príprava dát
all_acc     = [acc_normal; acc_tlmeny];
group_acc_n = repmat({'Palubovka (Normálny)'}, length(acc_normal), 1);
group_acc_t = repmat({'Glovebox (Tlmený)'},    length(acc_tlmeny), 1);
groups_acc  = [group_acc_n; group_acc_t];

% Vykreslenie
figure('Name', 'Statisticke porovnanie GPS Accuracy', ...
       'Position', [300, 300, 750, 600], ...
       'Color', 'white');

ax3 = axes('Color', 'white');
hold(ax3, 'on');

bp3 = boxplot(all_acc, groups_acc, ...
    'Widths', 0.45, ...
    'Colors', [color_normal; color_tlmeny], ...
    'Symbol', '+');

set(bp3, 'LineWidth', 1.6);

h3 = findobj(ax3, 'Tag', 'Box');
patch(get(h3(1), 'XData'), get(h3(1), 'YData'), color_tlmeny, ...
    'FaceAlpha', 0.35, 'EdgeColor', 'none');
patch(get(h3(2), 'XData'), get(h3(2), 'YData'), color_normal, ...
    'FaceAlpha', 0.35, 'EdgeColor', 'none');

% Priemery
mean_acc_n = mean(acc_normal);
mean_acc_t = mean(acc_tlmeny);
plot(1, mean_acc_n, 'g*', 'MarkerSize', 11, 'LineWidth', 1.8);
plot(2, mean_acc_t, 'g*', 'MarkerSize', 11, 'LineWidth', 1.8);

% Legenda
h_leg1 = patch(nan, nan, color_normal, 'FaceAlpha', 0.35, 'EdgeColor', color_normal, 'LineWidth', 1.6);
h_leg2 = patch(nan, nan, color_tlmeny, 'FaceAlpha', 0.35, 'EdgeColor', color_tlmeny, 'LineWidth', 1.6);
h_leg3 = plot(nan, nan, 'g*', 'MarkerSize', 11, 'LineWidth', 1.8);

legend([h_leg1, h_leg2, h_leg3], ...
    {'Palubovka (Normálny)', 'Glovebox (Tlmený)', 'Priemerná hodnota'}, ...
    'Location', 'northeast', 'FontSize', 15, 'Box', 'on');

% Popisky
title('Porovnanie presnosti GPS (Trasa Žilina – Brno)', ...
    'FontSize', 14, 'FontWeight', 'bold', 'Color', 'black');
ylabel('Presnosť GPS (m)', 'FontSize', 12, 'Color', 'black');
grid on;
set(ax3, 'GridAlpha', 0.6, 'FontSize', 11, 'Color', 'white', ...
    'XColor', 'black', 'YColor', 'black');
ax3.GridColor = [0 0 0];

% Štatistika
fprintf('\n--- ŠTATISTIKA GPS ACCURACY ---\n');
fprintf('Palubovka (Normal) -> Medián: %.1f m | Priemer: %.1f m | Počet vzoriek: %d\n', ...
    median(acc_normal), mean_acc_n, length(acc_normal));
fprintf('Glovebox (Tlmený)  -> Medián: %.1f m | Priemer: %.1f m | Počet vzoriek: %d\n', ...
    median(acc_tlmeny), mean_acc_t, length(acc_tlmeny));
fprintf('Rozdiel mediánov: %.1f m\n', median(acc_normal) - median(acc_tlmeny));
