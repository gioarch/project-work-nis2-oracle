# Project Work L-31 — Oracle Database e NIS2

## Scopo

Repository tecnico didattico per il Project Work L-31. Il progetto implementa
in Oracle Database un modello relazionale per organizzare asset, servizi,
fornitori, responsabilità, punti di contatto, dipendenze tecniche e versioni
storiche, oltre a una VIEW destinata a un'esportazione CSV dimostrativa.

## Stato del repository remoto

Il package tecnico è pubblicato nel repository GitHub:

- repository: <https://github.com/gioarch/project-work-nis2-oracle>;
- branch principale: `main`;
- clone HTTPS: `git clone https://github.com/gioarch/project-work-nis2-oracle.git`.

Il contenuto pubblicato corrisponde al package tecnico validato per lo Step 12.

## DBMS e prerequisiti

- Oracle Database 12c o successivo per il supporto alle colonne `IDENTITY`;
- Oracle SQLcl per l'esportazione CSV mediante `SET SQLFORMAT csv` e `SPOOL`;
- in alternativa, SQL Developer per l'esecuzione manuale degli script SQL;
- uno schema utente dedicato e vuoto, con privilegi ordinari di creazione degli
  oggetti necessari;
- codifica UTF-8 per file e sessione client.

Il progetto è stato validato staticamente e poi eseguito su una reale
istanza Oracle Database.

## Struttura

```text
project-work-nis2-oracle/
├── README.md
├── sql/
│   ├── 01_schema.sql
│   ├── 02_indexes.sql
│   ├── 03_dataset.sql
│   ├── 04_views.sql
│   ├── 05_queries.sql
│   ├── 06_tests.sql
│   └── 07_export_sqlcl.sql
├── docs/
│   ├── er_diagram.png
│   ├── data_dictionary.md
│   ├── deploy.md
│   └── popolamento_manutenzione.md
└── relazione/
    └── README.md
```

`relazione/project_work.pdf` è stato aggiunto dopo la redazione e
l'assemblaggio finale previsti dal workflow; non viene creato un PDF segnaposto.

## Ordine di esecuzione

1. `sql/01_schema.sql` — crea le 13 tabelle e i vincoli;
2. `sql/02_indexes.sql` — crea i tre indici aggiuntivi motivati;
3. `sql/03_dataset.sql` — carica 98 record fittizi e conclude con `COMMIT`;
4. `sql/04_views.sql` — crea `vw_export_nis2_demo`;
5. `sql/05_queries.sql` — esegue le query dimostrative Q1–Q9;
6. `sql/06_tests.sql` — produce i risultati dei test di sola lettura;
7. `sql/07_export_sqlcl.sql` — genera `export_nis2_demo.csv` tramite SQLcl.

Le istruzioni operative complete sono in [`docs/deploy.md`](docs/deploy.md).

## Dataset e test

Il dataset riguarda la società fittizia **Digital Services Srl**. Nomi,
fornitori e recapiti sono esplicitamente dimostrativi; le email usano il dominio
riservato `.invalid`.

`sql/06_tests.sql` verifica conteggi, copertura funzionale, relazioni N:M,
assenza di auto-dipendenze, unicità e ricostruibilità delle versioni storiche,
risultati significativi delle query e interrogabilità della VIEW.

I valori `OK` previsti nei test sono condizioni calcolate dalle query: non sono
evidenze di esecuzione finché lo script non viene eseguito realmente su Oracle.

## Generazione del CSV

Dopo la creazione della VIEW, eseguire con Oracle SQLcl:

```text
@sql/07_export_sqlcl.sql
```

Lo script genera `export_nis2_demo.csv` nella directory di lavoro del client.
Il CSV non è incluso nel repository finché non viene prodotto da un'esecuzione
reale.

## Validazione statica ed esecuzione reale

La validazione svolta comprende coerenza tra DDL, dataset, query, VIEW, Data
Dictionary e test. Non equivale a un deploy o a un collaudo su Oracle.

Non sono quindi dichiarati come realmente avvenuti:

- creazione di tabelle, indici o VIEW;
- caricamento del dataset;
- esecuzione delle query e dei test;
- generazione del CSV.

## Natura didattica e disclaimer ACN

La VIEW `vw_export_nis2_demo` è una soluzione didattica sviluppata per
soddisfare la richiesta di estrazione strutturata del Project Work. I campi
selezionati sono campi minimi progettuali derivati dal modello dati e dalla
traccia. La VIEW e il relativo CSV non riproducono la Piattaforma ACN, il
modello ufficiale di categorizzazione né un tracciato CSV ufficiale ACN.

## Pubblicazione GitHub

Il repository pubblico usa `main` come branch principale ed è raggiungibile
all'URL <https://github.com/gioarch/project-work-nis2-oracle>. Per ottenere una
copia locale:

```text
git clone https://github.com/gioarch/project-work-nis2-oracle.git
```

Nessun dato di autenticazione, token, password o stringa di connessione deve
essere inserito nel repository.
