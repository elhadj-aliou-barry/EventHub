/*
    Fonction qui verifie si une place est disponible pour un evenement donne.
    Retourne 1 si la place est disponible, 0 sinon.
*/
DROP FUNCTION IF EXISTS Place_disponible_multiple;
CREATE FUNCTION Place_disponible_multiple(
    ide_event INT,
    nombre_places INT ,
    type_de_place VARCHAR(20),
    numero_place INT
)
RETURNS INT
DETERMINISTIC
READS SQL DATA
BEGIN
    DECLARE v_id_salle INT;
    DECLARE num_rangee INT;
    DECLARE v_count INT DEFAULT 1;
    
    -- Utilisation correcte du paramètre ide_event
    SELECT id_salle INTO v_id_salle FROM Evenement E WHERE E.id_event = ide_event; 
    
    SET num_rangee= rangee_place(numero_place,v_id_salle);
    
    WHILE v_count <= nombre_places DO
        -- Correction de l'appel : id_event remplacé par ide_event
        IF Place_disponible_simple(ide_event, type_de_place, numero_place + v_count - 1) <> 0 OR rangee_place(numero_place + v_count-1,v_id_salle)<>num_rangee THEN
            RETURN  0;
        END IF;
        SET v_count = v_count + 1;
    END WHILE;
    RETURN 1 ;
END ; 



/*
    Fonction qui retourne le numero de la premiere place contigue disponible
    pour un evenement donne, un nombre de places et un type de place.
    Retourne 0 si aucune place n'est disponible.
*/
DROP FUNCTION IF EXISTS Place_contigue_disponible;
CREATE FUNCTION Place_contigue_disponible(
    ide_event INT,
    nombre_places INT,
    type_de_place VARCHAR(20)
)   
RETURNS INT
DETERMINISTIC
READS SQL DATA
BEGIN
    DECLARE v_id_salle INT;
    DECLARE nb_total_places INT;
    DECLARE num_debut INT DEFAULT 1;

    -- Récupérer l'id de la salle
    SELECT id_salle
    INTO v_id_salle
    FROM Evenement
    WHERE id_event = ide_event;

    -- Récupérer le nombre total de places dans la salle
    SELECT nb_place_vip + nb_place_standard + nb_place_balcon
    INTO nb_total_places
    FROM Salle
    WHERE id_salle = v_id_salle;

    -- Boucle pour tester chaque bloc possible
    WHILE num_debut <= nb_total_places - nombre_places + 1 DO
        IF Place_disponible_multiple(ide_event, nombre_places, type_de_place, num_debut) = 1 THEN
            RETURN num_debut; -- bloc trouvé
        END IF;
        SET num_debut = num_debut + 1;
    END WHILE;

    RETURN 0; -- aucun bloc disponible
END ; 

-- procedure qui permet d'inserer plusieurs place contigues réservé en statut 'Attente'
drop procedure if exists inserer_N_places ;
CREATE PROCEDURE inserer_N_places (
    IN p_id_client INT,
    IN p_id_event INT,
    IN Nombre_place INT,
    IN Num_debut_place INT,
    IN place_type VARCHAR(20)
)
BEGIN
    DECLARE i INT DEFAULT 1;
    DECLARE n INT;

    SET n = Num_debut_place;

    -- Boucle d'insertion
    WHILE i <= Nombre_place DO
        CALL inserer_place(p_id_event, n, place_type) ;
        SET n = n + 1;
        SET i = i + 1;
    END WHILE;
END;

-- FUNCTION POUR INSERER UNE RESERVATION DE PLUSIEURS PLACES
CREATE FUNCTION inserer_N_reservation (
    p_id_client INT,
    p_id_event INT,
    p_N_place INT,       -- numéro de la place
    p_N_place_res INT,   -- nombre de places réservées
    p_place_type VARCHAR(20)
)
RETURNS INT
MODIFIES SQL DATA
BEGIN
    INSERT INTO Reservation (num_place, nb_place_res, type_place, id_client, id_event)
    VALUES (p_N_place, p_N_place_res, p_place_type, p_id_client, p_id_event);
    
    RETURN LAST_INSERT_ID();
END;

/*
    Procédure qui met à jour les statistiques de vente de places
    pour un événement donné en fonction du type de place et du nombre de places vendues.
*/

CREATE PROCEDURE maj_N_statistiques (
    IN p_id_event INT,
    IN p_nombre_places INT,
    IN p_type_place VARCHAR(20)
)
BEGIN
    IF p_type_place = 'Standard' THEN
        UPDATE Statistique_evenement
        SET standard_vendue = standard_vendue + p_nombre_places
        WHERE id_event = p_id_event;
    ELSEIF p_type_place = 'VIP' THEN
        UPDATE Statistique_evenement
        SET vip_vendue = vip_vendue + p_nombre_places
        WHERE id_event = p_id_event;
    ELSEIF p_type_place = 'Balcon' THEN
        UPDATE Statistique_evenement
        SET balcon_vendue = balcon_vendue + p_nombre_places
        WHERE id_event = p_id_event;
    END IF;
END;