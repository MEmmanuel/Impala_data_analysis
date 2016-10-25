# Ce script prend en entrée l'arborescence des compétences au format xlxs et sort un document JSON qui reprend
# les informations utiles
import os
import pandas as pd
import json

# Préparation des chemins utiles
dir_path = os.path.dirname(os.path.realpath(__file__))
# Arborescence des compétences
competences_data = os.path.join(arbo_dir_path, 'ArborescencesActivitesCompetences/rome_arbocompétences_juin62182.xlsx')
# Fichier de sortie
competences_output = os.path.join(dir_path, 'fichier_donnees/competences.json')

#Chargement des données dans un dataframe pandas
sheetname = 'Arbo Comptétences ROMEJuin 2016'
header = 0
skiprows = 0
Data = pd.read_excel(competences_data, sheetname, header, skiprows)

# Nombre de métiers
data_range = len(Data)

#Création du dictionnaire
data_dict = {}

i = 0
niv1 = 'nan'
niv2 = 'nan'
niv3 = 'nan'
niv4 = 'nan'
list_same_niv = []
while i < data_range:
    if not type(Data.iloc[i,4]) == str:
        list_same_niv = []
        if type(Data.iloc[i,0]) == str:
            niv1 = Data.iloc[i,0]
            niv2 = 'nan'
            niv3 = 'nan'
            niv4 = 'nan'
            i += 1
            data_dict[niv1] = {}
        if type(Data.iloc[i,1]) == str:
            niv2 = Data.iloc[i,1]
            niv3 = 'nan'
            niv4 = 'nan'
            i += 1
            data_dict[niv1][niv2] = {}
        if type(Data.iloc[i,2]) == str:
            niv3 = Data.iloc[i,2]
            niv4 = 'nan'
            i += 1
            data_dict[niv1][niv2][niv3] = {}
        if type(Data.iloc[i,3]) == str:
            niv4 = Data.iloc[i,3]
            i += 1
            data_dict[niv1][niv2][niv3][niv4] = []

    if  type(Data.iloc[i,4]) == str:
        list_same_niv.append([Data.iloc[i,4], Data.iloc[i,5]])
        i += 1
    if i == data_range:
        try:
            data_dict[niv1][niv2][niv3][niv4] = list_same_niv
        except:
            data_dict[niv1][niv2][niv3] = {}
            try:
                data_dict[niv1][niv2][niv3][niv4] = list_same_niv
            except:
                data_dict[niv1][niv2] = {}
                try:
                    data_dict[niv1][niv2][niv3][niv4] = list_same_niv
                except:
                    data_dict[niv1] = {}
                    data_dict[niv1][niv2][niv3][niv4] = list_same_niv      
        break
    if not type(Data.iloc[i,4]) == str:        
        try:
            data_dict[niv1][niv2][niv3][niv4] = list_same_niv
        except:
            data_dict[niv1][niv2][niv3] = {}
            try:
                data_dict[niv1][niv2][niv3][niv4] = list_same_niv
            except:
                data_dict[niv1][niv2] = {}
                try:
                    data_dict[niv1][niv2][niv3][niv4] = list_same_niv
                except:
                    data_dict[niv1] = {}
                    data_dict[niv1][niv2][niv3][niv4] = list_same_niv                   

# Copie des données au format JSON
with open(competences_output, 'w') as f:
        f.write(json.dumps(data_dict, indent=4))