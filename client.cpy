           AJOUT_CLIENT.
           OPEN INPUT fclients
           MOVE 0 TO fichierFin
           MOVE 0 TO testClient
           MOVE 0 TO testNomClient
           DISPLAY "Entrez le code client :"
           ACCEPT cl_id
           DISPLAY "Entrez le nom :"
           ACCEPT cl_nom
           DISPLAY "Entrez le prénom :"
           ACCEPT cl_prenom
           DISPLAY "Entrez le numéro de téléphone :"
           ACCEPT cl_tel
           DISPLAY "Entrez l'email :"
           ACCEPT cl_mail
           DISPLAY "Entrez le nombre de point de fidélité : "
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
               DISPLAY "Erreur, le client est déjà dans le fichier"
           ELSE IF testClient = 0 AND testNomClient = 0 THEN
               OPEN I-O fclients
               MOVE client TO tamp_fclient
               WRITE tamp_fclient
               END-WRITE
               DISPLAY "Ajout effectué"
               DISPLAY fc_prenom
               CLOSE fclients
           END-IF.

           SUPPR_CLIENT.
           OPEN I-O fclients
           MOVE 0 to choixSupprClient
           MOVE 0 TO fichierFin
           MOVE 0 TO testNomClient
           DISPLAY "Supprimer avec l'id (1) ou nom/prénom (2) ?"
           ACCEPT choixSupprClient
           EVALUATE choixSupprClient
           WHEN 1
               DISPLAY "Suppression par id"
               DISPLAY "Entrez l'id : "
               ACCEPT cl_id
               MOVE cl_id TO fc_id
                  delete fclients record
                  invalid key
                 display "Suppression impossible de  " fc_id end-display
                  not invalid key
               display "Suppresion effectuée !" end-display
               end-delete
           WHEN 2
                DISPLAY "Suppression par nom et prénom"
                DISPLAY "Entrez le nom : "
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
                   DELETE fclients
                   DISPLAY "Suppresion effectuée"
                END-IF
           WHEN OTHER
                   DISPLAY "Choix invalide"
                   PERFORM SUPPR_CLIENT

           END-EVALUATE
           close fclients.

           CONSULTER_PTS_FIDELITE.
           OPEN INPUT fclients
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
               DISPLAY "Points de fidélité : ", fc_ptsFidelite
           END-IF
           close fclients.


           MODIFIER_INFO_CLIENT.
           OPEN INPUT fclients
           MOVE 0 TO testNomClient
           MOVE 0 TO fichierFin
           MOVE 0 TO idClient
           DISPLAY"Entrez le nom : "
           ACCEPT cl_nom
           DISPLAY "Entrez le prénom : "
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
                   DISPLAY "Entrez le nouveau numéro de téléphone"
                   ACCEPT cl_tel
                   DISPLAY "Entrez le nouveau mail"
                   ACCEPT cl_mail
                   DISPLAY "Entrez le nombre de points de fidélité"
                   ACCEPT cl_ptsFidelite
                   MOVE cl_tel TO fc_tel
                   MOVE cl_mail TO fc_mail
                   MOVE cl_ptsFidelite TO fc_ptsFidelite
                   REWRITE tamp_fclient
                     INVALID KEY DISPLAY "Erreur de réécriture"
                     NOT INVALID KEY DISPLAY "La modification est faite"
                   END-REWRITE
                END-READ
            CLOSE fclients.
