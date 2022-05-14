           ENREGISTRER_VENTE.
           MOVE 0 TO trouveVente
           MOVE 0 TO VerifClient
           MOVE 0 TO VerifVente
           PERFORM WITH TEST AFTER UNTIL VerifVente = 0
                        DISPLAY "Entrez l'id de la vente:"
                        ACCEPT idVente
                        PERFORM VERIF_ID_VENTE
           END-PERFORM
           PERFORM WITH TEST AFTER UNTIL trouveVente = 1
                        DISPLAY "Entrez le nom du comic achete :"
                        ACCEPT titreRef
                        PERFORM VERIF_NOM_REF
           END-PERFORM

           PERFORM VERIF_CLIENT_VENTE

           MOVE FUNCTION CURRENT-DATE TO ve_dateVente



           PERFORM WITH TEST AFTER UNTIL ve_prixvente > 0
               DISPLAY "Entrez le prix de vente"
               ACCEPT ve_prixVente
           END-PERFORM

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
                DISPLAY "Ajout effectue"
                CLOSE fventes
            ELSE
                DISPLAY "Faire une commande et un achat "
                DISPLAY "Comic pas en stock"
            END-IF.

           VERIF_NOM_REF.
                OPEN INPUT finventaire
                MOVE titreRef TO fi_titre
                READ finventaire
                INVALID KEY MOVE 0 TO trouveVente
                NOT INVALID KEY MOVE 1 TO trouveVente
                END-READ
                CLOSE finventaire.

           VERIF_CLIENT_VENTE.

               OPEN INPUT fclients
                MOVE 0 TO testNomClient
                   DISPLAY"Entrez le nom du client : "
                   ACCEPT cl_nom
                   DISPLAY "Entrez le prenom du client : "
                   ACCEPT cl_prenom
                   PERFORM WITH TEST AFTER UNTIL fichierFin=1
                       READ fclients NEXT
                       AT END MOVE 1 TO fichierFin
                       NOT AT END
                       IF fc_nom = cl_nom AND fc_prenom = cl_prenom THEN
                          MOVE 1 TO testNomClient
                          MOVE fc_id TO idVerifClient
                       END-IF
                       END-READ
                   END-PERFORM
                   IF testNomClient = 0 THEN
                   DISPLAY "Le client n'existe pas , creation !"
                        PERFORM AJOUT_CLIENT
                   END-IF
                   CLOSE fclients.

           VERIF_ID_VENTE.
               MOVE idVente TO fv_id
               OPEN INPUT fventes
               READ fventes
               KEY IS fv_id
               INVALID KEY MOVE 0 TO VerifVente
               NOT INVALID KEY MOVE 1 TO VerifVente
               DISPLAY "Cle dejà existante"
               END-READ
               CLOSE fventes.

           VERIF_STOCKS.
           MOVE 0 TO ve_statut
           OPEN INPUT finventaire
               MOVE titreRef TO fi_titre
               READ finventaire
               INVALID KEY DISPLAY "erreur comic non trouve"
               NOT INVALID KEY
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
           DISPLAY cr_fclients
           MOVE idVerifClient TO fc_id
           READ fclients
           KEY IS fc_id
           INVALID KEY
           DISPLAY "Erreur client non trouve"
           NOT INVALID KEY
                   MOVE fc_ptsFidelite TO LatentPoint
                   ADD 1 TO LatentPoint END-ADD
                   MOVE LatentPoint TO fc_ptsFidelite
                   REWRITE tamp_fclient
                   END-REWRITE
                   DISPLAY cr_fclients
           END-READ

           CLOSE fclients
           OPEN INPUT fclients
           READ fclients
           KEY IS fc_id
           INVALID KEY DISPLAY "Erreur client non trouve"
           NOT INVALID KEY
                IF LatentPoint=fc_ptsFidelite THEN
                DISPLAY "Reussite de la reecriture pts fidelites"
                ELSE
                DISPLAY "Erreur reecriture pts fidelites"
                END-IF
           END-READ
           CLOSE fclients.

           MAJ_INVENTAIRE.
           OPEN I-O finventaire
           MOVE titreRef TO fi_titre
           READ finventaire KEY IS fi_titre
           INVALID KEY DISPLAY "Erreur comic non trouve"
           NOT INVALID KEY
           SUBTRACT 1 FROM fi_quantite END-SUBTRACT
           REWRITE tamp_finventaire
           INVALID KEY DISPLAY "Erreur reecriture inventaire"
           NOT INVALID KEY DISPLAY "Reussite de la reecriture stocks"

           END-REWRITE
           END-READ
           CLOSE finventaire.


           VERIF_ID_COMMANDE.
           MOVE idCommande TO fv_id
           OPEN INPUT fventes
           READ fventes
           KEY IS fv_id
           INVALID KEY MOVE 0 TO VerifVente
           NOT INVALID KEY MOVE 1 TO VerifVente
           END-READ
           CLOSE fventes.




           MAJ_STATUT_COMMANDE.
           MOVE 0 TO VerifVente
           MOVE 0 TO idCommande
           MOVE 0 TO VerifStatut

           PERFORM WITH TEST AFTER UNTIL VerifVente = 1
                   OPEN I-O fventes
                   DISPLAY "Entrez l'id de la commande: "
                   ACCEPT idCommande
                   READ fventes
                   KEY IS idCommande
                   INVALID KEY
                   MOVE 0 TO VerifVente
                   CLOSE fventes
                   NOT INVALID KEY
                   IF fv_statut = 0 THEN
                   DISPLAY "La vente n'est pas une commande"
                   ELSE
                      PERFORM WITH TEST AFTER UNTIL VerifStatut = 1
                           ACCEPT EtatStatut
                           IF EtatStatut > 1 AND EtatStatut < 4 THEN
                               MOVE 1 TO VerifStatut
                           ELSE
                               MOVE 0 TO VerifStatut
                           END-IF
                       END-PERFORM
                   MOVE EtatStatut TO fv_statut
                   REWRITE tamp_fvente
               INVALID KEY DISPLAY "Erreur de reecriture commande"
                 NOT INVALID KEY DISPLAY "La modification est faite"

                   MOVE 1 TO VerifVente
                   END-REWRITE
                   END-IF
                   END-READ
                   CLOSE fventes
           END-PERFORM.
