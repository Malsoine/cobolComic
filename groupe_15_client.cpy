           *>Cette méthode permet d'ajouter un nouveau client au fichier
           *>des clients du magasin
           AJOUT_CLIENT.
           OPEN INPUT fclients
           MOVE 0 TO fichierFin
           MOVE 0 TO testClient
           MOVE 0 TO testNomClient

           *>On demande à l'utilisateur de rentrer l'id du client
           
           DISPLAY "Entrez le code client :"
           ACCEPT cl_id
      
           *>On demande à l'utilisateur de rentre le nom et prénom du
           *>client
           DISPLAY "Entrez le nom :"
           ACCEPT cl_nom
           DISPLAY "Entrez le prenom :"
           ACCEPT cl_prenom
                   
           *>On demande à l'utilisateur de renter le numéro de 
           *>téléphone et l'email du client
           DISPLAY "Entrez le numero de telephone :"
           DISPLAY "(10 chiffres)"
           ACCEPT cl_tel
           DISPLAY "Entrez l'email :"
           DISPLAY "(xxx@xxx.xx)"
           ACCEPT cl_mail

           *>On initialise le nombre de points de fidélité de client
           *>à 0
           MOVE 0 TO cl_ptsFidelite

           *>On vérifie que le nom et prénom donné son unique
           PERFORM WITH TEST AFTER UNTIL fichierFin=1
               READ fclients NEXT
               AT END MOVE 1 TO fichierFin
               NOT AT END
                   IF fc_nom = cl_nom AND fc_prenom = cl_prenom THEN
                       MOVE 1 TO testNomClient
                   END-IF
               END-READ
           END-PERFORM

           *>On recherche si l'id donné par l'utilisateur existe déjà
           *>Dans le fichier des clients du magasin
           MOVE cl_id TO fc_id
           READ fclients
           KEY IS fc_id
           INVALID KEY MOVE 0 TO testClient
           NOT INVALID KEY MOVE 1 TO testClient
           END-READ
           CLOSE fclients

           *>L'id ou le nom/prénom du client donné par l'utilisateur
           *>existe déjà dans le fichier des clients de la boutique
           *>donc on relance la procédure
           IF testClient = 1 OR testNomClient = 1 THEN
               DISPLAY "Erreur, le client est deja dans le fichier"
               DISPLAY "  "
               PERFORM AFFICHER_LISTE_CLIENTS
               DISPLAY "  "
               DISPLAY " - Resaisie d'un client - "
               PERFORM AJOUT_CLIENT

           *>L'id et le nom/prénom du client donné par l'utilisateur
           *>n'existe pas dans le fichier fclients donc on l'ajoute
           ELSE IF testClient = 0 AND testNomClient = 0 THEN
               OPEN I-O fclients
               MOVE client TO tamp_fclient
               WRITE tamp_fclient
               END-WRITE
               DISPLAY "Ajout de :"
               DISPLAY fc_prenom
               DISPLAY fc_nom
               DISPLAY "effectue"
               CLOSE fclients
           END-IF.

           *>Cette méthode permet de supprimer un client du fichier
           SUPPR_CLIENT.
           MOVE 0 to choixSupprClient
           MOVE 0 TO fichierFin
           MOVE 0 TO idClient
           MOVE 0 TO testClient
           MOVE 0 TO testNomClient

           *>Choix sur la recherche du client à supprimer
           DISPLAY "-----"
           DISPLAY "Supprimer avec l'id (1)"
           DISPLAY "Supprimer avec nom/prenom (2) ?"
           DISPLAY "-----"
           ACCEPT choixSupprClient
           EVALUATE choixSupprClient

           *>Suppression par l'id du client
           WHEN 1
               OPEN I-O fclients
               *>On demande à l'utilisateur de rentrer l'id du client 
               *>à supprimer
               DISPLAY "Suppression par id"
               DISPLAY "Entrez l'id : "
               ACCEPT cl_id
               MOVE cl_id TO fc_id
                  delete fclients record
                  invalid key
                 display "Suppression impossible de  " fc_id end-display
                  not invalid key
               display "Suppresion effectuee !" end-display
               end-delete
               CLOSE fclients

           *>Suppression par le nom et prénom du client
           WHEN 2
               OPEN I-O fclients
                *>On demande à l'utilisateur de rentrer le nom et le
                *>prénom du client à supprimer
                DISPLAY "Suppression par nom et prenom"
                DISPLAY "Entrez le nom : "
                ACCEPT cl_nom
                DISPLAY "Entrez le prenom : "
                ACCEPT cl_prenom

                *>Lecture séquentielle du fichier fclients jusqu'à la
                *>fin du fichier
                PERFORM WITH TEST AFTER UNTIL fichierFin=1
                   READ fclients NEXT
                   AT END MOVE 1 TO fichierFin
                   NOT AT END
                   IF fc_nom = cl_nom AND fc_prenom = cl_prenom THEN
                       MOVE fc_id TO idClient
                   END-IF
                   END-READ
               END-PERFORM
               CLOSE fclients              
               OPEN I-O fclients
                MOVE idClient TO fc_id
                READ fclients KEY IS fc_id
                INVALID KEY DISPLAY "Ce client n'existe pas"
                NOT INVALID KEY DELETE fclients
                DISPLAY "Suppression effectuee"
                END-READ
                CLOSE fclients

           *>Le choix entré par l'utilisateur est invalide
           WHEN OTHER
                   DISPLAY "Choix invalide"
                   PERFORM SUPPR_CLIENT
           END-EVALUATE.

           *>Cette méthode permet de consulter les points de fidélités
           *>d'un client 
           CONSULTER_PTS_FIDELITE.
           OPEN INPUT fclients
           MOVE 0 TO fichierFin
           MOVE 0 TO testNomClient

           *>On demande à l'utilisateur de rentrer le nom et prénom
           *>du client dont on veut connaître le nombre de points de
           *>fidélités
           DISPLAY"Entrez le nom : "
           ACCEPT cl_nom
           DISPLAY "Entrez le prenom : "
           ACCEPT cl_prenom

           *>Lecture séquentielle du fichier fclients jusqu'à sa fin
           PERFORM WITH TEST AFTER UNTIL fichierFin=1
               READ fclients NEXT
               AT END MOVE 1 TO fichierFin
               NOT AT END
               IF fc_nom = cl_nom AND fc_prenom = cl_prenom THEN
                  MOVE 1 TO testNomClient
               END-IF
               END-READ
           END-PERFORM
        
           *>Affichage du nombre de points de fidélités
           IF testNomClient = 1
               DISPLAY "Points de fidelite : ", fc_ptsFidelite
           END-IF
           close fclients.


           *>Cette méthode permet de modifier certaines informations
           *>d'un client : mail, téléphone
           MODIFIER_INFO_CLIENT.
           OPEN INPUT fclients
           MOVE 0 TO testNomClient
           MOVE 0 TO fichierFin
           MOVE 0 TO idClient

           *>On demande à l'utilisateur de rentrer le nom et prénom du
           *>client dont on veut modifier certaines informations
           DISPLAY"Entrez le nom : "
           ACCEPT cl_nom
           DISPLAY "Entrez le prenom : "
           ACCEPT cl_prenom

           *>Lecture séquentielle du fichier fclients jusqu'à sa fin
           PERFORM WITH TEST AFTER UNTIL fichierFin=1
               READ fclients NEXT
               AT END MOVE 1 TO fichierFin
               NOT AT END
               *>Le client donné par l'utilisateur est trouvé
               IF fc_nom = cl_nom AND fc_prenom = cl_prenom THEN
                  *>Récupération de l'id du client
                  MOVE fc_id TO idClient
               END-IF
               END-READ
           END-PERFORM
           close fclients.
           OPEN I-O fclients
            MOVE idClient TO fc_id
            *>Lecture directe du fichier fventes sur l'id du client
            READ fclients KEY IS fc_id
                INVALID KEY DISPLAY "Ce client n'existe pas"
                NOT INVALID KEY
                   *>Le client est trouvé
                   *>Procédure de changement des informations du client
                   DISPLAY "Entrez le nouveau numero de telephone"
                   DISPLAY "(10 chiffres)"
                   ACCEPT cl_tel
                   DISPLAY "Entrez le nouveau mail"
                   DISPLAY "(xxx@xxx.xx)"
                   ACCEPT cl_mail
                   DISPLAY "Entrez le nombre de points de fidelite"
                   ACCEPT cl_ptsFidelite
                   MOVE cl_tel TO fc_tel
                   MOVE cl_mail TO fc_mail
                   MOVE cl_ptsFidelite TO fc_ptsFidelite
                   REWRITE tamp_fclient
                     INVALID KEY DISPLAY "Erreur de reecriture"
                     NOT INVALID KEY DISPLAY "La modification est faite"
                   END-REWRITE
                END-READ
            CLOSE fclients.

           *>Cette méthode permet d'afficher la liste des clients
           *>du magasin de comic
           AFFICHER_LISTE_CLIENTS.
           OPEN INPUT fclients
           MOVE 0 TO fichierFin

           DISPLAY "Affichage de la liste des clients"
           *>Lecture séquentielle de l'ensemble du fichier
           PERFORM WITH TEST AFTER UNTIL fichierFin=1
               READ fclients NEXT
               AT END MOVE 1 TO fichierFin
               NOT AT END
               DISPLAY "-------"
               DISPLAY "Nom : ",fc_nom
               DISPLAY "Prenom : ",fc_prenom
               DISPLAY "Identifiant : ", fc_id
               DISPLAY "Nombre de pts de fidelites : ", fc_ptsFidelite
               END-READ
           END-PERFORM
           CLOSE fclients.


           *>Cette méthode permet de consulter plusieur statistiques 
           *>concernant les clients de la boutique
           STATISTIQUES_CLIENT.
           OPEN INPUT fclients
           MOVE 0 TO choixSupprClient
           MOVE 0 to testClient
           MOVE 0 TO fichierFin
           MOVE 0 TO nbClient
           MOVE 0 TO ptsFidelite
        
           *>Affichage des statistiques pouvant être calculées
           DISPLAY "Que voulez-vous faire ?"
           DISPLAY "   -Afficher le nombre de client (1)"
           DISPLAY "   -Afficher les clients dont le nombre de points"
           DISPLAY " de fidelite est egale ou supérieur au seuil rentre"
           DISPLAY "   -Afficher le client ayant le plus de points (3)"
           DISPLAY "   -RETOUR (0)"
           ACCEPT choixSupprClient
           EVALUATE choixSupprClient
           WHEN 1
        
           *>Statistique concernant le calcul du nombre de client 
           *>Lecture séquentielle du ficheir fclients jusqu'à sa fin
           PERFORM WITH TEST AFTER UNTIL fichierFin=1
               READ fclients NEXT
               AT END MOVE 1 TO fichierFin
               NOT AT END
               ADD 1 TO nbClient
               END-READ
           END-PERFORM
           DISPLAY "Nombre de client : ", nbClient

           *>Statistique affichant les clients ayant un nombre de points
           *>de fidélités => à un seuil rentré par l'utilisateur
           WHEN 2
           MOVE 0 TO nbClient
           *>On demande à l'utilisateur de rentrer le seuil voulu
           DISPLAY"A partir de quel seuil voulez-vous voir les clients?"
           ACCEPT ptsFidelite
           DISPLAY " "
           DISPLAY "-------"
           DISPLAY"Clients ayant ou ayant plus de ", ptsFidelite
           DISPLAY "points de fidelite : "
        
           *>Lecture séquentielle du fichier jusqu'à sa fin
           PERFORM WITH TEST AFTER UNTIL fichierFin=1
               READ fclients NEXT
               AT END MOVE 1 TO fichierFin
               NOT AT END
               IF ptsFidelite <= fc_ptsFidelite THEN
                   ADD 1 TO nbClient
                   *>Affichage des clients concernés
                   DISPLAY "-------"
                   DISPLAY "Nom : ",fc_nom
                   DISPLAY "Prenom : ",fc_prenom
                END-IF
               END-READ
           END-PERFORM
           *>Affichage du nommbre total de clients concernés
           DISPLAY "-------"
           DISPLAY "Il y a au total ", nbClient, " client(s)"
           DISPLAY "dont le nombre de points de fidelite est egale ou "
           DISPLAY "au dessus de", ptsFidelite, " points"
           DISPLAY " "

           *>Statistique retournant le client avec le plus de points 
           *>de fidélités
           WHEN 3
           *>Initialisation des points de fidélités
           MOVE 0 TO ptsFidelite
           *>Lecture séquentielle du fichier fclients jursqu'à sa fin
           PERFORM WITH TEST AFTER UNTIL fichierFin=1
               READ fclients NEXT
               AT END MOVE 1 TO fichierFin
               NOT AT END
               *>Test si le client présent dans le tampon a un nombre de
               *>points de fidélités supérieur à celui qui est sotcké,
               *>si c'est le cas alors ce client devient la nouvelle
               *>référence pour la comparaison
               IF ptsFidelite <= fc_ptsFidelite THEN
                  MOVE fc_ptsFidelite TO ptsFidelite
                  MOVE fc_nom TO cl_nom
                  MOVE fc_prenom TO cl_prenom
                END-IF
               END-READ
           END-PERFORM
           *>Affichade du client ayant le plus de points de fidélité
           DISPLAY " "
           DISPLAY "Le client ayant le plus de point est : "
           DISPLAY "Nom : ",fc_nom
           DISPLAY "Prenom : ",fc_prenom
           DISPLAY "Avec un total de ", ptsFidelite, " points"
           END-EVALUATE
           CLOSE fclients.
