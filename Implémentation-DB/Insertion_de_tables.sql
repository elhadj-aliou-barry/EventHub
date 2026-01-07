ALTER TABLE Clients AUTO_INCREMENT = 1;
ALTER TABLE Salle AUTO_INCREMENT = 1;
ALTER TABLE Evenement AUTO_INCREMENT = 1;
ALTER TABLE Reservation AUTO_INCREMENT = 1;
ALTER TABLE Paiement AUTO_INCREMENT = 1;
ALTER TABLE Evenement_Archive AUTO_INCREMENT = 1;
ALTER TABLE Historique_reservation AUTO_INCREMENT = 1;
ALTER TABLE Historique_paiement AUTO_INCREMENT = 1;
alter table Statistique_evenement AUTO_INCREMENT = 1 ;

delete from Evenement;
delete from Reservation;
delete from Salle;
delete from Place;
delete from Historique_paiement;
delete from Historique_paiement;
delete from Evenement_Archive;
delete from Paiement;
delete from Clients;
delete from Statistique_evenement;

-- Clients

INSERT INTO Clients (nom, prenom, num_tel, email) VALUES
('El Amrani', 'Yassine', '0600000001', 'yassine@eventhub.ma'),
('Benali', 'Khadija', '0600000002', 'khadija@eventhub.ma'),
('Alaoui', 'Othmane', '0600000003', 'othmane@eventhub.ma'),
('Chraibi', 'Salma', '0600000004', 'salma@eventhub.ma'),
('Zerouali', 'Hamza', '0600000005', 'hamza@eventhub.ma'),
('Bennani', 'Meryem', '0600000006', 'meryem@eventhub.ma'),
('El Idrissi', 'Anas', '0600000007', 'anas@eventhub.ma'),
('Tahiri', 'Imane', '0600000008', 'imane@eventhub.ma'),
('Skalli', 'Ayoub', '0600000009', 'ayoub@eventhub.ma'),
('Amine', 'Rania', '0600000010', 'rania@eventhub.ma');


-- Salle

INSERT INTO Salle
(nom_salle, capacite_max, nb_rangee, nb_place_rangee,
 nb_place_standard, nb_place_vip, nb_place_balcon)
VALUES
('Théâtre Mohammed V', 300, 15, 20, 180, 60, 60),
('Complexe Culturel Anfa', 200, 10, 20, 120, 40, 40),
('Palais des Congrès Marrakech', 400, 20, 20, 240, 80, 80),
('Centre Culturel Fès', 150, 10, 15, 120, 30, 0),
('Salle Ibn Khaldoun', 120, 12, 10, 100, 20, 0),
('Megarama Casablanca', 180, 12, 15, 120, 30, 30),
('Cinéma Rif Tanger', 90, 9, 10, 90, 0, 0),
('Opéra de Rabat', 250, 10, 25, 150, 50, 50),
('Centre Culturel Agadir', 160, 8, 20, 120, 40, 0),
('Salle Atlas Ouarzazate', 140, 7, 20, 80, 40, 20);

select * from salle;
-- Evenement

INSERT INTO Evenement
(titre_event, description_event, categorie_event, date_event, lieu_event,
 prix_standard, prix_vip, prix_balcon, id_salle)
VALUES
-- Salle 1 (balcon)
('Nuit Andalouse', 'Musique arabo-andalouse traditionnelle', 'Musique',
 '2025-01-15 20:00', 'Rabat', 60, 100, 85, 1),

-- Salle 2 (balcon)
('Tech Innov Morocco', 'Conférence sur l’innovation numérique', 'Conférence',
 '2025-01-20 09:00', 'Casablanca', 50, 80, 70, 2),

-- Salle 3 (balcon)
('Festival Gnaoua', 'Soirée Gnaoua moderne', 'Culture',
 '2025-01-25 19:00', 'Marrakech', 55, 90, 75, 3),

-- Salle 4 (PAS de balcon)
('Théâtre Amazigh', 'Pièce amazighe contemporaine', 'Théâtre',
 '2025-01-30 18:30', 'Fès', 40, 65, NULL, 4),

-- Salle 5 (PAS de balcon)
('Stand-up Darija', 'Humour marocain en darija', 'Spectacle',
 '2025-02-02 21:00', 'Rabat', 35, 55, 45, 5),

-- Salle 6 (balcon)
('Forum Entreprendre Maroc', 'Entrepreneuriat et startups', 'Business',
 '2025-02-06 10:00', 'Casablanca', 70, 110, 95, 6),

-- Salle 7 (PAS de balcon)
('Cinéma Maghrébin', 'Avant-première marocaine', 'Cinéma',
 '2025-02-10 20:30', 'Tanger', 30, 80, 60, 7),

-- Salle 8 (balcon)
('Symphonie du Désert', 'Orchestre et musique du Sud', 'Musique',
 '2025-02-14 20:00', 'Rabat', 65, 105, 90, 8),

-- Salle 9 (PAS de balcon)
('Santé & Innovation', 'Conférence médicale', 'Conférence',
 '2025-02-18 09:30', 'Agadir', 45, 75, NULL, 9),

-- Salle 10 (balcon)
('Gala Solidarité Atlas', 'Soirée caritative nationale', 'Gala',
 '2025-02-22 20:00', 'Ouarzazate', 80, 130, 110, 10);