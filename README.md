# Mobile Network Signal Measurement (4G) / Meranie mobilného signálu (4G)

> Slovenská verzia sa nachádza nižšie / Slovak version is below

---

## English Version

### Overview

This repository contains the dataset and interactive map visualizations from a bachelor's thesis focused on analyzing the coverage and quality of mobile networks (4G LTE). The primary focus of this research is measuring signal attenuation (penetration loss) caused by the physical construction of various public transport vehicles (trains, trams) and evaluating the impact of measurement equipment placement on GNSS accuracy and Radio Frequency (RF) metrics.

---

### Measured Routes & Scenarios

The data logs cover over **900 kilometres** of railway and road corridors, including:

- **Railway Corridors (CZ):** Prague – Cheb, Prague – České Budějovice, Prague – Děčín
- **Road/Highway Corridors (CZ/SK):** Brno – Žilina (and return trips)
- **Urban Public Transport:** Tram lines in the city of Brno (e.g. historical centre to Technology Park)
- **Specific Scenarios:** Direct comparisons of signal penetration between older train carriages and modern units (Moravia) equipped with laser-treated metallised windows, as well as testing hardware placement (dashboard vs. glovebox)

---

### Data Structure & Log Files

The raw data is provided in `TXT/CSV` format, collected using the **G-NetTrack Pro** diagnostic application.

#### Glossary of Log File Abbreviations

| Field | Description |
|---|---|
| `Timestamp` | Date and exact time of the logged measurement |
| `Longitude / Latitude` | GNSS spatial coordinates |
| `Speed` | Speed of the device/vehicle (km/h) |
| `Network Tech / NetworkMode` | The active radio technology (e.g. 4G) |
| `Node / CellID / LAC` | Identifiers for the connected cell tower and location area |
| `NodeLevel (RSRP)` | Reference Signal Received Power (dBm) — primary indicator of signal strength |
| `Qual (RSRQ)` | Reference Signal Received Quality (dB) |
| `SNR (SINR)` | Signal-to-Interference-plus-Noise Ratio (dB) — critical parameter for data throughput and connection quality |
| `LTERSSI` | Total received signal strength indicator, including noise and interference |
| `Accuracy` | GNSS localisation accuracy (metres) |
| `Altitude / Height` | Elevation data |

---

### MATLAB Visualisations

In addition to raw logs, this repository includes MATLAB files used for data post-processing and spatial visualisation.

> **Requirements:** To open the `.fig` map files and run the provided `.m` scripts, you must have **MATLAB** installed on your computer.

Once downloaded and opened in MATLAB, you can fully interact with the figures — zoom in on specific streets, pan across the railway corridors, and inspect the precise handover points and signal drops. If you do not have MATLAB, you can still use the raw CSV/TXT logs to create your own visualizations in open-source GIS software like **QGIS** or **Google Earth**.

---
---

## Slovenská verzia

### O projekte

Tento repozitár obsahuje namerané dáta a interaktívne mapové vizualizácie z bakalárskej práce zameranej na analýzu pokrytia a kvality mobilných sietí (4G LTE). Hlavným cieľom je meranie útlmu signálu spôsobeného fyzickou konštrukciou rôznych prostriedkov hromadnej dopravy (vlaky, električky) a vyhodnotenie vplyvu umiestnenia meracej aparatúry na presnosť GNSS a rádiové (RF) parametre.

---

### Merané trasy a scenáre

Dátové logy pokrývajú viac ako **900 kilometrov** železničných a cestných koridorov, vrátane:

- **Železničné koridory (ČR):** Praha – Cheb, Praha – České Budějovice, Praha – Děčín
- **Cestné koridory (ČR/SR):** Brno – Žilina (a spiatočné jazdy)
- **Mestská hromadná doprava:** Električkové trate v Brne (napr. z historického centra do Technologického parku)
- **Špecifické scenáre:** Priame porovnania priestupnosti signálu medzi staršími vagónmi a modernými jednotkami (Moravia) s pokovovanými oknami, ako aj testovanie umiestnenia hardvéru v aute (palubná doska vs. odkladacia priehradka)

---

### Štruktúra dát a log súbory

Surové dáta sú poskytované vo formáte `TXT/CSV` a boli zbierané pomocou aplikácie **G-NetTrack Pro**.

#### Vysvetlivky skratiek v log súboroch

| Pole | Popis |
|---|---|
| `Timestamp` | Dátum a presný čas zaznamenania hodnoty |
| `Longitude / Latitude` | Priestorové GNSS súradnice (zemepisná dĺžka a šírka) |
| `Speed` | Rýchlosť pohybu zariadenia/vozidla (km/h) |
| `Network Tech / NetworkMode` | Aktuálne využívaná rádiová technológia (napr. 4G) |
| `Node / CellID / LAC` | Identifikátory pripojenej základňovej stanice a lokality |
| `NodeLevel (RSRP)` | Sila prijatého referenčného signálu (dBm) |
| `Qual (RSRQ)` | Kvalita prijatého referenčného signálu (dB) |
| `SNR (SINR)` | Odstup užitočného signálu od šumu a interferencií (dB) — kritický QoS parameter |
| `LTERSSI` | Celková úroveň prijatého signálu vrátane šumu a rušenia z okolia |
| `Accuracy` | Presnosť priestorovej lokalizácie GNSS (metre) |
| `Altitude / Height` | Údaje o nadmorskej výške |

---

### MATLAB vizualizácie

Okrem surových logov tento repozitár obsahuje aj MATLAB súbory využité na post-processing a priestorovú vizualizáciu dát.

> **Požiadavky:** Na otvorenie súborov `.fig` a spustenie priložených skriptov `.m` je potrebné mať nainštalovaný **MATLAB**.

Po stiahnutí a otvorení v prostredí MATLAB môžete s mapami plne interagovať — približovať konkrétne ulice, posúvať sa po trati a detailne skúmať body handoveru či výpadky signálu. Ak MATLAB nemáte k dispozícii, surové logy vo formáte CSV/TXT je možné vizualizovať aj v open-source GIS softvéri, napríklad v **QGIS** alebo **Google Earth**.
