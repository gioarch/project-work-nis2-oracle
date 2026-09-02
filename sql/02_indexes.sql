-- ============================================================
-- Project Work L-31
-- STEP 7 - Indici Oracle aggiuntivi
-- Modello dati canonico V2
-- File: 02_indexes.sql
--
-- Contiene esclusivamente indici NON già coperti da PK/UNIQUE.
-- VALIDAZIONE: statica e logico-referenziale.
-- ESECUZIONE REALE: superata su Oracle AI Database 26ai con SQLcl 26.2.2.
-- ============================================================

-- TRADE-OFF GENERALE:
-- Gli indici aggiuntivi possono velocizzare JOIN e ricerche coerenti con le query previste,
-- ma aumentano spazio occupato e costo di INSERT/UPDATE/DELETE.
-- Per questo il progetto mantiene soltanto tre indici aggiuntivi realmente motivati.

-- Q6: partendo da un servizio, facilita il recupero degli asset associati.
-- La PK di asset_servizi è (id_asset, id_servizio), quindi non ha
-- id_servizio come colonna iniziale.
CREATE INDEX idx_asset_servizi_servizio
    ON asset_servizi (id_servizio);

-- Q4/Q5: partendo da un responsabile, facilita il recupero degli asset
-- di competenza. La PK è (id_asset, id_responsabile).
CREATE INDEX idx_asset_resp_responsabile
    ON asset_responsabili (id_responsabile);

-- Q4/Q5: partendo da un responsabile, facilita il recupero dei servizi
-- di competenza. La PK è (id_servizio, id_responsabile).
CREATE INDEX idx_servizi_resp_responsabile
    ON servizi_responsabili (id_responsabile);

-- NON viene creato idx_asset_criticita.
-- Motivo: criticita ha un dominio di soli quattro valori e il dataset
-- dimostrativo è piccolo; un B-tree dedicato avrebbe selettività limitata.
-- La decisione evita un indice poco giustificato e il relativo costo
-- aggiuntivo in spazio e operazioni di scrittura.
