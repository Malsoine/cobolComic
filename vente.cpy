           ENREGISTRER_VENTE.
           MOVE 0 TO trouveVente
           MOVE 0 TO VerifClient
           MOVE 0 TO VerifVente
           PERFORM WITH TEST AFTER UNTIL VerifVente = 0
                        DISPLAY "Entrez l'id de la vente:"
                        ACCEPT idVente
                        PERFORM VERIF_ID_VENTE
           END-PERFORM
           PERFORM WITH TEST AFTER UNTIL NOT titreRef = " "
                        DISPLAY "Entrez le nom du comic acheté :"
                        ACCEPT titreRef
                        PERFORM VERIF_NOM_REF
           END-PERFORM
           PERFORM WITH TEST AFTER UNTIL idVerifClient > 0
                        DISPLAY "Entrez l'id du client acheteur :"
                        ACCEPT idVerifClient
                        PERFORM VERIF_ID_CLIENT
           END-PERFORM
           DISPLAY "Entrez la date de vente"
           ACCEPT ve_dateVente

           PERFORM WITH TEST AFTER UNTIL ve_prixvente > 0
               DISPLAY "Entrez le prix de vente"
               ACCEPT ve_prixVente
           END-PERFORM
           DISPLAY trouveVente
           IF trouveVente = 0 THEN
               DISPLAY "Comic non trouvé, erreur"
           ELSE
               IF VerifClient = 0 THEN
                   DISPLAY "Client non trouvé, créer un client d'abord"
               ELSE
                    PERFORM VERIF_STOCKS
                    IF ve_statut = 0 THEN
                        MOVE idVerifClient TO ve_client
                        MOVE idVente TO ve_id
                        MOVE titreRef TO ve_titreComics

                        PERFORM MAJ_INVENTAIRE
                        PERFORM AJOUTER_PTS_FIDELITE
                        OPEN I-O fventes
                        MOVE vente TO tamp_fvente
                        WRITE tamp_fvente
                        END-WRITE
                        DISPLAY "Ajout effectué"
                        CLOSE fventes



                    ELSE
                        DISPLAY "Faire une commande et un achat "
                        DISPLAY "Comic pas en stock"
                    END-IF
               END-IF
           END-IF.

           VERIF_NOM_REF.
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

           VERIF_ID_VENTE.
               MOVE idVente TO fv_id
               OPEN INPUT fventes
               READ fventes
               KEY IS fv_id
               INVALID KEY MOVE 0 TO VerifVente

               NOT INVALID KEY MOVE 1 TO VerifVente
               DISPLAY "Clé déjà existante"
               END-READ
               CLOSE fventes.

           VERIF_STOCKS.
           MOVE 0 TO ve_statut
           OPEN INPUT finventaire
               MOVE 1 TO Wfin
               MOVE nomComicVente TO fi_titre
               DISPLAY fi_titre
               READ finventaire
           INVALID KEY MOVE 5 to ve_statut
                NOT INVALID KEY
                DISPLAY "test"
                MOVE 0 TO Wfin
                   IF fi_quantite > 0
                   THEN
                       MOVE 0 TO ve_statut
                   ELSE
                       MOVE 1 TO ve_statut
                   END-IF
                END-READ
           CLOSE finventaire.


           AJOUTER_PTS_FIDELITE.
           OPEN I-O fclients
           MOVE idVerifClient TO fc_id
           READ fclients KEY IS fc_id
           INVALID KEY DISPLAY "Erreur"
           NOT INVALID KEY
           ADD 1 TO fc_ptsFidelite END-ADD
           REWRITE tamp_fclient
           INVALID KEY DISPLAY "Erreur reecriture"
           NOT INVALID KEY DISPLAY "Reussite de la reecriture"
           END-REWRITE
           END-READ
           CLOSE fclients.

           MAJ_INVENTAIRE.
           OPEN I-O finventaire
           MOVE titreRef TO fi_titre
           READ finventaire KEY IS fi_titre
           INVALID KEY DISPLAY "Erreur"
           NOT INVALID KEY
           SUBTRACT 1 FROM fi_quantite END-SUBTRACT
           REWRITE tamp_finventaire
           INVALID KEY DISPLAY "Erreur reecriture"
           NOT INVALID KEY DISPLAY "Reussite de la reecriture"
           END-REWRITE
           END-READ
           CLOSE finventaire.
