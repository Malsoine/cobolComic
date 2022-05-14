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

           *>Récupération du prix de vente du comic dans le fichier
           *>inventaire          
           PERFORM RECUPERER_PRIX_DE_VENTE

           *>Vérification du nombre d'exemplaire du comic en stock
            PERFORM VERIF_STOCKS
           *>IL y a des exemplaires en stock
            IF fv_statut = 0 THEN
                MOVE idVerifClient TO fv_client
                MOVE idVente TO fv_id
                MOVE titreRef TO fv_titreComics

                PERFORM MAJ_INVENTAIRE
                PERFORM AJOUTER_PTS_FIDELITE

                OPEN I-O fventes
                WRITE tamp_fvente
                END-WRITE
                DISPLAY "Vente enregistree"
                CLOSE fventes
            *>Il n'y a pas d'exemplaire en stock on effectue donc une
            *>commande
            ELSE
                DISPLAY "Le comic voulu n'a pas d'exemplaire en stock"
                DISPLAY "On enregistre donc une commande"
                MOVE idVerifClient TO fv_client
                MOVE idVente TO fv_id
                MOVE titreRef TO fv_titreComics

                PERFORM MAJ_INVENTAIRE
                PERFORM AJOUTER_PTS_FIDELITE

                OPEN I-O fventes
                WRITE tamp_fvente
                END-WRITE
                DISPLAY "Commande enregistree"
                CLOSE fventes
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
                MOVE 1 TO fichierFin
                   DISPLAY"Entrez le nom du client : "
                   ACCEPT cl_nom
                   DISPLAY "Entrez le prenom du client : "
                   ACCEPT cl_prenom
                   PERFORM WITH TEST AFTER UNTIL fichierFin=0
                       READ fclients NEXT
                       AT END MOVE 0 TO fichierFin
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
               MOVE 1 TO Wfin
               OPEN INPUT fventes
               READ fventes
               KEY IS fv_id
               INVALID KEY MOVE 0 TO VerifVente
               NOT INVALID KEY MOVE 1 TO VerifVente
               END-READ
               CLOSE fventes
               IF VerifVente = 1 THEN
                  OPEN INPUT fventes
                  DISPLAY "Liste des id de ventes deja attribues"
                  PERFORM WITH TEST AFTER UNTIL Wfin =0
                        READ fventes NEXT
                        AT END 
                         MOVE 0 TO Wfin
                        NOT AT END DISPLAY fv_id
                          DISPLAY "----------------"
                        END-READ
                     END-PERFORM
                     CLOSE fventes
                END-IF.
                

           RECUPERER_PRIX_DE_VENTE.
                OPEN INPUT finventaire
                MOVE titreRef TO fi_titre
                READ finventaire
                INVALID KEY DISPLAY "erreur comic non trouve"
                NOT INVALID KEY
                    MOVE fi_prix TO fv_prixVente
                CLOSE finventaire.

           VERIF_STOCKS.
           MOVE 0 TO fv_statut
           OPEN INPUT finventaire
               MOVE titreRef TO fi_titre
               READ finventaire
               INVALID KEY DISPLAY "erreur comic non trouve"
               NOT INVALID KEY
               IF fi_quantite > 0
               THEN
                   MOVE 0 TO fv_statut
               ELSE
                   MOVE 1 TO fv_statut
               END-IF
                END-READ
           CLOSE finventaire.


           AJOUTER_PTS_FIDELITE.
           OPEN I-O fclients
           MOVE fv_client TO fc_id
           READ fclients KEY IS fc_id
                INVALID KEY
                        DISPLAY "Erreur client non trouve"
                NOT INVALID KEY
                        *>MOVE fc_ptsFidelite TO LatentPoint
                        ADD 1 TO fc_ptsFidelite END-ADD
                        *>MOVE LatentPoint TO fc_ptsFidelite
                        REWRITE tamp_fclient
                    INVALID KEY DISPLAY "Erreur ajout pts de fidelite"
           NOT INVALID KEY DISPLAY "Reussite ajout pts de fidelite"
                        END-REWRITE
           END-READ
           CLOSE fclients.      

           MAJ_INVENTAIRE.
           OPEN I-O finventaire
           MOVE titreRef TO fi_titre
           READ finventaire KEY IS fi_titre
                INVALID KEY DISPLAY "Erreur : comic non trouve"
                NOT INVALID KEY
                        SUBTRACT 1 FROM fi_quantite END-SUBTRACT
                REWRITE tamp_finventaire
           INVALID KEY DISPLAY "Erreur mise a jour du stock"
           NOT INVALID KEY DISPLAY "Reussite de la mise a jour du stock"
                        
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
               INVALID KEY 
            DISPLAY "Erreur de la modification du status de la commande"
                 NOT INVALID KEY DISPLAY "La modification est faite"

                   MOVE 1 TO VerifVente
                   END-REWRITE
                   END-IF
                   END-READ
                   CLOSE fventes
           END-PERFORM.

           *>Affiche la liste des ventes
           AFFICHER_VENTE.
                OPEN INPUT fventes
                MOVE 1 TO Wfin
                *>Lecture séquentielle du fichier jusqu'à sa fin
                PERFORM WITH TEST AFTER UNTIL Wfin = 0
                   READ fventes NEXT
                   AT END MOVE 0 TO Wfin
                   NOT AT END 
                       *>Affichage des informations liées à l'achat
                       DISPLAY "Id de la vente :", fv_id
                       DISPLAY "Statut de la vente :", fv_statut
                       DISPLAY "Date de la vente :", fv_dateVente
                       DISPLAY "Comic vendu :", fv_titreComics
                       DISPLAY "Prix de la vente :", fv_prixVente
                       DISPLAY "Id du client :", fv_client
                       DISPLAY "----------------------------------"
                   END-READ
                END-PERFORM
                CLOSE fventes.
