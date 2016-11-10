Le dossier '0 - Data' contient :
-- 'MetiersOnisep' : les fiches de l'Onisep au format XML (fourni par l'Onisep)
-- 'Onisep_metier_link.csv' : la liste des métiers de l'Onisep et des liens vers les fiches du site internet (disonible sur data.gouv.fr)
-- 'ONISEP_vs_PE.csv' : la liste de 592 métiers et des codes ROME associés

Le dossier '00 - Scraping output' contient les fiches métiers du site internet de l'Onisep scrapées au format JSON à l'aide du script 'Onisep_jobs_scraper.ipynb'.

Le script 'Onisep_tsne_Preprocessing.ipynb' permet de préparer les données des fiches métiers pour les traiter sur R. Chaque métier est représenté par un vecteur avec comme variables :
- les centres d'intérêt (variables égales à 1 si le centre d'intérêt est présent dans la fiche métier et 0 sinon)
- les secteurs d'activités
- les statuts
- le salaire débutant
- le niveau d'études pour accéder au métier
Le data frame final est copié dans le fichier 'table_onisep.csv'.

Le script R 'tsne.R' permet de traiter les données du data frame "table_onisep.csv" et de calculer les coordonnées des points de la carto obtenue à l'aide du t-SNE. Le résultat est copié dans le fichier 'results_tsne_ap_clusters.csv' et contient :
- le code métier de l'Onisep
- l'intitulé du métier
- les valeurs des variables des métiers
- les coordonnées du t-SNE de chaque métier
- le cluster de chaque métier