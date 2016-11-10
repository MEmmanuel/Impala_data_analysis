library(plotly)
library(dplyr)
setwd("~/PycharmProjects/ImpalaPoleEmploi2/Impala/Coordonnees t-SNE")

df = read.csv("results_tsne_ap_clusters.csv")
X1 = df$X1
X2 = df$X2
metier = df$Metier
clusters = df$ap_clusters


#### Plot dans des carrés ####
df_final = NULL
for (k in 1:n_cluster){
  df_temp = filter(df, ap_clusters==k)
  for (m in 1:nrow(df_temp)){
    Y1 = as.numeric(C[k,1]) + runif(1, -4, 4)
    Y2 = as.numeric(C[k,2]) + runif(1, -4, 4)
    df_temp[m, "Y1"] = Y1
    df_temp[m, "Y2"] = Y2
  }
  df_final = rbind(df_final, df_temp)
}

metier = df_final$Metier
clusters = df_final$ap_clusters
Y1 = df_final$Y1
Y2 = df_final$Y2
plot_ly(df_final,
        x = Y1, y = Y2,
        color = as.factor(clusters),
        text = metier,
        mode = "markers")


df_X = cbind(X1,X2)
d1 = dist(df_X, "euclidean")
min(d1)
m=1
for(m in 1:nrow(df)){
  if (df[m,"X1"]>0){
    df[m,"Z1"] = df[m,"X1"] + 10 * min(d)
  }
  else {
    df[m,"Z1"] = df[m,"X1"] - 10 * min(d)
  }
  if (df[m,"X2"]>0){
    df[m,"Z2"] = df[m,"X2"] + 10 * min(d)
  }
  else {
    df[m,"Z2"] = df[m,"X2"] - 10 * min(d)
  }
}
summary(d1)
m=6
j=
for (j in 1:592){
  d = c(d, sqrt( ((df[m,"X1"]-df[j,"X1"])^2 + (df[m,"X2"] - df[j,"X2"])^2) ))
}
min(d[8:592])
c=0
for(m in seq(from=1, to=592, by=1)){
  df[m,"Z1"] = df[m,"X1"] + runif(1, -0.5, 0.5)
  df[m+1,"Z2"] = df[m+1,"X2"] + runif(1, -0.5, 0.5)
}

Z1=df$Z1
Z2=df$Z2
plot_ly(df,
        x = Z1, y = Z2,
        color = as.factor(clusters),
        text = metier,
        mode = "markers")

min(d1)
C=NULL
for (i in 1:4){
  Y1 = 10*i
  for (j in 1:3){
    Y2 = 10*j
    C = rbind(C,list(Y1,Y2))
  }
}

df_final = NULL
for (k in 1:n_cluster){
  df_temp = filter(df, ap_clusters==k)
  for (m in 1:nrow(df_temp)){
    Y1 = as.numeric(C[k,1]) + runif(1, -4, 4)
    Y2 = as.numeric(C[k,2]) + runif(1, -4, 4)
    df_temp[m, "Y1"] = Y1
    df_temp[m, "Y2"] = Y2
  }
  df_final = rbind(df_final, df_temp)
}

write.csv(df_final, "results.csv",
          row.names = F)

df = read.csv("results.csv")
metier = df_final$Metier
clusters = df_final$ap_clusters
Y1 = df_final$Y1
Y2 = df_final$Y2
plot_ly(df_final,
        x = Y1, y = Y2,
        color = as.factor(clusters),
        text = metier,
        mode = "markers")

