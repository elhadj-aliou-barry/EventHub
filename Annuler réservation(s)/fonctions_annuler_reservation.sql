/* Fonction pour recuperer l'id_client a partir de son email
  Parametres:
    r_email : email du client

  Valeur de retour:
    identifiant du client
*/

CREATE FUNCTION Recuperer_id_client(r_email VARCHAR(50))
RETURNS INT
DETERMINISTIC
BEGIN
   DECLARE v_id_client INT DEFAULT 0;

   SELECT id_client
   INTO v_id_client
   FROM Clients
   WHERE email = r_email
   LIMIT 1;

   RETURN v_id_client; 
END;

-- test de la fonction 
select Recuperer_id_client('nicolas.robert@gmail.com') as id_dupont ; 

/* Fonction pour recuperer l'id_reservation a partir de l'email du client, de l'id_event et du num_place
  Parametres:
    r_email : email du client
    r_id_event : identifiant de l'evenement
    r_num_place : numero de la place

  Valeur de retour:
    identifiant de la reservation
*/

CREATE FUNCTION Recuperer_id_reservation(r_email VARCHAR(50), r_id_event INT, r_num_place INT)
RETURNS INT
DETERMINISTIC
 BEGIN
   DECLARE v_id_reservation INT DEFAULT 0;
   DECLARE v_id_client INT;

   SET v_id_client = Recuperer_id_client(r_email);
  IF v_id_client = 0 THEN
      RETURN 0; -- client non trouve
   END IF;
   SELECT id_reservation
   INTO v_id_reservation
   FROM Reservation
   WHERE id_client = v_id_client 
     AND id_event = r_id_event 
     AND num_place = r_num_place
   LIMIT 1;

   RETURN v_id_reservation;
END;

-- test de le fonction Recuperer_id_reservation
select Recuperer_id_reservation ('amine.richard@gmail.com',2,27) ;

/* Procedure pour liberer une place lors de l'annulation d'une reservation
  Parametres:
    p_num_place : numero de la place a liberer
*/

CREATE PROCEDURE Liberer_place_reservation (
    IN p_num_place INT,
    IN p_id_event INT
)
BEGIN
    DELETE FROM Place
    WHERE num_place = p_num_place AND id_event = p_id_event ;
END;


/* Procedure pour mettre a jour les statistiques de l'evenement lors d'une annulation
  Parametres:
    p_id_event : identifiant de l'evenement
    p_type_place : type de la place annulee (standard, vip, balcon)
*/
CREATE PROCEDURE MAJ_annulation_statistiques (
    IN p_id_event INT,
    IN p_type_place VARCHAR(20)
)
BEGIN
    IF p_type_place = 'Standard' THEN
        UPDATE Statistique_evenement
        SET standard_vendue = standard_vendue - 1
        WHERE id_event = p_id_event;
    ELSEIF p_type_place = 'VIP' THEN
        UPDATE Statistique_evenement
        SET vip_vendue = vip_vendue - 1
        WHERE id_event = p_id_event;
    ELSEIF p_type_place = 'Balcon' THEN
        UPDATE Statistique_evenement
        SET balcon_vendue = balcon_vendue - 1
        WHERE id_event = p_id_event;
    END IF;
END;
