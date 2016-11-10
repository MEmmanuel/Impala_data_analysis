# -*- coding: utf-8 -*-
import os
import logging
from lxml import etree
import json

# Préparation des chemins utiles
dir_path = os.path.dirname(os.path.realpath(__file__))
metiers_dir_path = os.path.join(dir_path, 'ficheMetierXml')
list_xml_files = os.listdir(metiers_dir_path)

log = logging.getLogger()
map(log.removeHandler, log.handlers[:])
map(log.removeFilter, log.filters[:])

logging.basicConfig(level=logging.DEBUG,
                    format='%(asctime)s %(name)-12s %(levelname)-8s %(message)s',
                    datefmt='%m-%d %H:%M',
                    filemode='w')

# define a Handler which writes INFO messages or higher to the sys.stderr
console = logging.StreamHandler()
console.setLevel(logging.INFO)
# set a format which is simpler for console use
formatter = logging.Formatter('%(name)-12s: %(levelname)-8s %(message)s')
# tell the handler to use this format
console.setFormatter(formatter)
# add the handler to the root logger
log.addHandler(console)

#This function put all the information of the xml file into a dictionnary
def parse_xml_file(fiche):
    fiche_dict = {}
    log.info(fiche)
    tree = etree.parse(metiers_dir_path + '/' + fiche)
    root = tree.getroot()
    log.info(root)
    def parse_bloc_code_rome(bloc):
        bloc = bloc[0]
        fiche_dict['code_rome'] = bloc.xpath('code_rome')[0].text
        fiche_dict['intitule'] = bloc.xpath('intitule')[0].text
        fiche_dict['code_ogr'] = bloc.xpath('code_ogr')[0].text
        pass

    def parse_bloc_appellation(bloc):
        log.info(bloc)
        bloc = bloc[0]
        fiche_dict['parse_appellation'] = 1
        def parse_itemapp(bloc_item):
            item_app_dict = {}
            item_app_dict['code_ogr'] = bloc_item.xpath('code_ogr')[0].text
            item_app_dict['libelle'] = bloc_item.xpath('libelle')[0].text
            item_app_dict['libelle_court'] = bloc_item.xpath('libelle_court')[0].text
            item_app_dict['priorisation'] = bloc_item.xpath('priorisation')[0].text
            return item_app_dict

        fiche_dict['appelations'] = [parse_itemapp(tmp) for tmp in bloc]
        pass

    def parse_description(bloc):
        fiche_dict['definition'] = bloc.xpath('//definition')[0].text
        fiche_dict['acces_emploi_metier'] = bloc.xpath('//acces_emploi_metier')[0].text
        fiche_dict['condition_exercice_activite'] = bloc.xpath('//condition_exercice_activite')[0].text
        pass

    def parse_bloc_environnement_de_travail(bloc):
        log.info(bloc)
        bloc = bloc[0]
        fiche_dict['parse_appellation'] = 1
        def parse_itemapp(bloc_item):
            item_app_dict = {}
            item_app_dict['code_ogr'] = bloc_item.xpath('code_ogr')[0].text
            item_app_dict['libelle'] = bloc_item.xpath('libelle')[0].text
            item_app_dict['code_type_section_env'] = bloc_item.xpath('code_type_section_env')[0].text
            item_app_dict['priorisation'] = bloc_item.xpath('priorisation')[0].text
            return item_app_dict

        fiche_dict['environnement_travail'] = [parse_itemapp(tmp) for tmp in bloc]
        pass

    def parse_activites_de_base(bloc):
        log.info(bloc)
        bloc = bloc[0]
        fiche_dict['activites_de_base'] = 1
        def parse_itemab(bloc_item):
            item_app_dict = {}
            item_app_dict['code_ogr'] = bloc_item.xpath('code_ogr')[0].text
            item_app_dict['libelle'] = bloc_item.xpath('libelle')[0].text
            item_app_dict['code_type_activite'] = bloc_item.xpath('code_type_activite')[0].text
            item_app_dict['code_type_item_activite'] = bloc_item.xpath('code_type_item_activite')[0].text
            item_app_dict['position_item'] = bloc_item.xpath('position_item')[0].text
            item_app_dict['priorisation'] = bloc_item.xpath('priorisation')[0].text
            item_app_dict['riasec_majeur'] = bloc_item.xpath('riasec_majeur')[0].text
            try:
                item_app_dict['riasec_mineur'] = bloc_item.xpath('riasec_mineur')[0].text
            except:
                pass
            return item_app_dict
        fiche_dict['activites_de_base'] = [parse_itemab(tmp) for tmp in bloc]
        pass

    def parse_savoir_action(bloc):
        log.info(bloc)
        fiche_dict['savoir_action'] = []
        def parse_itemsa(bloc_item):
            item_app_dict = {}
            item_app_dict['code_ogr'] = bloc_item.xpath('code_ogr')[0].text
            item_app_dict['libelle'] = bloc_item.xpath('libelle')[0].text
            item_app_dict['code_type_competence'] = bloc_item.xpath('code_type_competence')[0].text
            item_app_dict['position_item'] = bloc_item.xpath('position_item')[0].text
            item_app_dict['priorisation'] = bloc_item.xpath('priorisation')[0].text
            return item_app_dict
        savoir_action = []
        for item in bloc:
            savoir_action = savoir_action + [parse_itemsa(tmp) for tmp in item]
        fiche_dict['savoir_action'] = savoir_action
        pass

    def parse_activite_specifique(bloc):
        log.info(bloc)
        fiche_dict['activite_specifique'] = []
        def parse_itemas(bloc_item):
            item_app_dict = {}
            item_app_dict['code_ogr'] = bloc_item.xpath('code_ogr')[0].text
            item_app_dict['libelle'] = bloc_item.xpath('libelle')[0].text
            item_app_dict['code_type_activite'] = bloc_item.xpath('code_type_activite')[0].text
            item_app_dict['code_type_item_activite'] = bloc_item.xpath('code_type_item_activite')[0].text
            item_app_dict['position_item'] = bloc_item.xpath('position_item')[0].text
            item_app_dict['priorisation'] = bloc_item.xpath('priorisation')[0].text
            try:
                item_app_dict['riasec_majeur'] = bloc_item.xpath('riasec_majeur')[0].text
                try:
                    item_app_dict['riasec_mineur'] = bloc_item.xpath('riasec_mineur')[0].text
                except:
                    pass
            except:
                pass
            return item_app_dict
        activite_specifique = []
        for item in bloc:
            activite_specifique = activite_specifique + [parse_itemas(tmp) for tmp in item]
        fiche_dict['activite_specifique'] = activite_specifique
        pass

    def parse_savoir_theorique_et_proceduraux(bloc):
        log.info(bloc)
        fiche_dict['savoir_theorique_et_proceduraux'] = []
        def parse_itemstp(bloc_item):
            item_app_dict = {}
            item_app_dict['code_ogr'] = bloc_item.xpath('code_ogr')[0].text
            item_app_dict['libelle'] = bloc_item.xpath('libelle')[0].text
            item_app_dict['code_type_competence'] = bloc_item.xpath('code_type_competence')[0].text
            item_app_dict['position_item'] = bloc_item.xpath('position_item')[0].text
            item_app_dict['priorisation'] = bloc_item.xpath('priorisation')[0].text
            return item_app_dict
        savoir_theorique_et_proceduraux = []
        for item in bloc:
            savoir_theorique_et_proceduraux = savoir_theorique_et_proceduraux + [parse_itemstp(tmp) for tmp in item]
        fiche_dict['savoir_theorique_et_proceduraux'] = savoir_theorique_et_proceduraux
        pass

    def parse_mobilites_proches(bloc):
        log.info(bloc)
        bloc = bloc[0]
        fiche_dict['mobilites_proches'] = 1
        def parse_item_mobpr(bloc_item):
            item_app_dict = {}
            item_app_dict['code_rome_cible'] = bloc_item.xpath('code_rome_cible')[0].text
            item_app_dict['libelle_rome_cible'] = bloc_item.xpath('libelle_rome_cible')[0].text
            return item_app_dict
        fiche_dict['mobilites_proches'] = [parse_item_mobpr(tmp) for tmp in bloc]
        pass

    def parse_mobilites_si_evolution(bloc):
        log.info(bloc)
        bloc = bloc[0]
        fiche_dict['mobilites_si_evolution'] = 1
        def parse_item_mobev(bloc_item):
            item_app_dict = {}
            item_app_dict['code_rome_cible'] = bloc_item.xpath('code_rome_cible')[0].text
            item_app_dict['libelle_rome_cible'] = bloc_item.xpath('libelle_rome_cible')[0].text
            return item_app_dict
        fiche_dict['mobilites_si_evolution'] = [parse_item_mobev(tmp) for tmp in bloc]
        pass

    parse_bloc_code_rome(root.xpath('//bloc_code_rome'))
    parse_bloc_appellation(root.xpath('//bloc_appellation'))
    parse_description(root)
    parse_bloc_environnement_de_travail(root.xpath('//bloc_environnement_de_travail'))
    parse_activites_de_base(root.xpath('//activites_de_base'))
    parse_savoir_action(root.xpath('//savoir_action'))
    parse_activite_specifique(root.xpath('//activite_specifique'))
    parse_savoir_theorique_et_proceduraux(root.xpath('//savoir_theorique_et_proceduraux'))
    parse_mobilites_proches(root.xpath('//mobilites_proches'))
    parse_mobilites_si_evolution(root.xpath('//mobilites_si_evolution'))

    return fiche_dict

#Indicate the output folder for the data
OUTPUT_FOLDER = os.path.join(dir_path,'fichesMetiers')
#Write each dictionnary into a json file
for xml_file in list_xml_files:
    fiche_dict = parse_xml_file(xml_file)
    file = OUTPUT_FOLDER + '/' + xml_file + '.json'
    with open(file, 'w') as f:
        f.write(json.dumps(fiche_dict, indent=4))