# Bonne Pratiques FME

Ce document contient une liste de bonne pratiques à utiliser lors du développement de *Workbench* ou de *Custom Transformer*.  Le suivi de ces directives facilitera la maintenance en assurant un homogénéité du code écrit par les différents développeurs.

Note importante: Ce document de bonne pratiques FME est en mode ébauche, les membres de l'équipe sont encouragés à développer de nouvelles *bonnes pratiques FME* ou de bonifier des *bonne pratiques FME* existentes qui seront partagées au sein de l'équipe et consignées dans le site web d'équipe.   

Ce document adresse les éléments de *bonnes pratiques FME* suivants:

 - [Documentation](#Documentation)
 - [Hardcoding](#Bookmark)
 - [Terminator](#Bookmark-imbriqué)
 - [Résillience](#Résillience)
 - [Nom du transformer](#Nom-du-transformer)
 - [Gestion des attributs](#Gestion-des-attributs)


# Documentation

Toujours documenter les *transformer* et *custom transformer* selon la [procédure de documentation](Documentation%20FME.md) afin d'assurer une homogénéité dans le code en plus de maximiser sa lisibilité.
 

# Hardcoding

Le *hardcoding* est une pratique de développement logiciel où les données sont directement écrite dans le code.  Cette pratique tend à créer du code moins générique qu'il faut constamment modifier pour l'adapter à de nouvelles situations (ex.: prise en charge de nouvelles provinces).  Le *hardcoding* est à éviter à tout prix.  L'utilisation de fichiers de configuration et de *publish parameters* est encouragée afin d'éviter les problèmes engendrés par le *hardcoding*.

C'est au développeur d'identifier les situations potentielles de *hardcoding* et de choisir la meilleure stratégie d'évitement.


# Terminator

Le *Terminator* est un *transformer* qui arrête abruptement l'exécution du *workbench* lorsqu'il est activé.  Il est utilisé généralement pour détecté des situations non valides.  Le *terminator* devrait toujours être utilisé dans le cas de *transformer* lorsqu'une situation inattendue survient mais aussi dans le cas de *transformer* qui possèdent plusieurs ports de sortie qui ne devraient pas être utilisé normalement. Dans de tels cas les ports de sortie *non utilisés* devraient être reliés à un *Terminator* de façon à déceler ces cas dans le code (voir figure ci-dessous).

Le *Terminator* offre aussi la possibilité d'afficher un texte lorsqu'il est activé.  Le texte devrait toujours être représentatif de la raison pourquoi le *Terminator* est activé (ex.: *Invalid attribute value for ID*) et éviter les formalutation trop générique (ex.: *Translation failed...*)

![Terminator usage](images/img_5.png)

# Nom du transformer

Toujours conserver le nom du *transformer* tel que donner par FME.  Si vous avez plus d'un *transformer* du même type dans votre *workbench* alors ajouter un suffixe numérique (ex pour le *transformer* Tester: Tester, Tester_1, Tester_2, ...).  Conserver le nom du *transformer* original permet d'identifier plus rapidement le type de *transformer* employé.  Si un nom plus représentatif vous semble important alors privilégier une annotation sur le *transformer*. 


# Résillience

Le traitement des collections d'enregistrements de métadonnées de l'environnement des provinces et territoires (P/T) à celui du gouvernment fédéral se fait par traitment en lot (via *FME Server*).  Il est donc primordial que tous les *workbench* qui traitent les différentes P/T soient très résillients aux problèmes.  Si un ou plusieurs enregistrments de métadonnées ne peuvent pas être traduits car ces derniers contiennent un ou plusieurs cas particuliers qui ne sont pas pris en compte, il faut alors rejeter ce ou ces enregistrments, laisser une trace du problème dans un fichier log et traiter tous les autres enregistrements que le workbench est capable de manipuler.  Dans ce type de condition, il ne faut pas utiliser de *Terminator* qui ferait arrêter abruptement l'exécution du programme. 

**C'est au développeur de trouver la juste balance entre quand utiliser le *Terminator* (faire terminer abruptement un programme) car un *workbench* est dans un état instable et quand un *workbench* est incapable de traîter un enregistrement de métadonnées et ce dernier doit simplement être rejeté.**

# Gestion des attributs
 

Le traitment des collections d'enregistrements de métadonnées des différentes provinces utilise plusieurs centaines d'attributs FME et de listes FME en plus de ceux qui sont créés par les différents *transformer* et *custom transformer* de vos *workbench*.  En plus de saturer le FME Data Inspector et de rendre l'interprétation des résultats plus difficile, les attributs et listes sont de grands consommateurs de ressources pour FME (mémoire et CPU).  Afin de mieux gérer les attributs doivent tous les *custom transformer* doivent doivent se conformer aux directives suivantes:
  * Utiliser le *custom transformer* ATTRIBUTE_UNEXPOSER à la fin de l'exécution d'un *custom transformer* afin qu'aucun n'attribut ne soit exposé;
  * Utilisé le *transformer* *AttributeExposer* au début de votre *custom transformer* afin d'exposer uniquement les attributs nécessaires à votre traitement afin d'en faciliter la lecture, le débuggage et optimiser l'utilisation des ressources;
  * Utiliser le *AttributeRemover* afin d'enlever tous les attributs et listes temporaires et/ou qui ne sont plus utiles à votre traitement subséquents afin d'en faciliter la lecture, le débuggage et optimiser l'utilisation des ressources.