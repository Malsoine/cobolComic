        *>Methode qui ajoute une nouvelle référence (d'un comics) dans
        *>l'inventaire de la boutique
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

                *>On demande à l'utilisateur de rentrer la quantité
                *>d'exemplaires du comics (ne peut pas être négatif)
                PERFORM WITH TEST AFTER UNTIL fi_quantite>=0
                        DISPLAY "Entrez la quantité"
                        ACCEPT fi_quantite
                END-PERFORM

                *>On demande à l'utilisateur de rentrer le prix 
                *>unitaire du comics (ni nul ni négatif)
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

        *>Cette méthode vérifie que l'id donné est déjà attribué ou non
        *>à une référence dans l'inventaire
        VERIF_ID_REF.
                MOVE 0 TO trouve
                OPEN INPUT finventaire
                MOVE idRef TO fi_id
                READ finventaire
                *>L'id existe déjà
                INVALID KEY MOVE 0 TO trouve
                *>L'id n'existe pas déjà
                NOT INVALID KEY MOVE 1 TO trouve
                END-READ
                CLOSE finventaire.

        *>Cette méthode vérifie que le titre donné est déjà attribué ou 
        *>non à une référence dans l'inventaire
        VERIF_TITRE_REF.
                MOVE 0 TO trouve
                OPEN INPUT finventaire
                MOVE titreRef TO fi_titre
                READ finventaire
                *>Le titre existe déjà
                INVALID KEY MOVE 0 TO trouve
                *>Le titre n'existe pas déjà
                NOT INVALID KEY MOVE 1 TO trouve
                END-READ
                CLOSE finventaire.
        
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
                DISPLAY "Suppression effectuée"
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
                 DISPLAY "Quantité disponible en stock : ", fi_quantite
                         DISPLAY "Prix du comic : ", fi_prix
                         DISPLAY "--------------------------"
                         END-READ
                      END-PERFORM
                   END-START
                *>L'utilisateur rentre un autre nombre que 1 et 2
                WHEN OTHER
                   DISPLAY "Choix invalide"
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
                INVALID KEY DISPLAY "Ce comic n'existe"
                *>Le comic est trouvé
                NOT INVALID KEY
                   *>Demande à l'utilisateur de rentrer le nouveau prix
                   DISPLAY "Entrez le nouveau prix de ce comic"
                   ACCEPT nouveauPrix
                   *>Modification de la variable concernant le prix dans 
                   *>le tampon
                   MOVE nouveauPrix TO fi_prix
                   *Réécriture du tampon
                   REWRITE tamp_finventaire
                     INVALID KEY DISPLAY "Erreur de réecriture"
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
                           DISPLAY "Quantité disponible :", fi_quantite
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
                            *>Zffichage des informations du comic
                            THEN DISPLAY "Nom du comic :", fi_titre
                                 DISPLAY "Auteur du comic :", fi_auteur
                            DISPLAY "------------------------------"
                            END-IF
                        END-READ
                   END-PERFORM
                *>L'utilisateur a rentré un autre nombre que 1 ou 2, 
                *>l'entrée est donc invalide 
                WHEN OTHER
                   DISPLAY "Choix invalide"
                END-EVALUATE
                CLOSE finventaire.
