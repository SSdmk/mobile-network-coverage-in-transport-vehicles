% Skript: Mapa pripojenia k vysielačom - krátka trasa (Tram)
clear; clc; close all;

% 1. Súbor
  % filename = 'Tram_Centr_Kol';
   filename = 'Tram_Kol_Centr';

% 2. Import
opts = detectImportOptions(filename, 'Delimiter', '\t');
data = readtable(filename, opts);

% 3. Filtrovanie
lat  = data.Latitude;
lon  = data.Longitude;
node = data.Node;

valid = (lat ~= 0) & (lon ~= 0);
lat  = lat(valid);
lon  = lon(valid);
node = node(valid);

% 4. Unikátni vysielači a číselný index
unique_nodes = unique(node);
n_nodes      = length(unique_nodes);
node_idx     = zeros(size(node));
for i = 1:n_nodes
    node_idx(node == unique_nodes(i)) = i;
end

% 4b. Zistenie dominantného pásma pre každý vysielač
band     = data.BAND;
band     = band(valid);
node_band = cell(n_nodes, 1);   % pásmo pre každý node

for i = 1:n_nodes
    mask_b = (node_idx == i);
    bands_i = band(mask_b);

    % Nájdeme najpočetnejšie pásmo
    [unique_b, ~, ic_b] = unique(bands_i);
    counts_b = accumarray(ic_b, 1);
    [~, max_i] = max(counts_b);
    node_band{i} = unique_b{max_i};
end

% 5. Farebnná mapa - 11 dobre rozlíšiteľných farieb
% cmap = turbo(n_nodes);
% cmap = jet(n_nodes);
% cmap = hsv(n_nodes);

% 5. Farebná mapa - dynamický Master zoznam z oboch súborov
% Rýchle načítanie uzlov z oboch súborov pre zistenie všetkých unikátnych vysielačov
opts_master = detectImportOptions('Tram_Centr_Kol.txt', 'Delimiter', '\t');
temp_data1 = readtable('Tram_Centr_Kol.txt', opts_master);
temp_data2 = readtable('Tram_Kol_Centr.txt', opts_master);

% Spojíme všetky uzly z oboch trás dokopy
vsetky_uzly = [temp_data1.Node; temp_data2.Node];

% Vytvoríme Master zoznam a odstránime nuly (ak sú)
vsetky_vysielace = unique(vsetky_uzly);
vsetky_vysielace(vsetky_vysielace == 0) = []; 

% Vytvoríme farebnú paletu (turbo) presne na mieru pre celkový počet vysielačov
master_cmap = turbo(length(vsetky_vysielace));

% Priradenie farieb aktuálnemu súboru
cmap = zeros(n_nodes, 3);
for i = 1:n_nodes
    % Nájdeme, na akej pozícii v Master zozname je náš aktuálny vysielač
    idx = find(vsetky_vysielace == unique_nodes(i));
    
    if isempty(idx)
        % Poistka: ak by sa náhodou vysielač nenašiel, dáme mu čiernu
        cmap(i, :) = [0 0 0]; 
    else
        % Priradíme mu jeho stálu farbu z Master palety
        cmap(i, :) = master_cmap(idx, :);
    end
end

% 5b. Súradnice vysielačov (manuálne zadané)
tower_data = [
    2356, 49.21776997380175, 16.592427159755662;
    2361, 49.1975278,        16.6025083;
    2369, 49.2031667,        16.5997389;
    2401, 49.2008528,        16.6038694;
    2409, 49.22445656071771, 16.58195958702182;
    2425, 49.1964722,        16.6054861;
    2430, 49.213177468331196,16.592500293398093;
    2441, 49.2068361,        16.5964861;
    2896, 49.22819503628988, 16.58145731871691;
    3087, 49.2320722,        16.5717556;
    3093, 49.2101472,        16.5896167;
    3106, 49.2032556,        16.5933556;
];
tower_ids  = tower_data(:, 1);
tower_lats = tower_data(:, 2);
tower_lons = tower_data(:, 3);

% 6. Vykreslenie - svetlá mapa
figure('Name', 'Mapa vysielačov - svetlá', ...
       'Position', [100, 100, 950, 700], ...
       'Color', 'white');

