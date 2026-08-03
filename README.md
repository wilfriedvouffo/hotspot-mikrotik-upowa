# hotspot-mikrotik-upowa

Ce dépôt contient l'ensemble de la documentation, des scripts de configuration et des fichiers du portail captif nécessaires au déploiement d'une solution de Hotspot Wi-Fi intégrée sur routeur **MikroTik hAP ax²** (RouterOS v7.19.5).

Le système offre :
* Une gestion contrôlée des accès réseau via un **portail captif personnalisé**.
* Des **profils utilisateurs différenciés** (`etudiant` et `invite`) avec limitation de bande passante, durée de session et nombre d'appareils autorisés.
* Un **système de génération et d'expiration calendaire automatique des comptes** à 30 jours via scripts RouterOS et tâches planifiées (`scheduler`).
* La **sécurisation des services d'administration** du routeur.
* Un mécanisme de **sauvegardes automatiques quotidiennes** de la configuration (`.backup` et `.rsc`).

## Auteurs
* VOUFFO Wilfrid Beongel
* MBOGOL Yves Bertrand
* ASSONTIA BOUALI Yan
