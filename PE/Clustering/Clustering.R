library(dplyr)
library(Rtsne)
library(apcluster)
library(plotly)
library(kernlab)

# Préparation des données
data_preprocessing = function(df_path){
  ### Chargement des données
  df_init = read.csv("PE_niv23.csv", header=T)
  n = nrow(df_init)
  p = ncol(df_init)
  df_temp = df_init[4:p] 
  df_temp = df_temp[,colSums(df_temp) > 0]
  df = data.frame(df_init[1:3],df_temp)
  p = ncol(df)
  
  ### Normalisation 
  df[,4:p] = scale(df[,4:p])
  
  return(df)
}

# Choix de la meilleure perplexité dans l'algorithme t-SNE
perplex_tsne = function(df){
  p=ncol(df)
  ### Matrice des données
  df_matrix = as.matrix(df[, 4:p])
  ### Information de KL
  KL = NULL
  for (i in 2:15){
    set.seed(1)
    res_tsne = Rtsne(df_matrix, perplexity = i, theta = 0.0)
    len = length(res_tsne$itercosts)
    KL = c(KL, res_tsne$itercosts[len])
  }
  plot(2:15, KL,      
       xlab = "Perplexité", 
       ylab ="Information de KL")
  return(KL)
}

# t-SNE 
tsne = function(df, perplexity=5,seed){
  p = ncol(df)
  ### Matrice des données
  df_matrix = as.matrix(df[, 4:p])
  
  ### Calcul des coordonnées des points obtenus par le t-SNE
  set.seed(seed)
  res_tsne = Rtsne(df_matrix, perplexity = perplexity, theta = 0.0)
  X1 = res_tsne$Y[,1]
  X2 = res_tsne$Y[,2]
  ### Data frame contenant les coordonnées du t-SNE de chaque métier
  return(df_clusters = data.frame(df, X1, X2))
}  
  
# Clustering obtenu à partir de la cartographie du t-SNE
clustering = function(df, method, K){
  set.seed(1)
  X1 = df$X1
  X2 = df$X2
  df_tsne = cbind(X1, X2)
  if (method=="KM"){
    km = kmeans(df_tsne, K)
    clusters = km$cluster
    cluster_size = summary(km$size)
  }
  if (method=="HC"){
    d = dist(df_tsne, method = "euclidean")
    hc = hclust(d, method = "ward.D")
    clusters = cutree(hc, K)
    hc_size = NULL
    for (i in 1:K){
      hc_size=c(hc_size, sum(clusters==i))
    }
    cluster_size = summary(hc_size)
  }
  if (method=="SC"){
    sc = specc(df_tsne, K)
    clusters = sc
    cluster_size = summary(sc@size)
  }
  if (method=="AP"){
    ap = apclusterK(negDistMat(r=2), df_tsne, K, details=TRUE)
    clusters = labels(ap, "enum")
    cluster_ap = as.numeric(summary(ap@clusters)[,1])
    cluster_size = summary(cluster_ap)
  }
  print(cluster_size)
  return(df_clusters = data.frame(df, clusters))
}



### Graphique des points du t-SNE et de leur cluster
plot_tsne = function(df_clusters){
  X1 = df_clusters$X1
  X2 = df_clusters$X2
  # Graphique des points du t-SNE et de leur cluster
  plot_ly(df_clusters,
          x = X1, y = X2,
          color = as.factor(df_clusters$clusters),
          mode = "markers",
          text = intitule)
}

# Comparaison des clusters
minWeightBipartiteMatching <- function(clusteringA, clusteringB) {
  require(clue)
  idsA <- unique(clusteringA)  # distinct cluster ids in a
  idsB <- unique(clusteringB)  # distinct cluster ids in b
  nA <- length(clusteringA)  # number of instances in a
  nB <- length(clusteringB)  # number of instances in b
  if (length(idsA) != length(idsB) || nA != nB) {
    stop("number of cluster or number of instances do not match")
  }
  
  nC <- length(idsA)
  tupel <- c(1:nA)
  
  # computing the distance matrix
  assignmentMatrix <- matrix(rep(-1, nC * nC), nrow = nC)
  for (i in 1:nC) {
    tupelClusterI <- tupel[clusteringA == i]
    solRowI <- sapply(1:nC, function(i, clusterIDsB, tupelA_I) {
      nA_I <- length(tupelA_I)  # number of elements in cluster I
      tupelB_I <- tupel[clusterIDsB == i]
      nB_I <- length(tupelB_I)
      nTupelIntersect <- length(intersect(tupelA_I, tupelB_I))
      return((nA_I - nTupelIntersect) + (nB_I - nTupelIntersect))
    }, clusteringB, tupelClusterI)
    assignmentMatrix[i, ] <- solRowI
  }
  
  # optimization
  result <- solve_LSAP(assignmentMatrix, maximum = FALSE)
  attr(result, "assignmentMatrix") <- assignmentMatrix
  return(result)
}

