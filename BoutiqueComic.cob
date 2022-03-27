       IDENTIFICATION DIVISION.
       PROGRAM-ID. boutiqueComic.

       ENVIRONMENT DIVISION.
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
           select fachats assign to "achats.dat"
           organization indexed
           access mode is dynamic
           record key is fa_id
           alternate record key is fa_titrecomics WITH DUPLICATES
           file status is cr_fachats.

           select fventes assign to "ventes.dat"
           organization indexed
           access mode is dynamic
           record key is fv_cle
           alternate record key is fv_datevente WITH DUPLICATES
           file status is cr_fventes.

           select finventaire assign to "inventaire.dat"
           organization indexed
           access mode is dynamic
           record key is fi_titre
           alternate record key is fi_auteur WITH DUPLICATES
           file status is cr_finventaire.

           select fclients assign to "clients.dat"
           organization indexed
           access mode is dynamic
           record key is fc_id
           alternate record key is fc_ptsFidelite WITH DUPLICATES
           file status is cr_fclients.



       DATA DIVISION.

       FILE SECTION.
       FD fachats.
           01 tamp_fachats.
                02 fa_id PIC 9(15).
                02 fa_dateAchat PIC X(10).
                02 fa_titreComics PIC A(30).
                02 fa_quantite PIC 9(4).
                02 fa_prixAchat PIC 9(6)v9(2).
                02 fa_nomFournisseur PIC A(30).
       FD fventes.
           01 tamp_fvente.
                02 fv_cle.
                    03 fv_id PIC 9(15).
                    03 fv_statut PIC 9(15).
                02 fv_dateVente PIC X(10).
                02 fv_titreComics PIC A(30).
                02 fv_prixVente PIC 9(6)v9(2).
                02 fv_client PIC 9(15).
       FD finventaire.
           01 tamp_finventaire.
               02 fi_id PIC 9(15).
               02 fi_titre PIC A(30).
               02 fi_auteur PIC A(30).
               02 fi_quantite PIC 9(4).
               02 fi_prix PIC 9(6)v9(2).
       FD fclients.
           01 tamp_fclient.
               02 fc_id PIC 9(15).
               02 fc_prenom PIC A(30).
               02 fc_nom PIC A(30).
               02 fc_tel PIC 9(10).
               02 fc_mail PIC A(30).
               02 fc_ptsFidelite PIC 9(3).


       WORKING-STORAGE SECTION.
           77 cr_fachats PIC 9(2).
           77 cr_fventes PIC 9(2).
           77 cr_finventaire PIC 9(2).
           77 cr_fclients PIC 9(2).
           77 testNomClient PIC 9.
           77 fichierFin PIC 9.
           77 choixSupprClient PIC 9.
           77 testClient PIC 9.
           01 achat.
                02 ac_id PIC 9(15).
                02 ac_dateAchat PIC X(10).
                02 ac_titreComics PIC A(30).
                02 ac_quantite PIC 9(4).
                02 ac_prixAchat PIC 9(6)v9(2).
                02 ac_nomFournisseur PIC A(30).
           01 vente.
               02 ve_cle.
                    03 ve_id PIC 9(15).
                    03 ve_statut PIC 9(15).
                02 ve_dateVente PIC X(10).
                02 ve_titreComics PIC A(30).
                02 ve_prixVente PIC 9(6)v9(2).
                02 ve_client PIC 9(15).
           01 inventaire.
               02 in_id PIC 9(15).
               02 in_titre PIC A(30).
               02 in_auteur PIC A(30).
               02 in_quantite PIC 9(4).
               02 in_prix PIC 9(6)v9(2).
           01 client.
               02 cl_id PIC 9(15).
               02 cl_prenom PIC A(30).
               02 cl_nom PIC A(30).
               02 cl_tel PIC 9(10).
               02 cl_mail PIC A(30).
               02 cl_ptsFidelite PIC 9(3).
       PROCEDURE DIVISION.
           OPEN I-O fachats
           IF cr_fachats=35 THEN
               OPEN OUTPUT fachats
           END-IF
           CLOSE fachats
           OPEN I-O fventes
           IF cr_fventes = 35 THEN
               OPEN OUTPUT fventes
           END-IF
           CLOSE fventes
           OPEN I-O finventaire
           IF cr_finventaire=35 THEN
               OPEN OUTPUT finventaire
           END-IF
           CLOSE finventaire

           OPEN I-O fclients
           IF cr_fclients=35 THEN
               OPEN OUTPUT fclients
           END-IF
           CLOSE fclients

            DISPLAY "Fichiers créés "

           *>PERFORM AJOUTCLIENT
           PERFORM SUPPRCLIENT
       STOP RUN.


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
