-- Reserver_place_simple(client, event, place ,type de place, mode de paiement)
call Reserver_place_simple(1,1,1,'VIP','Espèce'); 
call Reserver_place_simple(2,1,5,'VIP','Carte bancaire');
-- Reserver_places_multiple (client, event, place , Nombre de place ,type de place, mode de paiement)
call Reserver_places_multiple (3,1,2,2,'VIP','Espèce');
call Reserver_places_multiple (4,1,3,4,'VIP','Espèce'); -- erreur

-- test des vues et des procédures des statistiques en temps réel 
call Statistique_evenement_vue(1) ;
call Afficher_performance_categorie ('Musique') ; 


-- test de l'annulation des réservations :
-- 
-- Annuler_reservation_multiple (p_email, p_id_event, p_num_place ,  p_type_place, p_nombres_place )

-- Pour une place Annuler_reservation('email',id_event,num_place,'type_place') 
call Annuler_reservation('yassine@eventhub.ma',1,1,'vip') ; 
call Annuler_reservation('khadija@eventhub.ma',1,5,'vip') ; 
-- Pour plusieurs places 
CALL Annuler_reservation_multiple('othmane@eventhub.ma',1,2,'VIP',2); 