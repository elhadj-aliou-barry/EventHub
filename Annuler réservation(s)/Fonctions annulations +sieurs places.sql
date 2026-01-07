-- Annuler une réservation de plusieurs place
-- procedure de mise à jour des statistiques d'un evenement
CREATE PROCEDURE MAJ_N_annulation_statistiques (
    IN p_id_event INT,
    IN nombre_places INT ,
    IN p_type_place VARCHAR(20)
)
BEGIN
    IF p_type_place = 'Standard' THEN
        UPDATE Statistique_evenement
        SET standard_vendue = standard_vendue - nombre_places
        WHERE id_event = p_id_event;
    ELSEIF p_type_place = 'VIP' THEN
        UPDATE Statistique_evenement
        SET vip_vendue = vip_vendue - nombre_places
        WHERE id_event = p_id_event;
    ELSEIF p_type_place = 'Balcon' THEN
        UPDATE Statistique_evenement
        SET balcon_vendue = balcon_vendue - nombre_places
        WHERE id_event = p_id_event;
    END IF;

END;

-- procédure qui supprime plusieurs places
DROP PROCEDURE IF EXISTS Liberer_place_reservation_multiple;
CREATE PROCEDURE Liberer_place_reservation_multiple (
    IN p_num_place INT,
    IN p_id_event INT,
    IN p_nombres_place INT
)
BEGIN
    DECLARE compteur INT DEFAULT 0;
    WHILE compteur < p_nombres_place DO
        DELETE FROM Place
        WHERE num_place = (p_num_place + compteur) 
          AND id_event = p_id_event;
        SET compteur = compteur + 1;  
    END WHILE; 
END;
