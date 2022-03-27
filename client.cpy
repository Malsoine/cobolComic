           AJOUTCLIENT.
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

           SUPPRCLIENT.
           MOVE 0 to choixSupprClient
           MOVE 0 TO fichierFin
           MOVE 0 TO testNomClient
           DISPLAY "Supprimer avec l'id (1) ou nom/prénom (2) ?"
           ACCEPT choixSupprClient
           EVALUATE choixSupprClient
           WHEN 1
               DISPLAY "oui"
           WHEN 2
                DISPLAY "Suppression par nom et prénom"
                DISPLAY "Entrez le nom"
                ACCEPT cl_nom
                DISPLAY "Entrez le prénom"
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
           END-EVALUATE.
