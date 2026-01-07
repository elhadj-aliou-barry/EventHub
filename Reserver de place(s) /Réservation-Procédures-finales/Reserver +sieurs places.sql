drop procedure if exists Reserver_places_multiple ;
CREATE PROCEDURE Reserver_places_multiple (
    IN p_id_client INT,
    IN p_id_event INT,
    IN p_nombre_places INT,
    IN p_Num_debut_place INT ,
    IN p_place_type VARCHAR(20),
    IN p_mode_paiement VARCHAR(20)
)
Main: BEGIN
    DECLARE Processus TEXT DEFAULT '';
    DECLARE num_debut_place INT;
    DECLARE reservation_id INT;
    DECLARE prix_place DECIMAL(10,2);

    DECLARE limit_vip INT;
    DECLARE limit_standard INT;
    DECLARE limit_balcon INT;
    DECLARE messages TEXT DEFAULT '';
    DECLARE rangee INT;

    -- Validation du type de place et limites
    Validation: BEGIN
        SELECT nb_place_vip INTO limit_vip FROM Salle WHERE id_salle = (SELECT id_salle FROM Evenement WHERE id_event = p_id_event LIMIT 1);
        SELECT nb_place_vip + nb_place_standard INTO limit_standard FROM Salle WHERE id_salle = (SELECT id_salle FROM Evenement WHERE id_event = p_id_event LIMIT 1);
        SELECT nb_place_vip + nb_place_standard + nb_place_balcon INTO limit_balcon FROM Salle WHERE id_salle = (SELECT id_salle FROM Evenement WHERE id_event = p_id_event LIMIT 1);

        -- Vérification limites selon type de place
        IF p_place_type = 'VIP' THEN
            IF p_nombre_places > limit_vip THEN
                SET Processus = 'Nombre de places demandé est trop élevé pour VIP | ';
                LEAVE Validation;
            END IF;
        ELSEIF p_place_type = 'Standard' THEN
            IF p_nombre_places > (limit_standard - limit_vip) THEN
                SET Processus = 'Nombre de places trop élevé pour Standard | ';
                LEAVE Validation;
            END IF;
        ELSEIF p_place_type = 'Balcon' THEN
            IF p_nombre_places > (limit_balcon - limit_standard) THEN
                SET Processus = 'Nombre de places trop élevé pour Balcon | ';
                LEAVE Validation;
            END IF;
        ELSE
            SET Processus = 'Type de place invalide | ';
            LEAVE Validation;
        END IF;
    END Validation;

    IF Processus <> '' THEN
        SELECT Processus AS "Etapes de la réservation";
        LEAVE Main;
    END IF;

    -- Vérification de cohérence entre numéro de place de départ et type de place
    Coherence: BEGIN
        IF p_place_type = 'VIP' THEN
            IF p_Num_debut_place < 1 OR p_Num_debut_place > limit_vip THEN
                SET Processus = 'Numéro invalide pour une place VIP | ';
                LEAVE Coherence;
            END IF;
        ELSEIF p_place_type = 'Standard' THEN
            IF p_Num_debut_place <= limit_vip OR p_Num_debut_place > limit_standard THEN
                SET Processus = 'Numéro invalide pour une place Standard | ';
                LEAVE Coherence;
            END IF;
        ELSEIF p_place_type = 'Balcon' THEN
            IF p_Num_debut_place <= limit_standard OR p_Num_debut_place > limit_balcon THEN
                SET Processus = 'Numéro invalide pour une place Balcon | ';
                LEAVE Coherence;
            END IF;
        ELSE
            SET Processus = 'Type de place invalide | ';
            LEAVE Coherence;
        END IF;
    END Coherence;

    IF Processus <> '' THEN
        SELECT Processus AS "Etapes de la réservation";
        LEAVE Main;
    END IF;

    -- Vérifier si les places contiguës sont libres à partir de p_Num_debut_place
IF Place_disponible_multiple(p_id_event, p_nombre_places, p_place_type, p_Num_debut_place) = 1 THEN
    SET num_debut_place = p_Num_debut_place;

    START TRANSACTION;
     SELECT 1 INTO @dummy FROM Evenement WHERE id_event = p_id_event FOR UPDATE; 
    -- Insérer la réservation des places
    SET reservation_id = inserer_N_reservation(p_id_client, p_id_event, p_Num_debut_place, p_nombre_places, p_place_type);
    CALL inserer_N_places(p_id_client, p_id_event, p_nombre_places, p_Num_debut_place, p_place_type);

    -- Insérer le paiement pour toutes les places
    SET prix_place = Determiner_prix_place(p_id_event, p_place_type) * p_nombre_places;
    CALL inserer_paiement(prix_place, p_mode_paiement);

    -- Mettre à jour les statuts
    UPDATE Paiement SET statut = 'Confirmé' WHERE id_reservation = reservation_id;
    UPDATE Reservation SET statut = 'Confirmée' WHERE id_reservation = reservation_id;

    -- Mettre à jour les statistiques
    CALL maj_N_statistiques(p_id_event, p_nombre_places, p_place_type);

    COMMIT;

    SET Processus = CONCAT('Réservation de ', p_nombre_places, ' places ', p_place_type, ' confirmée à partir de la place ', num_debut_place, ' | ');
    SET messages = 'Réservation effectuée avec succès.';

ELSE
    -- Chercher le premier bloc contigu disponible
    SET num_debut_place = Place_contigue_disponible(p_id_event, p_nombre_places, p_place_type);

    IF num_debut_place > 0 THEN
        SET messages = CONCAT('Il n''y a pas ', p_nombre_places,' places côtes à côtes disponible à partir de la place ',p_Num_debut_place,' pour ce type.    | Premier bloc disponible à partir de la place ', num_debut_place);
    ELSE
        SET messages = CONCAT('Impossible de réserver ', p_nombre_places, ' places côtes à côtes pour des places ', p_place_type, '. |      Il n''y a plus ',p_nombre_places,' côtes à cotes pour cette classe de place ');
    END IF;

    SET Processus = 'Réservation non confirmée.';
END IF;

-- Affichage des résultats
IF num_debut_place = p_Num_debut_place THEN
    SELECT Processus AS "Etapes de la réservation";
ELSE 
    SELECT messages AS "Message de reservation";
END IF ;
END ;

CALL Reserver_places_multiple(1,4,2,5,'VIP','Carte bancaire');
