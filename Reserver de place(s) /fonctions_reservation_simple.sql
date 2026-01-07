/* Fonction Place_disponible_simple
   Vérifie la disponibilité d'une place spécifique pour un événement donné.

   Paramètres :
     idevent      : Identifiant de l'événement
     type_place   : Type de la place ('standard', 'vip', 'balcon')
     numero_place : Numéro de la place spécifique à vérifier

   Valeurs de retour :
     0 : La place est disponible
     1 : Pas de places disponibles pour ce type
     2 : La place spécifique est déjà réservée
*/
drop function if exists Place_disponible_simple;
CREATE FUNCTION Place_disponible_simple(
    ide_event INT,
    type_de_place VARCHAR(20),
    numero_place INT
)
RETURNS INT
DETERMINISTIC 
BEGIN
    DECLARE nbplace_dispo INT DEFAULT 0;
    DECLARE place_reservee INT DEFAULT 0;

    IF type_de_place = 'standard' THEN

        SELECT sa.nb_place_standard - se.standard_vendue
        INTO nbplace_dispo
        FROM Evenement e
        JOIN Salle sa ON e.id_salle = sa.id_salle
        JOIN Statistique_evenement se ON e.id_event = se.id_event
        WHERE e.id_event = ide_event;

    ELSEIF type_de_place = 'vip' THEN

        SELECT sa.nb_place_vip - se.vip_vendue
        INTO nbplace_dispo
        FROM Evenement e
        JOIN Salle sa ON e.id_salle = sa.id_salle
        JOIN Statistique_evenement se ON e.id_event = se.id_event
        WHERE e.id_event = ide_event;

    ELSEIF type_de_place = 'balcon' THEN

        SELECT sa.nb_place_balcon - se.balcon_vendue
        INTO nbplace_dispo
        FROM Evenement e
        JOIN Salle sa ON e.id_salle = sa.id_salle
        JOIN Statistique_evenement se ON e.id_event = se.id_event
        WHERE e.id_event = ide_event;

    ELSE
        RETURN 1; -- type invalide
    END IF;

    /* Plus de places disponibles pour ce type */
    IF nbplace_dispo <= 0 THEN
        RETURN 1;
    END IF;

    /* Vérifier si la place précise est déjà réservée */
    SELECT COUNT(*)
    INTO place_reservee
    FROM Place P
    WHERE P.id_event = ide_event
      AND num_place = numero_place
      AND P.type_place = type_de_place;

    IF place_reservee > 0 THEN
        RETURN 2;
    END IF;

    /* Tout est OK */
    RETURN 0;
END ;

drop procedure if exists inserer_place;
CREATE PROCEDURE inserer_place (
    IN id_event INT,
    IN N_place INT,
    IN place_type VARCHAR(20)
)
 BEGIN
    -- variables necessaires
    DECLARE salle INT;
    DECLARE N_rangee INT;

    -- Récupérer le numéro de la salle de l'événement
    SELECT id_salle INTO salle
    FROM Evenement E
    WHERE E.id_event = id_event;

    -- Calculer le numéro de la rangée
    SET N_rangee = rangee_place (N_place,salle) ;

    -- Insérer la place
    INSERT INTO Place (num_place, num_rangee, id_salle, type_place,id_event)
    VALUES (N_place, N_rangee, salle, place_type,id_event);
END;

-- fonction qui ramene le numero de la rangée d'une place
CREATE FUNCTION rangee_place (
    num_place INT,
    salle INT
)
RETURNS INT
DETERMINISTIC
READS SQL DATA
BEGIN
    DECLARE N_rangee INT;
    DECLARE nb_place_range INT;

    SET nb_place_range = (SELECT nb_place_rangee FROM Salle WHERE id_salle = salle);
    SET N_rangee = (num_place - 1) DIV nb_place_range + 1;

    RETURN N_rangee;
END;

-- FUNCTION POUR INSERER UNE RESERVATION
CREATE FUNCTION inserer_reservation (
    p_id_client INT,
    p_id_event INT,
    p_N_place INT,
    p_place_type VARCHAR(20)
)
RETURNS INT
DETERMINISTIC
BEGIN
    INSERT INTO Reservation (num_place, type_place, id_client, id_event)
    VALUES (p_N_place, p_place_type, p_id_client, p_id_event);
    RETURN LAST_INSERT_ID();
END;



-- Procedure pour inserer un paiement
CREATE PROCEDURE inserer_paiement (
    IN p_montant DECIMAL(10,2),
    IN p_mode_paiement VARCHAR(20)
)
BEGIN
    DECLARE p_id_reservation INT; 
-- recuperer la derniere reservation inseree 
    SET p_id_reservation = (select MAX(id_reservation) from Reservation);
    INSERT INTO Paiement (id_reservation, montant, mode_paiement)
    VALUES (p_id_reservation, p_montant, p_mode_paiement);
END;

-- PROCEDURE POUR METTRE A JOUR LA TABLE STATISTIQUE EVENEMENT
drop procedure if exists maj_statistiques ;
CREATE PROCEDURE maj_statistiques (
    IN p_id_event INT,
    IN p_type_place VARCHAR(20)
)
BEGIN
    IF p_type_place = 'Standard' THEN
        UPDATE Statistique_evenement
        SET standard_vendue = standard_vendue + 1
        WHERE id_event = p_id_event;
    ELSEIF p_type_place = 'VIP' THEN
        UPDATE Statistique_evenement
        SET vip_vendue = vip_vendue + 1
        WHERE id_event = p_id_event;
    ELSEIF p_type_place = 'Balcon' THEN
        UPDATE Statistique_evenement
        SET balcon_vendue = balcon_vendue + 1
        WHERE id_event = p_id_event;
    END IF;

END; 


-- FONCTION POUR OBTENIR LE PRIX D'UNE PLACE SELON SON TYPE
CREATE FUNCTION Determiner_prix_place (
    id_event INT,
    type_place VARCHAR(20)
) RETURNS DECIMAL(10,2)
BEGIN
    DECLARE prix DECIMAL(10,2);

    IF type_place = 'Standard' THEN
        SELECT prix_standard INTO prix FROM Evenement E WHERE E.id_event = id_event;
    ELSEIF type_place = 'VIP' THEN
        SELECT prix_vip INTO prix FROM Evenement E WHERE E.id_event = id_event;
    ELSEIF type_place = 'Balcon' THEN
        SELECT prix_balcon INTO prix FROM Evenement E WHERE E.id_event = id_event;
    END IF;

    RETURN prix;
END;

