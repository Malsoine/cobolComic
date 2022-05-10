         *>Cette méthode permet d'enregistrer un nouvel achat dans
         *>le fichier  
         ENREGISTRER_ACHAT.

                *>Demande à l'utilisateur de rentrer l'id de l'achat
                *>à enregistrer
                PERFORM WITH TEST AFTER UNTIL trouve = 0
                        DISPLAY "Entrez le numero d'id de l'achat"
                        ACCEPT idAchat
                        *>ON vérifie que cet id n'est pas déjà utilisé
                        *>pour un autre achat au sein du fichier
                        PERFORM VERIF_ID_ACHAT
                END-PERFORM

                *>Rentre la date du système pour la date d'achat
                MOVE FUNCTION CURRENT-DATE TO ac_dateAchat               

                *>Demande à l'utilisateur de rentrer le titre du comic
                *>acheté
                DISPLAY "Entrez le titre du comic achete"
                ACCEPT fa_titreComics

                *>Demande à l'utilisateur de rentrer la quantité achétée
                PERFORM WITH TEST AFTER UNTIL fa_quantite > 0
                        DISPLAY "Entrez la quantite achetee"
                        ACCEPT fa_quantite
                END-PERFORM
                
                *>Demande à l'utilisateur le prix unitaire d'achat
                PERFORM WITH TEST AFTER UNTIL fa_prixAchat > 0
                        DISPLAY "Entrez le prix d'achat"
                        ACCEPT fa_prixAchat
                END-PERFORM

                *>Demande à l'utilisateur de rentrer le nom du 
                *>fournisseur
                PERFORM WITH TEST AFTER UNTIL NOT fa_nomFournisseur=" "
                        DISPLAY "Entrez le nom du fournisseur"
                        ACCEPT fa_nomFournisseur
                END-PERFORM
                MOVE idAchat TO fa_id
                OPEN I-O fachats
                *>Ecriture de ce nouvel achat dans le fichier
                WRITE tamp_fachats
                END-WRITE
                MOVE fa_titreComics TO titreRef

                *>On vérifie que le titre du comic acheté existe déjà
                *>ou non dans le fichier inventaire
                PERFORM VERIF_TITRE_REF
                *>Le comic n'existe pas alors on crée une nouvelle 
                *>référence dans le fichier inventaire
                IF trouve = 0
                THEN DISPLAY "Le comic achete n'existe pas dans
                l'inventaire, il va donc y être ajoute"
                    *>Demande à l'utilisateur de rentrer l'id de la réf
                    PERFORM WITH TEST AFTER UNTIL trouve=0
                        DISPLAY "Entrez un identifiant"
                        ACCEPT idRef
                        *>On vérifie que l'id rentré par l'utilisateur
                        *>n'existe pas déjà dans le fichier
                        PERFORM VERIF_ID_REF
                    END-PERFORM

                    *>On récupère le titre du comic de l'achat que l'on
                    *>vient d'enregistrer pour l'utiliser dans la 
                    *>référence que l'on va ajouter
                    MOVE fa_titreComics TO fi_titre

                    *>Demande à l'utilisateur le nom de l'auteur du 
                    *>comic (non vide)
                    PERFORM WITH TEST AFTER UNTIL NOT fi_auteur=" "
                        DISPLAY "Entrez un auteur"
                        ACCEPT fi_auteur
                    END-PERFORM
                    
                    *>On récupère la quantité achetée pour l'utiliser 
                    *>dans la référence que l'on va ajouter
                    MOVE fa_quantite TO fi_quantite

                    *>Demande à l'utilisateur le prix unitaire de vente
                    *>du comic
                    PERFORM WITH TEST AFTER UNTIL fi_prix>0
                        DISPLAY "Entrez le prix de l'article"
                        ACCEPT fi_prix
                    END-PERFORM
                    OPEN I-O finventaire
                    *>Ecriture de cette nouvelle référence dans 
                    *>l'inventaire
                    WRITE tamp_finventaire
                    END-WRITE
                    CLOSE finventaire

                *>Le comic acheté existe déjà dans l'inventaire de 
                *>la boutique
                ELSE
                    OPEN I-O finventaire
                    
                    *>On récupère le titre du comic utilisé pour l'achat
                    *>qui vient d'être enregistré
                    MOVE fa_titreComics TO fi_titre
                    *>Lecture directe sur la clé principale qu'est le
                    *>titre du comic dans l'inventaire
                    READ finventaire KEY IS fi_titre
                    INVALID KEY DISPLAY "Erreur"
                    NOT INVALID KEY
                        *>On ajoute la quantité d'exemplaires du comic
                        *>que l'on vient d'acheter à la quantité déjà
                        *>présente en stock
                        ADD fa_quantite TO fi_quantite END-ADD
                        *>Réécriture de la référence avec la nouvelle
                        *>quantité
                        REWRITE tamp_finventaire
                             INVALID KEY DISPLAY "Erreur reecriture"
                     NOT INVALID KEY DISPLAY "Reussite de la reecriture"
                        END-REWRITE
                    END-READ
                    CLOSE finventaire
                 END-IF
                 CLOSE fachats.

        *>Cette méthode vérife que l'id de l'achat existe déjà ou non
        *>dans le fichier dachat
        VERIF_ID_ACHAT.
                MOVE 0 TO trouve
                MOVE 1 TO Wfin
                OPEN INPUT fachats
                MOVE idAchat TO fa_id
                READ fachats
                *>L'id d'achat n'est attribué à aucun achat 
                INVALID KEY MOVE 0 TO trouve
                *>L'id rentré existe déjà
                NOT INVALID KEY MOVE 1 TO trouve
                END-READ
                CLOSE fachats
                *>On ferme le fichier puis on le réouvre afin que le
                *>pointeur qui parcourt le fichier repart depuis le 
                *>début de celui-ci
                OPEN INPUT fachats
                *>On affiche les identifiants déjà attribués
                IF trouve = 1
                THEN 
                     DISPLAY "Liste des identifiants deja attribues"
                     PERFORM WITH TEST AFTER UNTIL Wfin =0
                        READ fachats NEXT
                        AT END 
                         DISPLAY "L'id entre est déjà attribue"
                         MOVE 0 TO Wfin
                        NOT AT END DISPLAY fa_id
                          DISPLAY "----------------"
                        END-READ
                     END-PERFORM
                END-IF
                CLOSE fachats.

        *>Cette méthode affiche l'ensemble des achats présents dans le
        *>fichier achat
        AFFICHER_ACHAT. 
                OPEN INPUT fachats
                MOVE 1 TO Wfin
                *>Lecture séquentielle du fichier jusqu'à sa fin
                PERFORM WITH TEST AFTER UNTIL Wfin = 0
                   READ fachats NEXT
                   AT END MOVE 0 TO Wfin
                   NOT AT END 
                       *>Affichage des informations liées à l'achat
                       DISPLAY "Id de l'achat :", fa_id
                       DISPLAY "Date de l'achat :", fa_dateAchat
                       DISPLAY "Id de l'achat :", fa_titreComics
                       DISPLAY "Quantite achetée :", fa_quantite
                       DISPLAY "Prix unitaire du comic :", fa_prixAchat
                       DISPLAY "Fournisseur :", fa_nomFournisseur
                       DISPLAY "----------------------------------"
                   END-READ
                END-PERFORM
                CLOSE fachats.
