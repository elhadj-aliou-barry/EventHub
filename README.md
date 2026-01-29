# 🎟️ EventHub — Système de Gestion d’Événements basé sur SQL

## 📌 Présentation

**EventHub** est un système complet de gestion d’événements basé sur **MySQL / MariaDB**.  
Il est conçu pour gérer des **concerts, conférences, cinémas** et tout autre type d’événement nécessitant une gestion avancée des réservations.

Le projet fournit un **backend SQL complet**, incluant :  
- le schéma de base de données  
- les triggers  
- les fonctions  
- les procédures stockées

---

## 🚀 Fonctionnalités principales

- ✔️ Réservation de places (simple ou multiple)  
- ✔️ Gestion des paiements sécurisés  
- ✔️ Annulation de réservations  
- ✔️ Historique et archivage des événements  
- ✔️ Statistiques en temps réel (occupation, bénéfices, performances)  
- ✔️ Gestion de la concurrence avec transactions et verrous explicites  

---

## 🗄️ Technologies utilisées

- 🛢️ **MySQL / MariaDB**  
- ⚙️ **Triggers**  
- 🔁 **Transactions SQL**  
- 🧠 **Fonctions & procédures stockées**  
- 🔐 **Verrouillage (`SELECT ... FOR UPDATE`)**

---

## ⚡ Démarrage rapide

### Créer la base de données et le schéma
```sql
mysql -u root -p < Implémentation-DB/EventHub_DB.sql
```
**Naviguer dans le projet pour inserer les données dans les tables et tester les différentes procédures, fonctions et vues**

## Réalisateur :

- Elhadj Aliou Barry
- Karim Diakité
