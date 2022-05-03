           ENREGISTRER_ACHAT.
                PERFORM WITH TEST AFTER UNTIL trouve = 0
                        DISPLAY "Entrez le numéro d'id de l'achat"
                        ACCEPT idAchat
                        PERFORM VERIF_ID_ACHAT
                END-PERFORM
                DISPLAY "Entrez la date d'achat"
                ACCEPT fa_dateAchat
                DISPLAY "Entrez le titre du comic acheté"
                ACCEPT fa_titreComics
                PERFORM WITH TEST AFTER UNTIL fa_quantite > 0
                        DISPLAY "Entrez la quantité acheté"
                        ACCEPT fa_quantite
                END-PERFORM
                PERFORM WITH TEST AFTER UNTIL fa_prixAchat > 0
                        DISPLAY "Entrez le prix d'achat"
                        ACCEPT fa_prixAchat
                END-PERFORM
                PERFORM WITH TEST AFTER UNTIL NOT fa_nomFournisseur=" "
                        DISPLAY "Entrez le nom du fournisseur"
                        ACCEPT fa_nomFournisseur
                END-PERFORM
                MOVE idAchat TO fa_id
                OPEN I-O fachats
                WRITE tamp_fachats
                END-WRITE
                MOVE fa_titreComics TO titreRef
                PERFORM VERIF_TITRE_REF
                IF trouve = 0
                THEN DISPLAY "Le comic achete n'existe pas dans
                l'inventaire, il va donc y être ajoute"
                    PERFORM WITH TEST AFTER UNTIL trouve=0
                        DISPLAY "Entrez un identifiant"
                        ACCEPT idRef
                        PERFORM VERIF_ID_REF
                    END-PERFORM
                    MOVE fa_titreComics TO fi_titre
                    PERFORM WITH TEST AFTER UNTIL NOT fi_auteur=" "
                        DISPLAY "Entrez un auteur"
                        ACCEPT fi_auteur
                    END-PERFORM
                    MOVE fa_quantite TO fi_quantite
                    PERFORM WITH TEST AFTER UNTIL fi_prix>0
                        DISPLAY "Entrez le prix de l'article"
                        ACCEPT fi_prix
                    END-PERFORM
                    OPEN I-O finventaire
                    WRITE tamp_finventaire
                    END-WRITE
                    CLOSE finventaire
                ELSE
                    OPEN I-O finventaire
                    MOVE fa_titreComics TO fi_titre
                    READ finventaire KEY IS fi_titre
                    INVALID KEY DISPLAY "Erreur"
                    NOT INVALID KEY
                        ADD fa_quantite TO fi_quantite END-ADD
                        REWRITE tamp_finventaire
                             INVALID KEY DISPLAY "Erreur reecriture"
                     NOT INVALID KEY DISPLAY "Reussite de la reecriture"
                        END-REWRITE
                    END-READ
                    CLOSE finventaire
                 END-IF
                 CLOSE fachats.


        VERIF_ID_ACHAT.
                MOVE 0 TO trouve
                OPEN INPUT fachats
                MOVE idAchat TO fa_id
                READ fachats
                INVALID KEY MOVE 0 TO trouve
                NOT INVALID KEY MOVE 1 TO trouve
                END-READ
                CLOSE fachats.

        AFFICHER_ACHAT. 
                OPEN INPUT fachats
                MOVE 1 TO Wfin
                PERFORM WITH TEST AFTER UNTIL Wfin = 0
                   READ fachats NEXT
                   AT END MOVE 0 TO Wfin
                   NOT AT END 
                       DISPLAY "Id de l'achat :", fa_id
                       DISPLAY "Date de l'achat :", fa_dateAchat
                       DISPLAY "Id de l'achat :", fa_titreComics
                       DISPLAY "Quantité achetée :", fa_quantite
                       DISPLAY "Prix unitaire du comics :", fa_prixAchat
                       DISPLAY "Fournisseur :", fa_nomFournisseur
                       DISPLAY "----------------------------------"
                   END-READ
                END-PERFORM
                CLOSE fachats.
