require(dplyr)
require(data.table)
require(Rtsne)
require(readr)
require(tidyr)
require(ggplot2)
require(lintr)
require(plotly)
require(mice)
require(apcluster)

# Dossier de travail
file.path = getwd()
setwd(file.path)

# Chargement des données
df = read.csv("table_onisep.csv", header=T)

# Si les salaires débutants sont manquants, on les remplace par le salaire médian
df[is.na(df['Salaire.débutant']), 'Salaire.débutant'] = 
  median(df[!is.na(df['Salaire.débutant']), 'Salaire.débutant'])

# Plusieurs vecteurs métiers sont identiques. Pour les distinguer un peu,
# on ajoute du bruit dans les salaires
df_train <- df %>% 
  mutate(Salaire.débutant = jitter(Salaire.débutant))

# Normalisation (entre 0 et 1) des salaires débutants
# et suppression des variables inutiles pour le calcul des coordonnées
df_train <- df %>% 
         mutate(Salaire.débutant = jitter(Salaire.débutant),
                Salaire.débutant.norm = (Salaire.débutant - min(Salaire.débutant))/ 
                                (max(Salaire.débutant) - min(Salaire.débutant)),
                diplome.norm = (Niveau.diplome - min(Niveau.diplome)) / 
                                (max(Niveau.diplome) - min(Niveau.diplome))) %>%
  select(-Salaire.débutant, -Code.Onisep, -Métier, -X, -Niveau.diplome) %>%
  distinct(.)

# Matrice des données
df_train[is.na(df_train)] = 0          
train_matrix = as.matrix(df_train)

#tsne_global
# Pour changer l'aspect de la carto : on peut faire varier le seed et la perplexité
set.seed(47)
tsne_global <- Rtsne(train_matrix, perplexity = 30, theta = 0.0) 
results <- bind_cols(df, data.frame(tsne_global$Y))

plot_ly(results,
        x = X1, y = X2, color = results$diplome.norm,
        text = results$Métier, mode = "markers")

# affinity propagation
# Pour changer le nombre de clusters : faire varier q entre 0 et 1 
# (q=1 --> chaque point est un cluster)
# (q=0 --> tous les points sont dans le même cluster)
apres <- apcluster(negDistMat(r=2), tsne_global$Y, details=TRUE, q=0.1)
clusters = labels(apres, "enum")
plot_ly(results,
        x = X1, y = X2, color = as.factor(clusters),
        text = results$Métier, mode = "markers")
output <- bind_cols(results, as.data.frame(clusters))

# Copie du résultat dans un fichier CSV
write.csv(output, 'results_tsne_ap_clusters.csv',
          row.names = F,
          fileEncoding = 'UTF-8')

