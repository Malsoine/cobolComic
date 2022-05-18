        *>Methode qui ajoute un nouveau comic dans l'inventaire 
        *>de la boutique, ce comic n'a pas d'exemplaires en stock,
        *>il est donc commandable
        *>Pour avoir un nouveau comic dans l'inventaire et qu'il ait
        *>des exemplaires en stock, il faut passer par la méthode
        *>ENREGISTRER_ACHAT
        AJOUTER_REFERENCE.
                *>On demande à l'utilisateur de rentrer l'id de la réf
                PERFORM WITH TEST AFTER UNTIL trouve=0
                        DISPLAY "Entrez un identifiant"
                        ACCEPT idRef
                        *>On vérifie que l'identifiant rentré par
                        *>l'utilisateur n'existe pas déjà dans
                        *>le fichier
                        PERFORM VERIF_ID_REF
                END-PERFORM

                *>On demande à l'utilisateur de rentrer le titre du
                *>comic à ajouter au fichier
                PERFORM WITH TEST AFTER UNTIL trouve=0
                        DISPLAY "Entrez un titre"
                        ACCEPT titreRef
                        *>On vérifie que le titre rentré par
                        *>l'utilisateur n'existe pas déjà
                        *>dans le fichier
                        PERFORM VERIF_TITRE_REF
                END-PERFORM

                *>On demande à l'utilisateur de rentrer le
                *>nom de l'auteur (non vide)
                PERFORM WITH TEST AFTER UNTIL NOT fi_auteur=" "
                        DISPLAY "Entrez un auteur"
                        ACCEPT fi_auteur
                END-PERFORM

                *>La quantité est par défaut 0 car cela signifie que 
                *>ce comic peut être commandé, si on veut ajouter un
                *>comic à l'inventaire de la boutique avec une quantite
                *>!=0 alors il faut passer par "enregistrer achat"
                MOVE 0 TO fi_quantite

                *>On demande à l'utilisateur de rentrer le prix de vente
                *>unitaire du comics (ni nul ni négatif)
                PERFORM WITH TEST AFTER UNTIL fi_prix>0
                        DISPLAY "Entrez le prix de vente du comic"
                        ACCEPT fi_prix
                END-PERFORM
                MOVE idRef TO fi_id
                MOVE titreRef TO fi_titre
                OPEN I-O finventaire
                WRITE tamp_finventaire
                END-WRITE
                CLOSE finventaire.

        *>Cette méthode vérifie que l'id donné est déjà attribué ou non
        *>à une référence dans l'inventaire
        VERIF_ID_REF.
                MOVE 0 TO trouve
                OPEN INPUT finventaire
                MOVE idRef TO fi_id
                READ finventaire KEY IS fi_id
                *>L'id existe déjà
                INVALID KEY MOVE 0 TO trouve
                *>L'id n'existe pas déjjà
                NOT INVALID KEY MOVE 1 TO trouve
                END-READ  
                CLOSE finventaire
                *>On ferme le fichier puis on le réouvre afin que le
                *>pointeur qui parcourt le fichier repart depuis le 
                *>début de celui-ci     
                IF trouve = 1
                THEN 
                     OPEN INPUT finventaire
                     DISPLAY "Liste des identifiants deja attribues"
                     PERFORM WITH TEST AFTER UNTIL Wfin =0
                        READ finventaire NEXT
                        AT END 
                         DISPLAY "L'id entre est deja attribue"
                         MOVE 0 TO Wfin
                        NOT AT END DISPLAY fi_id
                          DISPLAY "----------------"
                        END-READ
                     END-PERFORM
                     CLOSE finventaire
                END-IF.      
                

        *>Cette méthode vérifie que le titre donné est déjà attribué ou
        *>non à une référence dans l'inventaire
        VERIF_TITRE_REF.
                MOVE 0 TO trouve
                OPEN INPUT finventaire
                MOVE titreRef TO fi_titre
                READ finventaire
                *>Le titre existe déjà
                INVALID KEY MOVE 0 TO trouve
                *>Le titre n'existe pas 
                NOT INVALID KEY MOVE 1 TO trouve
                END-READ
                CLOSE finventaire
                *>On ferme le fichier puis on le réouvre afin que le
                *>pointeur qui parcourt le fichier repart depuis le 
                *>début de celui-ci
                IF trouve = 1
                THEN 
                     OPEN INPUT finventaire
                     DISPLAY "Liste des titres deja attribues"
                     PERFORM WITH TEST AFTER UNTIL Wfin =0
                        READ finventaire NEXT
                        AT END 
                         DISPLAY "Le titre entre est deja attribue"
                         MOVE 0 TO Wfin
                        NOT AT END DISPLAY fi_titre
                          DISPLAY "----------------"
                        END-READ
                     END-PERFORM
                      CLOSE finventaire
                END-IF.
               

        *>Cette méthode supprime la référence du comic dont le titre
        *>est demandé à l'utilisateur dans le fichier
        SUPPRIMER_REFERENCE.
                MOVE 0 TO trouve
                DISPLAY "Entrez le nom du comic à supprimer"
                ACCEPT fi_titre
                OPEN I-O finventaire
                *>Lecture directe dans le fichier sur la clé qu'est
                *>le titre du comic
                READ finventaire KEY IS fi_titre
                *>Le comic n'est pas trouvé dans le fichier
                INVALID KEY DISPLAY "Ce comic n'existe pas"
                *>Le comic est trouvé alors on le supprime
                NOT INVALID KEY DELETE finventaire
                DISPLAY "Suppression effectuee"
                END-READ
                CLOSE finventaire.

        *>Cette méthode recherche une référence dans le fichier selon
        *>l'option choisie (avec le titre ou le nom de l'auteur)
        RECHERCHER_REFERENCE.
        *>On demande à l'utilisateur de choisir l'option de recherche
        DISPLAY "Chercher avec le titre (1) ou l'auteur (2) du comic?"
                ACCEPT choixRechercheC
                *>Evaluation du choix fait par l'utilisateur
                EVALUATE choixRechercheC
                *>Recherche selon le titre du comic
                WHEN 1
                   DISPLAY "Entrez le titre du comic cherché"
                   ACCEPT titreRef
                   OPEN INPUT finventaire
                   MOVE titreRef TO fi_titre
                   *>Recherche directe sur la clé principale
                   READ finventaire
                   *>Le comic n'existe pas dans le fichier
           INVALID KEY DISPLAY "Ce comic n'existe pas dans l'inventaire"
                   *>Le comic existe dans le fichier
                   NOT INVALID KEY
                   *>Affichage des informations liées au comic
                   DISPLAY "Titre du comic : ", fi_titre
                   DISPLAY "Auteur du comic : ", fi_auteur
               DISPLAY "Quantité disponible en stock : ", fi_quantite
                   DISPLAY "Prix du comic : ", fi_prix
                   DISPLAY "---------------------------"
                   END-READ
                *>Recherche selon le nom de l'auteur
                WHEN 2
                   MOVE 1 TO Wfin
                   DISPLAY "Entrez le nom de l'auteur cherche"
                   ACCEPT nomAuteur
                   OPEN INPUT finventaire
                   MOVE nomAuteur TO fi_auteur
                   *>Lecture sur zone en fonction du nom de l'auteur
                   START finventaire, KEY IS = fi_auteur
               *>L'auteur rentré par l'utilisateur n'existe pas
               INVALID KEY DISPLAY "Aucun comic de cet auteur n'existe"
               *>L'auteur rentré est trouvé
                   NOT INVALID KEY
                      *>Lecture de la zone et jusqu'à la fin de celle-ci
                      PERFORM WITH TEST AFTER UNTIL Wfin = 0
                         READ finventaire NEXT
                         *>Fin de la zone
                         AT END MOVE 0 TO Wfin
                         NOT AT END
                         *>Affichage des informations liées au comic
                         DISPLAY "Nom du comic : ", fi_titre
                         DISPLAY "Auteur du comic : ", fi_auteur
                 DISPLAY "Quantite disponible en stock : ", fi_quantite
                         DISPLAY "Prix du comic : ", fi_prix
                         DISPLAY "--------------------------"
                         END-READ
                      END-PERFORM
                   END-START
                *>L'utilisateur rentre un autre nombre que 1 et 2
                WHEN OTHER
                  DISPLAY "Choix invalide, rentrez à nouveau un chiffre"
                END-EVALUATE
                CLOSE finventaire.

        *>Cette méthode modifie le prix unitaire de vente d'un comic
        MODIFIER_PRIX_COMIC.
       DISPLAY "Entrez le nom du comic que vous voulez modifier le prix"
            ACCEPT titreRef
            OPEN I-O finventaire
            MOVE titreRef TO fi_titre
            *>Lecture directe du fichier sur la clé principale qu'est
            *>le titre du comic rentré par l'utilisateur
            READ finventaire KEY IS fi_titre
                *>Le comic n'est pas trouvé
                INVALID KEY DISPLAY "Ce comic n'existe pas"
                *>Le comic est trouvé
                NOT INVALID KEY
                   *>Demande à l'utilisateur de rentrer le nouveau prix
                   DISPLAY "Entrez le nouveau prix de vente du comic"
                   ACCEPT nouveauPrix
                   *>Modification de la variable concernant le prix dans
                   *>le tampon
                   MOVE nouveauPrix TO fi_prix
                   *>Réécriture du tampon
                   REWRITE tamp_finventaire
                     INVALID KEY DISPLAY "Erreur de reecriture"
                     NOT INVALID KEY DISPLAY "La modification est faite"
                   END-REWRITE
                END-READ
            CLOSE finventaire.

        *>Cette méthode affiche les comics présents dans l'inventaire
        *>selon 2 options possibles (ceux ayant des exemplaires en stock
        *>ou ceux qui sont commandables c'est-à-dire qu'ils n'ont pas
        *>d'exemplaires en stock)
        CONSULTER_INVENTAIRE.
       DISPLAY "Afficher les comics en stock (1)"
       DISPLAY "OU ceux que ne le sont pas (2)?"
                ACCEPT choixAffichageStock
                EVALUATE choixAffichageStock
                *>Critère de recherche : comic présent en stock
                WHEN 1
                   OPEN INPUT finventaire
                   MOVE 1 TO Wfin
                   *>Lecture séquentielle du fichier jusqu'à sa fin
                   PERFORM WITH TEST AFTER UNTIL Wfin=0
                        READ finventaire NEXT
                        AT END MOVE 0 TO Wfin
                        NOT AT END
                           *>Le comic est présent en stock
                           IF fi_quantite > 0
                           *>Affichage des informations du comic
                           THEN DISPLAY "Nom du comic : ", fi_titre
                                DISPLAY "Auteur du comic : ", fi_auteur
                           DISPLAY "Quantite disponible :", fi_quantite
                                DISPLAY "------------------------------"
                           END-IF
                        END-READ
                   END-PERFORM
                *>Critère de recherche : comic commandable
                WHEN 2
                   OPEN INPUT finventaire
                   MOVE 1 TO Wfin
                   *>Lecture séquentielle du fichier jusqu'à sa fin
                   PERFORM WITH TEST AFTER UNTIL Wfin=0
                        READ finventaire NEXT
                        AT END MOVE 0 TO Wfin
                        NOT AT END
                            *>Le comic est commandable
                            IF fi_quantite = 0
                            *>Affichage des informations du comic
                            THEN DISPLAY "Nom du comic :", fi_titre
                                 DISPLAY "Auteur du comic :", fi_auteur
                            DISPLAY "------------------------------"
                            END-IF
                        END-READ
                   END-PERFORM
                *>L'utilisateur a rentré un autre nombre que 1 ou 2,
                *>l'entrée est donc invalide
                WHEN OTHER
                   DISPLAY "Choix invalide, rentrez un nouveau chiffre"
                END-EVALUATE
                CLOSE finventaire.

        *>Cette méthode affiche l'ensemble des comics présents dans 
        *>l'inventaire du magasin
        AFFICHER_COMIC.
                OPEN INPUT finventaire
                MOVE 1 TO Wfin
                *>Lecture séquentielle du fichier jusqu'à sa fin
                PERFORM WITH TEST AFTER UNTIL Wfin = 0
                   READ finventaire NEXT
                   AT END MOVE 0 TO Wfin
                   NOT AT END 
                       *>Affichage des informations liées à l'inventaire
                       DISPLAY "Id comic:", fi_id
                       DISPLAY "Titre du comic :", fi_titre
                       DISPLAY "Auteur du comic :", fi_auteur
                       DISPLAY "Quantité :", fi_quantite
                       DISPLAY "Prix unitaire :", fi_prix
                       DISPLAY "----------------------------------"
                   END-READ
                END-PERFORM
                CLOSE finventaire.
