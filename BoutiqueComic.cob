       IDENTIFICATION DIVISION.
       PROGRAM-ID. boutiqueComic.

       ENVIRONMENT DIVISION.
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
           select felec assign to "electeurs.dat"
           organization sequential
           access mode is sequential
           file status is cr_felec.

           select felecAge assign to "electeursAge.dat"
           organization sequential
           access mode is sequential
           file status is cr_felecAge.

           select fbureau assign to "bureaux.dat"
           organization indexed
           access mode is dynamic
           record key is fbu_code
           alternate record key is fbu_ville
           alternate record key is fbu_region WITH DUPLICATES
           file status is cr_fbureau.


       DATA DIVISION.

       FILE SECTION.
       FD felec.
           01 tamp_felec.
                02 fe_idE PIC 9(15).
                02 fe_nom PIC A(30).
                02 fe_prenom PIC A(30).
                02 fe_age PIC 9(3).
                02 fe_villeHabitation PIC A(30).
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
