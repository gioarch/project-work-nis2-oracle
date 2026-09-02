-- ============================================================
-- Project Work L-31
-- STEP 9 - Query Oracle
-- Modello dati canonico V2 - BLOCCATO
-- File: 05_queries.sql
--
-- VALIDAZIONE: statica, sintattica e logico-referenziale.
-- ESECUZIONE REALE: superata e ritestata su Oracle AI Database 26ai con SQLcl 26.2.2.
-- ============================================================

-- Mantiene valide le istruzioni multilinea anche in presenza di righe vuote
-- quando lo script viene eseguito con SQLcl o SQL*Plus.
SET SQLBLANKLINES ON

-- Q1 - Asset critici
-- Estrae gli asset classificati CRITICA con organizzazione e stato corrente.
SELECT
    a.id_asset,
    a.nome_asset,
    a.tipo_asset,
    a.criticita,
    o.nome_organizzazione,
    a.stato
FROM asset a
JOIN organizzazioni o
    ON o.id_organizzazione = a.id_organizzazione
WHERE a.criticita = 'CRITICA'
ORDER BY a.nome_asset;

-- Spiegazione Q1: il filtro seleziona i tre asset CRITICA del dataset.

-- Q2 - Servizi erogati
-- Elenca i servizi dell'organizzazione con identificativo, nome e criticita.
SELECT
    s.id_servizio,
    s.nome_servizio,
    s.criticita,
    o.nome_organizzazione
FROM servizi s
JOIN organizzazioni o
    ON o.id_organizzazione = s.id_organizzazione
ORDER BY s.nome_servizio;

-- Spiegazione Q2: il JOIN associa ciascun servizio alla sua organizzazione.

-- Q3 - Dipendenze da terze parti
-- Usa servizi_fornitori per collegare ogni servizio ai fornitori esterni.
SELECT
    s.nome_servizio,
    f.nome_fornitore,
    sf.tipo_dipendenza,
    sf.criticita_dipendenza,
    sf.descrizione
FROM servizi_fornitori sf
JOIN servizi s
    ON s.id_servizio = sf.id_servizio
JOIN fornitori f
    ON f.id_fornitore = sf.id_fornitore
ORDER BY s.nome_servizio, f.nome_fornitore;

-- Spiegazione Q3: le due FK dell'associativa identificano servizio e fornitore.

-- Q4 - Responsabili associati ad asset e/o servizi
-- UNION ALL mantiene distinta la provenienza della competenza senza riferimenti polimorfici.
SELECT
    r.id_responsabile,
    r.nome || ' ' || r.cognome AS nominativo,
    r.ruolo,
    'ASSET' AS tipo_elemento,
    a.id_asset AS id_elemento,
    a.nome_asset AS elemento_competenza
FROM responsabili r
JOIN asset_responsabili ar
    ON ar.id_responsabile = r.id_responsabile
JOIN asset a
    ON a.id_asset = ar.id_asset
UNION ALL
SELECT
    r.id_responsabile,
    r.nome || ' ' || r.cognome AS nominativo,
    r.ruolo,
    'SERVIZIO' AS tipo_elemento,
    s.id_servizio AS id_elemento,
    s.nome_servizio AS elemento_competenza
FROM responsabili r
JOIN servizi_responsabili sr
    ON sr.id_responsabile = r.id_responsabile
JOIN servizi s
    ON s.id_servizio = sr.id_servizio
ORDER BY nominativo, tipo_elemento, elemento_competenza;

-- Spiegazione Q4: i due rami distinguono responsabilita su asset e su servizi.

-- Q5 - Punti di contatto ed elementi di competenza
-- I contatti sono collegati ad asset e servizi tramite le associative dei responsabili.
SELECT
    r.nome || ' ' || r.cognome AS nominativo,
    r.ruolo,
    pc.funzione,
    pc.priorita_contatto,
    pc.email,
    pc.telefono,
    'ASSET' AS tipo_elemento,
    a.nome_asset AS elemento_competenza
FROM punti_contatto pc
JOIN responsabili r
    ON r.id_responsabile = pc.id_responsabile
JOIN asset_responsabili ar
    ON ar.id_responsabile = r.id_responsabile
JOIN asset a
    ON a.id_asset = ar.id_asset