# Permute les labels des clusters CL1 pour les faire correspondre au mieux avec les labels de CL2
permutation = function(CL1, CL2){
  n_cluster = length(CL1)
  matching = minWeightBipartiteMatching(CL1, CL2)
  CL1_perm = CL1
  for (i in 1:n_cluster){
    CL1_perm[which(CL1 == i)] = matching[i]
  }
  return(CL1_perm)
}

# Data frame des clusters pour les algorithmes KM, HC et SC et comparaison des clusterings
comparaison_clusters = function(df, K=100){
  # Calcul des clusters
  df_clusters_AP = clustering(df, method="AP", K = 100)
  n_cluster = length(unique(df_clusters_AP$clusters))
  df_clusters_KM = clustering(df, method="KM", K = n_cluster)
  df_clusters_HC = clustering(df, method="HC", K = n_cluster)
  df_clusters_SC = clustering(df, method="SC", K = n_cluster)
  # Vecteurs des clusters
  KM = df_clusters_KM$clusters
  HC = df_clusters_HC$clusters
  SC = df_clusters_SC$clusters
  AP = df_clusters_AP$clusters
  # Permutation des labels
  hc_km_perm = permutation(HC, KM)
  sc_km_perm = permutation(SC, KM)
  ap_km_perm = permutation(AP, KM)
  sc_hc_perm = permutation(SC, HC)
  ap_hc_perm = permutation(AP, HC)
  ap_sc_perm = permutation(AP, SC)
  # Nombre d'occurences différentes
  diff_hc_km = sum(KM != hc_km_perm)/n
  diff_sc_km = sum(KM != sc_km_perm)/n
  diff_ap_km = sum(KM != ap_km_perm)/n
  diff_sc_hc = sum(HC != sc_hc_perm)/n
  diff_ap_hc = sum(HC != ap_hc_perm)/n
  diff_ap_sc = sum(SC != ap_sc_perm)/n
  
  comparaison = data.frame(km = c(km = 1, hc = diff_hc_km, sc =diff_sc_km, ap = diff_ap_km),
                           hc =c(diff_hc_km, 1, diff_sc_hc, diff_ap_hc), 
                           sc =c(diff_sc_km, diff_sc_hc, 1, diff_ap_sc),
                           ap =c(diff_ap_km, diff_ap_hc, diff_ap_sc, 1))
  return(comparaison)
}
  
### Création d'un data frame contenant les code rome, les intitulés et les clusters des métiers
clusters = function(df_clusters){
  intitule = df_clusters$intitule
  code_rome = df_clusters$code_rome
  clusters = df_clusters$clusters
  return(jobs_clusters = data.frame(code_rome, intitule, clusters))
}  


### Fonction qui crée un data frame contenant les numéros des clusters
### et la moyenne des variables des métiers de chaque cluster
mean_cluster = function(df){
  n_cluster = max(as.numeric(df$clusters))
  p = 170
  clusters = df$clusters
  
  df_mean = NULL
  df_temp = filter(df[,4:p],clusters==1) 
  cluster_mean = apply(df_temp, 2, mean) 
  df_mean = data.frame(t(cluster_mean)) 
  for (i in 2:n_cluster){
    df_temp = filter(df[,4:p],clusters==i)
    cluster_mean = apply(df_temp, 2, mean)
    df_mean = rbind(df_mean, t(cluster_mean))
  }
  return(df_mean)
}

### Variables caractéristiques du cluster k
caract_cluster = function(df_mean, k){
    # Liste des variables
    var_names = colnames(df_mean)
    
    # Quantile des variables dans le data frame df_mean
    df_quantile = apply(df_mean, 2, function(x) quantile(x,probs=0.94))
    
    # Liste des variables prépondérantes dans la description des clusters
    bool = df_mean[k,] > df_quantile
    return(var_names[bool])
}

# Sortie au format CSV des code_rome des métiers et des clusters associés
csv_tfidf_output = function(df_clusters){
  code_rome = df_clusters$code_rome
  clusters = df_clusters$clusters
  output = data.frame(code_rome, clusters)
  write.csv(output, 'PE_clusters.csv',
            row.names = F,
            fileEncoding = 'UTF-8')
}