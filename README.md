# HELMoliday Mobile

Projet du cours d'architectures logicielles et du cours de frameworks web (année académique 2023-2024) réalisé par Clara SCHILTZ et Lionel BOVY.


**⚠️ Activer la connexion VPN de HELMo**

## Installation
- Depuis le terminal, ouvrir le dossier racine du projet
- Exécuter la commande `flutter pub get`

## Utilisateurs
| Adresse e-mail         | Mot de passe |
|------------------------|--------------|
| claraschiltz@gmail.com | Hello@1234   |
| lionel@bovy.dev        | Hello&123    |

## Exécution des tests E2E
- Depuis le terminal, ouvrir le dossier racine du projet
- Exécuter les commandes suivantes :
```bash
flutter test integration_test/login_test.dart
flutter test integration_test/holiday_test.dart
flutter test integration_test/register_test.dart
```

## Problème connu
### Ajout d'une activité
Lors de l'ajout d'une activité, il se peut que l'API ne réponde plus à cause de l'envoi de mails répétés. Ce problème survient lorsqu'on ajoute plusieurs activités dans période de temps relativement courte.