UNION ALL
SELECT
    r.nome || ' ' || r.cognome AS nominativo,
    r.ruolo,
    pc.funzione,
    pc.priorita_contatto,
    pc.email,
    pc.telefono,
    'SERVIZIO' AS tipo_elemento,
    s.nome_servizio AS elemento_competenza
FROM punti_contatto pc
JOIN responsabili r
    ON r.id_responsabile = pc.id_responsabile
JOIN servizi_responsabili sr
    ON sr.id_responsabile = r.id_responsabile
JOIN servizi s
    ON s.id_servizio = sr.id_servizio
ORDER BY nominativo, funzione, priorita_contatto, tipo_elemento, elemento_competenza;

-- Spiegazione Q5: l'elemento di competenza deriva sempre dalle associative canoniche.

-- Q6 - Riepilogo di uno specifico servizio
-- Le tre aggregazioni correlate evitano combinazioni artificiali fra insiemi indipendenti.
-- Nel dataset dimostrativo id_servizio = 1 identifica Gestione Portale Clienti.
SELECT
    s.id_servizio,
    s.nome_servizio,
    s.criticita,
    (
        SELECT LISTAGG(a.nome_asset, ', ')
                   WITHIN GROUP (ORDER BY a.nome_asset)
        FROM asset_servizi ass
        JOIN asset a
            ON a.id_asset = ass.id_asset
        WHERE ass.id_servizio = s.id_servizio
    ) AS asset_associati,
    (
        SELECT LISTAGG(f.nome_fornitore, ', ')
                   WITHIN GROUP (ORDER BY f.nome_fornitore)
        FROM servizi_fornitori sf
        JOIN fornitori f
            ON f.id_fornitore = sf.id_fornitore
        WHERE sf.id_servizio = s.id_servizio
    ) AS fornitori_associati,
    (
        SELECT LISTAGG(r.nome || ' ' || r.cognome, ', ')
                   WITHIN GROUP (ORDER BY r.cognome, r.nome)
        FROM servizi_responsabili sr
        JOIN responsabili r
            ON r.id_responsabile = sr.id_responsabile
        WHERE sr.id_servizio = s.id_servizio
    ) AS responsabili_associati
FROM servizi s
WHERE s.id_servizio = 1;

-- Spiegazione Q6: LISTAGG produce tre elenchi senza moltiplicare gli insiemi.

-- Q7 - Storico versioni di un asset
-- Mostra in ordine di versione gli snapshot del Portale Clienti (id_asset = 1).
SELECT
    sa.id_asset,
    sa.numero_versione,
    sa.data_inizio_validita,
    sa.data_fine_validita,
    sa.nome_asset,
    sa.tipo_asset,
    sa.criticita,
    sa.stato,
    sa.tipo_modifica,
    sa.descrizione_modifica
FROM storico_asset sa
WHERE sa.id_asset = 1
ORDER BY sa.numero_versione;

-- Spiegazione Q7: l'ordinamento rende ricostruibile l'evoluzione dell'asset.

-- Q8 - Storico versioni di un servizio
-- Mostra in ordine di versione gli snapshot di Gestione Portale Clienti (id_servizio = 1).
SELECT
    ss.id_servizio,
    ss.numero_versione,
    ss.data_inizio_validita,
    ss.data_fine_validita,
    ss.nome_servizio,
    ss.criticita,
    ss.tipo_modifica,
    ss.descrizione_modifica
FROM storico_servizi ss
WHERE ss.id_servizio = 1
ORDER BY ss.numero_versione;

-- Spiegazione Q8: l'ordinamento rende ricostruibile l'evoluzione del servizio.

-- Q9 - Dipendenze tecniche tra asset
-- La semantica e: l'asset origine dipende dal funzionamento dell'asset richiesto.
SELECT
    d.id_dipendenza,
    ao.id_asset AS id_asset_origine,
    ao.nome_asset AS asset_origine,
    ar.id_asset AS id_asset_richiesto,
    ar.nome_asset AS asset_richiesto,
    d.tipo_dipendenza,
    d.descrizione
FROM dipendenze d
JOIN asset ao
    ON ao.id_asset = d.id_asset_origine
JOIN asset ar
    ON ar.id_asset = d.id_asset_richiesto
ORDER BY ao.nome_asset, ar.nome_asset;

-- Spiegazione Q9: i due alias di asset esplicitano origine e requisito tecnico.
