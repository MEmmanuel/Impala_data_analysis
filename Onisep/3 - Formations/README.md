Le dossier '0 - Data' contient :
-- 'Malek_Metier_Formation.csv' : l'association métier/formation scrapée par Malek
-- 'Onisep_etablissement_superieur.csv' : la liste des établissements supérieurs (disponible sur data.gouv.fr)
-- 'Onisep_formation.csv' : la liste des formations recensées par l'Onisep (disponible sur data.gouv.fr)
-- 'Onisep_metier_link.csv' : les liens vers les pages webs des métiers de l'Onisep


Le dossier '1 - Scraping Exemples Formations' contient :
-----> le script 'Scraping Exemples Formations.ipynb' qui scrape les exemples de formations des fiches métiers du site de l'Onisep et crée deux dictionnaires JSON :
--> "metier_formation.json" : {metier : [formations]}
--> "metier_acces.json" : {metier : ["texte de l'onglet "Accès au métier] } 
-----> le script 'Stats exemples metiers formations' calcule certaines statistiques des exemples de formations et la liste des métiers sans exemple de formations


Le dossier '2 - Metier Dict Maker' contient :
-----> le dossier 'data'
-----> le script 'Metier_dict_maker.ipynb' : crée deux dictionnaires JSON :
-- 'metier_TypeFormation.json' : {Métiers : [types de formations] }
-- 'metier_TypeFormation_Formation.json' :  {Métiers : {types de formations : [formations]}}
-----> le script 'Stats_metier_dict.ipynb' : statistiques sur les dictionnaires 'metier_TypeFormation' et 'metier_TypeFormation_Formation'


Le dossier '3 - Formations Scraper' contient :
-----> un dossier output
-----> le script 'Formations_scraper.ipynb' : scrape les formations de l'Onisep à partir de la liste des formations disponible sur 'data.gouv.fr' et crée un dictionnaire :
-- {Formations : 
		{Débouchés professionnels : 
			{Débouchés : 
				["texte de l'onglet Débouchés professionnels de la fiche formation"],
			Exemples de débouchés : 
				[exemples de métiers]
			},
		Poursuivre mes études : {
			Pousuivre : 
				["texte de l'onglet Poursuivre mes études de la fiche formation"],
			Exemples de formations poursuivies :
				[exemples de formations poursuivies]
			},
		Accès au métier :{
			Accès :
				["texte de l'onglet Accès au métier de la fiche formation"],
			Exemples de formations requises :
				[exemples de formations requises]
			}
		}
	}
-- Les formations qui n'ont aucun des trois onglets sont répertoriées dans la liste 'errors.json'
-----> le script "Stats formations Onisep" : donne des statistiques sur le dictionnaire :
Nombre de formations avec des infos = 2404
Nombre de formations avec Débouchés professionnels = 2401
Nombre de formations avec Accès à la formation = 342
Nombre de formations avec Poursuivre mes études... = 483


Le dossier '4 - Metier niveau diplome' contient :
-----> le script 'Metier niveau diplome.ipynb' calcule le niveau d'étude de chaque métier en fonction des exemples de formations requises.
Pas forcément utile vu que le niveau est en fait déjà indiqué dans les fiches métiers.

