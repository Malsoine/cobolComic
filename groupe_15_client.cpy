           *>Cette m�thode permet d'ajouter un nouveau client au fichier
           *>des clients du magasin
           *>Elle correspond � la fonctionnalit� 'Ajouter un client
           *>fid�le'
           AJOUT_CLIENT.
           OPEN INPUT fclients
           MOVE 0 TO fichierFin
           MOVE 0 TO testClient
           MOVE 0 TO testNomClient

           *>On demande � l'utilisateur de rentrer l'id du client
           
           DISPLAY "Entrez le code client :"
           ACCEPT cl_id
      
           *>On demande � l'utilisateur de rentre le nom et pr�nom du
           *>client
           DISPLAY "Entrez le nom :"
           ACCEPT cl_nom
           DISPLAY "Entrez le prenom :"
           ACCEPT cl_prenom
                   
           *>On demande � l'utilisateur de renter le num�ro de 
           *>t�l�phone et l'email du client
           DISPLAY "Entrez le numero de telephone :"
           DISPLAY "(10 chiffres)"
           ACCEPT cl_tel
           DISPLAY "Entrez l'email :"
           DISPLAY "(xxx@xxx.xx)"
           ACCEPT cl_mail

           *>On initialise le nombre de points de fid�lit� de client
           *>� 0
           MOVE 0 TO cl_ptsFidelite

           *>On v�rifie que le nom et pr�nom donn� son unique
           PERFORM WITH TEST AFTER UNTIL fichierFin=1
               READ fclients NEXT
               AT END MOVE 1 TO fichierFin
               NOT AT END
                   IF fc_nom = cl_nom AND fc_prenom = cl_prenom THEN
                       MOVE 1 TO testNomClient
                   END-IF
               END-READ
           END-PERFORM

           *>On recherche si l'id donn� par l'utilisateur existe d�j�
           *>Dans le fichier des clients du magasin
           PERFORM VERIF_ID_CLIENT          

           *>L'id ou le nom/pr�nom du client donn� par l'utilisateur
           *>existe d�j� dans le fichier des clients de la boutique
           *>donc on relance la proc�dure
           IF testClient = 1 OR testNomClient = 1 THEN
               DISPLAY "Erreur, le client est deja dans le fichier"
               DISPLAY "  "
               PERFORM AFFICHER_LISTE_CLIENTS
               DISPLAY "  "
               DISPLAY " - Resaisie d'un client - "
               PERFORM AJOUT_CLIENT

           *>L'id et le nom/pr�nom du client donn� par l'utilisateur
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

           *>Cette m�thode v�rifie si l'id du client existe d�j� ou non
           *>dans le fichier fclients qui regourpe l'ensemble des
           *>clients de la boutique
           VERIF_ID_CLIENT.
                MOVE 0 TO testClient
                MOVE 1 TO Wfin
                OPEN INPUT fclients
                MOVE idClient TO fc_id
                READ fclients
                *>L'id du client n'est attribu� � aucun client
                INVALID KEY MOVE 0 TO testCLient
                *>L'id rentr� existe d�j�
                NOT INVALID KEY MOVE 1 TO testClient
                END-READ
                CLOSE fclients
                *>On ferme le fichier puis on le r�ouvre afin que le
                *>pointeur qui parcourt le fichier repart depuis le 
                *>d�but de celui-ci
                *>On affiche les identifiants d�j� attribu�s
                IF testClient = 1
                THEN 
                     OPEN INPUT fclients
                     DISPLAY "Liste des identifiants deja attribues"
                     PERFORM WITH TEST AFTER UNTIL Wfin =0
                        READ fclients NEXT
                        AT END 
                         MOVE 0 TO Wfin
                        NOT AT END DISPLAY fc_id
                          DISPLAY "----------------"
                        END-READ
                     END-PERFORM
                     CLOSE fclients
                END-IF.

           *>Cette m�thode permet de supprimer un client du fichier
           *>Elle correspond � la fonctionnalit� 'Supprimer un client
           *>fid�le'
           SUPPR_CLIENT.
           MOVE 0 to choixSupprClient
           MOVE 0 TO fichierFin
           MOVE 0 TO idClient
           MOVE 0 TO testClient
           MOVE 0 TO testNomClient

           *>Choix sur la recherche du client � supprimer
           DISPLAY "-----"
           DISPLAY "Supprimer avec l'id (1)"
           DISPLAY "Supprimer avec nom/prenom (2) ?"
           DISPLAY "-----"
           ACCEPT choixSupprClient
           EVALUATE choixSupprClient

           *>Suppression par l'id du client
           WHEN 1
               OPEN I-O fclients
               *>On demande � l'utilisateur de rentrer l'id du client 
               *>� supprimer
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

           *>Suppression par le nom et pr�nom du client
           WHEN 2
               OPEN I-O fclients
                *>On demande � l'utilisateur de rentrer le nom et le
                *>pr�nom du client � supprimer
                DISPLAY "Suppression par nom et prenom"
                DISPLAY "Entrez le nom : "
                ACCEPT cl_nom
                DISPLAY "Entrez le prenom : "
                ACCEPT cl_prenom

                *>Lecture s�quentielle du fichier fclients jusqu'� la
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

           *>Le choix entr� par l'utilisateur est invalide
           WHEN OTHER
                   DISPLAY "Choix invalide"
                   PERFORM SUPPR_CLIENT
           END-EVALUATE.

           *>Cette m�thode permet de consulter les points de fid�lit�s
           *>d'un client 
           *>Elle correspond � la fonctionnalit� 'Consulter les points
           *>de fidelit�'
           CONSULTER_PTS_FIDELITE.
           OPEN INPUT fclients
           MOVE 0 TO fichierFin
           MOVE 0 TO testNomClient

           *>On demande � l'utilisateur de rentrer le nom et pr�nom
           *>du client dont on veut conna�tre le nombre de points de
           *>fid�lit�s
           DISPLAY"Entrez le nom : "
           ACCEPT cl_nom
           DISPLAY "Entrez le prenom : "
           ACCEPT cl_prenom

           *>Lecture s�quentielle du fichier fclients jusqu'� sa fin
           PERFORM WITH TEST AFTER UNTIL fichierFin=1
               READ fclients NEXT
               AT END MOVE 1 TO fichierFin
               NOT AT END
               IF fc_nom = cl_nom AND fc_prenom = cl_prenom THEN
                  MOVE 1 TO testNomClient
               END-IF
               END-READ
           END-PERFORM
        
           *>Affichage du nombre de points de fid�lit�s
           IF testNomClient = 1
               DISPLAY "Points de fidelite : ", fc_ptsFidelite
           END-IF
           close fclients.


           *>Cette m�thode permet de modifier certaines informations
           *>d'un client : mail, t�l�phone
           *>Elle correspond � la fonctionnalit� 'Modifier les 
           *>informations d'un client'
           MODIFIER_INFO_CLIENT.
           OPEN INPUT fclients
           MOVE 0 TO testNomClient
           MOVE 0 TO fichierFin
           MOVE 0 TO idClient

           *>On demande � l'utilisateur de rentrer le nom et pr�nom du
           *>client dont on veut modifier certaines informations
           DISPLAY"Entrez le nom : "
           ACCEPT cl_nom
           DISPLAY "Entrez le prenom : "
           ACCEPT cl_prenom

           *>Lecture s�quentielle du fichier fclients jusqu'� sa fin
           PERFORM WITH TEST AFTER UNTIL fichierFin=1
               READ fclients NEXT
               AT END MOVE 1 TO fichierFin
               NOT AT END
               *>Le client donn� par l'utilisateur est trouv�
               IF fc_nom = cl_nom AND fc_prenom = cl_prenom THEN
                  *>R�cup�ration de l'id du client
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
                   *>Le client est trouv�
                   *>Proc�dure de changement des informations du client
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

           *>Cette m�thode permet d'afficher la liste des clients
           *>du magasin de comic
           *>Elle correspond � la fonctionnalit� 'Afficher la liste 
           *>des clients'
           AFFICHER_LISTE_CLIENTS.
           OPEN INPUT fclients
           MOVE 0 TO fichierFin

           DISPLAY "Affichage de la liste des clients"
           *>Lecture s�quentielle de l'ensemble du fichier
           PERFORM WITH TEST AFTER UNTIL fichierFin=1
               READ fclients NEXT
               AT END MOVE 1 TO fichierFin
               NOT AT END
               DISPLAY "-------"
               DISPLAY "Nom : ",fc_nom
               DISPLAY "Prenom : ",fc_prenom
               DISPLAY "Identifiant : ", fc_id
               DISPLAY "Nombre de pts de fidelites : ", fc_ptsFidelite
               DISPLAY "Num�ro de telephone :", fc_tel
               DISPLAY "Email :", fc_mail
               END-READ
           END-PERFORM
           CLOSE fclients.


           *>Cette m�thode permet de consulter plusieur statistiques 
           *>concernant les clients de la boutique
           *>Elle correspond � la fonctionnalit� 'Consulter des 
           *>statistiques "employ�"'
           STATISTIQUES_CLIENT.
           OPEN INPUT fclients
           MOVE 0 TO choixSupprClient
           MOVE 0 to testClient
           MOVE 0 TO fichierFin
           MOVE 0 TO nbClient
           MOVE 0 TO ptsFidelite
        
           *>Affichage des statistiques pouvant �tre calcul�es
           DISPLAY "Que voulez-vous faire ?"
           DISPLAY "   -Afficher le nombre de client (1)"
           DISPLAY "   -Afficher les clients dont le nombre de points"
           DISPLAY " de fidelite est egale ou sup�rieur au seuil rentre"
           DISPLAY "   -Afficher le client ayant le plus de points (3)"
           DISPLAY "   -RETOUR (0)"
           ACCEPT choixSupprClient
           EVALUATE choixSupprClient
           WHEN 1
        
           *>Statistique concernant le calcul du nombre de client 
           *>Lecture s�quentielle du ficheir fclients jusqu'� sa fin
           PERFORM WITH TEST AFTER UNTIL fichierFin=1
               READ fclients NEXT
               AT END MOVE 1 TO fichierFin
               NOT AT END
               ADD 1 TO nbClient
               END-READ
           END-PERFORM
           DISPLAY "Nombre de client : ", nbClient

           *>Statistique affichant les clients ayant un nombre de points
           *>de fid�lit�s => � un seuil rentr� par l'utilisateur
           WHEN 2
           MOVE 0 TO nbClient
           *>On demande � l'utilisateur de rentrer le seuil voulu
           DISPLAY"A partir de quel seuil voulez-vous voir les clients?"
           ACCEPT ptsFidelite
           DISPLAY " "
           DISPLAY "-------"
           DISPLAY"Clients ayant ou ayant plus de ", ptsFidelite
           DISPLAY "points de fidelite : "
        
           *>Lecture s�quentielle du fichier jusqu'� sa fin
           PERFORM WITH TEST AFTER UNTIL fichierFin=1
               READ fclients NEXT
               AT END MOVE 1 TO fichierFin
               NOT AT END
               IF ptsFidelite <= fc_ptsFidelite THEN
                   ADD 1 TO nbClient
                   *>Affichage des clients concern�s
                   DISPLAY "-------"
                   DISPLAY "Nom : ",fc_nom
                   DISPLAY "Prenom : ",fc_prenom
                END-IF
               END-READ
           END-PERFORM
           *>Affichage du nommbre total de clients concern�s
           DISPLAY "-------"
           DISPLAY "Il y a au total ", nbClient, " client(s)"
           DISPLAY "dont le nombre de points de fidelite est egale ou "
           DISPLAY "au dessus de", ptsFidelite, " points"
           DISPLAY " "

           *>Statistique retournant le client avec le plus de points 
           *>de fid�lit�s
           WHEN 3
           *>Initialisation des points de fid�lit�s
           MOVE 0 TO ptsFidelite
           *>Lecture s�quentielle du fichier fclients jursqu'� sa fin
           PERFORM WITH TEST AFTER UNTIL fichierFin=1
               READ fclients NEXT
               AT END MOVE 1 TO fichierFin
               NOT AT END
               *>Test si le client pr�sent dans le tampon a un nombre de
               *>points de fid�lit�s sup�rieur � celui qui est sotck�,
               *>si c'est le cas alors ce client devient la nouvelle
               *>r�f�rence pour la comparaison
               IF ptsFidelite <= fc_ptsFidelite THEN
                  MOVE fc_ptsFidelite TO ptsFidelite
                  MOVE fc_nom TO cl_nom
                  MOVE fc_prenom TO cl_prenom
                END-IF
               END-READ
           END-PERFORM
           *>Affichade du client ayant le plus de points de fid�lit�
           DISPLAY " "
           DISPLAY "Le client ayant le plus de point est : "
           DISPLAY "Nom : ",fc_nom
           DISPLAY "Prenom : ",fc_prenom
           DISPLAY "Avec un total de ", ptsFidelite, " points"
           END-EVALUATE
           CLOSE fclients.
