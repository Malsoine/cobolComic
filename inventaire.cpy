       AJOUTER_REFERENCE.
                PERFORM WITH TEST AFTER UNTIL trouve=0
                        DISPLAY "Entrez un identifiant"
                        ACCEPT idRef
                        PERFORM VERIF_ID_REF
                END-PERFORM
                PERFORM WITH TEST AFTER UNTIL trouve=0
                        DISPLAY "Entrez un titre"
                        ACCEPT titreRef
                        PERFORM VERIF_TITRE_REF
                END-PERFORM
                PERFORM WITH TEST AFTER UNTIL NOT fi_auteur=" "
                        DISPLAY "Entrez un auteur"
                        ACCEPT fi_auteur
                END-PERFORM
                PERFORM WITH TEST AFTER UNTIL fi_quantite>=0
                        DISPLAY "Entrez la quantité"
                        ACCEPT fi_quantite
                END-PERFORM
                PERFORM WITH TEST AFTER UNTIL fi_prix>0
                        DISPLAY "Entrez le prix de l'article"
                        ACCEPT fi_prix
                END-PERFORM
                MOVE idRef TO fi_id
                MOVE titreRef TO fi_titre
                OPEN I-O finventaire
                WRITE tamp_finventaire
                END-WRITE
                CLOSE finventaire.

        VERIF_ID_REF.
                MOVE 0 TO trouve
                OPEN INPUT finventaire
                MOVE idRef TO fi_id
                READ finventaire
                INVALID KEY MOVE 0 TO trouve
                NOT INVALID KEY MOVE 1 TO trouve
                END-READ
                CLOSE finventaire.

        VERIF_TITRE_REF.
                MOVE 0 TO trouve
                OPEN INPUT finventaire
                MOVE titreRef TO fi_titre
                READ finventaire
                INVALID KEY MOVE 0 TO trouve
                NOT INVALID KEY MOVE 1 TO trouve
                END-READ
                CLOSE finventaire.

        SUPPRIMER_REFERENCE.
                MOVE 0 TO trouve
                DISPLAY "Entrez le nom du comic à supprimer"
                ACCEPT fi_titre
                OPEN I-O finventaire
                READ finventaire KEY IS fi_titre
                INVALID KEY DISPLAY "Ce comic n'existe pas"
                NOT INVALID KEY DELETE finventaire
                DISPLAY "Suppression effectuée"
                END-READ
                CLOSE finventaire.

        RECHERCHER_REFERENCE.
        DISPLAY "Chercher avec le titre (1) ou l'auteur (2) du comic?"
                ACCEPT choixRechercheC
                EVALUATE choixRechercheC
                WHEN 1
                   DISPLAY "Entrez le nom du comic cherché"
                   ACCEPT titreRef
                   OPEN INPUT finventaire
                   MOVE titreRef TO fi_titre
                   READ finventaire
           INVALID KEY DISPLAY "Ce comic n'existe pas dans l'inventaire"
                   NOT INVALID KEY
                   DISPLAY "Nom du comic : ", fi_titre
                   DISPLAY "Auteur du comic : ", fi_auteur
               DISPLAY "Quantité disponible en stock : ", fi_quantite
                   DISPLAY "Prix du comic : ", fi_prix
                   DISPLAY "---------------------------"
                   END-READ
                WHEN 2
                   MOVE 1 TO Wfin
                   DISPLAY "Entrez le nom de l'auteur cherche"
                   ACCEPT nomAuteur
                   OPEN INPUT finventaire
                   MOVE nomAuteur TO fi_auteur
                   START finventaire, KEY IS = fi_auteur
               INVALID KEY DISPLAY "Aucun comic de cet auteur n'existe"
                   NOT INVALID KEY
                      PERFORM WITH TEST AFTER UNTIL Wfin = 0
                         READ finventaire NEXT
                         AT END MOVE 0 TO Wfin
                         NOT AT END
                         DISPLAY "Nom du comic : ", fi_titre
                         DISPLAY "Auteur du comic : ", fi_auteur
                 DISPLAY "Quantité disponible en stock : ", fi_quantite
                         DISPLAY "Prix du comic : ", fi_prix
                         DISPLAY "--------------------------"
                         END-READ
                      END-PERFORM
                   END-START
                WHEN OTHER
                   DISPLAY "Choix invalide"
                END-EVALUATE
                CLOSE finventaire.

        MODIFIER_PRIX_COMIC.
       DISPLAY "Entrez le nom du comic que vous voulez modifier le prix"
            ACCEPT titreRef
            OPEN I-O finventaire
            MOVE titreRef TO fi_titre
            READ finventaire KEY IS fi_titre
                INVALID KEY DISPLAY "Ce comic n'existe"
                NOT INVALID KEY
                   DISPLAY "Entrez le nouveau prix de ce comic"
                   ACCEPT nouveauPrix
                   MOVE nouveauPrix TO fi_prix
                   REWRITE tamp_finventaire
                     INVALID KEY DISPLAY "Erreur de réecriture"
                     NOT INVALID KEY DISPLAY "La modification est faite"
                   END-REWRITE
                END-READ
            CLOSE finventaire.

        CONSULTER_INVENTAIRE.
       DISPLAY "Afficher les comics en stock (1)"
       DISPLAY "OU ceux que ne le sont pas (2)?"
                ACCEPT choixAffichageStock
                EVALUATE choixAffichageStock
                WHEN 1
                   OPEN INPUT finventaire
                   MOVE 1 TO Wfin
                   PERFORM WITH TEST AFTER UNTIL Wfin=0
                        READ finventaire NEXT
                        AT END MOVE 0 TO Wfin
                        NOT AT END
                           IF fi_quantite > 0
                           THEN DISPLAY "Nom du comic : ", fi_titre
                                DISPLAY "Auteur du comic : ", fi_auteur
                                DISPLAY "------------------------------"
                           END-IF
                        END-READ
                   END-PERFORM
                WHEN 2
                   OPEN INPUT finventaire
                   MOVE 1 TO Wfin
                   PERFORM WITH TEST AFTER UNTIL Wfin=0
                        READ finventaire NEXT
                        AT END MOVE 0 TO Wfin
                        NOT AT END
                            IF fi_quantite = 0
                            THEN DISPLAY "Nom du comic :", fi_titre
                                 DISPLAY "Auteur du comic :", fi_auteur
                            DISPLAY "------------------------------"
                            END-IF
                        END-READ
                   END-PERFORM
                WHEN OTHER
                   DISPLAY "Choix invalide"
                END-EVALUATE
                CLOSE finventaire.
