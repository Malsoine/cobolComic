      
        MENU_PRINC.
                
                MOVE 0 TO trouve

                PERFORM WITH TEST AFTER UNTIL trouve =1
                        DISPLAY "--- Choix de l'utilisateur : ---"
                        DISPLAY "0 pour un employé"
                        DISPLAY "1 pour le gérant"
                        DISPLAY " "
                        DISPLAY "2 Installation du jeu d'essai"
                        ACCEPT utilisateur
                        IF utilisateur = "0" OR utilisateur = "1" OR 
                        utilisateur = "2" THEN
                                MOVE 1 TO trouve
                        ELSE
                              DISPLAY "Ressaisissez !"
                        END-IF
                END-PERFORM
                MOVE 0 TO trouve
                
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
                         DISPLAY "      -Consulter clients (1)"
                         DISPLAY "      -Ajouter client (2)"
                         DISPLAY "      -Supprimer client (3)"
                         DISPLAY "      -Modifier client (4)"
                         DISPLAY "      -RETOUR (0)"
                        
                        ACCEPT choixMenu2
                        

                        IF choixMenu2 > 4 THEN 
                                
                        PERFORM WITH TEST AFTER UNTIL choixMenu2 < 4
                                DISPLAY "Ressaisissez !"
                                ACCEPT choixMenu2
                        END-PERFORM
                        END-IF
                        
                        EVALUATE TRUE
                                WHEN choixMenu2 = 1

                                        DISPLAY "1"
                                WHEN choixMenu2 = 2

                                        DISPLAY "2"
                                WHEN choixMenu2 = 3

                                        DISPLAY "3"
                                WHEN choixMenu2 = 4

                                        DISPLAY "4"
                        END-EVALUATE
                END-PERFORM
                
                PERFORM MENU_GERANT.
                
        SOUS_MENU_STOCKS_GERANT.
        
                MOVE 0 TO choixMenu2
                PERFORM WITH TEST AFTER UNTIL choixMenu2 = 0
                        DISPLAY "   -- GESTION STOCKS --"
                        DISPLAY "      -Enregistrer un achat (1)"
                        DISPLAY "      -Rechercher comics (2)"
                        DISPLAY "      -Consulter inventaire (3)"
                        DISPLAY "      -Ajouter référence (4)"
                        DISPLAY "      -Supprimer référence (5)"
                        DISPLAY "      -Modifier référence (6)"
                        DISPLAY "      -RETOUR (0)"
                        
                        ACCEPT choixMenu2
                        

                        IF choixMenu2 > 6 THEN 
                                
                        PERFORM WITH TEST AFTER UNTIL choixMenu2 < 4
                                DISPLAY "Ressaisissez !"
                                ACCEPT choixMenu2
                        END-PERFORM
                        END-IF
                        
                        EVALUATE TRUE
                                WHEN choixMenu2 = 1

                                        DISPLAY "1"
                                WHEN choixMenu2 = 2

                                        DISPLAY "2"
                                WHEN choixMenu2 = 3

                                        DISPLAY "3"
                                WHEN choixMenu2 = 4

                                        DISPLAY "4"
                                WHEN choixMenu2 = 5
                                        DISPLAY "5"
                                        
                                WHEN choixMenu2 = 6
                                        DISPLAY "6"
                        END-EVALUATE
                END-PERFORM
                
                DISPLAY " "
                PERFORM MENU_GERANT.
                
                                
        SOUS_MENU_VENTES_GERANT.
        
                MOVE 0 TO choixMenu2
                PERFORM WITH TEST AFTER UNTIL choixMenu2 = 0
                        DISPLAY "   -- GESTION VENTE --"
                        DISPLAY "      -Enregistrer une vente (1)"
                        DISPLAY "      -Enregistrer une commande (2)"
                        DISPLAY "      -Historique commandes (3)"
                        DISPLAY "      -RETOUR (0)"
                        
                        ACCEPT choixMenu2
                        
                        IF choixMenu2 > 4 THEN 
                                
                        PERFORM WITH TEST AFTER UNTIL choixMenu2 < 4
                                DISPLAY "Ressaisissez !"
                                ACCEPT choixMenu2
                        END-PERFORM
                        END-IF
                        
                        EVALUATE TRUE
                                WHEN choixMenu2 = 1

                                        DISPLAY "1"
                                WHEN choixMenu2 = 2

                                        DISPLAY "2"
                                WHEN choixMenu2 = 3

                                        DISPLAY "3"
                                WHEN choixMenu2 = 4
                                
                                        DISPLAY "4"
                        END-EVALUATE
                END-PERFORM
                
                DISPLAY " "
                PERFORM MENU_GERANT.
        
        
        AFFICHE_STATS_GERANT.
               DISPLAY "STATISTIQUES"
                
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
                         DISPLAY "      -Consulter clients (1)"
                         DISPLAY "      -Ajouter client (2)"
                         DISPLAY "      -Supprimer client (3)"
                         DISPLAY "      -Modifier client (4)"
                         DISPLAY "      -RETOUR (0)"
                        
                        ACCEPT choixMenu2
                        

                        IF choixMenu2 > 4 THEN 
                                
                        PERFORM WITH TEST AFTER UNTIL choixMenu2 < 4
                                DISPLAY "Ressaisissez !"
                                ACCEPT choixMenu2
                        END-PERFORM
                        END-IF
                        
                        EVALUATE TRUE
                                WHEN choixMenu2 = 1

                                        DISPLAY "1"
                                WHEN choixMenu2 = 2

                                        DISPLAY "2"
                                WHEN choixMenu2 = 3

                                        DISPLAY "3"
                                WHEN choixMenu2 = 4

                                        DISPLAY "4"
                        END-EVALUATE
                END-PERFORM
                
                PERFORM MENU_GERANT.
                
        SOUS_MENU_STOCKS_EMPLOYE.
        
                MOVE 0 TO choixMenu2
                PERFORM WITH TEST AFTER UNTIL choixMenu2 = 0
                        DISPLAY "   -- GESTION STOCKS --"
                        DISPLAY "      -Rechercher comics (1)"
                        DISPLAY "      -Consulter inventaire (2)"
                        DISPLAY "      -RETOUR (0)"
                        
                        ACCEPT choixMenu2
                        

                        IF choixMenu2 > 6 THEN 
                                
                        PERFORM WITH TEST AFTER UNTIL choixMenu2 < 2
                                DISPLAY "Ressaisissez !"
                                ACCEPT choixMenu2
                        END-PERFORM
                        END-IF
                        
                        EVALUATE TRUE
                                WHEN choixMenu2 = 1

                                        DISPLAY "1"
                                WHEN choixMenu2 = 2

                                        DISPLAY "2"
                        END-EVALUATE
                END-PERFORM
                
                DISPLAY " "
                PERFORM MENU_GERANT.
                
                                
        SOUS_MENU_VENTES_EMPLOYE.
        
                MOVE 0 TO choixMenu2
                PERFORM WITH TEST AFTER UNTIL choixMenu2 = 0
                        DISPLAY "   -- GESTION VENTE --"
                        DISPLAY "      -Enregistrer une vente (1)"
                        DISPLAY "      -Enregistrer une commande (2)"
                        DISPLAY "      -Historique commandes (3)"
                        DISPLAY "      -RETOUR (0)"
                        
                        ACCEPT choixMenu2
                        
                        IF choixMenu2 > 4 THEN 
                                
                        PERFORM WITH TEST AFTER UNTIL choixMenu2 < 4
                                DISPLAY "Ressaisissez !"
                                ACCEPT choixMenu2
                        END-PERFORM
                        END-IF
                        
                        EVALUATE TRUE
                                WHEN choixMenu2 = 1

                                        DISPLAY "1"
                                WHEN choixMenu2 = 2

                                        DISPLAY "2"
                                WHEN choixMenu2 = 3

                                        DISPLAY "3"
                                WHEN choixMenu2 = 4
                                
                                        DISPLAY "4"
                        END-EVALUATE
                END-PERFORM
                
                DISPLAY " "
                PERFORM MENU_EMPLOYE.
        
        
        AFFICHE_STATS_EMPLOYE.
               DISPLAY "STATISTIQUES"
               
               PERFORM MENU_PRINC.
          
         
