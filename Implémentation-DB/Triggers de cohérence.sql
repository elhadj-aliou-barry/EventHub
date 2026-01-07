alter table Evenement_Archive AUTO_INCREMENT = 1; 
ALTER TABLE Evenement AUTO_INCREMENT = 1; 
ALTER TABLE Statistique_evenement AUTO_INCREMENT = 1;

--trigger qui gere l'insertion des valeurs de prix_vip et prix_balcon dans la table Evenement s'ils ne sont pas renseignés
drop trigger if exists before_insert_evenement ;
CREATE TRIGGER before_insert_evenement
BEFORE INSERT ON Evenement
FOR EACH ROW
BEGIN
  DECLARE place_vip INT;
  DECLARE place_balcon INT;

  SELECT nb_place_vip, nb_place_balcon 
  INTO place_vip, place_balcon 
  FROM Salle 
  WHERE id_salle = NEW.id_salle;

  IF NEW.prix_vip IS NULL AND place_vip <> 0 THEN
      SIGNAL SQLSTATE '45000' 
      SET MESSAGE_TEXT = "Cette salle possède des places VIP, veuillez renseigner le prix de ces places";
  END IF;

  IF NEW.prix_balcon IS NULL AND place_balcon <> 0 THEN
      SIGNAL SQLSTATE '45000' 
      SET MESSAGE_TEXT = "Cette salle possède des places Balcon, veuillez renseigner le prix de ces places";
  END IF;

END ;


-- trigger d'insertion de la table Statistique_evenement lors de l'insertion d'un nouvel evenement
CREATE TRIGGER AI_event AFTER INSERT ON Evenement
FOR EACH ROW
BEGIN
INSERT INTO Statistique_evenement ( id_event, standard_vendue, vip_vendue, balcon_vendue)
VALUES (NEW.id_event, 0, 0, 0) ;
END;

-- trigger d'insertion de la table Evenement_Archive lors de l'insertion d'un nouvel evenement
CREATE TRIGGER Enregistrement_evenement_archive AFTER INSERT ON Evenement
FOR EACH ROW
BEGIN
    INSERT INTO Evenement_Archive(id_archive, titre_event, description_event, categorie_event, date_event, lieu_event, prix_standard, prix_vip, prix_balcon , id_salle)
    VALUES (NEW.id_event, NEW.titre_event, NEW.description_event, NEW.categorie_event, NEW.date_event, NEW.lieu_event, NEW.prix_standard, NEW.prix_vip, NEW.prix_balcon, NEW.id_salle);
END;

-- trigger d'insertion de la table Historique_reservation lors de l'insertion d'une nouvelle reservation
CREATE TRIGGER Enregistrement_historique_reservation AFTER INSERT ON Reservation
FOR EACH ROW
BEGIN
    INSERT INTO Historique_reservation (id_reservation, nb_place_res, num_place, type_place, statut, id_client, id_event, date_operation)
    VALUES (NEW.id_reservation, NEW.nb_place_res, NEW.num_place, NEW.type_place, NEW.statut, NEW.id_client, NEW.id_event, CURRENT_TIMESTAMP());
END;

-- trigger d'insertion de la table Historique_reservation lors de la modification d'une reservation
CREATE TRIGGER Maj_historique_reservation AFTER UPDATE ON Reservation
FOR EACH ROW
BEGIN
    INSERT INTO Historique_reservation (id_reservation, nb_place_res, num_place, type_place, statut, id_client, id_event, date_operation)
    VALUES (NEW.id_reservation, NEW.nb_place_res, NEW.num_place, NEW.type_place, NEW.statut, NEW.id_client, NEW.id_event, CURRENT_TIMESTAMP());
END;    

-- triger d'insertion de la table Historique_paiement lors de l'insertion d'un nouveau paiement
CREATE TRIGGER Enregistrement_historique_paiement AFTER INSERT ON Paiement
FOR EACH ROW
BEGIN
    INSERT INTO Historique_paiement (id_paiement, id_reservation, montant, mode_paiement, statut, date_operation, employe)
    VALUES (NEW.id_paiement, NEW.id_reservation, NEW.montant, NEW.mode_paiement, NEW.statut, CURRENT_TIMESTAMP(), CURRENT_USER());
END;

-- triger d'insertion de la table Historique_paiement lors de la modification d'un paiement
CREATE TRIGGER Maj_historique_paiement AFTER UPDATE ON Paiement
FOR EACH ROW
BEGIN
    INSERT INTO Historique_paiement (id_paiement, id_reservation, montant, mode_paiement, statut, date_operation, employe)
    VALUES (NEW.id_paiement, NEW.id_reservation, NEW.montant, NEW.mode_paiement, NEW.statut, CURRENT_TIMESTAMP(), CURRENT_USER());              
END;



drop trigger if exists AI_event ;

delete from Paiement where id_paiement > 0;
alter table Paiement AUTO_INCREMENT = 1;
delete from Reservation where id_reservation > 0;
alter table Reservation AUTO_INCREMENT = 1;
where num_place > 0;
alter table Place AUTO_INCREMENT = 1;


