           *>Cette méthode enregistre une vente ou une commande en
           *>fonction de si le comic acheté par le client a des
           *>exemplaires en stock ou non
           *>Elle correspond à la fonctionnalité 'Enregistrer une vente
           *> ou une commande'
           ENREGISTRER_VENTE.
           MOVE 0 TO trouveVente
           MOVE 0 TO VerifClient
           MOVE 0 TO VerifVente

           *>On demande à l'utilisateur de rentrer id de la vente
           *>ou de la commande
           PERFORM WITH TEST AFTER UNTIL verifVente = 0
                        DISPLAY "Entrez l'id de la vente:"
                        ACCEPT idVente
                        PERFORM VERIF_ID_VENTE
           END-PERFORM

           *>On demande à l'utilisateur de rentrer le titre du comic
           *>acheté par un client
           PERFORM WITH TEST AFTER UNTIL trouveVente = 1
                        DISPLAY "Entrez le nom du comic achete :"
                        ACCEPT titreRef
                        PERFORM VERIF_NOM_REF
           END-PERFORM

           *>On demande à l'utilisateur de rentrer le nom et prénom du
           *>client qui fait cet achat et on vérifie si il existe dans
           *>le fichier des clients du la boutique ou non
           PERFORM VERIF_CLIENT_VENTE
           *>Le client n'existe pas dans le fichier fclients donc le 
           *>crée
           IF testNomClient = 0 THEN 
               DISPLAY "Le client n'existe pas, creation !"
               *>Demande à l'utilisateur de rentrer l'id du client
               PERFORM WITH TEST AFTER UNTIL testClient = 0
                    DISPLAY "Entrez le code client"
                    ACCEPT idClient
                    PERFORM VERIF_ID_CLIENT                
               END-PERFORM
               
               *>On récupère le nom et prénom du client qui a effectué
               *>l'achat d'un comic que l'on va enregistrer pour 
               *>l'utiliser dans l'enregistrement du client que l'on    
               *>va ajouter
               MOVE cl_nom TO fc_nom
               MOVE cl_prenom TO fc_prenom

               *>On demande à l'utilisateur de renter le numéro de 
               *>téléphone et l'email du client
               DISPLAY "Entrez le numero de telephone :"
               DISPLAY "(10 chiffres)"
               ACCEPT fc_tel
               DISPLAY "Entrez l'email :"
               DISPLAY "(xxx@xxx.xx)"
               ACCEPT fc_mail

               *>Initialisation du nombre de points de fidélité à 0
               MOVE 0 TO fc_ptsFidelite
               
               *>Ecriture du nouveau client dans le fichier fclients
               OPEN I-O fclients
               WRITE tamp_fclient
               END-WRITE
               CLOSE fclients
          END-IF
             
           IF testNomClient = 1 THEN
              MOVE idVerifClient TO fv_client
           ELSE IF testNomClient = 0 THEN
              MOVE idClient TO fv_client
           END-IF
           
           *>Rentre la date du système comme date d'achat
           MOVE FUNCTION CURRENT-DATE TO fv_dateVente

           *>Récupération du prix de vente du comic dans le fichier
           *>inventaire          
           PERFORM RECUPERER_PRIX_DE_VENTE

           *>Vérification du nombre d'exemplaire du comic en stock
            PERFORM VERIF_STOCKS
           *>IL y a des exemplaires en stock, on enregistre une vente
            IF fv_statut = 0 THEN                
                MOVE idVente TO fv_id
                MOVE titreRef TO fv_titreComics

                PERFORM MAJ_INVENTAIRE
                PERFORM AJOUTER_PTS_FIDELITE

                OPEN I-O fventes
                WRITE tamp_fvente
                END-WRITE
                DISPLAY "Vente enregistree"
                CLOSE fventes
            *>Il n'y a pas d'exemplaire en stock on enregistre donc une
            *>commande
            ELSE
                DISPLAY "Le comic voulu n'a pas d'exemplaire en stock"
                DISPLAY "On enregistre donc une commande"
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

           *>Cette méthode vérifie si le titre du comic entré existe 
           *>ou non
           VERIF_NOM_REF.
                OPEN INPUT finventaire
                MOVE titreRef TO fi_titre
                READ finventaire
                *>Le comic n'existe pas
                INVALID KEY MOVE 0 TO trouveVente
                *>Le comic existe déjà
                NOT INVALID KEY MOVE 1 TO trouveVente
                END-READ                
                CLOSE finventaire

                *>On ferme le fichier puis on le réouvre afin que le
                *>pointeur qui parcourt le fichier repart depuis le 
                *>début de celui-ci
                *>On affiche les comics présents dans l'inventaire
                IF trouveVente = 0
                THEN 
                     OPEN INPUT finventaire
                     DISPLAY "Liste des comics present en inventaire"
                     PERFORM WITH TEST AFTER UNTIL Wfin =0
                        READ finventaire NEXT
                        AT END 
                         MOVE 0 TO Wfin
                        NOT AT END DISPLAY fi_titre
                          DISPLAY "----------------"
                        END-READ
                     END-PERFORM
                     CLOSE finventaire
                END-IF.

           *>Cette méthode demande à l'utilisateur d'entrer le nom et
           *>prénom d'un client, si celui-ci n'existe pas alors on le
           *>créer
           VERIF_CLIENT_VENTE.

               OPEN INPUT fclients
                MOVE 0 TO testNomClient
                MOVE 1 TO fichierFin
                   DISPLAY "Entrez le nom du client : "
                   ACCEPT cl_nom
                   DISPLAY "Entrez le prenom du client : "
                   ACCEPT cl_prenom

                   *>Lecture séquentielle du fichier fclients pour
                   *>savoir si le client donné existe ou non
                   PERFORM WITH TEST AFTER UNTIL fichierFin=0
                       READ fclients NEXT
                       AT END MOVE 0 TO fichierFin
                       NOT AT END
                       *>Le client existe
                       IF fc_nom = cl_nom AND fc_prenom = cl_prenom THEN
                          MOVE 1 TO testNomClient
                          MOVE fc_id TO idVerifClient
                       END-IF
                       END-READ
                   END-PERFORM
                   CLOSE fclients.

           *>Cette méthode vérifie si l'id de la vente donné est déjà
           *>utilisé ou non dans le fichier fventes
           VERIF_ID_VENTE.
               MOVE idVente TO fv_id
               MOVE 1 TO Wfin
               OPEN INPUT fventes
               READ fventes
               KEY IS fv_id
               *>L'id donné n'existe pas
               INVALID KEY MOVE 0 TO verifVente
               *>L'id donné existe
               NOT INVALID KEY MOVE 1 TO verifVente
               END-READ
               CLOSE fventes
               *>L'id donné existe, on affiche l'ensemble des id 
               *>utilisés dans le fichier fventes pour aider la saisie
               *>de l'utilisateur
               IF verifVente = 1 THEN
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
                
           *>Cette méthode récupère le prix unitaire de vente qui est 
           *>défini dans le fichier finventaire et cela pour un 
           *>comic dont le titre est donné
           RECUPERER_PRIX_DE_VENTE.
                OPEN INPUT finventaire
                MOVE titreRef TO fi_titre
                READ finventaire
                INVALID KEY DISPLAY "Erreur : ce comic n'existe pas"
                NOT INVALID KEY
                    MOVE fi_prix TO fv_prixVente
                CLOSE finventaire.

           *>Cette méthode vérifie si le comic dont le titre est donné
           *>possède des exemplaires en stock ou non
           VERIF_STOCKS.
           MOVE 0 TO fv_statut
           OPEN INPUT finventaire
               MOVE titreRef TO fi_titre
               READ finventaire
               INVALID KEY DISPLAY "Erreur : ce comic n'existe pas"
               NOT INVALID KEY
               *>Le comic possède des exemplaires en stock
               IF fi_quantite > 0
               THEN
                   MOVE 0 TO fv_statut
               ELSE
                   *>Le comic ne possède pas d'exemplaire en stock
                   MOVE 1 TO fv_statut
               END-IF
               END-READ
           CLOSE finventaire.

           *>Cette méthode ajoute  1 point de fidélité au client
           *>qui a affectué un achat de comic
           AJOUTER_PTS_FIDELITE.
           OPEN I-O fclients
           MOVE fv_client TO fc_id
           READ fclients KEY IS fc_id
                INVALID KEY
                        DISPLAY "Erreur : ce client n'existe pas"
                NOT INVALID KEY
                        *>AJout d'1 pts de fidelité au client
                        ADD 1 TO fc_ptsFidelite END-ADD
                        REWRITE tamp_fclient
                    INVALID KEY 
         DISPLAY "Erreur concernant la mise à jour des pts de fidelites"
           NOT INVALID KEY DISPLAY "Mise a jour des pts de fidelites"
                        END-REWRITE
           END-READ
           CLOSE fclients.      

           *>Cette méthode met à jour les stock du magasin après 
           *>l'achat d'un comic par un client
           MAJ_INVENTAIRE.
           OPEN I-O finventaire
           MOVE titreRef TO fi_titre
           READ finventaire KEY IS fi_titre
                INVALID KEY DISPLAY "Erreur : ce comic n'existe pas"
                NOT INVALID KEY
                        *>Dans le cas où il s'agit d'une vente, c'est à 
                        *>dire lorsque le comic dont le titre est donné
                        *>a des exemplaires en stock
                        IF fi_quantite > 0 THEN
                          SUBTRACT 1 FROM fi_quantite END-SUBTRACT
                          REWRITE tamp_finventaire
                     INVALID KEY DISPLAY "Erreur : mise a jour du stock"
           NOT INVALID KEY DISPLAY "Mise a jour du stock"
                        END-REWRITE                        
                        END-IF           
           END-READ
           CLOSE finventaire.           
 
           *>Cette méthode permet de mettre à jour le status d'une
           *>commande
           *>Elle correspond à la fonctionnalité 'Mettre à jour une 
           *>commande'
           MAJ_STATUT_COMMANDE.
           MOVE 0 TO idCommande
           MOVE 0 TO verifStatut 

           *>On demande à l'utilisateur de rentrer l'id de la commande
           *>que l'on veut mettre à jour           
           DISPLAY "Entrez l'id de la commande : "
           ACCEPT idCommande


           OPEN I-O fventes          
           MOVE idCommande TO fv_id
           READ fventes KEY IS fv_id
                *>L'id donné n'existe pas
                INVALID KEY 
                DISPLAY "Erreur, cet id n'est pas attribue" 
                *>L'id donné existe 
                NOT INVALID KEY 
                        *>Mais il s'agit d'une vente     
                        IF fv_statut = 0 THEN
            DISPLAY "L'id rentre concerne une vente et non une commande"
                        *>Il s'agit bien d'une commande                
                        ELSE
                        *>Affichage du statut actuelle de la commande
                        DISPLAY "Statut de la commande :", fv_statut
                      *>On demande à l'utilisateur de rentrer le nouveau
                      *>statut de la commande
                      PERFORM WITH TEST AFTER UNTIL verifStatut = 1 
              DISPLAY "Entrez  le nouveau statut de la commande (1,2,3)"
                        ACCEPT etatStatut
                        *>Les status possibles sont : 1, 2 et 3 
                        IF etatStatut > 1 AND etatStatut < 4 THEN 
                           MOVE 1 TO verifStatut
                        ELSE
                           MOVE 0 TO verifStatut
                        END-IF 
                   END-PERFORM
                   MOVE etatStatut TO fv_statut
                   *>On écrit la modification
                   REWRITE tamp_fvente
                   INVALID KEY
                      DISPLAY "Erreur de mise à jour du statut"
                   NOT INVALID KEY DISPLAY "Modification enregistree"
                   END-REWRITE
                END-IF               
           END-READ
           CLOSE fventes. 

           *>Cette méthode calcul le chiffre d'affaire de la boutique
           *>à une date donnée
           *>Elle correspond à la fonctionnalité 'consulter des 
           *>statistiques "gérant" '
           CALCULER_CHIFFRE_AFFAIRE. 
           MOVE 0 TO CA
           MOVE 0 TO nbVente
           MOVE 1 TO Wfin

           *>On demande à l'utilisateur de rentrer la date pour laquelle
           *>il veut avoir cette information
           DISPLAY "Entrez la date du chiffre d'affaire a conculter"
           DISPLAY "Entrez l'annee"
           ACCEPT an
           DISPLAY "Entrez le mois"
           ACCEPT mois
           DISPLAY "Entrez le jour"
           ACCEPT jour
        
           OPEN INPUT fventes
           *>Lecture séquentielle du fichier fventes
           PERFORM WITH TEST AFTER UNTIL Wfin = 0           
                READ fventes NEXT
                AT END MOVE 0 TO Wfin
                NOT AT END
                    *>Lorsque la date de la vente ou de la commande
                    *>correspond à la date rentrée par l'utilisateur,
                    *>on compte son prix dans le chiffre d'affaire
                    IF dateYearV = an AND dateMOnthV = mois 
                        AND dateDayV = jour THEN
                        ADD 1 TO nbVente END-ADD
                        ADD fv_prixVente TO CA END-ADD
                    END-IF
                END-READ
           END-PERFORM
           CLOSE fventes
           *>Si le chiffre d'affaire est nul alors cela signifie que
           *>ce jour là, la boutique n'a pas eu de ventes/commandes
           IF CA = 0 THEN
            DISPLAY "La boutique n'a eu acune vente/commande ce jour là"
           ELSE     
             *>Affichage des résultats trouvé      
             DISPLAY "Bilan pour la date du : ", an, mois, jour
             DISPLAY "Chiffre d'affaire :", CA
             DISPLAY "Nombre de ventes/commandes du jour :", nbVente
          END-IF.
          
          *>Cette méthode affiche l'historique des commandes 
          *>du magasin      
          *>Elle correspond à la fonctionnalité 'Accéder à l'historique
          *>des commandes'
           AFFICHER_COMMANDE. 
                OPEN INPUT fventes
                MOVE 1 TO Wfin
                *>Lecture séquentielle du fichier jusqu'à sa fin
                PERFORM WITH TEST AFTER UNTIL Wfin = 0
                   READ fventes NEXT
                   AT END MOVE 0 TO Wfin
                   NOT AT END 
                       IF fv_statut=1 OR fv_statut=2 OR fv_statut=3 THEN
                        *>Affichage des informations liées à la commande
                        DISPLAY "Id de la commande :", fv_id
                        DISPLAY "Statut de la commande :", fv_statut
                        DISPLAY "Date de la commande :", fv_dateVente
                        DISPLAY "Comic commande :", fv_titreComics
                        DISPLAY "Prix :", fv_prixVente
                        DISPLAY "Id du client :", fv_client
                        DISPLAY "----------------------------------"
                       END-IF
                   END-READ
                END-PERFORM
                CLOSE fventes.
          
           *>Cette méthode affiche la liste des ventes du magasin
           *>Elle correspond à la fonctionnalité 'Accéder à l'historique
          *>des ventes'
           AFFICHER_VENTE.
                MOVE 1 TO Wfin
                OPEN INPUT fventes               
                *>Lecture séquentielle du fichier fventes jusqu'à ça
                *>fin
                PERFORM WITH TEST AFTER UNTIL Wfin = 0
                    READ fventes NEXT
                    AT END MOVE 0 TO Wfin
                    NOT AT END 
                        *>Affichage des informations liées à la vente
                        DISPLAY "Id de la vente :", fv_id
                        DISPLAY "Date de la vente :", fv_dateVente
                        DISPLAY "Comic vendu :", fv_titreComics
                        DISPLAY "Prix de la vente :", fv_prixVente
                        DISPLAY "Id du client :", fv_client
                        DISPLAY "----------------------------------"
                   END-READ
                END-PERFORM                
                CLOSE fventes.
