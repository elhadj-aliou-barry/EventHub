DROP PROCEDURE IF EXISTS Annuler_reservation_multiple;
CREATE PROCEDURE Annuler_reservation_multiple (
    IN p_email VARCHAR(50),
    IN p_id_event INT,
    IN p_num_place INT,
    IN p_type_place VARCHAR(20),
    IN p_nombres_place INT
)
Annulation: BEGIN
    DECLARE p_id_reservation INT default NULL;
    DECLARE messages TEXT DEFAULT '';


    -- récupération de la réservation
    SET p_id_reservation = Recuperer_id_reservation(
        p_email, p_id_event, p_num_place
    );

    -- vérification existence
    IF p_id_reservation = 0 THEN
        SET messages = 'Reservation non trouvée';
        SELECT messages AS Message;
        LEAVE Annulation;
    END IF;

    START TRANSACTION;

        UPDATE Paiement
        SET statut = 'Remboursé'
        WHERE id_reservation = p_id_reservation;

        SET messages = CONCAT(messages, ' | Paiement remboursé');

        UPDATE Reservation
        SET statut = 'Annulée'
        WHERE id_reservation = p_id_reservation;

        SET messages = CONCAT(messages, ' | Réservation annulée');

        CALL Liberer_place_reservation_multiple(p_num_place,p_id_event,p_nombres_place);
        CALL MAJ_N_annulation_statistiques(p_id_event,p_nombres_place, p_type_place);

    COMMIT;

    SELECT messages AS Messages;
END ;

CALL Annuler_reservation_multiple('jean.dupont@gmail.com',4,1,'VIP',4);