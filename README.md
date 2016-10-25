# Impala_data_analysis
Permet de réaliser un clustering des métiers en choisissant le nombre de clusters souhaités puis de sortir visualiser le tf-idf 

# Prérequis :
**R** https://www.r-project.org/

**Rstudio** https://www.rstudio.com/

**Python 3.0 ou plus**

**Jupyter Notebook**

# Clustering des métiers : "Main.R"
Ce script permet de clusteriser les métiers, de les représenter graphiquement, et de préparer un fichier d'entrée pour le tf-idf.

Ouvrir le fichier "Main.R" dans Rstudio.
Installer les librairies (seulement pour la première utilisation),
remplacer le chemin vers le dossier "Clustering",
et exécuter les lignes du script (ctrl + enter)

Le fichier "jobs_clusters.csv" contient les métiers et leurs clusters


# tfidf des clusters
Permet de sortir le tf-idf des définitions des métiers de chaque cluster. Le tf_idf donne l'importance d'un terme contenu dans un cluster, relativement aux autres clusters.

## Ouvrir le notebook tfidf_data_preprocessing.
Remplacer les chemins suivants :
- "metiers_dir_path" est le chemin vers le dossier "fiches_metiers"
- "PE_clusters_file" est le chemin vers le fichier "PE_clusters.csv"
- "jobs_cluster_file" est le chemin vers le fichier de sortie (qui servira dans le script suivant

Exécuter toutes les cellules du script

## Ouvrir le notebook tfidf
Remplacer les chemins suivants 
- "metiers_dir_path"est le chemin vers le fichier "jobs_cluster.json"
- "tf_idf_file" est le fichier de sortie du tf-idf

Le résultat est au format JSON dans le fichier "tf_idf.json"
