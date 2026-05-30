 % Skript na zobrazenie merania signálu z G-NetTrack Pro
clear; clc; 
close all;

% 1. Názov tvojho súboru s dátami
% filename = 'Zilina-Brno_normal';
 % filename = 'Brno-Zilina_tlmeny';


% 2. Nastavenie importu (G-NetTrack používa tabulátor ako oddeľovač)
opts = detectImportOptions(filename, 'Delimiter', '\t');
% Ak by bol problém s názvami stĺpcov, MATLAB ich načíta presne tak, ako sú v hlavičke
data = readtable(filename, opts);

% 3. Extrakcia potrebných stĺpcov
lat = data.Latitude;
lon = data.Longitude;
level = data.Level; % Zvyčajne RSRP (v dBm)

% 4. Čistenie dát (Odstránenie bodov, kde vypadlo GPS alebo chýba zápis)
% Vylúčime riadky, kde je Latitude alebo Longitude 0 a kde Level chýba (NaN)
valid_idx = (lat ~= 0) & (lon ~= 0) & ~isnan(level);
lat = lat(valid_idx);
lon = lon(valid_idx);
level = level(valid_idx);

% --- Vytvorenie farebnej škály ---
r1 = ones(128,1); g1 = linspace(0,1,128)'; b1 = zeros(128,1); % Prechod Červená -> Žltá
r2 = linspace(1,0,128)'; g2 = ones(128,1); b2 = zeros(128,1); % Prechod Žltá -> Zelená
custom_cmap = [r1, g1, b1; r2, g2, b2];
point_size = 30; % Veľkosť bodov


% ==============================================
% PRVÉ OKNO: Pôvodný (vo "white mode")
% ==============================================
figure('Name', 'Svetlá mapa pokrytia', 'Position', [100, 100, 800, 600]);

geoscatter(lat, lon, point_size, level, 'filled', 'MarkerEdgeColor', 'k', 'LineWidth', 0.2);
geobasemap('streets-light'); % Nastaví svetlú/bielu mapu
title('Trasa Žilina-Brno');

% Aplikovanie farieb a legendy pre prvé okno
colormap(custom_cmap); 
clim([-115, -65]); % Ak máš starší MATLAB, zmeň na: caxis([-115, -65])

cb1 = colorbar;
cb1.Label.String = 'Sila signálu - Level (dBm)';
cb1.FontSize = 11;


% ==============================================
% DRUHÉ OKNO: Satelitná mapa
% ==============================================
% Druhé okno posunieme o kúsok vedľa (Position: x=150, y=150), aby sa úplne neprekryli
figure('Name', 'Satelitná mapa pokrytia', 'Position', [150, 150, 800, 600]);

geoscatter(lat, lon, point_size, level, 'filled', 'MarkerEdgeColor', 'k', 'LineWidth', 0.2);
geobasemap('satellite'); % Nastaví satelitnú mapu
title('Satelitná mapa');

% Aplikovanie farieb a legendy pre druhé okno
colormap(custom_cmap); 
clim([-115, -65]); % Ak máš starší MATLAB, zmeň na: caxis([-115, -65])

cb2 = colorbar;
cb2.Label.String = 'Sila signálu - Level (dBm)';
cb2.FontSize = 11;


