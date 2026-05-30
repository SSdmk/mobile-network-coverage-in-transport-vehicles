% Skript: CDF graf RSRP podľa frekvenčného pásma (Band 20 vs Band 3)
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

% 3. Pomocná funkcia na filtrovanie podľa pásma
% Vstup: tabuľka, názov pásma ('L20' alebo 'L3')
% Výstup: zoradené RSRP hodnoty pre CDF
function sorted = filter_band(data, band_name)
    lat   = data.Latitude;
    lon   = data.Longitude;
    level = data.Level;
    band  = data.BAND;

    valid = (lat ~= 0) & (lon ~= 0) & ~isnan(level) & strcmp(band, band_name);
    sorted = sort(level(valid));
end

% 4. Extrakcia dát pre každú kombináciu
s_n_b20 = filter_band(data_normal, 'L20');   % Palubovka - Band 20
s_n_b3  = filter_band(data_normal, 'L3');    % Palubovka - Band 3
s_t_b20 = filter_band(data_tlmeny, 'L20');   % Glovebox  - Band 20
s_t_b3  = filter_band(data_tlmeny, 'L3');    % Glovebox  - Band 3

% 5. Výpočet CDF
cdf = @(x) (1:length(x))' / length(x);

% 6. Farby a štýly
% Band 20 = modrá, Band 3 = oranžová
% Palubovka = plná čiara, Glovebox = čiarkovaná
c_b20 = [0.20, 0.47, 0.75];
c_b3  = [0.85, 0.33, 0.10];

% 7. Vykreslenie - dva samostatné grafy

% --- GRAF 1: Band 20 (800 MHz) ---
figure('Name', 'CDF - RSRP Band 20', ...
       'Position', [150, 150, 850, 600], ...
       'Color', 'white');

ax1 = axes('Color', 'white');
hold(ax1, 'on');

plot(s_n_b20, cdf(s_n_b20), '-', 'Color', c_b20, 'LineWidth', 2.5, ...
    'DisplayName', 'Palubovka – Band 20 (800 MHz)');
plot(s_t_b20, cdf(s_t_b20), '-', 'Color', c_b3,  'LineWidth', 2.5, ...
    'DisplayName', 'Glovebox – Band 20 (800 MHz)');

yline(0.10, '--', 'Color', [0.6 0.6 0.6], 'LineWidth', 1.0, ...
    'Label', '10 %', 'LabelHorizontalAlignment', 'left', 'HandleVisibility', 'off');
yline(0.50, '--', 'Color', [0.6 0.6 0.6], 'LineWidth', 1.0, ...
    'Label', '50 %', 'LabelHorizontalAlignment', 'left', 'HandleVisibility', 'off');
yline(0.90, '--', 'Color', [0.6 0.6 0.6], 'LineWidth', 1.0, ...
    'Label', '90 %', 'LabelHorizontalAlignment', 'left', 'HandleVisibility', 'off');

title('CDF – RSRP Band 20 / 800 MHz (Trasa Brno-Žilina)', ...
    'FontSize', 14, 'FontWeight', 'bold', 'Color', 'black');
xlabel('RSRP (dBm)', 'FontSize', 12, 'Color', 'black');
ylabel('Kumulatívna pravdepodobnosť  P(X ≤ x)', 'FontSize', 12, 'Color', 'black');
xlim([-125, -60]); ylim([0, 1]);
% set(ax1, 'XDir', 'reverse');
legend('Location', 'northwest', 'FontSize', 15, 'Box', 'on', 'FontWeight', 'bold');
grid on;
set(ax1, 'GridAlpha', 0.5, 'FontSize', 11, 'Color', 'white', ...
    'XColor', 'black', 'YColor', 'black');
ax1.GridColor = [0 0 0];

% --- GRAF 2: Band 3 (1800 MHz) ---
figure('Name', 'CDF - RSRP Band 3', ...
       'Position', [200, 200, 850, 600], ...
       'Color', 'white');

ax2 = axes('Color', 'white');
hold(ax2, 'on');

plot(s_n_b3, cdf(s_n_b3), '-', 'Color', c_b20, 'LineWidth', 2.5, ...
    'DisplayName', 'Palubovka – Band 3 (1800 MHz)');
plot(s_t_b3, cdf(s_t_b3), '-', 'Color', c_b3,  'LineWidth', 2.5, ...
    'DisplayName', 'Glovebox – Band 3 (1800 MHz)');

yline(0.10, '--', 'Color', [0.6 0.6 0.6], 'LineWidth', 1.0, ...
    'Label', '10 %', 'LabelHorizontalAlignment', 'left', 'HandleVisibility', 'off');
yline(0.50, '--', 'Color', [0.6 0.6 0.6], 'LineWidth', 1.0, ...
    'Label', '50 %', 'LabelHorizontalAlignment', 'left', 'HandleVisibility', 'off');
yline(0.90, '--', 'Color', [0.6 0.6 0.6], 'LineWidth', 1.0, ...
    'Label', '90 %', 'LabelHorizontalAlignment', 'left', 'HandleVisibility', 'off');

title('CDF – RSRP Band 3 / 1800 MHz (Trasa Brno-Žilina)', ...
    'FontSize', 14, 'FontWeight', 'bold', 'Color', 'black');
xlabel('RSRP (dBm)', 'FontSize', 12, 'Color', 'black');
ylabel('Kumulatívna pravdepodobnosť  P(X ≤ x)', 'FontSize', 12, 'Color', 'black');
xlim([-125, -60]); ylim([0, 1]);
% set(ax2, 'XDir', 'reverse');
legend('Location', 'northwest', 'FontSize', 15, 'Box', 'on', 'FontWeight', 'bold');
grid on;
set(ax2, 'GridAlpha', 0.5, 'FontSize', 11, 'Color', 'white', ...
    'XColor', 'black', 'YColor', 'black');
ax2.GridColor = [0 0 0];

% 8. Štatistika
fprintf('--- CDF ŠTATISTIKA podľa pásma ---\n');
datasets = {s_n_b20, s_t_b20, s_n_b3, s_t_b3};
names    = {'Palubovka Band 20', 'Glovebox  Band 20', ...
            'Palubovka Band 3 ', 'Glovebox  Band 3 '};

for i = 1:4
    d = datasets{i};
    if isempty(d)
        fprintf('%s -> žiadne dáta\n', names{i});
        continue;
    end
    p10 = d(round(0.10 * length(d)));
    p50 = d(round(0.50 * length(d)));
    p90 = d(round(0.90 * length(d)));
    fprintf('%s -> P10: %5.1f dBm | P50: %5.1f dBm | P90: %5.1f dBm | Vzorky: %d\n', ...
        names{i}, p10, p50, p90, length(d));
end