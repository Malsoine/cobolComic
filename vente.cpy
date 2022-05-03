           ENREGISTRER_VENTE.
           PERFORM WITH TEST AFTER UNTIL trouveVente = 1
                        DISPLAY "Entrez le nom du comic acheté :"
                        ACCEPT nomComicVente
                        PERFORM VERIF_NOM_COMIC
           END-PERFORM
           PERFORM WITH TEST AFTER UNTIL VerifClient = 1
                        DISPLAY "Entrez l'id du client acheteur :"
                        ACCEPT idVerifClient
                        PERFORM VERIF_ID_CLIENT
           END-PERFORM
           DISPLAY "Entrez la date d'achat"
           ACCEPT fv_dateVente


           DISPLAY "VENTE".

           VERIF_NOM_COMIC.
                MOVE 0 TO trouveVente
                OPEN INPUT finventaire
                MOVE titreRef TO fi_titre
                READ finventaire
                INVALID KEY MOVE 0 TO trouveVente
                NOT INVALID KEY MOVE 1 TO trouveVente
                END-READ
                CLOSE finventaire.

           VERIF_ID_CLIENT.
               MOVE idVerifClient TO fc_id
               OPEN INPUT fclients
               READ fclients
               KEY IS fc_id
               INVALID KEY MOVE 0 TO VerifClient
               NOT INVALID KEY MOVE 1 TO VerifClient
               END-READ
               CLOSE fclients.
