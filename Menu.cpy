
        MENU_PRINC.

                MOVE 0 TO trouveMenu

                PERFORM WITH TEST AFTER UNTIL trouveMenu =1
                        DISPLAY "--- Choix de l'utilisateur : ---"
                        DISPLAY "0 pour un employe"
                        DISPLAY "1 pour le gerant"
                        DISPLAY " "
                        DISPLAY "2 Installation du jeu d'essai"
                        ACCEPT utilisateur
                        IF utilisateur = "0" OR utilisateur = "1" OR
                        utilisateur = "2" THEN
                                MOVE 1 TO trouveMenu
                        ELSE
                              DISPLAY "Ressaisissez !"
                        END-IF
                END-PERFORM
                MOVE 0 TO trouveMenu

                IF utilisateur = "0" THEN
                        PERFORM MENU_EMPLOYE
                ELSE IF utilisateur = "1" THEN
                        PERFORM MENU_GERANT
                ELSE
                        DISPLAY "FAIRE JEU D'ESSAI"
                        PERFORM MENU_PRINC
                END-IF.


        MENU_GERANT.

                MOVE 0 TO choixMenu
                DISPLAY "--- MENU GERANT ---"
                PERFORM WITH TEST AFTER UNTIL choixMenu = 0
                        DISPLAY "  -- QUE VOULEZ-VOUS FAIRE ? --"

                        DISPLAY "   -Gestion clients (1)"
                        DISPLAY "   -Gestion stocks (2)"
                        DISPLAY "   -Gestion ventes (3)"
                        DISPLAY "   -Statistiques (4)"
                        DISPLAY "   -QUITTER (0)"

                        ACCEPT choixMenu

                        IF choixMenu > 4 THEN

                        PERFORM WITH TEST AFTER UNTIL choixMenu < 4
                                DISPLAY "Ressaisissez !"
                                ACCEPT choixMenu
                        END-PERFORM
                        END-IF

                        EVALUATE TRUE
                                WHEN choixMenu = 1
                                        PERFORM SOUS_MENU_CLIENTS_GERANT
                                WHEN choixMenu = 2
                                        PERFORM SOUS_MENU_STOCKS_GERANT
                                WHEN choixMenu = 3
                                        PERFORM SOUS_MENU_VENTES_GERANT
                                WHEN choixMenu = 4
                                        PERFORM AFFICHE_STATS_GERANT
                        END-EVALUATE
                END-PERFORM.

        SOUS_MENU_CLIENTS_GERANT.

                MOVE 0 TO choixMenu2
                PERFORM WITH TEST AFTER UNTIL choixMenu2 = 0
                    DISPLAY "   -- GESTION CLIENTS --"
              DISPLAY "      -Consulter les points d'un clients (1)"
                    DISPLAY "      -Ajouter un client (2)"
                    DISPLAY "      -Supprimer un client (3)"
                    DISPLAY "      -Modifier les infos d'un client (4)"
                    DISPLAY "      -Afficher la liste des clients (5)"
                    DISPLAY "      -RETOUR (0)"

                        ACCEPT choixMenu2


                        IF choixMenu2 > 5 THEN

                        PERFORM WITH TEST AFTER UNTIL choixMenu2 < 4
                                DISPLAY "Ressaisissez !"
                                ACCEPT choixMenu2
                        END-PERFORM
                        END-IF

                        EVALUATE TRUE
                                WHEN choixMenu2 = 1
                                       PERFORM CONSULTER_PTS_FIDELITE
                                WHEN choixMenu2 = 2

                                        PERFORM AJOUT_CLIENT
                                WHEN choixMenu2 = 3

                                        PERFORM SUPPR_CLIENT
                                WHEN choixMenu2 = 4

                                       PERFORM MODIFIER_INFO_CLIENT
                               WHEN choixMenu2 = 5
                                   PERFORM AFFICHER_LISTE_CLIENTS

                        END-EVALUATE
                END-PERFORM

                PERFORM MENU_GERANT.

        SOUS_MENU_STOCKS_GERANT.

                MOVE 0 TO choixMenu2
                PERFORM WITH TEST AFTER UNTIL choixMenu2 = 0
                        DISPLAY "   -- GESTION STOCKS --"
                        DISPLAY "      -Enregistrer un achat (1)"
                     DISPLAY "      -Afficher la liste des achats (2)"
                        DISPLAY "      -Rechercher comic (3)"
                        DISPLAY "      -Consulter les stocks (4)"
                        DISPLAY "      -Ajouter un comic en stock(5)"
                        DISPLAY "      -Supprimer un comic (6)"
                        DISPLAY "      -Modifier un comic (7)"
                        DISPLAY "      -RETOUR (0)"


                        ACCEPT choixMenu2


                        IF choixMenu2 > 7 THEN

                        PERFORM WITH TEST AFTER UNTIL choixMenu2 < 4
                                DISPLAY "Ressaisissez !"
                                ACCEPT choixMenu2
                        END-PERFORM
                        END-IF
                        EVALUATE TRUE
                                WHEN choixMenu2 = 1
                                       PERFORM ENREGISTRER_ACHAT

                                WHEN choixMenu2 = 2
                                       PERFORM AFFICHER_ACHAT

                                WHEN choixMenu2 = 3
                                       PERFORM RECHERCHER_REFERENCE

                                WHEN choixMenu2 = 4
                                       PERFORM CONSULTER_INVENTAIRE

                                WHEN choixMenu2 = 5
                                       PERFORM AJOUTER_REFERENCE

                                WHEN choixMenu2 = 6

                                       PERFORM SUPPRIMER_REFERENCE

                                WHEN choixMenu2 = 7
                                        PERFORM MODIFIER_PRIX_COMIC
                        END-EVALUATE
                END-PERFORM

                DISPLAY " "
                PERFORM MENU_GERANT.


        SOUS_MENU_VENTES_GERANT.

                MOVE 0 TO choixMenu2
                PERFORM WITH TEST AFTER UNTIL choixMenu2 = 0
                        DISPLAY "   -- GESTION VENTE --"
                DISPLAY "      -Enregistrer une vente/commande (1)"
           DISPLAY "      -Mise à jour statut de la commande (2)"
                        DISPLAY "      -Historique commandes (3)"
                       DISPLAY "      -Afficher la liste des ventes (4)"
                        DISPLAY "      -RETOUR (0)"

                        ACCEPT choixMenu2

                        IF choixMenu2 > 5 THEN

                        PERFORM WITH TEST AFTER UNTIL choixMenu2 < 5
                                DISPLAY "Ressaisissez !"
                                ACCEPT choixMenu2
                        END-PERFORM
                        END-IF

                        EVALUATE TRUE
                                WHEN choixMenu2 = 1

                                        PERFORM ENREGISTRER_VENTE
                                WHEN choixMenu2 = 2
                                        PERFORM MAJ_STATUT_COMMANDE
                                        DISPLAY "2"
                                WHEN choixMenu2 = 3

                                        DISPLAY "3"
                                WHEN choixMenu2 = 4

                                        PERFORM AFFICHER_VENTE
                        END-EVALUATE
                END-PERFORM

                DISPLAY " "
                PERFORM MENU_GERANT.


        AFFICHE_STATS_GERANT.

           MOVE 0 TO choixMenu2
                PERFORM WITH TEST AFTER UNTIL choixMenu2 = 0
                        DISPLAY "   -- STATISTIQUES --"
                    DISPLAY "      -Statistiques Client (1)"
                        DISPLAY "      -RETOUR (0)"
                        ACCEPT choixMenu2
                        IF choixMenu2 > 3 THEN
                        PERFORM WITH TEST AFTER UNTIL choixMenu2 < 4
                                DISPLAY "Ressaisissez !"
                                ACCEPT choixMenu2
                        END-PERFORM
                        END-IF
                        EVALUATE TRUE
                                WHEN choixMenu2 = 1
                                        PERFORM STATISTIQUES_CLIENT
                        END-EVALUATE
                END-PERFORM

                DISPLAY " "
                PERFORM MENU_GERANT.
               PERFORM MENU_PRINC.


        MENU_EMPLOYE.
                DISPLAY "--- MENU EMPLOYE ---"
                MOVE 0 TO choixMenu

                PERFORM WITH TEST AFTER UNTIL choixMenu = 0
                        DISPLAY "  -- QUE VOULEZ-VOUS FAIRE ? --"

                        DISPLAY "   -Gestion clients (1)"
                        DISPLAY "   -Gestion stocks (2)"
                        DISPLAY "   -Gestion ventes (3)"
                        DISPLAY "   -Statistiques (4)"
                        DISPLAY "   -QUITTER (0)"

                        ACCEPT choixMenu

                        IF choixMenu > 4 THEN

                        PERFORM WITH TEST AFTER UNTIL choixMenu < 4
                                DISPLAY "Ressaisissez !"
                                ACCEPT choixMenu
                        END-PERFORM
                        END-IF

                        EVALUATE TRUE
                                WHEN choixMenu = 1
                                       PERFORM SOUS_MENU_CLIENTS_EMPLOYE
                                WHEN choixMenu = 2
                                        PERFORM SOUS_MENU_STOCKS_EMPLOYE
                                WHEN choixMenu = 3
                                        PERFORM SOUS_MENU_VENTES_EMPLOYE
                                WHEN choixMenu = 4
                                        PERFORM AFFICHE_STATS_EMPLOYE
                        END-EVALUATE
                END-PERFORM.

        SOUS_MENU_CLIENTS_EMPLOYE.

                MOVE 0 TO choixMenu2
                PERFORM WITH TEST AFTER UNTIL choixMenu2 = 0
                         DISPLAY "   -- GESTION CLIENTS --"
              DISPLAY "      -Consulter les points d'un clients (1)"
                    DISPLAY "      -Ajouter un client (2)"
                    DISPLAY "      -Supprimer un client (3)"
                    DISPLAY "      -Modifier les infos d'un client (4)"
                    DISPLAY "      -Afficher la liste des clients (5)"
                    DISPLAY "      -RETOUR (0)"
                        ACCEPT choixMenu2


                        IF choixMenu2 > 5 THEN

                        PERFORM WITH TEST AFTER UNTIL choixMenu2 < 4
                                DISPLAY "Ressaisissez !"
                                ACCEPT choixMenu2
                        END-PERFORM
                        END-IF
                        EVALUATE TRUE
                                WHEN choixMenu2 = 1
                                       PERFORM CONSULTER_PTS_FIDELITE
                                WHEN choixMenu2 = 2

                                        PERFORM AJOUT_CLIENT

                                WHEN choixMenu2 = 3

                                        PERFORM SUPPR_CLIENT
                                WHEN choixMenu2 = 4

                                        PERFORM MODIFIER_INFO_CLIENT
                                WHEN choixMenu2 = 5
                                        PERFORM AFFICHER_LISTE_CLIENTS
                        END-EVALUATE
                END-PERFORM

                PERFORM MENU_GERANT.

        SOUS_MENU_STOCKS_EMPLOYE.

                MOVE 0 TO choixMenu2
                PERFORM WITH TEST AFTER UNTIL choixMenu2 = 0
                        DISPLAY "   -- GESTION STOCKS --"
                        DISPLAY "      -Rechercher un comic (1)"
                        DISPLAY "      -Consulter l'inventaire (2)"
                        DISPLAY "      -RETOUR (0)"

                        ACCEPT choixMenu2


                        IF choixMenu2 > 2 THEN

                        PERFORM WITH TEST AFTER UNTIL choixMenu2 < 2
                                DISPLAY "Ressaisissez !"
                                ACCEPT choixMenu2
                        END-PERFORM
                        END-IF

                        EVALUATE TRUE
                                WHEN choixMenu2 = 1

                                        PERFORM RECHERCHER_REFERENCE
                                WHEN choixMenu2 = 2

                                        PERFORM CONSULTER_INVENTAIRE
                        END-EVALUATE
                END-PERFORM

                DISPLAY " "
                PERFORM MENU_GERANT.


        SOUS_MENU_VENTES_EMPLOYE.

                MOVE 0 TO choixMenu2
                PERFORM WITH TEST AFTER UNTIL choixMenu2 = 0
                        DISPLAY "   -- GESTION VENTE --"
                    DISPLAY "      -Enregistrer une vente/commande (1)"
                DISPLAY "      -Mise à jour statut de la commande (2)"
                        DISPLAY "      -Historique commandes (3)"
                       DISPLAY "      -Afficher la liste des ventes (4)"
                        DISPLAY "      -RETOUR (0)"
                        ACCEPT choixMenu2
                        IF choixMenu2 > 5 THEN
                        PERFORM WITH TEST AFTER UNTIL choixMenu2 < 5
                                DISPLAY "Ressaisissez !"
                                ACCEPT choixMenu2
                        END-PERFORM
                        END-IF
                        EVALUATE TRUE
                                WHEN choixMenu2 = 1
                                        PERFORM ENREGISTRER_VENTE
                                WHEN choixMenu2 = 2
                                       PERFORM MAJ_STATUT_COMMANDE
                                        DISPLAY "2"
                                WHEN choixMenu2 = 3
                                        DISPLAY "3"
                                WHEN choixMenu2 = 4
                                        PERFORM AFFICHER_VENTE
                        END-EVALUATE
                END-PERFORM

                DISPLAY " "
                PERFORM MENU_EMPLOYE.


        AFFICHE_STATS_EMPLOYE.
                MOVE 0 TO choixMenu2
                PERFORM WITH TEST AFTER UNTIL choixMenu2 = 0
                        DISPLAY "   -- STATISTIQUES --"
                    DISPLAY "      -Statistiques Client (1)"
                        DISPLAY "      -RETOUR (0)"
                        ACCEPT choixMenu2
                        IF choixMenu2 > 3 THEN
                        PERFORM WITH TEST AFTER UNTIL choixMenu2 < 4
                                DISPLAY "Ressaisissez !"
                                ACCEPT choixMenu2
                        END-PERFORM
                        END-IF
                        EVALUATE TRUE
                                WHEN choixMenu2 = 1
                                        PERFORM STATISTIQUES_CLIENT
                        END-EVALUATE
                END-PERFORM

                DISPLAY " "
                PERFORM MENU_EMPLOYE.
               PERFORM MENU_PRINC.
