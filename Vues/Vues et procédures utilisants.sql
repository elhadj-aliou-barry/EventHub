-- Vue qui permet de donner des voir des statistiques en temps reel des evenements
create view Statistiques_des_evenements
as select id_event, standard_vendue , vip_vendue , balcon_vendue , taux_occupation(id_event) AS 'Taux_occupations', benefices(id_event) AS 'Revenus'
   from Statistique_evenement ;

-- vue qui permet d'afficher les catégories d'evenements d'Event Hub
CREATE OR REPLACE VIEW Performances_par_categorie AS
SELECT 
    e.categorie_event AS "Categorie",
    round(AVG(se.Taux_occupations),2) AS "Performances"
FROM Statistiques_des_evenements se, Evenement e
WHERE se.id_event = e.id_event
GROUP BY e.categorie_event;

-- procédure qui permet d'afficher les statistiques d'un evenement en utilisant la vue Statistiques_des_evenements
DROP PROCEDURE IF EXISTS Statistique_evenement_vue;

CREATE PROCEDURE Statistique_evenement_vue(IN se_id_event INT)
BEGIN
    CREATE OR REPLACE VIEW Informations_evenement_vue AS 
    SELECT 
        se.id_event AS `Id évènement`, 
        e.titre_event AS `Nom Évènement`,
        se.standard_vendue AS `Billets standards vendus`, 
        (sa.nb_place_standard - se.standard_vendue) AS `Billets standards restants`,
        se.vip_vendue AS `Billets VIP vendus`, 
        (sa.nb_place_vip - se.vip_vendue) AS `Billets vip restants`,
        se.balcon_vendue AS `Billets balcons vendus`, 
        (sa.nb_place_balcon - se.balcon_vendue) AS `Billets balcons restants`, 
        (se.balcon_vendue + se.vip_vendue + se.standard_vendue) / sa.capacite_max AS `Taux d'occupation`,
        (
            se.standard_vendue * e.prix_standard + 
            se.vip_vendue * e.prix_vip + 
            se.balcon_vendue * e.prix_balcon
        ) AS `Chiffre d'affaires`
    FROM Evenement e 
    JOIN Salle sa ON e.id_salle = sa.id_salle
    JOIN Statistique_evenement se ON e.id_event = se.id_event;

    SELECT * FROM Informations_evenement_vue
    WHERE `Id évènement` = se_id_event;
    
END;


-- procédure qui utilise la vue Performances_par_categorie pour afficher les performances d'une catégorie :
drop procedure if exists Afficher_performance_categorie ;
CREATE PROCEDURE Afficher_performance_categorie(IN p_categorie VARCHAR(50))
BEGIN
    SELECT *
    FROM Performances_par_categorie
    WHERE Categorie = p_categorie;
END ;