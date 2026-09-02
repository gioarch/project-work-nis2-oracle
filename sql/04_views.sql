-- ============================================================
-- Project Work L-31
-- STEP 10 - VIEW di export
-- Modello dati canonico V2 - BLOCCATO
-- File: 04_views.sql
--
-- VALIDAZIONE: statica, sintattica e logico-referenziale.
-- NON risulta eseguito su un'istanza Oracle in questa fase.
-- ============================================================

-- La VIEW vw_export_nis2_demo è una soluzione didattica sviluppata per
-- soddisfare la richiesta di estrazione strutturata del Project Work.
-- I campi selezionati sono campi minimi progettuali derivati dal modello dati
-- e dalla traccia. La VIEW e il relativo CSV non riproducono la Piattaforma
-- ACN, il modello ufficiale di categorizzazione né un tracciato CSV ufficiale
-- ACN.

-- La granularità è una riga per servizio. Le informazioni collegate sono
-- aggregate separatamente per evitare prodotti moltiplicativi involontari
-- tra asset, fornitori, responsabili e punti di contatto.
CREATE OR REPLACE VIEW vw_export_nis2_demo AS
SELECT
    o.id_organizzazione,
    o.nome_organizzazione,
    s.id_servizio,
    s.nome_servizio,
    s.criticita,
    (
        SELECT LISTAGG(
                   a.nome_asset || ' [' || a.tipo_asset || '; '
                   || a.criticita || '; ' || a.stato || ']',
                   ' | '
               ) WITHIN GROUP (ORDER BY a.nome_asset)
        FROM asset_servizi ass
        JOIN asset a
            ON a.id_asset = ass.id_asset
        WHERE ass.id_servizio = s.id_servizio
    ) AS asset_associati,
    (
        SELECT LISTAGG(
                   f.nome_fornitore || ' [' || sf.tipo_dipendenza || '; '
                   || sf.criticita_dipendenza || ']',
                   ' | '
               ) WITHIN GROUP (ORDER BY f.nome_fornitore)
        FROM servizi_fornitori sf
        JOIN fornitori f
            ON f.id_fornitore = sf.id_fornitore
        WHERE sf.id_servizio = s.id_servizio
    ) AS fornitori_associati,
    (
        SELECT LISTAGG(
                   r.nome || ' ' || r.cognome || ' [' || r.ruolo || ']',
                   ' | '
               ) WITHIN GROUP (ORDER BY r.cognome, r.nome)
        FROM servizi_responsabili sr
        JOIN responsabili r
            ON r.id_responsabile = sr.id_responsabile
        WHERE sr.id_servizio = s.id_servizio
    ) AS responsabili_associati,
    (
        SELECT LISTAGG(
                   r.nome || ' ' || r.cognome || ' [' || pc.funzione
                   || '; priorita ' || TO_CHAR(pc.priorita_contatto, 'FM99')
                   || '; email ' || NVL(pc.email, '-')
                   || '; tel ' || NVL(pc.telefono, '-') || ']',
                   ' | '
               ) WITHIN GROUP (
                   ORDER BY r.cognome, r.nome, pc.funzione, pc.priorita_contatto
               )
        FROM servizi_responsabili sr
        JOIN responsabili r
            ON r.id_responsabile = sr.id_responsabile
        JOIN punti_contatto pc
            ON pc.id_responsabile = r.id_responsabile
        WHERE sr.id_servizio = s.id_servizio
    ) AS punti_contatto_associati
FROM servizi s
JOIN organizzazioni o
    ON o.id_organizzazione = s.id_organizzazione;
