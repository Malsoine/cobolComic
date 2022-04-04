           AJOUT_CLIENT.
           OPEN INPUT fclients
           MOVE 0 TO fichierFin
           MOVE 0 TO testClient
           MOVE 0 TO testNomClient
           DISPLAY "Entrez le code client :"
           ACCEPT cl_id
           DISPLAY "Entrez le nom :"
           ACCEPT cl_nom
           DISPLAY "Entrez le pr�nom :"
           ACCEPT cl_prenom
           DISPLAY "Entrez le num�ro de t�l�phone :"
           ACCEPT cl_tel
           DISPLAY "Entrez l'email :"
           ACCEPT cl_mail
           DISPLAY "Entrez le nombre de point de fid�lit� : "
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
               DISPLAY "Erreur, le client est d�j� dans le fichier"
           ELSE IF testClient = 0 AND testNomClient = 0 THEN
               OPEN I-O fclients
               MOVE client TO tamp_fclient
               WRITE tamp_fclient
               END-WRITE
               DISPLAY "Ajout effectu�"
               DISPLAY fc_prenom
               CLOSE fclients
           END-IF.

           SUPPR_CLIENT.
           OPEN I-O fclients
           MOVE 0 to choixSupprClient
           MOVE 0 TO fichierFin
           MOVE 0 TO testNomClient
           DISPLAY "Supprimer avec l'id (1) ou nom/pr�nom (2) ?"
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
               display "Suppresion effectu�e !" end-display
               end-delete
           WHEN 2
                DISPLAY "Suppression par nom et pr�nom"
                DISPLAY "Entrez le nom : "
                ACCEPT cl_nom
                DISPLAY "Entrez le pr�nom : "
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
                   DISPLAY "Suppresion effectu�e"
                END-IF
           WHEN OTHER
                   DISPLAY "Choix invalide"
                   PERFORM SUPPR_CLIENT

           END-EVALUATE
           close fclients.

           CONSULTER_PTS_FIDELITE.
           OPEN INPUT fclients
           MOVE 0 TO testNomClient
           DISPLAY "Entrez le nom : "
           ACCEPT cl_nom
           DISPLAY "Entrez le pr�nom : "
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
               DISPLAY "Points de fid�lit� : ", fc_ptsFidelite
           END-IF
           close fclients.
