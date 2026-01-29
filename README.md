# 🎫 EventHub

<div align="center">

**Système complet de gestion d'événements avec réservations, paiements et statistiques en temps réel**

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Database](https://img.shields.io/badge/Database-MySQL-blue.svg)](https://www.mysql.com/)
[![SQL](https://img.shields.io/badge/Language-SQL-orange.svg)](https://en.wikipedia.org/wiki/SQL)

</div>

---

## 📋 Table des matières

- [À propos](#-à-propos)
- [Fonctionnalités](#-fonctionnalités)
- [Architecture de la base de données](#%EF%B8%8F-architecture-de-la-base-de-données)
- [Installation](#-installation)
- [Utilisation](#-utilisation)
- [Structure du projet](#-structure-du-projet)
- [Procédures stockées et fonctions](#-procédures-stockées-et-fonctions)
- [Exemples d'utilisation](#-exemples-dutilisation)
- [Contribution](#-contribution)
- [Licence](#-licence)

---

## 📖 À propos

**EventHub** est une solution complète de gestion d'événements conçue pour gérer efficacement :
- 🎭 Concerts et spectacles
- 📚 Conférences et séminaires
- 🎬 Salles de cinéma avec différentes configurations

Le système offre une gestion complète des réservations de places, des paiements sécurisés, des annulations avec remboursements, ainsi qu'un système robuste de statistiques en temps réel pour le suivi et l'analyse des ventes.

### 🎯 Objectifs du projet

- Centraliser la gestion des événements et des réservations
- Automatiser le processus de réservation et de paiement
- Fournir des statistiques en temps réel pour la prise de décision
- Garantir l'intégrité des données avec des triggers et des contraintes
- Offrir une solution scalable et maintenable

---

## ✨ Fonctionnalités

### 🎟️ Gestion des événements
- ✅ Création et gestion d'événements multiples
- ✅ Support de différentes catégories (Musique, Conférences, Cinéma, etc.)
- ✅ Configuration flexible des salles avec différents types de places
- ✅ Gestion des prix par type de place (Standard, VIP, Balcon)

### 💺 Gestion des réservations
- ✅ Réservation de places individuelles
- ✅ Réservation de places multiples en une seule transaction
- ✅ Vérification automatique de la disponibilité
- ✅ Support de différents types de places (Standard, VIP, Balcon)
- ✅ Système de statuts de réservation (En attente, Confirmée, Annulée)

### 💳 Gestion des paiements
- ✅ Support de plusieurs modes de paiement (Espèce, Carte bancaire, Virement)
- ✅ Suivi des transactions avec horodatage
- ✅ Gestion des remboursements lors d'annulations
- ✅ Traçabilité complète des paiements

### 🔄 Annulation et remboursement
- ✅ Annulation de réservations individuelles
- ✅ Annulation de réservations multiples
- ✅ Remboursement automatique selon le mode de paiement
- ✅ Libération automatique des places annulées

### 📊 Statistiques en temps réel
- ✅ Taux d'occupation des salles
- ✅ Statistiques de ventes par type de place
- ✅ Analyse de performance par catégorie d'événement
- ✅ Suivi du chiffre d'affaires
- ✅ Vues SQL optimisées pour les rapports

### 🔒 Intégrité des données
- ✅ Triggers de cohérence pour la gestion des places
- ✅ Contraintes de validation sur les capacités
- ✅ Gestion automatique des historiques
- ✅ Transactions ACID garanties

---

## 🏗️ Architecture de la base de données

### Schéma relationnel

Le système est construit autour de 6 tables principales :

#### 1. **Evenement**
Stocke les informations sur les événements organisés.
- `id_event` : Identifiant unique de l'événement
- `titre_event` : Titre de l'événement
- `description_event` : Description détaillée
- `categorie_event` : Catégorie (Musique, Conférence, etc.)
- `date_event` : Date et heure de l'événement
- `lieu_event` : Lieu de l'événement
- `prix_standard`, `prix_vip`, `prix_balcon` : Prix par type de place
- `id_salle` : Référence vers la salle

#### 2. **Salle**
Définit les caractéristiques des salles de spectacle.
- `id_salle` : Identifiant unique de la salle
- `nom_salle` : Nom de la salle
- `capacite_max` : Capacité maximale
- `nb_rangee` : Nombre de rangées
- `nb_place_rangee` : Nombre de places par rangée
- `nb_place_standard`, `nb_place_vip`, `nb_place_balcon` : Répartition des places

#### 3. **Place**
Gère les places individuelles pour chaque événement.
- `num_place` : Numéro de la place
- `id_event` : Référence vers l'événement
- `num_rangee` : Numéro de rangée
- `type_place` : Type (Standard, VIP, Balcon)
- `id_salle` : Référence vers la salle

#### 4. **Clients**
Informations sur les clients.
- `id_client` : Identifiant unique
- `nom`, `prenom` : Nom et prénom
- `num_tel` : Numéro de téléphone
- `email` : Adresse email

#### 5. **Reservation**
Enregistre les réservations de places.
- `id_reservation` : Identifiant unique
- `nb_place_res` : Nombre de places réservées
- `num_place` : Numéro de la première place
- `type_place` : Type de place
- `statut` : Statut de la réservation
- `id_client`, `id_event` : Références vers client et événement

#### 6. **Paiement**
Suit les transactions de paiement.
- `id_paiement` : Identifiant unique
- `montant` : Montant du paiement
- `mode_paiement` : Mode (Espèce, Carte bancaire, Virement)
- `statut` : Statut du paiement
- `date_paiement` : Horodatage
- `employe` : Employé ayant traité le paiement
- `id_reservation` : Référence vers la réservation

### Diagramme ERD

```
┌──────────────┐         ┌──────────────┐
│   Salle      │◄────────│  Evenement   │
└──────────────┘         └──────────────┘
       ▲                        ▲
       │                        │
       │                        │
┌──────────────┐         ┌──────────────┐
│    Place     │         │ Reservation  │◄────────┐
└──────────────┘         └──────────────┘         │
                                ▲                  │
                                │                  │
                         ┌──────────────┐   ┌──────────────┐
                         │   Clients    │   │   Paiement   │
                         └──────────────┘   └──────────────┘
```

---

## 🚀 Installation

### Prérequis

- **MySQL** version 5.7 ou supérieure (ou MariaDB 10.2+)
- Accès à un serveur MySQL avec privilèges de création de base de données
- Client MySQL (ligne de commande ou GUI comme MySQL Workbench, phpMyAdmin)

### Étapes d'installation

1. **Cloner le dépôt**
   ```bash
   git clone https://github.com/elhadj-aliou-barry/EventHub.git
   cd EventHub
   ```

2. **Créer la base de données**
   ```bash
   mysql -u votre_utilisateur -p < "Implémentation-DB/EventHub_DB.sql"
   ```

3. **Insérer les données de test**
   ```bash
   mysql -u votre_utilisateur -p EventHub < "Implémentation-DB/Insertion_de_tables.sql"
   ```

4. **Créer les triggers de cohérence**
   ```bash
   mysql -u votre_utilisateur -p EventHub < "Implémentation-DB/Triggers de cohérence.sql"
   ```

5. **Créer les procédures de réservation**
   ```bash
   mysql -u votre_utilisateur -p EventHub < "Reserver de place(s) /fonctions_reservation_simple.sql"
   mysql -u votre_utilisateur -p EventHub < "Reserver de place(s) /fonctions pour reservers +sieurs places.sql"
   ```

6. **Créer les procédures d'annulation**
   ```bash
   mysql -u votre_utilisateur -p EventHub < "Annuler réservation(s)/fonctions_annuler_reservation.sql"
   mysql -u votre_utilisateur -p EventHub < "Annuler réservation(s)/Fonctions annulations +sieurs places.sql"
   ```

7. **Créer les vues et procédures statistiques**
   ```bash
   mysql -u votre_utilisateur -p EventHub < "Vues/Vues et procédures utilisants.sql"
   mysql -u votre_utilisateur -p EventHub < "Statistiques-for-Event(s)/fonctions statistiques en temps reels.sql"
   ```

---

## 💻 Utilisation

### Connexion à la base de données

```bash
mysql -u votre_utilisateur -p EventHub
```

### Opérations de base

Le fichier `scénario de réservation.sql` contient des exemples d'utilisation complets.

---

## 📁 Structure du projet

```
EventHub/
├── README.md                           # Documentation principale
├── LICENSE                             # Licence MIT
├── scénario de réservation.sql        # Scénarios d'utilisation
│
├── Implémentation-DB/                 # Scripts de création de la base
│   ├── EventHub_DB.sql                # Création des tables
│   ├── Insertion_de_tables.sql        # Données de test
│   └── Triggers de cohérence.sql      # Triggers d'intégrité
│
├── Reserver de place(s) /             # Module de réservation
│   ├── Réservation-Procédures-finales/
│   │   ├── Reserver une place.sql
│   │   └── Reserver +sieurs places.sql
│   ├── fonctions_reservation_simple.sql
│   └── fonctions pour reservers +sieurs places.sql
│
├── Annuler réservation(s)/            # Module d'annulation
│   ├── Annulation-Procédures_finales/
│   │   ├── Annuler la reservation d'une place.sql
│   │   └── Annuler une réservation de +sieurs places.sql
│   ├── fonctions_annuler_reservation.sql
│   └── Fonctions annulations +sieurs places.sql
│
├── Vues/                              # Vues SQL
│   └── Vues et procédures utilisants.sql
│
└── Statistiques-for-Event(s)/         # Module statistiques
    └── fonctions statistiques en temps reels.sql
```

---

## 🔧 Procédures stockées et fonctions

### Réservations

#### `Reserver_place_simple`
Réserve une seule place pour un événement.

**Paramètres :**
- `p_id_client` : ID du client
- `p_id_event` : ID de l'événement
- `p_num_place` : Numéro de la place
- `p_type_place` : Type de place (VIP, STANDARD, BALCON)
- `p_mode_paiement` : Mode de paiement (Espèce, Carte bancaire, Virement)

#### `Reserver_places_multiple`
Réserve plusieurs places consécutives.

**Paramètres :**
- `p_id_client` : ID du client
- `p_id_event` : ID de l'événement
- `p_num_place` : Numéro de la première place
- `p_nb_places` : Nombre de places à réserver
- `p_type_place` : Type de place
- `p_mode_paiement` : Mode de paiement

### Annulations

#### `Annuler_reservation`
Annule une réservation simple.

**Paramètres :**
- `p_email` : Email du client
- `p_id_event` : ID de l'événement
- `p_num_place` : Numéro de la place
- `p_type_place` : Type de place

#### `Annuler_reservation_multiple`
Annule plusieurs places réservées.

**Paramètres :**
- `p_email` : Email du client
- `p_id_event` : ID de l'événement
- `p_num_place` : Numéro de la première place
- `p_type_place` : Type de place
- `p_nombres_place` : Nombre de places à annuler

### Statistiques

#### `Statistique_evenement_vue`
Affiche les statistiques complètes d'un événement.

**Paramètres :**
- `p_id_event` : ID de l'événement

#### `Afficher_performance_categorie`
Affiche la performance d'une catégorie d'événements.

**Paramètres :**
- `p_categorie` : Nom de la catégorie

#### `taux_occupation`
Calcule le taux d'occupation d'une salle pour un événement.

**Retourne :** Pourcentage d'occupation (DECIMAL)

#### `prix_place`
Retourne le prix d'une place selon son type.

**Paramètres :**
- `p_id_event` : ID de l'événement
- `p_type_place` : Type de place

**Retourne :** Prix de la place (DECIMAL)

---

## 📚 Exemples d'utilisation

### 1. Réserver une place simple

```sql
-- Réserver une place VIP pour le client 1 à l'événement 1
CALL Reserver_place_simple(1, 1, 1, 'VIP', 'Espèce');
```

### 2. Réserver plusieurs places

```sql
-- Réserver 3 places standard consécutives
CALL Reserver_places_multiple(3, 1, 2, 3, 'STANDARD', 'Carte bancaire');
```

### 3. Annuler une réservation

```sql
-- Annuler la réservation d'une place VIP
CALL Annuler_reservation('yassine@eventhub.ma', 1, 1, 'VIP');
```

### 4. Annuler plusieurs réservations

```sql
-- Annuler 2 places réservées
CALL Annuler_reservation_multiple('othmane@eventhub.ma', 1, 2, 'VIP', 2);
```

### 5. Consulter les statistiques d'un événement

```sql
-- Afficher toutes les statistiques de l'événement 1
CALL Statistique_evenement_vue(1);
```

### 6. Consulter la performance d'une catégorie

```sql
-- Voir les performances de la catégorie Musique
CALL Afficher_performance_categorie('Musique');
```

### 7. Calculer le taux d'occupation

```sql
-- Obtenir le taux d'occupation pour l'événement 1
SELECT taux_occupation(1) AS 'Taux d\'occupation (%)';
```

### 8. Obtenir le prix d'une place

```sql
-- Obtenir le prix d'une place VIP pour l'événement 1
SELECT prix_place(1, 'VIP') AS 'Prix VIP';
```

---

## 🤝 Contribution

Les contributions sont les bienvenues ! Pour contribuer :

1. **Fork** le projet
2. Créez une **branche** pour votre fonctionnalité (`git checkout -b feature/AmazingFeature`)
3. **Commitez** vos changements (`git commit -m 'Add some AmazingFeature'`)
4. **Push** vers la branche (`git push origin feature/AmazingFeature`)
5. Ouvrez une **Pull Request**

### Guidelines de contribution

- Suivez les conventions SQL existantes
- Documentez les nouvelles procédures stockées
- Testez vos modifications avant de soumettre
- Mettez à jour la documentation si nécessaire

---

## 📄 Licence

Ce projet est sous licence MIT. Voir le fichier [LICENSE](LICENSE) pour plus de détails.

---

## 👥 Auteurs

- **Elhadj Aliou Barry** - [GitHub](https://github.com/elhadj-aliou-barry)

---

## 📞 Support

Pour toute question ou suggestion :
- Ouvrez une [issue](https://github.com/elhadj-aliou-barry/EventHub/issues)
- Contactez l'équipe de développement

---

<div align="center">

**⭐ Si ce projet vous a été utile, n'hésitez pas à lui donner une étoile ! ⭐**

Made with ❤️ by EventHub Team

</div>
