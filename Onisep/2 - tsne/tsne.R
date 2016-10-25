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

file.path = "~/PycharmProjects/ImpalaPoleEmploi2/Impala/Onisep/tsne"
setwd(file.path)

df = read.csv("table_onisep.csv", header=T)

df[is.na(df['Salaire.débutant']), 'Salaire.débutant'] = median(df[!is.na(df['Salaire.débutant']), 'Salaire.débutant'])

df_train <- df %>% 
  mutate(Salaire.débutant = jitter(Salaire.débutant))

df_train <- df %>% 
         mutate(Salaire.débutant = jitter(Salaire.débutant),
                Salaire.débutant.norm = (Salaire.débutant - min(Salaire.débutant))/ 
                                (max(Salaire.débutant) - min(Salaire.débutant)),
                diplome.norm = (Niveau.diplome - min(Niveau.diplome)) / 
                                (max(Niveau.diplome) - min(Niveau.diplome))) %>%
  select(-Salaire.débutant, -Code.Onisep, -Métier, -X, -Niveau.diplome) %>%
  distinct(.)

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
apres <- apcluster(negDistMat(r=2), tsne_global$Y, details=TRUE, q=0.1)
clusters = labels(apres, "enum")
plot_ly(results,
        x = X1, y = X2, color = as.factor(clusters),
        text = results$Métier, mode = "markers")



## show details of clustering results
show(apres)

## plot clustering result
plot(apres, tsne_global$Y)

## plot heatmap
heatmap(apres)

## run affinity propagation with default preference of 10% quantile
## of similarities; this should lead to a smaller number of clusters
## reuse similarity matrix from previous run
apres <- apcluster(s=apres@sim, q=0.1)
show(apres)
plot(apres, tsne_global$Y)
clusters = labels(apres, "enum")

plot_ly(results,
        x = X1, y = X2, color = as.factor(clusters),
        text = results$Métier, mode = "markers")


ap_clusters <- apres@clusters
df_ap_clusters <- data.frame(jobs_id = integer(),
                             ap_clusters = integer(),
                             stringsAsFactors = F)

df_temp <- data.frame(ap_clusters = integer(),
                      jobs_id = integer(),
                      stringsAsFactors = F)
