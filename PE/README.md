Le dossier PE contient tous les développements en rapport avec les données de Pôle Emploi, sauf le Questionnaire version POC :

- le dossier '0 - PE data cleaner' contient le script pour transformer les fiches XML de Pôle Emploi au format JSON.

- le dossier '1 - Data Preprocessing' prépare les données de Pôle Emploi pour être traitées sur R et leur appliquer le t-SNE et un clustering.

- le dossier '2 - Clustering' contient les scripts pour appliquer le t-SNE et le clustering aux données de Pôle Emploi.

- le dossier '3 - Appelations PE' permet de créer un dictionnaire JSON : {code_rome : [appelations_metiers]}

- le dossier '4 - Clean ArborescencesActivitesCompetences' contient le premier nettoyage des arborescences de Pôle Emploi pour changer les intitulés des activités et des compétences.

- le dossier '5 - Jobs Intitulés Critères Similarités' crée un dictionnaire 'jobs_ifs.json' : 
{code_rome:{
	sim_jobs :[jobs similaires des fiches métiers de Pôle Emploi],
	features :[liste des libellés des compétences et activités des fiches métiers de PE],
	intitule :[liste des appelations de la fiche métier]
}}

- le dossier '6 - Clusters tf-idf' contient les scripts permettant de calculer le tf-idf des clusters de métiers (chaque cluster est représenté par les définitions des métiers qui le composent)