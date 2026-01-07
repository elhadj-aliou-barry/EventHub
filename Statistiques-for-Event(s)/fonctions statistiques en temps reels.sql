-- fonction qui calcul le taux d'occupations d'une salle
drop function if exists taux_occupation ;
CREATE FUNCTION taux_occupation (e_id_event INT)
RETURNS DECIMAL(5,2)
DETERMINISTIC
READS SQL DATA
BEGIN 
    DECLARE places_occupees INT;
    DECLARE capacite_max_salle INT;
    DECLARE taux DECIMAL(5,2);

    SELECT vip_vendue + standard_vendue + balcon_vendue INTO places_occupees FROM Statistique_evenement WHERE id_event = e_id_event;
    SELECT capacite_max INTO capacite_max_salle FROM Salle WHERE id_salle = (SELECT id_salle FROM Evenement WHERE id_event = e_id_event);

    IF capacite_max_salle = 0 THEN RETURN 0; END IF;

    SET taux = CAST(places_occupees AS DECIMAL(5,2)) / capacite_max_salle;

    RETURN taux * 100;
END;

SELECT taux_occupation(4);

-- fonction qui retourne le prix d'une place 
drop function if exists prix_place ;
CREATE FUNCTION prix_place (
    p_id_event INT,
    p_type_place VARCHAR(20)
)
RETURNS DECIMAL(10,2)
DETERMINISTIC
READS SQL DATA
BEGIN
    DECLARE prix DECIMAL(10,2);

    SELECT 
        CASE 
            WHEN p_type_place = 'VIP' THEN prix_vip
            WHEN p_type_place = 'STANDARD' THEN prix_standard
            WHEN p_type_place = 'BALCON' THEN prix_balcon
            ELSE 0
        END
    INTO prix
    FROM Evenement
    WHERE id_event = p_id_event ;

    RETURN prix;
END;
select prix_place (4,'VIP') ;

-- fonction qui calcul le nombre de place occupé pour un type
CREATE FUNCTION nb_places_occupees_type (
    p_id_event INT,
    p_type_place VARCHAR(20)
)
RETURNS INT
DETERMINISTIC
READS SQL DATA
BEGIN
    DECLARE nb INT;

    SELECT 
        CASE 
            WHEN p_type_place = 'STANDARD' THEN standard_vendue
            WHEN p_type_place = 'VIP' THEN vip_vendue
            WHEN p_type_place = 'BALCON' THEN balcon_vendue
            ELSE 0
        END
    INTO nb
    FROM Statistique_evenement
    WHERE id_event = p_id_event;

    RETURN nb;
END;

select nb_places_occupees_type (4,'VIP') ;


-- fonction qui calcul les bénéfices totaux obtenues 
DROP FUNCTION IF EXISTS BENEFICES ;
CREATE FUNCTION benefices(e_id_event INT)
RETURNS DECIMAL(15,2)
DETERMINISTIC
READS SQL DATA
BEGIN
    DECLARE revenus_total DECIMAL(15,2);
    -- calcul du total en multipliant prix * nombre de places pour chaque type
    SET revenus_total =
        nb_places_occupees_type(e_id_event, 'VIP') * prix_place(e_id_event, 'VIP') +
        nb_places_occupees_type(e_id_event, 'STANDARD') * prix_place(e_id_event, 'STANDARD') +
        nb_places_occupees_type(e_id_event, 'BALCON') * prix_place(e_id_event, 'BALCON');

    RETURN revenus_total;
END;

select benefices (4) ;

