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
           record key is fv_id
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
           alternate record key is fc_ptFidelite WITH DUPLICATES
           file status is cr_fclients.



       DATA DIVISION.

       FILE SECTION.
       FD fachats.
           01 tamp_fachats.
                02 fa_id PIC 9(15).
                02 fa_dateAchat PIC X(10).
                02 fa_titreComics PIC A(30).
                02 fa_quantite PIC 9(4).
                02 fa_prixAchat PIC 9(6)v99.
                02 fa_nomFournisseur PIC A(30).
       FD felecAge.
           01 tamp_felecAge.
                02 fea_idE PIC 9(15).
                02 fea_nom PIC A(30).
                02 fea_prenom PIC A(30).
                02 fea_age PIC 9(3).
                02 fea_villeHabitation PIC A(30).
       FD fbureau.
           01 tamp_fbureau.
               02 fbu_code PIC A(4).
               02 fbu_ville PIC A(30).
               02 fbu_heure_fermeture PIC 9(2).
               02 fbu_heure_ouverture PIC 9(2).
               02 fbu_region PIC 9(2).


       WORKING-STORAGE SECTION.
           77 cr_felec PIC 9(2).
           77 cr_fbureau PIC 9(2).
           77 cr_felecAge PIC 9(2).
           77 Wfin PIC 9.
           77 wStop PIC 9.
           77 test_nom PIC 9.
           77 test_ville PIC 9.
           01 elec.
               02 idE PIC 9(15).
               02 nom PIC A(30).
               02 prenom PIC A(30).
               02 age PIC 9(3).
               02 villeHabitation PIC A(30).
           01 bureau.
               02 bcode PIC A(4).
               02 ville PIC A(30).
               02 heure_fermeture PIC 9(2).
               02 heure_ouverture PIC 9(2).
               02 region PIC 9(2).
       PROCEDURE DIVISION.
      *-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-
       MAIN-PROCEDURE.
      **
      * The main procedure of the program
      **
            DISPLAY "Hello world"
            STOP RUN.
      ** add other procedures here
       END PROGRAM boutiqueComic.
