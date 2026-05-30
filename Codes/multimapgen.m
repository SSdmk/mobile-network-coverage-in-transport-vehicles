% Skript na zobrazenie merania signálu z G-NetTrack Pro - viacero súborov
clear; clc; close all;

% 1. Zoznam súborov a ich popisky do legendy
filenames = {
    'praha_cheb';
    'praha_ceske...';
    'praha_decin';
    
};

labels = {
    'praha_cheb';
    'praha_ceske...';
    'praha_decin';
   
};

% 2. Farebnná škála pre RSRP (červená -> žltá -> zelená)
r1 = ones(128,1); g1 = linspace(0,1,128)'; b1 = zeros(128,1);
r2 = linspace(1,0,128)'; g2 = ones(128,1); b2 = zeros(128,1);
custom_cmap = [r1, g1, b1; r2, g2, b2];
point_size  = 25;
clim_range  = [-115, -65];

% 3. Načítanie a spojenie všetkých dát
all_lat   = [];
all_lon   = [];
all_level = [];

for k = 1:length(filenames)
    opts = detectImportOptions(filenames{k}, 'Delimiter', '\t');
    d    = readtable(filenames{k}, opts);

    lat_k   = d.Latitude;
    lon_k   = d.Longitude;
    level_k = d.Level;

    valid_k = (lat_k ~= 0) & (lon_k ~= 0) & ~isnan(level_k);
    all_lat   = [all_lat;   lat_k(valid_k)];
    all_lon   = [all_lon;   lon_k(valid_k)];
    all_level = [all_level; level_k(valid_k)];

    fprintf('Načítaný súbor: %-30s  |  Platných vzoriek: %d\n', ...
        filenames{k}, sum(valid_k));
end

fprintf('Celkový počet bodov: %d\n\n', length(all_lat));

% ==============================================
% OKNO 1: Svetlá mapa
% ==============================================
figure('Name', 'Spoločná mapa - svetlá', ...
       'Position', [100, 100, 900, 700], ...
       'Color', 'white');

geoscatter(all_lat, all_lon, point_size, all_level, ...
    'filled', 'MarkerEdgeColor', 'none');
geobasemap('streets-light');
colormap(custom_cmap);
clim(clim_range);

title(sprintf('Mapa pokrytia RSRP – %d trás', length(filenames)), ...
    'FontSize', 13, 'FontWeight', 'bold');

cb1 = colorbar;
cb1.Label.String = 'RSRP (dBm)';
cb1.FontSize = 11;

% ==============================================
% OKNO 2: Satelitná mapa
% ==============================================
figure('Name', 'Spoločná mapa - satelit', ...
       'Position', [150, 150, 900, 700], ...
       'Color', 'white');

geoscatter(all_lat, all_lon, point_size, all_level, ...
    'filled', 'MarkerEdgeColor', 'none');
geobasemap('satellite');
colormap(custom_cmap);
clim(clim_range);

title(sprintf('Mapa pokrytia RSRP – %d trás', length(filenames)), ...
    'FontSize', 13, 'FontWeight', 'bold', 'Color', 'white');

cb2 = colorbar;
cb2.Label.String = 'RSRP (dBm)';
cb2.FontSize = 11;