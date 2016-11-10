### Installation des librairies (si ce n'est pas déjà fait)
#install.packages("dplyr")
#install.packages("Rtsne")
#install.packages("apcluster")
#install.packages("plotly")

### Ce script permet de clusteriser les métiers, de les représenter graphiquement, 
### et de préparer un fichier d'entrée pour le tf-idf 
### Prérequis : le fichier "PE_niv23.csv" (tableau des métiers et de leurs variables)
rm(list=ls())
# Chemin contenant le tableau des métiers nommé "PE_niv23.csv" 
# et le script R "Clustering.R"
file_path = getwd()
setwd(file_path)

# Chargement du script "Clustering.R"
source("Clustering.R")

# Préparation des données
df_proc = data_preprocessing(file_path)

# Choix de la meilleure perplexité (c'est long à calculer)
## KL = perplex_tsne(df_proc)
## plot(2:15, KL, xlab = "Perplexité", ylab ="Information de KL")

# Calcul t-SNE avec le choix de la perplexité
# perplexity=5, seed = 4, K=20
df = tsne(df_proc, perplexity = 5, seed = 1337)
df_clusters = clustering(df, method="HC", K = 50)
plot_tsne(df_clusters)

# Clustering des métiers : 
# on peut choisir le nombre de clusters K (en fait on obtiendra seulement une valeur
# approchée du nombre de clusters, optimisé par l'algorithme)
# 4 méthodes de classification sont disponibles :
# - "KM" : k-means
# - "HC" : Hierarchical Clustering
# - "SC" : Spectral Clustering
# - "AP" : Affinity Propagation
df_clusters = clustering(df, method="HC", K = 20)
plot_tsne(df_clusters)

# 
#i=1
#metier_similaire = NULL
#for (i in 1:50){
#  df_temp = filter(df_clusters, clusters==i)
#  metier_similaire[i] = list(df_temp$intitule)
#}

# Graphique des clusters
plot_tsne(df_clusters)

# Data frame des clusters
jobs_clusters = clusters(df_clusters)
View(jobs_clusters)

# Data frame des clusters pour les algorithmes KM, HC et SC et comparaison des clusterings
comparaison = comparaison_clusters(df, K)
View(comparaison)

# Caractérisation des clusters
matrix_mean = mean_cluster(df_clusters)
df_mean = cbind(cluster = 1:nrow(matrix_mean), matrix_mean)
mean_scale = scale(matrix_mean)
# t-SNE sur les moyennes des clusters
tsne_mean = Rtsne(matrix_mean, perplexity = 5)
X1 = tsne_mean$Y[,1]
X2 = tsne_mean$Y[,2]
plot_ly(tsne_mean,
        x = X1, y = X2,
        mode = "markers",
        color = as.factor(cl2),
        text = df_mean$cluster)

df_tsne = data.frame(X1, X2)
df_clusters2 = clustering(df_tsne, method = "HC", K = 20)
cl2 = df_clusters2$clusters
cluster2 = NULL
for (i in 1:nrow(df)){
  cluster1 = df_clusters[i,"clusters"]
  cluster2 = c(cluster2, clusters[cluster1])
}

df_clusters = cbind(df_clusters, cluster2)
jobs_clusters2 = cbind(jobs_clusters, cluster2)

df_6 = filter(jobs_clusters, clusters==23)
df_9 = filter(jobs_clusters, clusters==24)
df_19 = filter(jobs_clusters, clusters==19)
df_20 = filter(jobs_clusters, clusters==20)
df_21 = filter(jobs_clusters, clusters==21)

df_69 = rbind(df_6, df_9, df_19,df_20,df_21)
# Liste des variables qui décrivent le mieux le cluster k
main_features_clusters = NULL
for (k in 1:100){
  main_features_clusters = c(main_features_clusters, k, caract_cluster(matrix_mean, k))
}
main_features_clusters
write.table(main_features_clusters, 'Clusters/main_features_clusters.csv',
          row.names = F,
          fileEncoding = 'UTF-8')

caract_cluster(matrix_mean, k=87)
filter(jobs_clusters, clusters==87)
# Sortie au format CSV du fichier d'entrée du tf-idf (code_rome des métiers et clusters associé)
csv_tfidf_output(df_clusters)


# Sortie au format CSV des métiers et des clusters associés
write.csv(df_mean, 'df_mean.csv',
          row.names = F,
          fileEncoding = 'UTF-8')

