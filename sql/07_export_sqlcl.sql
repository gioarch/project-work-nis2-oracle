-- ============================================================
-- Project Work L-31
-- STEP 10 - Export CSV mediante Oracle SQLcl
-- File: 07_export_sqlcl.sql
--
-- Eseguire dopo 04_views.sql in una sessione Oracle SQLcl.
-- VALIDAZIONE: statica e logico-referenziale.
-- ESECUZIONE REALE: CSV generato su Oracle AI Database 26ai con SQLcl 26.2.2.
-- ============================================================

-- SQLFORMAT csv configura SQLcl per rappresentare il risultato in formato CSV.
SET SQLFORMAT csv

-- SPOOL scrive nel file indicato tutto l'output prodotto fino a SPOOL OFF.
SPOOL export_nis2_demo.csv

SELECT *
FROM vw_export_nis2_demo
ORDER BY id_servizio;

SPOOL OFF
