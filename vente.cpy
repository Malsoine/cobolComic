           *>Cette m�thode enregistre une vente ou une commande en
           *>fonction de si le comic achet� par le client a des
           *>exemplaires en stock ou non
           ENREGISTRER_VENTE.
           MOVE 0 TO trouveVente
           MOVE 0 TO VerifClient
           MOVE 0 TO VerifVente

           *>On demande � l'utilisateur de rentrer id de la vente
           *>ou de la commande
           PERFORM WITH TEST AFTER UNTIL verifVente = 0
                        DISPLAY "Entrez l'id de la vente:"
                        ACCEPT idVente
                        PERFORM VERIF_ID_VENTE
           END-PERFORM

           *>On demande � l'utilisateur de rentrer le titre du comic
           *>achet� par un client
           PERFORM WITH TEST AFTER UNTIL trouveVente = 1
                        DISPLAY "Entrez le nom du comic achete :"
                        ACCEPT titreRef
                        PERFORM VERIF_NOM_REF
           END-PERFORM

           *>On demande � l'utilisateur de rentrer le nom et pr�nom du
           *>client qui fait cet achat et on v�rifie si il existe dans
           *>le fichier des clients du la boutique ou non
           PERFORM VERIF_CLIENT_VENTE
           
           *>Rentre la date du syst�me comme date d'achat
           MOVE FUNCTION CURRENT-DATE TO fv_dateVente

           *>R�cup�ration du prix de vente du comic dans le fichier
           *>inventaire          
           PERFORM RECUPERER_PRIX_DE_VENTE

           *>V�rification du nombre d'exemplaire du comic en stock
            PERFORM VERIF_STOCKS
           *>IL y a des exemplaires en stock, on enregistre une vente
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
            *>Il n'y a pas d'exemplaire en stock on enregistre donc une
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

           *>Cette m�thode v�rifie si le titre du comic entr� existe 
           *>ou non
           VERIF_NOM_REF.
                OPEN INPUT finventaire
                MOVE titreRef TO fi_titre
                READ finventaire
                INVALID KEY MOVE 0 TO trouveVente
                NOT INVALID KEY MOVE 1 TO trouveVente
                END-READ
                CLOSE finventaire.

           *>Cette m�thode demande � l'utilisateur d'entrer le nom et
           *>pr�nom d'un client, si celui-ci n'existe pas alors on le
           *>cr�er
           VERIF_CLIENT_VENTE.

               OPEN INPUT fclients
                MOVE 0 TO testNomClient
                MOVE 1 TO fichierFin
                   DISPLAY "Entrez le nom du client : "
                   ACCEPT cl_nom
                   DISPLAY "Entrez le prenom du client : "
                   ACCEPT cl_prenom

                   *>Lecture s�quentielle du fichier fclients pour
                   *>savoir si le client donn� existe ou non
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
                   *>Le client n'existe pas, on le cr��
                   IF testNomClient = 0 THEN
                   DISPLAY "Le client n'existe pas , creation !"
                        PERFORM AJOUT_CLIENT
                   END-IF
                   CLOSE fclients.

           *>Cette m�thode v�rifie si l'id de la vente donn� est d�j�
           *>utilis� ou non dans le fichier fventes
           VERIF_ID_VENTE.
               MOVE idVente TO fv_id
               MOVE 1 TO Wfin
               OPEN INPUT fventes
               READ fventes
               KEY IS fv_id
               *>L'id donn� n'existe pas
               INVALID KEY MOVE 0 TO verifVente
               *>L'id donn� existe
               NOT INVALID KEY MOVE 1 TO verifVente
               END-READ
               CLOSE fventes
               *>L'id donn� existe, on affiche l'ensemble des id 
               *>utilis�s dans le fichier fventes pour aider la saisie
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
                
           *>Cette m�thode r�cup�re le prix unitaire de vente d'un
           *>comic dont le titre est donn�
           RECUPERER_PRIX_DE_VENTE.
                OPEN INPUT finventaire
                MOVE titreRef TO fi_titre
                READ finventaire
                INVALID KEY DISPLAY "Erreur : ce comic n'existe pas"
                NOT INVALID KEY
                    MOVE fi_prix TO fv_prixVente
                CLOSE finventaire.

           *>Cette m�thode v�rifie si le comic dont le titre est donn�
           *>poss�de des exemplaires en stock ou non
           VERIF_STOCKS.
           MOVE 0 TO fv_statut
           OPEN INPUT finventaire
               MOVE titreRef TO fi_titre
               READ finventaire
               INVALID KEY DISPLAY "Erreur : ce comic n'existe pas"
               NOT INVALID KEY
               *>Le comic poss�de des exemplaires en stock
               IF fi_quantite > 0
               THEN
                   MOVE 0 TO fv_statut
               ELSE
                   *>Le comic ne poss�de pas d'exemplaire en stock
                   MOVE 1 TO fv_statut
               END-IF
               END-READ
           CLOSE finventaire.

           *>Cette m�thode ajoute  1 point de fid�lit� au client
           *>qui a affectu� un achat de comic
           AJOUTER_PTS_FIDELITE.
           OPEN I-O fclients
           MOVE fv_client TO fc_id
           READ fclients KEY IS fc_id
                INVALID KEY
                        DISPLAY "Erreur : ce client n'existe pas"
                NOT INVALID KEY
                        *>MOVE fc_ptsFidelite TO LatentPoint
                        ADD 1 TO fc_ptsFidelite END-ADD
                        *>MOVE LatentPoint TO fc_ptsFidelite
                        REWRITE tamp_fclient
                    INVALID KEY 
         DISPLAY "Erreur concernant la mise � jour des pts de fidelites"
           NOT INVALID KEY DISPLAY "Mise a jour des pts de fidelites"
                        END-REWRITE
           END-READ
           CLOSE fclients.      

           *>Cette m�thode met � jour les stock du magasin apr�s 
           *>l'achat d'un comic par un client
           MAJ_INVENTAIRE.
           OPEN I-O finventaire
           MOVE titreRef TO fi_titre
           READ finventaire KEY IS fi_titre
                INVALID KEY DISPLAY "Erreur : ce comic n'existe pas"
                NOT INVALID KEY
                        *>Dans le cas o� il s'agit d'une vente, c'est � 
                        *>dire lorsque le comic dont le titre est donn�
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
 
           *>Cette m�thode permet de mettre � jour le status d'une
           *>commande
           MAJ_STATUT_COMMANDE.
           MOVE 0 TO idCommande
           MOVE 0 TO verifStatut 

           *>On demande � l'utilisateur de rentrer l'id de la commande
           *>que l'on veut mettre � jour           
           DISPLAY "Entrez l'id de la commande : "
           ACCEPT idCommande


           OPEN I-O fventes          
           MOVE idCommande TO fv_id
           READ fventes KEY IS fv_id
                *>L'id donn� n'existe pas
                INVALID KEY 
                DISPLAY "Erreur, cet id n'est pas attribue" 
                *>L'id donn� existe 
                NOT INVALID KEY 
                        *>Mais il s'agit d'une vente     
                        IF fv_statut = 0 THEN
            DISPLAY "L'id rentre concerne une vente et non une commande"
                        *>Il s'agit bien d'une commande                
                        ELSE
                        *>Affichage du statut actuelle de la commande
                        DISPLAY "Statut de la commande :", fv_statut
                      *>On demande � l'utilisateur de rentrer le nouveau
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
                   *>On �crit la modification
                   REWRITE tamp_fvente
                   INVALID KEY
                      DISPLAY "Erreur de mise � jour du statut"
                   NOT INVALID KEY DISPLAY "Modification enregistree"
                   END-REWRITE
                END-IF               
           END-READ
           CLOSE fventes. 

           *>Cette m�thode calcul le chiffre d'affaire de la boutique
           *>� une date donn�e
           CALCULER_CHIFFRE_AFFAIRE. 
           MOVE 0 TO CA
           MOVE 0 TO nbVente
           MOVE 1 TO Wfin

           *>On demande � l'utilisateur de rentrer la date pour laquelle
           *>il veut avoir cette information
           DISPLAY "Entrez la date du chiffre d'affaire a conculter"
           DISPLAY "Entrez l'annee"
           ACCEPT an
           DISPLAY "Entrez le mois"
           ACCEPT mois
           DISPLAY "Entrez le jour"
           ACCEPT jour
        
           OPEN INPUT fventes
           *>Lecture s�quentielle du fichier fventes
           PERFORM WITH TEST AFTER UNTIL Wfin = 0           
                READ fventes NEXT
                AT END MOVE 0 TO Wfin
                NOT AT END
                    *>Lorsque la date de la vente ou de la commande
                    *>correspond � la date rentr�e par l'utilisateur,
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
           *>ce jour l�, la boutique n'a pas eu de ventes/commandes
           IF CA = 0 THEN
            DISPLAY "La boutique n'a eu acune vente/commande ce jour l�"
           ELSE     
             *>Affichage des r�sultats trouv�      
             DISPLAY "Bilan pour la date du : ", an, mois, jour
             DISPLAY "Chiffre d'affaire :", CA
             DISPLAY "Nombre de ventes/commandes du jour :", nbVente
          END-IF.
          
          *>Cette m�thode affiche l'historique des commandes 
          *>du magasin      
           AFFICHER_COMMANDE. 
                OPEN INPUT fventes
                MOVE 1 TO Wfin
                *>Lecture s�quentielle du fichier jusqu'� sa fin
                PERFORM WITH TEST AFTER UNTIL Wfin = 0
                   READ fventes NEXT
                   AT END MOVE 0 TO Wfin
                   NOT AT END 
                       IF fv_statut=1 OR fv_statut=2 OR fv_statut=3 THEN
                        *>Affichage des informations li�es � la commande
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
          
           *>Cette m�thode affiche la liste des ventes du magasin
           AFFICHER_VENTE.
                MOVE 1 TO Wfin
                OPEN INPUT fventes               
                *>Lecture s�quentielle du fichier fventes jusqu'� �a
                *>fin
                PERFORM WITH TEST AFTER UNTIL Wfin = 0
                    READ fventes NEXT
                    AT END MOVE 0 TO Wfin
                    NOT AT END 
                        *>Affichage des informations li�es � la vente
                        DISPLAY "Id de la vente :", fv_id
                        DISPLAY "Date de la vente :", fv_dateVente
                        DISPLAY "Comic vendu :", fv_titreComics
                        DISPLAY "Prix de la vente :", fv_prixVente
                        DISPLAY "Id du client :", fv_client
                        DISPLAY "----------------------------------"
                   END-READ
                END-PERFORM                
                CLOSE fventes.
