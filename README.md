# HELMoliday Web

Projet du cours d'architectures logicielles et du cours de frameworks web (année académique 2023-2024) réalisé par Clara SCHILTZ et Lionel BOVY.

Lien vers le projet en production : [https://panoramix.cg.helmo.be/~q210266](https://panoramix.cg.helmo.be/~q210266)

**⚠️ Activer la connexion VPN de HELMo**

## Installation
- Depuis le terminal, ouvrir le dossier racine du projet
- Exécuter la commande `npm install`

## Utilisateurs
| Adresse e-mail         | Mot de passe |
|------------------------|--------------|
| claraschiltz@gmail.com | Hello@1234   |
| lionel@bovy.dev        | Hello&123    |

## Exécution des tests E2E
- Depuis le terminal, ouvrir le dossier racine du projet
- Exécuter la commande `flutter test integration_test/`

## Problème connu
### Ajout d'une activité
Lors de l'ajout d'une activité, il se peut que l'API ne réponde plus à cause de l'envoi de mails répétés. Ce problème survient lorsqu'on ajoute plusieurs activités dans période de temps relativement courte.