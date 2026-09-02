# Checklist di esecuzione reale Oracle
## Project Work L-31 – compilazione del 2 settembre 2026

La checklist è compilata esclusivamente sulla base dei file presenti in questa
cartella. La VIEW canonica è `vw_export_nis2_demo`.

## Dati del collaudo

- Versione Oracle: Oracle AI Database 26ai EE Extreme Perf, release `23.26.0.0.0`
- Strumento: Oracle SQLcl 26.2.2
- Data: 2 settembre 2026, GMT
- Schema: `[SCHEMA_FREESQL_26AI]` (identificativo sanitizzato)
- Commit: `6942d06bc44c4d5db964eebac6f3fa6b7500f8a7` per il deploy iniziale;
  `270a94cab30ca825c075c42962b2de36143b7353` per retest ed export

## A. Preparazione ambiente

- [x] Istanza Oracle compatibile disponibile.
- [x] Oracle SQLcl disponibile.
- [x] Schema didattico dedicato e inizialmente privo di oggetti progettuali.
- [x] Privilegi `CREATE TABLE` e `CREATE VIEW` verificati.
- [x] Esecuzione dalla directory del repository.
- [x] Posizione per log ed evidenze predisposta.

## B. Deploy dello schema

- [x] `sql/01_schema.sql` eseguito senza errori bloccanti.
- [x] `sql/02_indexes.sql` eseguito senza errori bloccanti.
- [x] Presenti le 13 tabelle del modello canonico.
- [x] PK, FK, `CHECK`, `UNIQUE` e `NOT NULL` coerenti con il DDL.
- [x] 47 vincoli nominati e zero vincoli disabilitati.
- [x] Tre indici aggiuntivi presenti e `VALID`.
- [x] Log conservato nelle evidenze.

## C. Popolamento del dataset

- [x] `sql/03_dataset.sql` eseguito senza errori bloccanti e con `COMMIT`.
- [x] 98 record complessivi e conteggi per tabella coerenti.
- [x] Tre asset critici.
- [x] Relazioni N:M asset-servizi presenti.
- [x] Relazioni servizio-fornitore presenti.
- [x] Dieci dipendenze tecniche e zero autodipendenze.
- [x] Responsabili e punti di contatto presenti.
- [x] Storici multiversione presenti per asset e servizi.
- [x] Dataset interamente fittizio.

## D. VIEW e query

- [x] `sql/04_views.sql` eseguito senza errori bloccanti.
- [x] VIEW `vw_export_nis2_demo` presente, `VALID` e interrogabile.
- [x] VIEW composta da cinque righe, una per servizio.
- [x] `sql/05_queries.sql` eseguito e ritestato dopo la correzione operativa.
- [x] Q1-Q9 coerenti con il dataset: 3, 5, 7, 21, 31, 1, 3, 3 e 10 righe.
- [x] Storici asset e servizio ricostruiti nell'ordine previsto.

## E. Script di test

- [x] `sql/06_tests.sql` eseguito e ritestato.
- [x] T01-T09: 39 esiti effettivi `OK`.
- [x] Nessun esito effettivo `KO`.
- [x] Zero autodipendenze, duplicati storici e incoerenze correnti.
- [x] Copertura delle relazioni N:M e delle query principali verificata.
- [x] VIEW interrogata con granularità `5 / 5 / 5`, esito `OK`.
- [x] Zero oggetti progettuali `INVALID`.
- N/A – test negativi non previsti: lo script è intenzionalmente di sola lettura.

## F. Export CSV

- [x] `sql/07_export_sqlcl.sql` eseguito con SQLcl.
- [x] CSV reale creato e conservato nelle evidenze.
- [x] Intestazione coerente con le nove colonne della VIEW.
- [x] Cinque righe dati controllate; nove colonne per ciascun record.
- [x] Contenuto coerente con il dataset.
- [x] Natura didattica e non ufficiale rispetto ad ACN documentata.

## G. Verifica tecnica finale – facoltativa

N/A – `sql/08_verifica_finale.sql` non è incluso nel package. I controlli
equivalenti richiesti sono coperti dai log di deploy, query e test.

## H. Esecuzione integrata – facoltativa

N/A – `sql/00_run_all.sql` non è incluso nel package. Gli script obbligatori
sono stati eseguiti singolarmente nell'ordine documentato.

## I. Coerenza con documentazione ed elaborato

- [x] ER diagram, schema relazionale e Data Dictionary corrispondono al DDL testato.
- [x] README e `docs/deploy.md` riportano ordine e ambiente reali.
- [x] Istruzioni di export corrispondenti alla procedura provata.
- [x] Validazione statica ed esecuzione reale chiaramente distinte.
- [x] Versione Oracle e strumento riportati correttamente.
- N/A in questo checkpoint – confronto con il PDF finale, non ancora assemblato;
  da rieseguire durante la redazione finale.

## L. Evidenze conservate

- [x] Log di precheck, deploy, dataset, VIEW/query e test.
- [x] Log del retest della correzione `SQLBLANKLINES`.
- [x] CSV realmente generato.
- [x] Versione Oracle, SQLcl, data e commit annotati.
- [x] Controlli facoltativi/non applicabili esplicitamente elencati.

## Esito complessivo

- [x] **COLLAUDO TECNICO COMPLETO SUPERATO** – tutti i controlli obbligatori
  applicabili al package tecnico sono stati realmente eseguiti con esito positivo.
- [ ] **COLLAUDO PARZIALE**.

### Note e anomalie

Il primo tentativo su FreeSQL 19c non è stato concluso perché lo schema non
disponeva del privilegio `CREATE VIEW`; non è usato come evidenza finale.

Una query manuale di controllo aveva evidenziato la sensibilità alle righe
vuote della sessione SQLcl. Il repository è stato corretto nel commit
`270a94cab30ca825c075c42962b2de36143b7353` aggiungendo
`SET SQLBLANKLINES ON`; il retest è stato eseguito partendo deliberatamente da
`SQLBLANKLINES OFF` ed è terminato senza regressioni.
