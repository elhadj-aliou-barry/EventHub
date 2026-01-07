drop procedure if exists Reserver_place_simple ;
drop procedure if exists Reserver_place_simple ;
CREATE PROCEDURE Reserver_place_simple (
    IN p_id_client INT,
    IN p_id_event INT,
    IN p_Num_place INT,
    IN p_place_type VARCHAR(20),
    IN p_mode_paiement VARCHAR(20)
)
Main: BEGIN
    DECLARE disponibilite INT;
    DECLARE prix_place DECIMAL(10,2);
    DECLARE reservation_id INT;
    DECLARE Processus TEXT DEFAULT '';

    DECLARE limit_vip INT;
    DECLARE limit_standard INT;
    DECLARE limit_balcon INT;


    Validation: BEGIN -- bloc de verification de la cohérence entre le numero de la place et le type renseigné

        SELECT nb_place_vip INTO limit_vip FROM Salle WHERE id_salle = (SELECT id_salle FROM Evenement WHERE id_event = p_id_event);
        SELECT nb_place_vip + nb_place_standard INTO limit_standard FROM Salle WHERE id_salle = (SELECT id_salle FROM Evenement WHERE id_event = p_id_event);
        SELECT nb_place_vip + nb_place_standard + nb_place_balcon INTO limit_balcon FROM Salle WHERE id_salle = (SELECT id_salle FROM Evenement WHERE id_event = p_id_event);
        -- Pour une place de type VIP
        IF p_place_type = 'VIP' THEN
            IF p_Num_place < 1 OR p_Num_place > limit_vip THEN
                SET Processus = 'Numéro invalide pour une place VIP | ';
                LEAVE Validation;
            END IF;
         -- Pour une place de type Standard 
        ELSEIF p_place_type = 'Standard' THEN
            IF p_Num_place <= limit_vip OR p_Num_place > limit_standard THEN
                SET Processus = 'Numéro invalide pour une place Standard | ';
                LEAVE Validation;
            END IF;
         -- Pour une place de type Balcon
        ELSEIF p_place_type = 'Balcon' THEN
            IF p_Num_place <= limit_standard OR p_Num_place > limit_balcon THEN
                SET Processus = 'Numéro invalide pour une place Balcon | ';
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


    START TRANSACTION;

    SELECT 1 INTO @dummy FROM Evenement WHERE id_event = p_id_event FOR UPDATE; -- verrou de la place

    SET disponibilite = Place_disponible_simple(p_id_event, p_place_type, p_Num_place);

    IF disponibilite = 0 THEN

        SET reservation_id = inserer_reservation(p_id_client, p_id_event, p_Num_place, p_place_type);
        CALL inserer_place(p_id_event, p_Num_place, p_place_type);
        SET prix_place = Determiner_prix_place(p_id_event, p_place_type);
        CALL inserer_paiement(prix_place, p_mode_paiement);

        UPDATE Paiement SET statut = 'Confirmé' WHERE id_reservation = reservation_id;
        UPDATE Reservation SET statut = 'Confirmée' WHERE id_reservation = reservation_id;

        CALL maj_statistiques(p_id_event, p_place_type);

        COMMIT;

        SET Processus = 'Réservation confirmée avec succès | ';

    ELSEIF disponibilite = 1 THEN
        ROLLBACK;
        SET Processus = CONCAT('Plus de places ', p_place_type, ' disponibles | ');

    ELSE
        ROLLBACK;
        SET Processus = CONCAT('La place ', p_Num_place, ' est déjà réservée | ');
    END IF;

    SELECT Processus AS "Etapes de la réservation";

END;



-- test de la procedure de reservation

call Reserver_place_simple (7,4,99,'balcon','espece') ;

