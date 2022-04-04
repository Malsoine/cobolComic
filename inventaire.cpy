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
                DISPLAY "Entrez le nom du comic cherché"
                ACCEPT titreRef
                OPEN INPUT finventaire
                MOVE titreRef TO fi_titre
                READ finventaire
                INVALID KEY DISPLAY "Ce comic n'existe pas"
                NOT INVALID KEY DISPLAY "Comic existant"
                END-READ
                CLOSE finventaire. 

