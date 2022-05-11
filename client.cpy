           AJOUT_CLIENT.
           OPEN INPUT fclients
           MOVE 0 TO fichierFin
           MOVE 0 TO testClient
           MOVE 0 TO testNomClient
           DISPLAY "Entrez le code client :"
           ACCEPT cl_id
           DISPLAY "Entrez le nom :"
           ACCEPT cl_nom
           DISPLAY "Entrez le prenom :"
           ACCEPT cl_prenom
           DISPLAY "Entrez le numéro de telephone :"
           DISPLAY "(10 chiffres)"
           ACCEPT cl_tel
           DISPLAY "Entrez l'email :"
           DISPLAY "(xxx@xxx.xx)"
           ACCEPT cl_mail
           DISPLAY "Entrez le nombre de point de fidelite : "
           ACCEPT cl_ptsFidelite
           PERFORM WITH TEST AFTER UNTIL fichierFin=1
               READ fclients NEXT
               AT END MOVE 1 TO fichierFin
               NOT AT END
                   IF fc_nom = cl_nom AND fc_prenom = cl_prenom THEN
                       MOVE 1 TO testNomClient
                   END-IF
               END-READ
           END-PERFORM

           MOVE cl_id TO fc_id
           READ fclients
           KEY IS fc_id
           INVALID KEY MOVE 0 TO testClient
           NOT INVALID KEY MOVE 1 TO testClient
           END-READ


           CLOSE fclients
           IF testClient = 1 OR testNomClient = 1 THEN
               DISPLAY "Erreur, le client est deja dans le fichier"
               DISPLAY "  "
               PERFORM AFFICHER_LISTE_CLIENTS
               DISPLAY "  "
               DISPLAY " - Resaisie d'un client - "
               PERFORM AJOUT_CLIENT
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

           SUPPR_CLIENT.
           MOVE 0 to choixSupprClient
           MOVE 0 TO fichierFin
           MOVE 0 TO idClient
           MOVE 0 TO testClient
           MOVE 0 TO testNomClient
           DISPLAY "-----"
           DISPLAY "Supprimer avec l'id (1)"
           DISPLAY "Supprimer avec nom/prenom (2) ?"
           DISPLAY "-----"
           ACCEPT choixSupprClient
           EVALUATE choixSupprClient
           WHEN 1
               OPEN I-O fclients
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
           WHEN 2
               OPEN I-O fclients
                DISPLAY "Suppression par nom et prenom1"
                DISPLAY "Entrez le nom : "
                ACCEPT cl_nom
                DISPLAY "Entrez le prenom : "
                ACCEPT cl_prenom
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

           WHEN OTHER
                   DISPLAY "Choix invalide"
                   PERFORM SUPPR_CLIENT

           END-EVALUATE.

           CONSULTER_PTS_FIDELITE.
           OPEN INPUT fclients
           MOVE 0 TO fichierFin
           MOVE 0 TO testNomClient
           DISPLAY"Entrez le nom : "
           ACCEPT cl_nom
           DISPLAY "Entrez le prénom : "
           ACCEPT cl_prenom
           PERFORM WITH TEST AFTER UNTIL fichierFin=1
               READ fclients NEXT
               AT END MOVE 1 TO fichierFin
               NOT AT END
               IF fc_nom = cl_nom AND fc_prenom = cl_prenom THEN
                  MOVE 1 TO testNomClient
               END-IF
               END-READ
           END-PERFORM
           IF testNomClient = 1
               DISPLAY "Points de fidelite : ", fc_ptsFidelite
           END-IF
           close fclients.


           MODIFIER_INFO_CLIENT.
           OPEN INPUT fclients
           MOVE 0 TO testNomClient
           MOVE 0 TO fichierFin
           MOVE 0 TO idClient
           DISPLAY"Entrez le nom : "
           ACCEPT cl_nom
           DISPLAY "Entrez le prenom : "
           ACCEPT cl_prenom
           PERFORM WITH TEST AFTER UNTIL fichierFin=1
               READ fclients NEXT
               AT END MOVE 1 TO fichierFin
               NOT AT END
               IF fc_nom = cl_nom AND fc_prenom = cl_prenom THEN
                  MOVE fc_id TO idClient
               END-IF
               END-READ
           END-PERFORM
           close fclients.
           OPEN I-O fclients
            MOVE idClient TO fc_id
            READ fclients KEY IS fc_id
                INVALID KEY DISPLAY "Ce client n'existe pas"
                NOT INVALID KEY
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

           AFFICHER_LISTE_CLIENTS.
           OPEN INPUT fclients
           MOVE 0 TO fichierFin
           DISPLAY "Affichage de la liste des clients"
           PERFORM WITH TEST AFTER UNTIL fichierFin=1
               READ fclients NEXT
               AT END MOVE 1 TO fichierFin
               NOT AT END
               DISPLAY "-------"
               DISPLAY "Nom : ",fc_nom
               DISPLAY "Prenom : ",fc_prenom
               DISPLAY "Identifiant : ", fc_id
               END-READ
           END-PERFORM
           CLOSE fclients.



           STATISTIQUES_CLIENT.
           OPEN INPUT fclients
           MOVE 0 TO choixSupprClient
           MOVE 0 to testClient
           MOVE 0 TO fichierFin
           MOVE 0 TO nbClient
           MOVE 0 TO ptsFidelite
           DISPLAY "Que voulez-vous faire ?"
           DISPLAY "   -Afficher le nombre de client (1)"
           DISPLAY "   -Afficher les clients au dessus d'un seuil de"
           DISPLAY "   points de fidélité (2)"
           DISPLAY "   -Afficher le client ayant le plus de points (3)"
           DISPLAY "   -RETOUR (0)"
           ACCEPT choixSupprClient
           EVALUATE choixSupprClient
           WHEN 1
           PERFORM WITH TEST AFTER UNTIL fichierFin=1
               READ fclients NEXT
               AT END MOVE 1 TO fichierFin
               NOT AT END
               ADD 1 TO nbClient
               END-READ
           END-PERFORM
           DISPLAY "Nombre de client : ", nbClient

           WHEN 2
           MOVE 0 TO nbClient
           DISPLAY"A partir de quel seuil voulez-vous voir les clients?"
           ACCEPT ptsFidelite
           DISPLAY " "
           DISPLAY "-------"
           DISPLAY"Clients ayant plus de ", ptsFidelite
           DISPLAY "points de fidelite : "
           PERFORM WITH TEST AFTER UNTIL fichierFin=1
               READ fclients NEXT
               AT END MOVE 1 TO fichierFin
               NOT AT END
               IF ptsFidelite <= fc_ptsFidelite THEN
                   ADD 1 TO nbClient
                   DISPLAY "-------"
                   DISPLAY "Nom : ",fc_nom
                   DISPLAY "Prenom : ",fc_prenom
                END-IF
               END-READ
           END-PERFORM
           DISPLAY "-------"
           DISPLAY "Il y a au total ", nbClient, " client(s)"
           DISPLAY "au dessus de ", ptsFidelite, " points"
           DISPLAY " "

           WHEN 3
           MOVE 0 TO ptsFidelite
           PERFORM WITH TEST AFTER UNTIL fichierFin=1
               READ fclients NEXT
               AT END MOVE 1 TO fichierFin
               NOT AT END
               IF ptsFidelite <= fc_ptsFidelite THEN
                  MOVE fc_ptsFidelite TO ptsFidelite
                  MOVE fc_nom TO cl_nom
                  MOVE fc_prenom TO cl_prenom
                END-IF
               END-READ
           END-PERFORM
           DISPLAY " "
           DISPLAY "Le client ayant le plus de point est : "
           DISPLAY "Nom : ",fc_nom
           DISPLAY "Prenom : ",fc_prenom
           DISPLAY "Avec un total de ", ptsFidelite, " points"
           END-EVALUATE
           CLOSE fclients.
