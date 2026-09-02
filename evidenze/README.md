# Evidenze del collaudo Oracle 26ai

Questa cartella contiene output prodotti da esecuzioni reali del package
tecnico del Project Work L-31.

## Ambiente osservato

- database: Oracle AI Database 26ai EE Extreme Perf;
- release dichiarata dal database: `23.26.0.0.0`;
- client: Oracle SQLcl 26.2.2;
- data del collaudo: 2 settembre 2026, GMT;
- dati: esclusivamente fittizi e didattici.

Lo schema utente e il service name sono stati sostituiti nel solo log di
precheck con i segnaposto `[SCHEMA_FREESQL_26AI]` e
`[SERVICE_FREESQL_26AI]`. Nessun risultato tecnico è stato alterato. I file non
contengono password, token o stringhe di connessione.

## Commit e sequenza di collaudo

- `6942d06bc44c4d5db964eebac6f3fa6b7500f8a7`: deploy iniziale di schema,
  indici, dataset, VIEW, query e test;
- `270a94cab30ca825c075c42962b2de36143b7353`: correzione di robustezza
  `SQLBLANKLINES`, retest di `05_queries.sql` e `06_tests.sql`, quindi export.

Le modifiche successive che aggiungono evidenze e aggiornano lo stato della
documentazione non cambiano il modello dati né la logica SQL già testata.

Nei log l'eco iniziale di alcuni sorgenti conserva la dicitura storica
`NON risulta eseguito su un'istanza Oracle in questa fase`. La dicitura era un
commento sullo stato precedente al collaudo, non un messaggio del database: le
istruzioni e i risultati riportati subito dopo nello stesso log documentano
l'esecuzione reale. Le intestazioni dei sorgenti correnti sono state poi
riallineate allo stato effettivo.

## Inventario

| File | Contenuto osservato |
|---|---|
| `00_precheck_oracle26ai.log` | Versione 26ai, privilegi `CREATE TABLE`/`CREATE VIEW`, zero oggetti iniziali |
| `01_deploy_schema_indici_26ai.log` | 13 tabelle, 47 vincoli nominati, zero vincoli disabilitati, tre indici `VALID` |
| `02_dataset_26ai.log` | `COMMIT`, 98 record e casi significativi coerenti |
| `03_views_queries_26ai.log` | VIEW `VALID`, cinque righe e risultati Q1-Q9 coerenti |
| `04_tests_26ai.log` | T01-T09, 39 esiti `OK`, nessun oggetto progettuale `INVALID` |
| `05_retest_sqlblanklines_26ai.log` | Retest con sessione inizialmente `SQLBLANKLINES OFF`; lo script abilita l'opzione e supera query/test |
| `export_nis2_demo_26ai.csv` | CSV reale: intestazione più cinque righe, nove colonne per record |
| `checklist_esecuzione_oracle26ai.md` | Checklist compilata esclusivamente su evidenze osservate |
| `SHA256SUMS` | Impronte SHA-256 dei sette artefatti prodotti dal collaudo |

Il CSV è stato inoltre aperto con un parser CSV: contiene sei record fisici,
nove colonne per record e gli identificativi servizio da 1 a 5. L'assenza di
fornitori per `Reportistica Clienti` è coerente con il dataset.

## Controlli non applicabili

- `sql/08_verifica_finale.sql`: non incluso; facoltativo secondo il Master;
- `sql/00_run_all.sql`: non incluso; facoltativo secondo il Master;
- test negativi: non previsti da `sql/06_tests.sql`, che è intenzionalmente di
  sola lettura.

Il precedente tentativo su FreeSQL 19c, non concluso per assenza del privilegio
`CREATE VIEW`, non fa parte delle evidenze finali del package.