gx1 = geoaxes('Position', [0.05, 0.05, 0.75, 0.88]);
hold(gx1, 'on');
geobasemap(gx1, 'streets-light');

for i = 1:n_nodes
    mask = (node_idx == i);
    geoscatter(gx1, lat(mask), lon(mask), 25, ...
        'filled', ...
        'MarkerFaceColor', cmap(i,:), ...
        'MarkerEdgeColor', 'none', ...
        'DisplayName', sprintf('Node %d  (%s)', unique_nodes(i), node_band{i}));
end

title(gx1, 'Pripojenie k vysielačom – Trasa: Technologicky Park → Centrum ', ...
    'FontSize', 13, 'FontWeight', 'bold');

lgd1 = legend(gx1, 'Location', 'eastoutside', 'FontSize', 10, 'Box', 'on');
title(lgd1, 'Node ID');
% Ikony vysielačov - svetlá mapa
for i = 1:length(tower_ids)
    idx = find(vsetky_vysielace == tower_ids(i));
    if isempty(idx), continue; end
    t_color = master_cmap(idx, :);
    geoscatter(gx1, tower_lats(i), tower_lons(i), 180, ...
        'o', ...                          % zmena symbolu 
        'filled', ...
        'MarkerFaceColor', t_color, ...
        'MarkerEdgeColor', 'k', ...
        'LineWidth', 1.2, ...
        'HandleVisibility', 'off');       % nezobrazí sa v legende
end

% 7. Vykreslenie - satelitná mapa
figure('Name', 'Mapa vysielačov - satelit', ...
       'Position', [150, 150, 950, 700], ...
       'Color', 'white');

gx2 = geoaxes('Position', [0.05, 0.05, 0.75, 0.88]);
hold(gx2, 'on');
geobasemap(gx2, 'satellite');

for i = 1:n_nodes
    mask = (node_idx == i);
    geoscatter(gx2, lat(mask), lon(mask), 25, ...
        'filled', ...
        'MarkerFaceColor', cmap(i,:), ...
        'MarkerEdgeColor', 'none', ...
        'DisplayName', sprintf('Node %d  (%s)', unique_nodes(i), node_band{i}));
end

title(gx2, 'Pripojenie k vysielačom – Trasa Centrum → Kollárova', ...
    'FontSize', 13, 'FontWeight', 'bold', 'Color', 'white');

lgd2 = legend(gx2, 'Location', 'eastoutside', 'FontSize', 10, 'Box', 'on');
title(lgd2, 'Node ID');

% Ikony vysielačov - satelitná mapa
for i = 1:length(tower_ids)
    idx = find(vsetky_vysielace == tower_ids(i));
    if isempty(idx), continue; end
    t_color = master_cmap(idx, :);
    geoscatter(gx2, tower_lats(i), tower_lons(i), 180, ...
        'h', ...
        'filled', ...
        'MarkerFaceColor', t_color, ...
        'MarkerEdgeColor', 'w', ...
        'LineWidth', 1.2, ...
        'HandleVisibility', 'off');
    end

% 8. Štatistika
fprintf('--- ŠTATISTIKA VYSIELAČOV ---\n');
fprintf('Počet unikátnych Node: %d\n\n', n_nodes);
fprintf('%-12s  %-8s\n', 'Node ID', 'Merania');
for i = 1:n_nodes
    fprintf('%-12d  %d\n', unique_nodes(i), sum(node == unique_nodes(i)));
end

% 8. Štatistika a Tabuľka vysielačov
fprintf('\n--- ŠTATISTIKA VYSIELAČOV ---\n');
fprintf('Počet unikátnych Node: %d\n\n', n_nodes);

% Vytvorenie poľa pre počet meraní
pocet_merani = zeros(n_nodes, 1);
for i = 1:n_nodes
    pocet_merani(i) = sum(node == unique_nodes(i));
end

% Vytvorenie skutočnej MATLAB tabuľky
TabulkaVysielacov = table(unique_nodes, pocet_merani, ...
    'VariableNames', {'Node_ID', 'Pocet_Merani'});

% Vypísanie tabuľky do Command Window
disp(TabulkaVysielacov);

% VOLITEĽNÉ: Uloženie tabuľky do Excelu (odkomentuj riadok nižšie, ak to chceš)
% writetable(TabulkaVysielacov, 'Pouzite_Vysielace.xlsx');
[]