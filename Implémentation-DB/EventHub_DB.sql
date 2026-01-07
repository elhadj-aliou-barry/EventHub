CREATE DATABASE EventHub DEFAULT CHARACTER SET utf8mb4;

USE  EventHub;

CREATE TABLE Evenement
(
  id_event INT UNSIGNED AUTO_INCREMENT,
  titre_event text NOT NULL,
  description_event TEXT,
  categorie_event VARCHAR(30) NOT NULL,
  date_event DATETIME NOT NULL,
  lieu_event VARCHAR(50) NOT NULL,
  prix_standard DECIMAL(10,2) NOT NULL,
  prix_vip DECIMAL(10,2) , --  null ssi nb_place_vip de salle = 0 ; 
  prix_balcon DECIMAL(10,2) ,  -- null ssi nb_place_standard de salle = 0 ; 
  id_salle INT UNSIGNED, -- clé etrangère vers Salle
-- definition des contraintes
  CONSTRAINT id_event_pk PRIMARY KEY(id_event),
  CONSTRAINT id_salle_event_fk FOREIGN KEY (id_salle)
   REFERENCES Salle(id_salle) 
)ENGINE=INNODB;


CREATE TABLE Salle
(
  id_salle INT UNSIGNED AUTO_INCREMENT,
  nom_salle VARCHAR(50) NOT NULL,
  capacite_max INT NOT NULL,
  nb_rangee INT NOT NULL,
  nb_place_rangee INT NOT NULL,
  nb_place_standard INT NOT NULL,
  nb_place_vip INT default 0,
  nb_place_balcon INT default 0,
-- definition des contraintes
  CONSTRAINT id_salle_pk PRIMARY KEY(id_salle),
  CONSTRAINT capMax_Salle_ck CHECK ( capacite_max >= nb_place_standard + nb_place_vip + nb_place_balcon ),
  CONSTRAINT coherence_place_rangee_ck CHECK ( nb_place_standard % nb_place_rangee = 0 AND
                                               nb_place_vip % nb_place_rangee = 0 AND
                                               nb_place_balcon % nb_place_rangee = 0 )
)ENGINE=INNODB;

CREATE TABLE Place
(
  num_place INT UNSIGNED,
  id_event INT UNSIGNED,
  num_rangee INT NOT NULL,
  type_place VARCHAR(20) NOT NULL,
  id_salle INT UNSIGNED, -- clé etrangère vers Salle
-- definition des contraintes
  CONSTRAINT event_Nplace_pk PRIMARY KEY(num_place,id_event),
  CONSTRAINT id_salle_place_fk FOREIGN KEY(id_salle)
    REFERENCES Salle(id_salle)
)ENGINE=INNODB;


CREATE TABLE Clients
(
   id_client INT UNSIGNED AUTO_INCREMENT,
   nom VARCHAR(30) NOT NULL,
   prenom VARCHAR(30) NOT NULL,
   num_tel VARCHAR(14) ,
   email VARCHAR(50),
-- definition de contraintes
   CONSTRAINT id_client_pk PRIMARY KEY(id_client)
)ENGINE=INNODB;


CREATE TABLE Reservation
(
  id_reservation INT UNSIGNED AUTO_INCREMENT,
  nb_place_res INT default 1,
  num_place INT UNSIGNED,
  type_place VARCHAR(20) NOT NULL,
  statut VARCHAR(15) DEFAULT 'En attente',
  id_client INT UNSIGNED, -- clé etrangère vers Clients
  id_event INT UNSIGNED, -- clé etrangère vers Evenement
-- definition des contraintes
  CONSTRAINT id_reservation_pk PRIMARY KEY(id_reservation),
  CONSTRAINT id_event_res_fk FOREIGN KEY(id_event)
    REFERENCES Evenement(id_event),
  CONSTRAINT id_cli_res_fk FOREIGN KEY(id_client)
    REFERENCES Clients(id_client)
)ENGINE=INNODB;



CREATE TABLE Paiement
(
   id_paiement INT  UNSIGNED AUTO_INCREMENT,
   montant DECIMAL(10,2),
   mode_paiement VARCHAR(20) NOT NULL,
   statut VARCHAR(20) default 'En attente',
   date_paiement TIMESTAMP NOT NULL,
   employe VARCHAR(30) default current_user(),
   id_reservation INT UNSIGNED, -- clé etrangère vers Reservation
-- definition des contraintes
   CONSTRAINT id_paiement_pk PRIMARY KEY(id_paiement),
   CONSTRAINT id_res_paie_fk FOREIGN KEY(id_reservation)
     REFERENCES Reservation(id_reservation)
)ENGINE=INNODB;

CREATE TABLE Evenement_Archive
(
    id_archive INT UNSIGNED,
    titre_event text NOT NULL,
    description_event TEXT,
    categorie_event VARCHAR(20) NOT NULL,
    date_event DATETIME NOT NULL,
    lieu_event VARCHAR(50) NOT NULL,
    prix_standard DECIMAL(10,2) NOT NULL,
    prix_vip DECIMAL(10,2),
    prix_balcon DECIMAL(10,2),
    id_salle INT UNSIGNED,
-- definition des contraintes
  CONSTRAINT id_archi_event_pk PRIMARY KEY(id_archive)
)ENGINE=INNODB;

alter table Evenement_Archive
modify column id_archive INT UNSIGNED;



CREATE TABLE Historique_reservation
(
   id_rh INT UNSIGNED AUTO_INCREMENT,
   id_reservation INT UNSIGNED,
   nb_place_res INT default 1,
   num_place INT UNSIGNED,
   type_place VARCHAR(20) NOT NULL,
   statut VARCHAR(15),
   id_client INT UNSIGNED,
   id_event INT UNSIGNED,
   date_operation DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP(),
-- definition des contraintes
   CONSTRAINT id_history_res_pk PRIMARY KEY(id_rh)
)ENGINE=INNODB;

CREATE TABLE Historique_paiement 
(
   id_ph INT UNSIGNED AUTO_INCREMENT,
   id_paiement INT UNSIGNED,
   id_reservation INT UNSIGNED,
   montant DECIMAL(10,2),
   mode_paiement VARCHAR(20) NOT NULL,
   statut VARCHAR(20) NOT NULL,
   date_operation TIMESTAMP NOT NULL,
   employe VARCHAR(30) default current_user(),
-- definition des contraintes
   CONSTRAINT id_ph_history_pk PRIMARY KEY(id_ph)
)ENGINE=INNODB;

CREATE TABLE Statistique_evenement
(
  id_event INT UNSIGNED,
  standard_vendue INT DEFAULT 0,
  vip_vendue INT DEFAULT 0,
  balcon_vendue INT DEFAULT 0,
-- definition des contraintes
  CONSTRAINT id_event_stat_pk PRIMARY KEY(id_event),
  CONSTRAINT id_event_stat_fk FOREIGN KEY(id_event)
    REFERENCES Evenement(id_event) 
)ENGINE=INNODB;

alter table Statistique_evenement
change id_archive id_event int UNSIGNED ;