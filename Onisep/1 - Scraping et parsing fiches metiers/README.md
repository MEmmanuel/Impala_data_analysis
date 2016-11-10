Le dossier '0 - Data' contient :
-- 'MetiersOnisep' : les fiches de l'Onisep au format XML (fourni par l'Onisep)
-- 'Onisep_metier_link.csv' : la liste des métiers de l'Onisep et des liens vers les fiches du site internet (disonible sur data.gouv.fr)
-- 'ONISEP_vs_PE.csv' : la liste de 592 métiers et des codes ROME associés

Le dossier '00 - Parsing output' contient les fiches métiers au format XML de l'Onisep transformées en format JSON à l'aide du script 'Onisep_jobs_XML_parser.ipynb'.

Le dossier '00 - Scraping output' contient les fiches métiers du site internet de l'Onisep scrapées au format JSON à l'aide du script 'Onisep_jobs_scraper.ipynb'.

Les fichiers 'Metiers_Onisep_ROME.csv' et 'Metiers_Onisep_ROME.xlsx' contiennent la liste des 733 métiers de l'Onisep avec :
- l'intitulé des métiers du fichier 'Onisep_metier_link.csv'
- le lien vers la fiche sur le site de l'Onisep
- le code Onisep du métier
- l'intitulé du métier sur le site de l'Onisep
- l'intitulé du métier dans les fiches au format XML envoyées par l'Onisep
- l'association entre métier de l'Onisep et code ROME faite par Antoine et Adel (592 métiers sur 733)
- l'association ente métier de l'Onisep et code ROME faite par l'Onisep
Ce fichier est obtenu à l'aide du script 'Onisep_merger.ipynb'